#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
DEFAULT_TARGET = "windows-x64" if os.name == "nt" else "linux-x64"
EXAMPLES = [
    "examples/moving-sprite/minipixels.json",
    "examples/scrolling-world/minipixels.json",
    "examples/pixel-effects/minipixels.json",
    "examples/jump-and-run/minipixels.json",
    "examples/tiled-platformer/minipixels.json",
]


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Build every MiniPixels example")
    parser.add_argument("--target", choices=("windows-x64", "linux-x64"), default=DEFAULT_TARGET)
    parser.add_argument("--compiler", default=str(COMPILER))
    args = parser.parse_args(argv)
    for project in EXAMPLES:
        cmd = [
            sys.executable,
            str(ROOT / "tools" / "minipixels.py"),
            "build",
            project,
            "--compiler",
            str(Path(args.compiler).resolve()),
            "--target",
            args.target,
        ]
        print("build-example:", " ".join(cmd))
        subprocess.check_call(cmd, cwd=str(ROOT))
    print(f"MiniPixels example builds passed ({args.target})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
