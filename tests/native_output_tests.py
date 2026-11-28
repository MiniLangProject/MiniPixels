"""Exercise owned PCM output, click-free transitions and autonomous servicing.

Mode 2 is a headless native worker, not a claim to test a physical device.
The same per-voice renderer and locking are used by the WinMM worker.
"""
from __future__ import annotations

import ctypes as c
import math
from pathlib import Path
import struct
import sys
import time


def main(runtime: str) -> None:
    lib = c.CDLL(str(Path(runtime).resolve()))
    create = lib.mpAudioOutputCreate
    create.argtypes = [c.c_uint32, c.c_uint32]
    create.restype = c.c_void_p
    add = lib.mpAudioOutputAddClip
    add.argtypes = [c.c_void_p, c.c_void_p, c.c_uint64, c.c_uint64,
                   c.c_uint32, c.c_uint32, c.c_uint32, c.c_uint32]
    add.restype = c.c_uint32
    sync = lib.mpAudioOutputSync
    sync.argtypes = [c.c_void_p, c.c_void_p, c.c_uint64, c.c_void_p, c.c_uint64]
    sync.restype = c.c_int32
    render = lib.mpAudioOutputRender
    render.argtypes = [c.c_void_p, c.c_void_p, c.c_uint64, c.c_uint32]
    render.restype = c.c_int32
    start = lib.mpAudioOutputStart
    start.argtypes = [c.c_void_p, c.c_uint32]
    start.restype = c.c_int32
    stats = lib.mpAudioOutputStats
    stats.argtypes = [c.c_void_p, c.c_void_p, c.c_uint64]
    stats.restype = c.c_int32
    close = lib.mpAudioOutputClose
    close.argtypes = [c.c_void_p]
    close.restype = None

    def command(clip=0, generation=0, playing=False, loop=False, cursor=0, left=1., right=1., limited=False):
        return struct.pack("<IIIIQIIII", clip, generation, playing, loop, cursor,
                           round(left * 1_000_000), round(right * 1_000_000), limited, 0)

    def snapshot(handle, commands):
        raw = b"".join(commands)
        data = c.create_string_buffer(raw)
        out = c.create_string_buffer(len(commands) * 16)
        assert sync(handle, data, len(raw), out, len(out)) == 1
        return [struct.unpack_from("<QII", out, i * 16) for i in range(len(commands))]

    def pcm(handle, frames):
        guarded = c.create_string_buffer(b"\xa5" * (frames * 4 + 32))
        assert render(handle, c.byref(guarded, 16), frames * 4, frames) == 1
        assert guarded.raw[:16] == guarded.raw[frames * 4 + 16:frames * 4 + 32] == b"\xa5" * 16
        return struct.unpack_from(f"<{frames * 2}h", guarded, 16)

    assert not create(0, 3) and not create(44100, 0) and not create(44100, 257)
    handle = create(44100, 3)
    assert handle
    try:
        source = c.create_string_buffer(struct.pack("<h", 12000) * 1000)
        assert add(handle, source, 2000, 1001, 44100, 1, 16, 2) == 0
        assert add(handle, source, 2000, 1000, 44100, 1, 12, 2) == 0
        clip = add(handle, source, 2000, 1000, 44100, 1, 16, 2)
        assert clip == 1
        # Destroy the caller's source contents: the worker must own its copy.
        c.memset(source, 0, len(source))
        commands = [command(clip, 1, True, True, left=.5, right=.25), command(), command()]
        snapshot(handle, commands)
        attack = pcm(handle, 256)
        assert 0 < attack[0] < 100 and attack[-2:] == (6000, 3000)
        assert max(abs(attack[i] - attack[i - 2]) for i in range(2, len(attack))) < 100
        assert snapshot(handle, commands)[0][0] == 256, "repeated snapshots must not restart playback"
        # Gain/mute changes ramp over 128 source-independent output frames.
        commands[0] = command(clip, 1, True, True, left=0, right=0)
        snapshot(handle, commands)
        release = pcm(handle, 256)
        assert release[-2:] == (0, 0)
        assert max(abs(release[i] - release[i - 2]) for i in range(2, len(release))) < 100
        assert snapshot(handle, commands)[0][0] == 512
        commands[1] = command(clip, 1, True, True, cursor=512, left=0, right=0)
        commands[2] = command(clip, 1, True, True, cursor=512, left=0, right=0)
        snapshot(handle, commands)
        assert not any(pcm(handle, 2048))
        states = snapshot(handle, commands)
        assert [state[0] for state in states] == [560, 560, 560], "silent stems retain exact loop phase"
        # A new generation retriggers the same source and channel explicitly.
        commands[0] = command(clip, 2, True, False, left=.5, right=.5)
        assert snapshot(handle, commands)[0][0] == 0
        pcm(handle, 1200)
        assert snapshot(handle, commands)[0][1] == 0
        assert not any(pcm(handle, 200)), "a stale completed snapshot must not retrigger an effect"
        commands[0] = command(clip, 3, True, True, left=.5, right=.5)
        snapshot(handle, commands)
        pcm(handle, 256)
        commands[0] = command()
        snapshot(handle, commands)
        stopped = pcm(handle, 256)
        assert stopped[0] > 5000 and stopped[-2:] == (0, 0)
        assert max(abs(stopped[i] - stopped[i - 2]) for i in range(2, len(stopped))) < 100
        # A bad snapshot is rejected atomically; it cannot modify earlier voices.
        commands[0] = command(clip, 4, True, True, left=.5, right=.5)
        snapshot(handle, commands)
        pcm(handle, 256)
        invalid = c.create_string_buffer(command() + command(999, 1, True) + command())
        out = c.create_string_buffer(48)
        assert sync(handle, invalid, 120, out, 48) == 0
        assert pcm(handle, 16)[-2:] == (6000, 6000)
        commands = [command(clip, 5, True, True, limited=True)] + [command(clip, 5, True, True)] * 2
        snapshot(handle, commands)
        limited = pcm(handle, 512)
        expected = math.floor(24000 + 8000 * (1 - math.exp(-12000 / 8000)))
        assert limited[-2:] == (expected, expected), "autonomous mixer uses the documented smooth knee"
        assert max(map(abs, limited)) <= 32000
    finally:
        close(handle)

    finish_limited = lib.mpAudioMixFinishLimited
    finish_limited.argtypes = [c.c_void_p, c.c_uint64, c.c_void_p, c.c_uint64, c.c_uint64]
    finish_limited.restype = c.c_int32
    values = [-1e8, -50000., -24001., -24000., -1000.5, 0., 1000.5, 24000., 24001., 50000., 1e8, float("nan")]
    source = (c.c_double * len(values))(*values)
    destination = c.create_string_buffer(len(values) * 2)
    assert finish_limited(source, c.sizeof(source), destination, len(destination), len(values) // 2)
    actual = struct.unpack(f"<{len(values)}h", destination.raw)
    expected = [0 if math.isnan(v) else math.floor(v if abs(v) <= 24000 else math.copysign(24000 + 8000 * (1 - math.exp(-(abs(v) - 24000) / 8000)), v)) for v in values]
    assert list(actual) == expected
    assert max(map(abs, actual)) <= 32000

    # The independent worker continues producing and advancing all 33 voices
    # while the host makes no update calls for far more than the old 69.7-ms queue.
    handle = create(44100, 33)
    assert handle
    elapsed = produced = 0
    try:
        values = [round(3000 * math.sin(math.tau * 220 * i / 44100)) for i in range(44100)]
        source = c.create_string_buffer(struct.pack(f"<{len(values)}h", *values))
        clip = add(handle, source, len(values) * 2, len(values), 44100, 1, 16, 2)
        commands = [command(clip, 1, True, True, left=.01, right=.01) for _ in range(33)]
        snapshot(handle, commands)
        assert start(handle, 2) == 1
        then = time.monotonic()
        time.sleep(.350)
        elapsed = time.monotonic() - then
        output = c.create_string_buffer(24)
        assert stats(handle, output, 24) == 1
        produced, underruns, error, copied = struct.unpack("<QIIQ", output.raw)
        assert produced >= 44100 * min(elapsed, .350) * .90, "worker must advance during host stalls"
        assert error == 0 and copied == 88200
        states = snapshot(handle, commands)
        assert len({state[0] for state in states}) == 1, "all stems remain exactly aligned"
        assert all(state[1] == 1 for state in states)
        # Offline render must never race the device/diagnostic worker.
        out = c.create_string_buffer(16)
        assert render(handle, out, 16, 4) == 0
    finally:
        close(handle)
    print(f"[OK] Independent output: owned PCM, transitions, phases, generations, atomic bounds; "
          f"33-voice worker produced {produced} frames during {elapsed:.3f}s host stall (headless sink)")


if __name__ == "__main__":
    main(sys.argv[1])
