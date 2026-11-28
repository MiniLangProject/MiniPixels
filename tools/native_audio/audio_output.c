// SPDX-License-Identifier: Apache-2.0
// Independently serviced PCM output. The worker owns every sample and never
// invokes the managed language runtime or retains pointers into its heap.
#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "audio_limiter.h"
#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <mmsystem.h>
#define MP_API __declspec(dllexport)
typedef CRITICAL_SECTION mp_output_mutex;
#define MP_LOCK(value) EnterCriticalSection(&(value)->mutex)
#define MP_UNLOCK(value) LeaveCriticalSection(&(value)->mutex)
#else
#include <pthread.h>
#include <time.h>
#define MP_API __attribute__((visibility("default")))
typedef pthread_mutex_t mp_output_mutex;
#define MP_LOCK(value) pthread_mutex_lock(&(value)->mutex)
#define MP_UNLOCK(value) pthread_mutex_unlock(&(value)->mutex)
#endif

#define MP_OUTPUT_CLIPS 128
#define MP_OUTPUT_VOICES 256
#define MP_OUTPUT_FRAMES 512
#define MP_OUTPUT_BUFFERS 4
#define MP_OUTPUT_RAMP 128
#define MP_OUTPUT_COMMAND_BYTES 40
#define MP_OUTPUT_STATE_BYTES 16
#define MP_OUTPUT_MAX_BYTES UINT64_C(536870912)

typedef struct MpOutputClip {
    uint8_t* data;
    uint64_t frames;
    uint32_t rate, channels, bits, align;
} MpOutputClip;

typedef struct MpOutputVoice {
    uint32_t clip, generation;
    int playing, looping, stopping;
    double cursor, left, right, target_left, target_right;
    double last_left, last_right, tail_left, tail_right;
    uint32_t ramp, tail;
} MpOutputVoice;

typedef struct MpOutput {
    mp_output_mutex mutex;
    MpOutputClip clips[MP_OUTPUT_CLIPS];
    MpOutputVoice voices[MP_OUTPUT_VOICES];
    uint32_t clip_count, voice_count, rate, mode;
    uint64_t copied_bytes, rendered_frames;
    uint32_t underruns, error;
    int closing, thread_started, soft_limit;
    uint8_t buffers[MP_OUTPUT_BUFFERS][MP_OUTPUT_FRAMES * 4];
#if defined(_WIN32)
    HANDLE thread, event;
    HWAVEOUT device;
    WAVEHDR headers[MP_OUTPUT_BUFFERS];
    uint32_t prepared;
#else
    pthread_t thread;
#endif
} MpOutput;

