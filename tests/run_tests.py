#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
import importlib.util
import json
import tempfile
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
TESTS = ["canvas_tests.ml", "systems_tests.ml", "headless_game_tests.ml", "render_regression_tests.ml"]


def run_python_tests() -> None:
    spec = importlib.util.spec_from_file_location("minipixels_cli", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    assert mod.VERSION == "0.2.0", mod.VERSION
    package_spec = importlib.util.spec_from_file_location("package_sdk", ROOT / "tools" / "package_sdk.py")
    if package_spec is None or package_spec.loader is None:
        raise RuntimeError("could not load tools/package_sdk.py")
    package_mod = importlib.util.module_from_spec(package_spec)
    package_spec.loader.exec_module(package_mod)
    literal = mod.bytes_literal(bytes([0, 0, 255, 0, 255, 0]))
    assert "pix = bytes(6, 0)" in literal, literal
    assert "pix[2] = 255" in literal, literal
    assert "pix[4] = 255" in literal, literal
    assert "pix[0]" not in literal, literal
    data = {
        "assets": [
            {"id": "hero", "type": "image", "path": "assets/hero.png", "sheet": {"frameWidth": 16, "frameHeight": 24}},
            {"id": "music", "type": "audio", "path": "assets/audio/theme.wav"},
            {"id": "script", "type": "file", "path": "assets/script.txt"},
            {"id": "legacy", "path": "assets/legacy.png"},
        ]
    }
    ids = [asset["id"] for asset in mod.embedded_assets(data)]
    assert ids == ["hero", "legacy"], ids
    assert mod.sheet_config(data["assets"][0]) == {"frameWidth": 16, "frameHeight": 24, "spacing": 0, "margin": 0}
    report = mod.asset_report(data, ROOT)
    assert [entry["id"] for entry in report["embedded"]] == ["hero", "legacy"], report
    assert [entry["id"] for entry in report["runtime"]] == ["music", "script"], report
    levels = {
        "levels": [
            {
                "width": 4,
                "height": 3,
                "spawn": {"x": 8, "y": 16},
                "exit": {"x": 96, "y": 32},
                "platforms": [{"x": 0, "y": 2, "w": 4}],
                "enemies": [{"x": 12, "y": 24, "minX": 4, "maxX": 40}],
                "coins": [{"x": 18, "y": 10}],
            }
        ]
    }
    normalized = mod.validate_levels(levels, "inline")
    assert normalized[0]["width"] == 4, normalized
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        level_path = tmp_path / "levels.json"
        level_path.write_text(json.dumps(levels), encoding="utf-8")
        out_dir = tmp_path / "generated"
        out_dir.mkdir()
        mod.generate_levels_module({"levels": {"_absolute_path": str(level_path)}}, out_dir)
        generated = (out_dir / "levels.ml").read_text(encoding="utf-8")
        assert "package generated.levels" in generated, generated
        assert "function enemyMinX" in generated, generated
        assert "fill(data, w, 0, 2, 4, 1)" in generated, generated
        sdk_zip = package_mod.package_sdk(tmp_path / "dist")
        assert sdk_zip.exists(), sdk_zip
        assert (sdk_zip.parent / f"{sdk_zip.name}.sha256").exists(), sdk_zip
        with zipfile.ZipFile(sdk_zip) as zf:
            names = set(zf.namelist())
            assert any(name.endswith("/README.md") for name in names), names
            assert any(name.endswith("/src/minipixels.ml") for name in names), names
            assert any(name.endswith("/sdk-manifest.json") for name in names), names
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
