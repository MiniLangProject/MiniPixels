"""Opt-in smoke test of the real SDK bridge; never modifies achievements or stats.

Run in a separate process for each library/client scenario. SteamAppId=480 is
development-only and must be supplied by the caller when exercising a client.
"""
import argparse
import ctypes
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("library", type=Path)
    expectation = parser.add_mutually_exclusive_group()
    expectation.add_argument("--require-client", action="store_true")
    expectation.add_argument("--expect-unavailable", action="store_true")
    parser.add_argument("--missing-runtime", action="store_true")
    args = parser.parse_args()
    bridge = ctypes.CDLL(str(args.library.resolve()))
    call = bridge.mpSteamCall
    call.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_int64, ctypes.c_void_p, ctypes.c_int32]
    call.restype = ctypes.c_int64
    buffer = ctypes.create_string_buffer(2048)

    def invoke(op, value=0):
        return call(op, b"", value, buffer, len(buffer))

    try:
        initialized = invoke(1, 480)
        assert initialized in (0, 1)
        invoke(17)
        diagnostic = buffer.value.decode("utf-8", errors="replace")
        assert "missing export" not in diagnostic, diagnostic
        assert "Test stub" not in diagnostic, "Expected a real SDK bridge"
        if args.missing_runtime:
            assert not initialized and "runtime missing beside" in diagnostic, diagnostic
        elif args.require_client:
            assert initialized == 1, diagnostic
        elif args.expect_unavailable:
            assert initialized == 0, "Unexpected Steam client initialization"
        if initialized:
            assert invoke(6) == 1
            assert invoke(8) > 0 and buffer.value.isdigit(), "SteamID output must be decimal"
            assert invoke(7) > 0, "Expected a persona name"
            assert invoke(9) > 0, "Expected a language"
            for _ in range(8):
                assert invoke(3) == 1
            assert invoke(16) == 0, "Read-only test must not store stats"
            print("Real Steam SDK: connected; identity, language and callbacks verified")
        else:
            assert invoke(6) == 0
            assert invoke(12) == -1
            assert invoke(14) == -2147483649
            print("Real Steam SDK: unavailable fallback verified; " + diagnostic)
    finally:
        invoke(4)
        invoke(4)
    assert invoke(6) == 0, "Shutdown must release the session"
    print("Steam SDK smoke passed")


if __name__ == "__main__":
    main()
