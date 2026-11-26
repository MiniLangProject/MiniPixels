// SPDX-License-Identifier: Apache-2.0
// MiniPixels native audio, asset-decoding, and pixel-conversion bridge.
// Third-party dependencies are fetched at pinned revisions by
// tools/build_audio_runtime.py and remain available under their own licenses.

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define DR_MP3_IMPLEMENTATION
#define DR_MP3_NO_STDIO
#include "dr_mp3.h"

#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_ZLIB
#define STBI_SUPPORT_ZLIB
#define STBI_NO_STDIO
#define STBI_NO_SIMD
#define STBI_NO_LINEAR
#define STBI_NO_HDR
#define STBI_NO_FAILURE_STRINGS
#include "stb_image.h"

/* Pinned BSD-2-Clause LZ4 reference decoder; compiled into this bridge. */
#include "lz4.c"

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

/* Bounded, allocation-free PCM accumulation. The language owns every source,
 * destination and decoder; this kernel never retains managed pointers. Samples
 * use the existing nearest-source-frame rule and ordered double additions. */
static double mpAudioPcmSample(const uint8_t* sample, int32_t bits)
{
    uint32_t raw;
    if (bits == 8) return ((int32_t)sample[0] - 128) * 256.0;
    raw = (uint32_t)sample[0] | ((uint32_t)sample[1] << 8);
    if (bits == 16) return raw >= 32768 ? (double)raw - 65536.0 : (double)raw;
    raw |= (uint32_t)sample[2] << 16;
    if (bits == 24) return (raw >= 8388608 ? (double)raw - 16777216.0 : (double)raw) / 256.0;
    raw |= (uint32_t)sample[3] << 24;
    return (raw >= UINT32_C(2147483648) ? (double)raw - 4294967296.0 : (double)raw) / 65536.0;
}

MP_API void mpAudioMixClear(void* destination, uint64_t bytes)
{
    if (destination != NULL && bytes <= SIZE_MAX) memset(destination, 0, (size_t)bytes);
}

MP_API double mpAudioMixPcm(
    void* destination, uint64_t mix_bytes, uint64_t output_frame,
    const void* source, uint64_t source_bytes, uint64_t source_start, uint64_t source_frames,
    int32_t channels, int32_t bits, int32_t block_align,
    double cursor, double step, double left_gain, double right_gain, void* result)
{
    uint64_t count = 0;
    uint64_t mix_frames = mix_bytes / 16;
    uint64_t frame;
    int32_t sample_bytes = bits / 8;
    int silent = left_gain == 0.0 && right_gain == 0.0;
    double* mix = (double*)destination;
    const uint8_t* pcm = (const uint8_t*)source;
    if (result == NULL) return cursor;
    memcpy(result, &count, sizeof(count));
    if (destination == NULL || output_frame >= mix_frames || mix_bytes > SIZE_MAX || mix_bytes % 16 != 0 ||
        !(cursor >= 0.0 && cursor < 18446744073709551616.0) || !(step > 0.0 && step < 18446744073709551616.0) ||
        source_frames > UINT64_MAX - source_start) return cursor;
    if (!silent && (source == NULL || channels < 1 || channels > 2 ||
        (bits != 8 && bits != 16 && bits != 24 && bits != 32) || block_align < channels * sample_bytes ||
        source_bytes > SIZE_MAX || source_frames > source_bytes / (uint32_t)block_align)) return cursor;
    while (output_frame + count < mix_frames && cursor >= (double)source_start &&
           cursor < (double)(source_start + source_frames)) {
        /* Double rounding at large absolute offsets must not turn the lower
         * bound into an unsigned underflow or round past the last source frame. */
        frame = (uint64_t)cursor;
        if (frame < source_start || frame - source_start >= source_frames) break;
        frame -= source_start;
        if (!silent) {
            const uint8_t* sample = pcm + (size_t)frame * (uint32_t)block_align;
            double left = mpAudioPcmSample(sample, bits);
            double right = channels == 1 ? left : mpAudioPcmSample(sample + sample_bytes, bits);
            mix[(output_frame + count) * 2] += (left * left_gain) / 100.0;
            mix[(output_frame + count) * 2 + 1] += (right * right_gain) / 100.0;
        }
        cursor += step;
        ++count;
    }
    memcpy(result, &count, sizeof(count));
    return cursor;
}

MP_API int32_t mpAudioMixFinish(
    const void* source, uint64_t source_bytes, void* destination, uint64_t destination_bytes, uint64_t frames)
{
    uint64_t sample;
    const double* mix = (const double*)source;
    uint8_t* pcm = (uint8_t*)destination;
    if (source == NULL || destination == NULL || source_bytes > SIZE_MAX || destination_bytes > SIZE_MAX ||
        frames > source_bytes / 16 || frames > destination_bytes / 4) return 0;
    for (sample = 0; sample < frames * 2; ++sample) {
        double value = mix[sample];
        int32_t integer;
        uint16_t packed;
        if (value != value) integer = 0;
        else if (value <= -32768.0) integer = -32768;
        else if (value >= 32767.0) integer = 32767;
        else {
            integer = (int32_t)value;
            if ((double)integer > value) --integer; /* floor, including negatives */
        }
        packed = (uint16_t)integer;
        pcm[sample * 2] = (uint8_t)packed;
        pcm[sample * 2 + 1] = (uint8_t)(packed >> 8);
    }
    return 1;
}

