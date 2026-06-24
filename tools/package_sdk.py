#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INCLUDE_DIRS = [
    ".github",
    "benchmarks",
    "docs",
    "examples",
    "src",
    "tests",
    "tools",
]
INCLUDE_FILES = [
    "CHANGELOG.md",
    "LICENSE",
    "README.md",
    "VERSION",
]
EXCLUDED_DIRS = {
    ".asset-work",
    ".git",
    "__pycache__",
    "build",
    "dist",
}
EXCLUDED_SUFFIXES = {
    ".exe",
    ".ilk",
    ".obj",
    ".pdb",
    ".pyc",
    ".zip",
}


def read_version() -> str:
    return (ROOT / "VERSION").read_text(encoding="utf-8").strip()


def include_path(path: Path) -> bool:
    rel_parts = path.relative_to(ROOT).parts
    if any(part in EXCLUDED_DIRS for part in rel_parts):
        return False
    if path.suffix.lower() in EXCLUDED_SUFFIXES:
        return False
    return True


def iter_files() -> list[Path]:
    files: list[Path] = []
    for name in INCLUDE_FILES:
        path = ROOT / name
        if path.exists() and path.is_file():
            files.append(path)
    for name in INCLUDE_DIRS:
        root = ROOT / name
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if path.is_file() and include_path(path):
                files.append(path)
    return sorted(set(files), key=lambda p: p.relative_to(ROOT).as_posix())


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        while True:
            chunk = f.read(1024 * 1024)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()


def package_sdk(output_dir: Path) -> Path:
    version = read_version()
    output_dir.mkdir(parents=True, exist_ok=True)
    package_root = f"MiniPixels-{version}"
    zip_path = output_dir / f"{package_root}-sdk.zip"
    if zip_path.exists():
        zip_path.unlink()

    files = iter_files()
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for path in files:
            rel = path.relative_to(ROOT).as_posix()
            zf.write(path, f"{package_root}/{rel}")
        manifest = {
            "name": "MiniPixels",
            "version": version,
            "fileCount": len(files),
            "root": package_root,
        }
        zf.writestr(f"{package_root}/sdk-manifest.json", json.dumps(manifest, indent=2, sort_keys=True) + "\n")

    checksum = sha256(zip_path)
    checksum_path = output_dir / f"{zip_path.name}.sha256"
    checksum_path.write_text(f"{checksum}  {zip_path.name}\n", encoding="utf-8")
    print(zip_path)
    print(checksum_path)
    return zip_path


def main() -> int:
    parser = argparse.ArgumentParser(prog="package_sdk")
    parser.add_argument("--output-dir", default=str(ROOT / "dist"))
    args = parser.parse_args()
    package_sdk(Path(args.output_dir).resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
