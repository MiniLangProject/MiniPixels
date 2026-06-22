#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
TESTS = ["canvas_tests.ml", "systems_tests.ml", "headless_game_tests.ml"]


def run_python_tests() -> None:
    spec = importlib.util.spec_from_file_location("minipixels_cli", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    literal = mod.bytes_literal(bytes([0, 0, 255, 0, 255, 0]))
    assert "pix = bytes(6, 0)" in literal, literal
    assert "pix[2] = 255" in literal, literal
    assert "pix[4] = 255" in literal, literal
    assert "pix[0]" not in literal, literal
    print("Python tool tests passed")


def main() -> int:
    run_python_tests()
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