MP_API int32_t mpAssetDecodeLz4(
    void* destination, uint64_t destination_size,
    const void* source, uint64_t source_buffer_size,
    uint64_t source_offset, uint64_t source_size)
{
    int result;
    if (destination == NULL || source == NULL || destination_size > INT32_MAX ||
        source_size > INT32_MAX || source_buffer_size > SIZE_MAX ||
        source_offset > source_buffer_size || source_size > source_buffer_size - source_offset) return 0;
    result = LZ4_decompress_safe((const char*)source + (size_t)source_offset,
        (char*)destination, (int)source_size, (int)destination_size);
    return result >= 0 && (uint64_t)result == destination_size;
}

MP_API int32_t mpAssetInflateZlib(
    void* destination,
    uint64_t destination_size,
    const void* source,
    uint64_t source_offset,
    uint64_t source_size)
{
    int result;
    if (destination == NULL || source == NULL || destination_size > INT32_MAX || source_size > INT32_MAX) return 0;
    if (destination_size == 0) return source_size == 0 ? 1 : 0;
    result = stbi_zlib_decode_buffer(
        (char*)destination,
        (int)destination_size,
        (const char*)source + source_offset,
        (int)source_size);
    return result == (int)destination_size ? 1 : 0;
}

/* Pixel presentation helpers live in the already-required native runtime so
 * Linux games do not need another sidecar library. They deliberately operate
 * on complete validated rows/frames; clipping remains in the engine. */
MP_API void mpPixelsRgbaToBgra(
    void* destination,
    uint64_t destination_offset,
    const void* source,
    uint64_t source_offset,
    int32_t pixel_count)
{
    uint8_t* dst;
    const uint8_t* src;
    int32_t x;
    if (destination == NULL || source == NULL || pixel_count <= 0) return;
    dst = (uint8_t*)destination + destination_offset;
    src = (const uint8_t*)source + source_offset;
    for (x = 0; x < pixel_count; ++x) {
        dst[0] = src[2];
        dst[1] = src[1];
        dst[2] = src[0];
        dst[3] = 0;
        dst += 4;
        src += 4;
    }
}

MP_API int32_t mpPixelsScaleIntegerBgra(
    void* destination,
    int32_t destination_width,
    int32_t destination_height,
    const void* source,
    int32_t source_width,
    int32_t source_height,
    int32_t viewport_x,
    int32_t viewport_y,
    int32_t factor)
{
    uint8_t* dst = (uint8_t*)destination;
    const uint8_t* src = (const uint8_t*)source;
    int32_t source_y;
    size_t row_bytes;
    if (dst == NULL || src == NULL || destination_width < 1 || destination_height < 1 ||
        source_width < 1 || source_height < 1 || factor < 1 || viewport_x < 0 || viewport_y < 0 ||
        (int64_t)viewport_x + (int64_t)source_width * factor > destination_width ||
        (int64_t)viewport_y + (int64_t)source_height * factor > destination_height) return 0;
    row_bytes = (size_t)source_width * (size_t)factor * 4;
    for (source_y = 0; source_y < source_height; ++source_y) {
        uint8_t* first_row = dst + (((size_t)viewport_y + (size_t)source_y * factor) * destination_width + viewport_x) * 4;
        uint8_t* out = first_row;
        int32_t source_x;
        int32_t duplicate_y;
        for (source_x = 0; source_x < source_width; ++source_x) {
            const uint8_t* pixel = src + ((size_t)source_y * source_width + source_x) * 4;
            int32_t duplicate_x;
            for (duplicate_x = 0; duplicate_x < factor; ++duplicate_x) {
                out[0] = pixel[2]; out[1] = pixel[1]; out[2] = pixel[0]; out[3] = 0;
                out += 4;
            }
        }
        for (duplicate_y = 1; duplicate_y < factor; ++duplicate_y) {
            memcpy(first_row + (size_t)duplicate_y * destination_width * 4, first_row, row_bytes);
        }
    }
    return 1;
}

MP_API int32_t mpPixelsScaleNearestBgra(
    void* destination,
    int32_t destination_width,
    int32_t destination_height,
    const void* source,
    int32_t source_width,
    int32_t source_height,
    int32_t viewport_x,
    int32_t viewport_y,
    int32_t viewport_width,
    int32_t viewport_height)
{
    uint8_t* dst = (uint8_t*)destination;
    const uint8_t* src = (const uint8_t*)source;
    int32_t start_x, start_y, end_x, end_y, y;
    if (dst == NULL || src == NULL || destination_width < 1 || destination_height < 1 ||
        source_width < 1 || source_height < 1 || viewport_width < 1 || viewport_height < 1) return 0;
    memset(dst, 0, (size_t)destination_width * destination_height * 4);
    start_x = viewport_x < 0 ? 0 : viewport_x;
    start_y = viewport_y < 0 ? 0 : viewport_y;
    end_x = viewport_x + viewport_width;
    end_y = viewport_y + viewport_height;
    if (end_x > destination_width) end_x = destination_width;
    if (end_y > destination_height) end_y = destination_height;
    if (start_x >= end_x || start_y >= end_y) return 1;
    for (y = start_y; y < end_y; ++y) {
        int32_t source_y = (int32_t)(((int64_t)(y - viewport_y) * source_height) / viewport_height);
        uint8_t* out = dst + ((size_t)y * destination_width + start_x) * 4;
        int32_t x;
        for (x = start_x; x < end_x; ++x) {
            int32_t source_x = (int32_t)(((int64_t)(x - viewport_x) * source_width) / viewport_width);
            const uint8_t* pixel = src + ((size_t)source_y * source_width + source_x) * 4;
            out[0] = pixel[2]; out[1] = pixel[1]; out[2] = pixel[0]; out[3] = 0;
            out += 4;
        }
    }
    return 1;
}
