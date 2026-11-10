"""Exercise the bounded native LZ4 ABI in an isolated process on either target."""
import ctypes
import random
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from lz4_block import encode


def main(runtime):
    lib = ctypes.CDLL(str(Path(runtime).resolve()))
    decode = lib.mpAssetDecodeLz4
    decode.argtypes = [ctypes.c_void_p, ctypes.c_uint64, ctypes.c_void_p,
                       ctypes.c_uint64, ctypes.c_uint64, ctypes.c_uint64]
    decode.restype = ctypes.c_int32
    rng = random.Random(412)

    def run(block, size, expected=None, offset=7, length=None, source_size=None):
        source = ctypes.create_string_buffer(b"PREFIX!" + block + b"SUFFIX!")
        output = ctypes.create_string_buffer(b"\xa5" * (size + 32))
        result = decode(ctypes.byref(output, 16), size, source,
                        len(source.raw) - 1 if source_size is None else source_size,
                        offset, len(block) if length is None else length)
        assert output.raw[:16] == b"\xa5" * 16
        assert output.raw[16 + size:32 + size] == b"\xa5" * 16
        if expected is not None:
            assert result == 1 and output.raw[16:16 + size] == expected
        return result

    for size in (0, 1, 4, 12, 13, 255, 256, 4096, 65536):
        for raw in (rng.randbytes(size), b"x" * size, (b"abc123" * (size // 6 + 1))[:size]):
            block = encode(raw)
            run(block, size, raw)
            if block:
                assert run(block[:-1], size) == 0
            assert run(block, size + 1) == 0
    for block in (b"", b"\x10", b"\xf0\xff", b"\x00\x00\x00", b"\x00\xff\xff"):
        assert run(block, 32) == 0
    valid = encode(b"abc")
    assert run(valid, 3, offset=1000) == 0
    assert run(valid, 3, length=1000) == 0
    assert run(valid, 3, source_size=6) == 0
    for _ in range(200):
        run(rng.randbytes(rng.randrange(0, 64)), rng.randrange(0, 256))
    print("Native LZ4 ABI tests passed (round trips, bounds, malformed blocks, guarded output)")


if __name__ == "__main__":
    main(sys.argv[1])
