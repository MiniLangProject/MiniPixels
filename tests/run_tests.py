#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
TESTS = ["canvas_tests.ml", "systems_tests.ml", "headless_game_tests.ml"]


def main() -> int:
    build = ROOT / "build" / "tests"
    build.mkdir(parents=True, exist_ok=True)
    for test in TESTS:
        src = ROOT / "tests" / test
        exe = build / (Path(test).stem + ".exe")
        cmd = [sys.executable, str(COMPILER), str(src), str(exe), "-I", str(ROOT / "src"), "-I", str(ROOT.parent / "MiniLangCompilerPy")]
        print("compile:", " ".join(cmd))
        subprocess.check_call(cmd, cwd=str(ROOT))
        print("run:", exe)
        subprocess.check_call([str(exe)], cwd=str(ROOT))
    print("MiniPixels tests passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