static uint32_t mp_output_u32(const uint8_t* p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static uint64_t mp_output_u64(const uint8_t* p)
{
    return mp_output_u32(p) | ((uint64_t)mp_output_u32(p + 4) << 32);
}
static void mp_output_put32(uint8_t* p, uint32_t n)
{
    p[0] = (uint8_t)n; p[1] = (uint8_t)(n >> 8); p[2] = (uint8_t)(n >> 16); p[3] = (uint8_t)(n >> 24);
}
static void mp_output_put64(uint8_t* p, uint64_t n)
{
    mp_output_put32(p, (uint32_t)n); mp_output_put32(p + 4, (uint32_t)(n >> 32));
}
static double mp_output_sample(const uint8_t* p, uint32_t bits)
{
    uint32_t n;
    if (bits == 8) return ((int32_t)p[0] - 128) * 256.0;
    n = (uint32_t)p[0] | ((uint32_t)p[1] << 8);
    if (bits == 16) return n >= 32768 ? (double)n - 65536.0 : n;
    n |= (uint32_t)p[2] << 16;
    if (bits == 24) return (n >= 8388608 ? (double)n - 16777216.0 : n) / 256.0;
    n |= (uint32_t)p[3] << 24;
    return (n >= UINT32_C(2147483648) ? (double)n - 4294967296.0 : n) / 65536.0;
}
static void mp_output_sample16(uint8_t* p, double v)
{
    int32_t n;
    uint16_t packed;
    if (v != v) n = 0;
    else if (v <= -32768.0) n = -32768;
    else if (v >= 32767.0) n = 32767;
    else { n = (int32_t)v; if (n > v) --n; }
    packed = (uint16_t)n;
    p[0] = (uint8_t)packed; p[1] = (uint8_t)(packed >> 8);
}

// Called with the mutex held. No allocation, file access, runtime callbacks or
// waiting occurs in the render loop. Music at zero gain still advances.
static void mp_output_render(MpOutput* value, uint8_t* output, uint32_t frames)
{
    uint32_t frame, index;
    for (frame = 0; frame < frames; ++frame) {
        double left = 0.0, right = 0.0;
        for (index = 0; index < value->voice_count; ++index) {
            MpOutputVoice* voice = &value->voices[index];
            double a = 0.0, b = 0.0;
            if (voice->playing && voice->clip > 0 && voice->clip <= value->clip_count) {
                MpOutputClip* clip = &value->clips[voice->clip - 1];
                if (voice->cursor >= clip->frames) {
                    if (voice->looping) voice->cursor = fmod(voice->cursor, (double)clip->frames);
                    else {
                        voice->playing = 0;
                        voice->tail_left = voice->last_left;
                        voice->tail_right = voice->last_right;
                        voice->tail = MP_OUTPUT_RAMP;
                    }
                }
                if (voice->playing) {
                    const uint8_t* p = clip->data + (size_t)(uint64_t)voice->cursor * clip->align;
                    if (voice->ramp) {
                        voice->left += (voice->target_left - voice->left) / voice->ramp;
                        voice->right += (voice->target_right - voice->right) / voice->ramp;
                        --voice->ramp;
                    }
                    a = mp_output_sample(p, clip->bits);
                    b = clip->channels == 1 ? a : mp_output_sample(p + clip->bits / 8, clip->bits);
                    a *= voice->left; b *= voice->right;
                    voice->cursor += (double)clip->rate / value->rate;
                    if (voice->stopping && voice->ramp == 0) voice->playing = 0;
                }
            }
            if (voice->tail) {
                a += voice->tail_left * ((double)voice->tail / MP_OUTPUT_RAMP);
                b += voice->tail_right * ((double)voice->tail / MP_OUTPUT_RAMP);
                --voice->tail;
            }
            voice->last_left = a; voice->last_right = b;
            left += a; right += b;
        }
        mp_output_sample16(output + frame * 4, value->soft_limit ? mp_audio_soft_limit(left) : left);
        mp_output_sample16(output + frame * 4 + 2, value->soft_limit ? mp_audio_soft_limit(right) : right);
    }
    value->rendered_frames += frames;
}

MP_API void* mpAudioOutputCreate(uint32_t rate, uint32_t voices)
{
    MpOutput* value;
    if (rate < 8000 || rate > 192000 || voices < 1 || voices > MP_OUTPUT_VOICES) return NULL;
    value = (MpOutput*)calloc(1, sizeof(*value));
    if (value == NULL) return NULL;
#if defined(_WIN32)
    InitializeCriticalSection(&value->mutex);
#else
    if (pthread_mutex_init(&value->mutex, NULL) != 0) { free(value); return NULL; }
#endif
    value->rate = rate; value->voice_count = voices;
    return value;
}

// Copies before acquiring the worker lock, so a long music stem upload cannot
// block device servicing. Copies remain owned until the output is closed.
MP_API uint32_t mpAudioOutputAddClip(void* handle, const void* data, uint64_t bytes,
    uint64_t frames, uint32_t rate, uint32_t channels, uint32_t bits, uint32_t align)
{
    MpOutput* value = (MpOutput*)handle;
    uint8_t* copy;
    uint32_t id;
    if (value == NULL || data == NULL || frames == 0 || rate < 8000 || rate > 192000 ||
        channels < 1 || channels > 2 || (bits != 8 && bits != 16 && bits != 24 && bits != 32) ||
        align < channels * (bits / 8) || bytes > SIZE_MAX || frames > bytes / align ||
        bytes > MP_OUTPUT_MAX_BYTES) return 0;
    copy = (uint8_t*)malloc((size_t)bytes);
    if (copy == NULL) return 0;
    memcpy(copy, data, (size_t)bytes);
    MP_LOCK(value);
    if (value->clip_count == MP_OUTPUT_CLIPS || bytes > MP_OUTPUT_MAX_BYTES - value->copied_bytes) {
        MP_UNLOCK(value); free(copy); return 0;
    }
    id = ++value->clip_count;
    value->clips[id - 1].data = copy;
    value->clips[id - 1].frames = frames;
    value->clips[id - 1].rate = rate;
    value->clips[id - 1].channels = channels;
    value->clips[id - 1].bits = bits;
    value->clips[id - 1].align = align;
    value->copied_bytes += bytes;
    MP_UNLOCK(value);
    return id;
}

// A complete ensemble is published atomically. Repeated snapshots never
// restart finished effects; only a new generation or source starts a voice.
// Command LE fields: clip, generation, playing, loop, cursor(u64), L/R gain in
// millionths, soft limiter flag (first record only), reserved u32.
// State: cursor(u64), playing(u32), generation.
MP_API int32_t mpAudioOutputSync(void* handle, const void* commands, uint64_t command_bytes,
    void* state, uint64_t state_bytes)
{
    MpOutput* value = (MpOutput*)handle;
    const uint8_t* input = (const uint8_t*)commands;
    uint8_t* output = (uint8_t*)state;
    uint32_t index;
    if (value == NULL || input == NULL || output == NULL ||
        command_bytes != (uint64_t)value->voice_count * MP_OUTPUT_COMMAND_BYTES ||
        state_bytes < (uint64_t)value->voice_count * MP_OUTPUT_STATE_BYTES) return 0;
    MP_LOCK(value);
    // Validate the whole transaction before mutating any voice.
    for (index = 0; index < value->voice_count; ++index) {
        const uint8_t* p = input + index * MP_OUTPUT_COMMAND_BYTES;
        if (mp_output_u32(p) > value->clip_count || mp_output_u32(p + 24) > 1000000 ||
            mp_output_u32(p + 28) > 1000000) { MP_UNLOCK(value); return 0; }
    }
    if (mp_output_u32(input + 32) > 1) { MP_UNLOCK(value); return 0; }
    value->soft_limit = mp_output_u32(input + 32) != 0;
    for (index = 0; index < value->voice_count; ++index) {
        const uint8_t* p = input + index * MP_OUTPUT_COMMAND_BYTES;
        MpOutputVoice* voice = &value->voices[index];
        uint32_t clip = mp_output_u32(p), generation = mp_output_u32(p + 4);
        int playing = mp_output_u32(p + 8) != 0 && clip != 0;
        double left = mp_output_u32(p + 24) / 1000000.0;
        double right = mp_output_u32(p + 28) / 1000000.0;
        if (playing && (voice->generation != generation || voice->clip != clip)) {
            voice->tail_left = voice->last_left; voice->tail_right = voice->last_right;
            voice->tail = MP_OUTPUT_RAMP;
            voice->clip = clip; voice->generation = generation;
            voice->cursor = (double)(mp_output_u64(p + 16) % value->clips[clip - 1].frames);
            voice->playing = 1; voice->stopping = 0;
            voice->left = 0.0; voice->right = 0.0;
            voice->target_left = left; voice->target_right = right;
            voice->ramp = MP_OUTPUT_RAMP;
        }
        voice->looping = mp_output_u32(p + 12) != 0;
        if (!playing && voice->playing && !voice->stopping) {
            voice->stopping = 1;
            voice->target_left = 0.0; voice->target_right = 0.0;
            voice->ramp = MP_OUTPUT_RAMP;
        } else if (playing && !voice->stopping &&
            (voice->target_left != left || voice->target_right != right)) {
            voice->target_left = left; voice->target_right = right;
            voice->ramp = MP_OUTPUT_RAMP;
        }
        mp_output_put64(output + index * MP_OUTPUT_STATE_BYTES, (uint64_t)voice->cursor);
        mp_output_put32(output + index * MP_OUTPUT_STATE_BYTES + 8, voice->playing && !voice->stopping);
        mp_output_put32(output + index * MP_OUTPUT_STATE_BYTES + 12, voice->generation);
    }
    MP_UNLOCK(value);
    return 1;
}

MP_API int32_t mpAudioOutputRender(void* handle, void* output, uint64_t bytes, uint32_t frames)
{
    MpOutput* value = (MpOutput*)handle;
    if (value == NULL || output == NULL || value->mode != 0 || frames == 0 ||
        frames > 192000 || bytes < (uint64_t)frames * 4) return 0;
    MP_LOCK(value); mp_output_render(value, (uint8_t*)output, frames); MP_UNLOCK(value);
    return 1;
}

MP_API int32_t mpAudioOutputStats(void* handle, void* output, uint64_t bytes)
{
    MpOutput* value = (MpOutput*)handle;
    uint8_t* p = (uint8_t*)output;
    if (value == NULL || p == NULL || bytes < 24) return 0;
    MP_LOCK(value);
    mp_output_put64(p, value->rendered_frames);
    mp_output_put32(p + 8, value->underruns);
    mp_output_put32(p + 12, value->error);
    mp_output_put64(p + 16, value->copied_bytes);
    MP_UNLOCK(value);
    return 1;
}

static int mp_output_closing(MpOutput* value)
{
    int closing;
    MP_LOCK(value); closing = value->closing; MP_UNLOCK(value);
    return closing;
}

#if defined(_WIN32)
static DWORD WINAPI mp_output_worker(LPVOID parameter)
{
    MpOutput* value = (MpOutput*)parameter;
    uint32_t next = 0;
    if (value->mode == 2) {
        // A diagnostic sink exercises autonomous scheduling without hardware.
        LARGE_INTEGER rate, now;
        double deadline;
        QueryPerformanceFrequency(&rate); QueryPerformanceCounter(&now);
        deadline = (double)now.QuadPart / rate.QuadPart;
        while (!mp_output_closing(value)) {
            QueryPerformanceCounter(&now);
            if ((double)now.QuadPart / rate.QuadPart >= deadline) {
                MP_LOCK(value); mp_output_render(value, value->buffers[0], MP_OUTPUT_FRAMES); MP_UNLOCK(value);
                deadline += (double)MP_OUTPUT_FRAMES / value->rate;
            } else Sleep(1);
        }
        return 0;
    }
    while (!mp_output_closing(value)) {
        uint32_t count = 0, index;
        ResetEvent(value->event);
        for (index = 0; index < MP_OUTPUT_BUFFERS; ++index)
            if (value->headers[index].dwFlags & WHDR_DONE) ++count;
        if (count == MP_OUTPUT_BUFFERS) {
            MP_LOCK(value); ++value->underruns; MP_UNLOCK(value);
        }
        for (index = 0; index < MP_OUTPUT_BUFFERS; ++index) {
            MMRESULT result;
            WAVEHDR* header = &value->headers[next];
            if (!(header->dwFlags & WHDR_DONE)) break;
            MP_LOCK(value); mp_output_render(value, value->buffers[next], MP_OUTPUT_FRAMES); MP_UNLOCK(value);
            result = waveOutWrite(value->device, header, sizeof(*header));
            if (result != MMSYSERR_NOERROR) {
                MP_LOCK(value); value->error = result; value->closing = 1; MP_UNLOCK(value);
                break;
            }
            next = (next + 1) % MP_OUTPUT_BUFFERS;
        }
        WaitForSingleObject(value->event, 10);
    }
    return 0;
}
#else
static void* mp_output_worker(void* parameter)
{
    MpOutput* value = (MpOutput*)parameter;
    struct timespec now, pause = {0, 1000000};
    double deadline;
    clock_gettime(CLOCK_MONOTONIC, &now);
    deadline = now.tv_sec + now.tv_nsec / 1000000000.0;
    while (!mp_output_closing(value)) {
        clock_gettime(CLOCK_MONOTONIC, &now);
        if (now.tv_sec + now.tv_nsec / 1000000000.0 >= deadline) {
            MP_LOCK(value); mp_output_render(value, value->buffers[0], MP_OUTPUT_FRAMES); MP_UNLOCK(value);
            deadline += (double)MP_OUTPUT_FRAMES / value->rate;
        } else nanosleep(&pause, NULL);
    }
    return NULL;
}
#endif

// Mode 1 is the Windows device, mode 2 a headless timing-test sink. Creating,
// uploading and publishing the ensemble precedes this call, preserving phase.
MP_API int32_t mpAudioOutputStart(void* handle, uint32_t mode)
{
    MpOutput* value = (MpOutput*)handle;
    if (value == NULL || value->mode != 0 || (mode != 1 && mode != 2)) return 0;
#if defined(_WIN32)
    if (mode == 1) {
        WAVEFORMATEX format;
        MMRESULT result;
        uint32_t index;
        memset(&format, 0, sizeof(format));
        format.wFormatTag = WAVE_FORMAT_PCM; format.nChannels = 2;
        format.nSamplesPerSec = value->rate; format.nBlockAlign = 4;
        format.nAvgBytesPerSec = value->rate * 4; format.wBitsPerSample = 16;
        value->event = CreateEvent(NULL, TRUE, FALSE, NULL);
        if (value->event == NULL) return 0;
        result = waveOutOpen(&value->device, WAVE_MAPPER, &format, (DWORD_PTR)value->event, 0, CALLBACK_EVENT);
        if (result != MMSYSERR_NOERROR) { value->error = result; return 0; }
        // Pause while priming so all four periods are queued before playback.
        result = waveOutPause(value->device);
        if (result != MMSYSERR_NOERROR) { value->error = result; return 0; }
        for (index = 0; index < MP_OUTPUT_BUFFERS; ++index) {
            WAVEHDR* header = &value->headers[index];
            header->lpData = (LPSTR)value->buffers[index]; header->dwBufferLength = MP_OUTPUT_FRAMES * 4;
            result = waveOutPrepareHeader(value->device, header, sizeof(*header));
            if (result != MMSYSERR_NOERROR) { value->error = result; return 0; }
            ++value->prepared;
            mp_output_render(value, value->buffers[index], MP_OUTPUT_FRAMES);
            result = waveOutWrite(value->device, header, sizeof(*header));
            if (result != MMSYSERR_NOERROR) { value->error = result; return 0; }
        }
        ResetEvent(value->event);
    }
    value->mode = mode;
    value->thread = CreateThread(NULL, 0, mp_output_worker, value, 0, NULL);
    if (value->thread == NULL) { value->mode = 0; return 0; }
    value->thread_started = 1;
    if (mode == 1) {
        MMRESULT result;
        SetThreadPriority(value->thread, THREAD_PRIORITY_ABOVE_NORMAL);
        result = waveOutRestart(value->device);
        if (result != MMSYSERR_NOERROR) { MP_LOCK(value); value->error = result; MP_UNLOCK(value); return 0; }
    }
#else
    if (mode != 2) return 0;
    value->mode = mode;
    if (pthread_create(&value->thread, NULL, mp_output_worker, value) != 0) { value->mode = 0; return 0; }
    value->thread_started = 1;
#endif
    return 1;
}

MP_API void mpAudioOutputClose(void* handle)
{
    MpOutput* value = (MpOutput*)handle;
    uint32_t index;
    if (value == NULL) return;
    MP_LOCK(value); value->closing = 1; MP_UNLOCK(value);
#if defined(_WIN32)
    if (value->event) SetEvent(value->event);
    if (value->thread_started) { WaitForSingleObject(value->thread, INFINITE); CloseHandle(value->thread); }
    if (value->device) {
        waveOutReset(value->device);
        for (index = 0; index < value->prepared; ++index)
            waveOutUnprepareHeader(value->device, &value->headers[index], sizeof(WAVEHDR));
        waveOutClose(value->device);
    }
    if (value->event) CloseHandle(value->event);
    DeleteCriticalSection(&value->mutex);
#else
    if (value->thread_started) pthread_join(value->thread, NULL);
    pthread_mutex_destroy(&value->mutex);
#endif
    for (index = 0; index < value->clip_count; ++index) free(value->clips[index].data);
    free(value);
}
