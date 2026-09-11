// SPDX-License-Identifier: Apache-2.0
// MiniPixels MP3 decoder bridge. dr_mp3 is fetched at a pinned revision by
// tools/build_audio_runtime.py and remains available under its own license.

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

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
