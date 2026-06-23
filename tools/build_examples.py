#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
EXAMPLES = [
    "examples/moving-sprite/minipixels.json",
    "examples/scrolling-world/minipixels.json",
    "examples/pixel-effects/minipixels.json",
    "examples/jump-and-run/minipixels.json",
]


def main() -> int:
    for project in EXAMPLES:
        cmd = [
            sys.executable,
            str(ROOT / "tools" / "minipixels.py"),
            "build",
            project,
            "--compiler",
            str(COMPILER),
        ]
        print("build-example:", " ".join(cmd))
        subprocess.check_call(cmd, cwd=str(ROOT))
    print("MiniPixels example builds passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
