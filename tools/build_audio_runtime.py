#!/usr/bin/env python3
"""Build the small native MP3 decoder used by the MiniPixels mixer."""

from __future__ import annotations

import argparse
import hashlib
import os
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "tools" / "native_audio" / "audio_decoder.c"
DR_MP3_COMMIT = "dfe8377631000664666519fdb83da193fd8037f4"
DR_MP3_URL = f"https://raw.githubusercontent.com/mackron/dr_libs/{DR_MP3_COMMIT}/dr_mp3.h"
DR_MP3_SHA256 = "997b7ee18de6e6b81e2a83f1ea9fc62aef25c62b28d48db95635f49e65de0a2f"


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _ensure_header(vendor_dir: Path) -> Path:
    header = vendor_dir / "dr_mp3.h"
    if header.is_file() and _sha256(header) == DR_MP3_SHA256:
        return header
    vendor_dir.mkdir(parents=True, exist_ok=True)
    temporary = header.with_suffix(".download")
    try:
        with urllib.request.urlopen(DR_MP3_URL, timeout=30) as response:
            temporary.write_bytes(response.read())
        actual = _sha256(temporary)
        if actual != DR_MP3_SHA256:
            raise RuntimeError(f"dr_mp3 checksum mismatch: expected {DR_MP3_SHA256}, got {actual}")
        temporary.replace(header)
    except Exception:
        if temporary.exists():
            temporary.unlink()
        raise
    return header


def _visual_studio_root() -> Path:
    vswhere = Path(os.environ.get("ProgramFiles(x86)", r"C:\Program Files (x86)")) / "Microsoft Visual Studio" / "Installer" / "vswhere.exe"
    if not vswhere.is_file():
        raise RuntimeError("Visual Studio Build Tools with the x64 C++ toolchain are required for Windows MP3 support")
    result = subprocess.run(
        [str(vswhere), "-latest", "-products", "*", "-requires", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64", "-property", "installationPath"],
        check=True,
        text=True,
        capture_output=True,
    )
    if not result.stdout.strip():
        raise RuntimeError("Visual Studio Build Tools with the x64 C++ toolchain are required for Windows MP3 support")
    return Path(result.stdout.strip())


def _wsl_path(path: Path) -> str:
    resolved = path.resolve()
    drive = resolved.drive.rstrip(":").lower()
    tail = resolved.as_posix().split(":", 1)[-1]
    return f"/mnt/{drive}{tail}"


def _build_windows(build_dir: Path, header: Path) -> Path:
    output = build_dir / "minipixels_audio.dll"
    if output.is_file() and output.stat().st_mtime >= max(SOURCE.stat().st_mtime, header.stat().st_mtime):
        return output
    vcvars = _visual_studio_root() / "VC" / "Auxiliary" / "Build" / "vcvars64.bat"
    obj = build_dir / "audio_decoder.obj"
    lib = build_dir / "minipixels_audio.lib"
    command_file = build_dir / "build_audio.cmd"
    command_file.write_text(
        "@echo off\n"
        f'call "{vcvars}" >nul\n'
        "if errorlevel 1 exit /b %errorlevel%\n"
        f'cl /nologo /O2 /MT /LD /TC "{SOURCE}" /I"{header.parent}" /Fo"{obj}" '
        f'/link /OUT:"{output}" /IMPLIB:"{lib}"\n',
        encoding="utf-8",
    )
    subprocess.run(["cmd.exe", "/d", "/c", str(command_file)], check=True)
    return output


def _build_linux(build_dir: Path, header: Path) -> Path:
    output = build_dir / "libminipixels_audio.so"
    if output.is_file() and output.stat().st_mtime >= max(SOURCE.stat().st_mtime, header.stat().st_mtime):
        return output
    args = ["gcc", "-std=c99", "-O3", "-fPIC", "-fvisibility=hidden", "-shared", str(SOURCE), f"-I{header.parent}", "-o", str(output)]
    if os.name == "nt":
        distro = os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu")
        args = [
            "wsl.exe", "-d", distro, "--", "gcc", "-std=c99", "-O3", "-fPIC", "-fvisibility=hidden", "-shared",
            _wsl_path(SOURCE), f"-I{_wsl_path(header.parent)}", "-o", _wsl_path(output),
        ]
    subprocess.run(args, check=True)
    return output


def ensure_audio_runtime(target: str, output_dir: Path | None = None) -> Path:
    if target not in ("windows-x64", "linux-x64"):
        raise ValueError(f"unsupported audio runtime target: {target}")
    build_dir = ROOT / "build" / "native-audio" / target
    vendor_dir = ROOT / "build" / "native-audio" / "vendor" / DR_MP3_COMMIT
    build_dir.mkdir(parents=True, exist_ok=True)
    header = _ensure_header(vendor_dir)
    runtime = _build_windows(build_dir, header) if target == "windows-x64" else _build_linux(build_dir, header)
    if output_dir is None:
        return runtime
    destination = Path(output_dir).resolve() / runtime.name
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination != runtime.resolve():
        shutil.copy2(runtime, destination)
    return destination


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", choices=("windows-x64", "linux-x64"), required=True)
    parser.add_argument("--output-dir")
    args = parser.parse_args(argv)
    print(ensure_audio_runtime(args.target, Path(args.output_dir) if args.output_dir else None))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
