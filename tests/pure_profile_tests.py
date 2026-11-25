#!/usr/bin/env python3
"""Verify the pure MiniLang profile without building any custom runtime bridge."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile
import wave
import zlib

ROOT = Path(__file__).resolve().parents[1]


def pe_imports(path: Path) -> list[str]:
    data = path.read_bytes()
    if data[:2] != b"MZ":
        raise AssertionError("Missing DOS header")
    pe = struct.unpack_from("<I", data, 0x3C)[0]
    if data[pe:pe + 4] != b"PE\0\0":
        raise AssertionError("Missing PE header")
    sections = struct.unpack_from("<H", data, pe + 6)[0]
    optional_size = struct.unpack_from("<H", data, pe + 20)[0]
    optional = pe + 24
    if struct.unpack_from("<H", data, optional)[0] != 0x20B:
        raise AssertionError("Expected PE32+")
    table = optional + optional_size

    def offset(rva: int) -> int:
        for index in range(sections):
            start = table + index * 40
            virtual_size, address, raw_size, raw = struct.unpack_from("<IIII", data, start + 8)
            if address <= rva < address + max(virtual_size, raw_size):
                delta = rva - address
                if delta >= raw_size or raw + delta >= len(data):
                    raise AssertionError("Import RVA outside file-backed section")
                return raw + delta
        raise AssertionError("Import RVA outside image")

    imports = []
    descriptor = offset(struct.unpack_from("<I", data, optional + 120)[0])
    while any(data[descriptor:descriptor + 20]):
        name = offset(struct.unpack_from("<I", data, descriptor + 12)[0])
        end = data.index(b"\0", name)
        imports.append(data[name:end].decode("ascii").lower())
        descriptor += 20
    return imports


def fixtures(directory: Path) -> None:
    expected = bytes((index * index + index // 3) & 31 for index in range(20000))
    (directory / "expected.bin").write_bytes(expected)
    (directory / "stored.zlib").write_bytes(zlib.compress(expected, level=0))
    fixed = zlib.compressobj(level=9, wbits=zlib.MAX_WBITS, strategy=zlib.Z_FIXED)
    (directory / "fixed.zlib").write_bytes(fixed.compress(expected) + fixed.flush())
    dynamic = zlib.compress(expected, level=9)
    if (dynamic[2] >> 1) & 3 != 2:
        raise AssertionError("Fixture must exercise a dynamic Huffman block")
    (directory / "dynamic.zlib").write_bytes(dynamic)
    pixels = bytes((index * 31 + 7) & 255 for index in range(24))
    (directory / "pixels.bin").write_bytes(pixels)

    def chunk(kind: bytes, payload: bytes) -> bytes:
        return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", zlib.crc32(kind + payload))

    png = (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", 3, 2, 8, 6, 0, 0, 0))
           + chunk(b"IDAT", zlib.compress(b"\0" + pixels[:12] + b"\0" + pixels[12:])) + chunk(b"IEND", b""))
    (directory / "image.png").write_bytes(png)
    with wave.open(str(directory / "pcm.wav"), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(1)
        output.setframerate(11025)
        output.writeframes(bytes([0, 64, 128, 255]))
    (directory / "probe.mp3").write_bytes(b"ID3\0\0\0\0\0\0\0")
    (directory / "probe.lz4").write_bytes(b"MPL1" + struct.pack("<I", 4) + b"x")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, default=ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py")
    args = parser.parse_args()
    compiler = args.compiler.resolve()
    build = ROOT / "build" / "pure-profile"
    build.mkdir(parents=True, exist_ok=True)
    results = {}
    for target, suffix in (("linux-x64", ""), ("windows-x64", ".exe")):
        executable = build / ("pure_profile_tests" + suffix)
        subprocess.run([sys.executable, str(compiler), str(ROOT / "tests" / "pure_profile_tests.ml"),
                        str(executable), "--target", target, "-DMINIPIXELS_PURE=true", "-I", str(ROOT / "src"),
                        "-I", str(compiler.parent)], cwd=ROOT, check=True)
        results[target] = {"compiled": True, "executed": False}
        if target == "windows-x64":
            imports = pe_imports(executable)
            forbidden = [name for name in imports if name.startswith(("minipixels", "minilang_", "steam_api"))]
            if forbidden:
                raise AssertionError(f"Pure PE has custom runtime imports: {forbidden}")
            results[target]["imports"] = imports
            print("Pure Windows PE imports:", ", ".join(imports), flush=True)
        can_run = target == ("windows-x64" if os.name == "nt" else "linux-x64")
        if can_run:
            with tempfile.TemporaryDirectory(prefix="fixtures-", dir=build) as temporary:
                directory = Path(temporary)
                fixtures(directory)
                environment = os.environ.copy()
                if target == "linux-x64":
                    environment["LD_DEBUG"] = "libs"
                result = subprocess.run([str(executable), str(directory)], cwd=ROOT, env=environment,
                                        text=True, capture_output=True, timeout=120)
                print(result.stdout, end="", flush=True)
                if result.returncode:
                    print(result.stderr, file=sys.stderr)
                    raise AssertionError(f"Pure profile executable exited {result.returncode}")
                if any(name in result.stderr for name in ("libminipixels_audio", "libminipixels_gpu", "libminilang_video")):
                    raise AssertionError("Pure profile attempted a custom runtime library load")
                results[target]["executed"] = True
    (build / "results.json").write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")
    print("Pure profile compile/import/runtime checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
