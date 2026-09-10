// SPDX-License-Identifier: Apache-2.0
// MiniPixels MP3 decoder bridge. dr_mp3 is fetched at a pinned revision by
// tools/build_audio_runtime.py and remains available under its own license.

#include <stdint.h>
#include <stdlib.h>

#define DR_MP3_IMPLEMENTATION
#define DR_MP3_NO_STDIO
#include "dr_mp3.h"

#if defined(_WIN32)
#define MP_API __declspec(dllexport)
#else
#define MP_API __attribute__((visibility("default")))
#endif

typedef struct MiniPixelsMp3Decoder {
    drmp3 decoder;
    drmp3_uint64 frame_count;
} MiniPixelsMp3Decoder;

MP_API void* mpAudioMp3Open(const void* data, uint64_t size)
{
    MiniPixelsMp3Decoder* value;
    if (data == NULL || size == 0) return NULL;
    value = (MiniPixelsMp3Decoder*)calloc(1, sizeof(*value));
    if (value == NULL) return NULL;
    if (!drmp3_init_memory(&value->decoder, data, (size_t)size, NULL)) {
        free(value);
        return NULL;
    }
    value->frame_count = drmp3_get_pcm_frame_count(&value->decoder);
    if (value->frame_count == 0 || value->decoder.channels < 1 || value->decoder.channels > 2) {
        drmp3_uninit(&value->decoder);
        free(value);
        return NULL;
    }
    return value;
}

MP_API int32_t mpAudioMp3Channels(void* handle)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    return value == NULL ? 0 : (int32_t)value->decoder.channels;
}

MP_API int32_t mpAudioMp3SampleRate(void* handle)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    return value == NULL ? 0 : (int32_t)value->decoder.sampleRate;
}

MP_API uint64_t mpAudioMp3FrameCount(void* handle)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    return value == NULL ? 0 : (uint64_t)value->frame_count;
}

MP_API uint64_t mpAudioMp3Read(void* handle, void* output, uint64_t frames)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    if (value == NULL || output == NULL || frames == 0) return 0;
    return (uint64_t)drmp3_read_pcm_frames_s16(&value->decoder, (drmp3_uint64)frames, (drmp3_int16*)output);
}

MP_API int32_t mpAudioMp3Seek(void* handle, uint64_t frame)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    if (value == NULL || frame > value->frame_count) return 0;
    return drmp3_seek_to_pcm_frame(&value->decoder, (drmp3_uint64)frame) ? 1 : 0;
}

MP_API void mpAudioMp3Close(void* handle)
{
    MiniPixelsMp3Decoder* value = (MiniPixelsMp3Decoder*)handle;
    if (value == NULL) return;
    drmp3_uninit(&value->decoder);
    free(value);
}
