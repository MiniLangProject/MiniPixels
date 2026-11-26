"""Compare the bounded PCM bridge against an independent scalar oracle."""
from __future__ import annotations

import ctypes as c
import math
from pathlib import Path
import random
import struct
import sys


def main(runtime):
    lib = c.CDLL(str(Path(runtime).resolve()))
    mix = lib.mpAudioMixPcm
    mix.argtypes = [c.c_void_p, c.c_uint64, c.c_uint64, c.c_void_p,
                   c.c_uint64, c.c_uint64, c.c_uint64, c.c_int32,
                   c.c_int32, c.c_int32, c.c_double, c.c_double,
                   c.c_double, c.c_double, c.c_void_p]
    mix.restype = c.c_double
    finish = lib.mpAudioMixFinish
    finish.argtypes = [c.c_void_p, c.c_uint64, c.c_void_p, c.c_uint64, c.c_uint64]
    finish.restype = c.c_int32
    clear = lib.mpAudioMixClear
    clear.argtypes = [c.c_void_p, c.c_uint64]
    clear.restype = None
    rng = random.Random(9182)
    cases = 0

    def sample(data, index, bits):
        width = bits // 8
        raw = int.from_bytes(data[index:index + width], 'little', signed=bits != 8)
        return (raw - 128) * 256 if bits == 8 else raw / (2 ** max(0, bits - 16))

    for bits in (8, 16, 24, 32):
        for channels in (1, 2):
            for rate in (11025, 22050, 44100, 48000, 96000):
                for source_start in (0, 17):
                    frames = 127
                    align = channels * (bits // 8) + (1 if cases % 2 else 0)
                    data = rng.randbytes(frames * align)
                    source = c.create_string_buffer(data)
                    count = 97
                    destination = (c.c_double * (count * 2))()
                    expected = [0.0] * (count * 2)
                    for voice in range(9):
                        start = source_start + rng.randrange(0, 20) + 0.375
                        step = rate / 44100.0
                        # Fractional products exercise the old percentage bug.
                        gain = (37.0 * 83 * 99) / 10000
                        pan = (-100, -37, 0, 17, 100)[voice % 5]
                        left = gain * (100 - pan) / 100 if pan > 0 else gain
                        right = gain * (100 + pan) / 100 if pan < 0 else gain
                        if voice == 8:
                            left = right = 0.0
                        output_start = voice % 4
                        cursor = start
                        used = 0
                        while output_start + used < count and source_start <= cursor < source_start + frames:
                            offset = (int(cursor) - source_start) * align
                            l = sample(data, offset, bits)
                            r = l if channels == 1 else sample(data, offset + bits // 8, bits)
                            expected[(output_start + used) * 2] += l * left / 100
                            expected[(output_start + used) * 2 + 1] += r * right / 100
                            cursor += step
                            used += 1
                        result = c.c_uint64(999)
                        actual_cursor = mix(destination, c.sizeof(destination), output_start,
                                            source, len(data), source_start, frames, channels,
                                            bits, align, start, step, left, right, c.byref(result))
                        assert result.value == used and actual_cursor == cursor
                    assert list(destination) == expected, (bits, channels, rate, source_start)
                    guarded = c.create_string_buffer(b'\xa5' * (count * 4 + 32))
                    assert finish(destination, c.sizeof(destination), c.byref(guarded, 16), count * 4, count) == 1
                    packed = b''.join(struct.pack('<h', max(-32768, min(32767, math.floor(x)))) for x in expected)
                    assert guarded.raw[16:16 + count * 4] == packed
                    assert guarded.raw[:16] == guarded.raw[16 + count * 4:32 + count * 4] == b'\xa5' * 16
                    clear(destination, c.sizeof(destination))
                    assert list(destination) == [0.0] * (count * 2)
                    cases += 1

    # Invalid source shapes cannot read beyond a supplied buffer or write output.
    destination = (c.c_double * 8)()
    data = c.create_string_buffer(b'\x00' * 16)
    for kwargs in ((2, 16, 4, 7), (3, 16, 6, 2), (1, 12, 2, 4), (2, 16, 1, 4)):
        channels, bits, align, frames = kwargs
        result = c.c_uint64(999)
        cursor = mix(destination, c.sizeof(destination), 0, data, 16, 0, frames,
                     channels, bits, align, 0.0, 1.0, 100.0, 100.0, c.byref(result))
        assert result.value == 0 and cursor == 0 and list(destination) == [0.0] * 8
    # A rounded double lower bound must not underflow the absolute frame index.
    result = c.c_uint64(999)
    cursor = mix(destination, c.sizeof(destination), 0, data, 16, 2**53 + 1, 1,
                 1, 16, 2, float(2**53), 1.0, 100.0, 100.0, c.byref(result))
    assert result.value == 0 and cursor == float(2**53) and list(destination) == [0.0] * 8
    # Silent advancement is independent of sample availability and still stops.
    result = c.c_uint64()
    cursor = mix(destination, c.sizeof(destination), 0, None, 0, 0, 3,
                 1, 16, 2, 1.5, 0.5, 0.0, 0.0, c.byref(result))
    assert result.value == 3 and cursor == 3.0
    guarded = c.create_string_buffer(b'\xa5' * 16)
    assert finish(destination, c.sizeof(destination), guarded, 15, 4) == 0
    assert guarded.raw[:16] == b'\xa5' * 16
    print(f'Native PCM oracle passed: {cases} format/rate/offset cases, 9 voices each; clipping, pans, silence and bounds')


if __name__ == '__main__':
    main(sys.argv[1])
