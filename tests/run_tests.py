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
TESTS = [
    "canvas_tests.ml",
    "systems_tests.ml",
    "asset_pack_tests.ml",
    "headless_game_tests.ml",
    "render_regression_tests.ml",
    "json_manifest_tests.ml",
    "generator_tests.ml",
]


def create_asset_pack_fixture() -> None:
    spec = importlib.util.spec_from_file_location("minipixels_cli", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    fixture_root = ROOT / "build" / "tests" / "asset_pack_fixture"
    fixture_assets = fixture_root / "assets"
    fixture_assets.mkdir(parents=True, exist_ok=True)
    pixels = bytes([255, 0, 0, 255, 0, 0, 255, 255])
    (fixture_assets / "hero.png").write_bytes(mod.write_png_rgba_store(2, 1, pixels))
    mod.write_asset_pack({"assets": [{"id": "hero", "type": "image", "path": "assets/hero.png"}]}, fixture_root, ROOT / "build" / "tests" / "assets.mpx")


def run_python_tests() -> None:
    spec = importlib.util.spec_from_file_location("minipixels_cli", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    assert mod.VERSION == "0.7.0", mod.VERSION
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
    ids = [asset["id"] for asset in mod.container_image_assets(data)]
    assert ids == ["hero", "legacy"], ids
    assert mod.sheet_config(data["assets"][0]) == {"frameWidth": 16, "frameHeight": 24, "spacing": 0, "margin": 0}
    report = mod.asset_report(data, ROOT)
    assert [entry["id"] for entry in report["embedded"]] == [], report
    assert [entry["id"] for entry in report["container"]] == ["hero", "legacy", "music", "script"], report
    assert [entry["id"] for entry in report["runtime"]] == [], report
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
    tiled = {
        "width": 4,
        "height": 3,
        "tilewidth": 32,
        "tileheight": 32,
        "layers": [
            {
                "type": "tilelayer",
                "name": "collision",
                "width": 4,
                "height": 3,
                "data": [
                    0,
                    0,
                    0,
                    0,
                    0,
                    2,
                    2,
                    0,
                    1,
                    1,
                    1,
                    1,
                ],
            },
            {
                "type": "objectgroup",
                "name": "objects",
                "objects": [
                    {"name": "spawn", "x": 8, "y": 16},
                    {"type": "exit", "x": 96, "y": 32},
                    {"type": "coin", "x": 48, "y": 24},
                    {
                        "type": "enemy",
                        "x": 64,
                        "y": 40,
                        "width": 96,
                        "properties": [
                            {"name": "minX", "value": 32},
                            {"name": "maxX", "value": 160},
                        ],
                    },
                ],
            },
        ],
    }
    normalized = mod.validate_levels(levels, "inline")
    assert normalized[0]["width"] == 4, normalized
    tiled_normalized = mod.normalize_level_source(tiled, "inline.tiled")
    tiled_level = mod.validate_levels(tiled_normalized, "inline.tiled")[0]
    assert tiled_level["spawn"] == {"x": 8, "y": 16}, tiled_level
    assert tiled_level["exit"] == {"x": 96, "y": 32}, tiled_level
    assert tiled_level["coins"][0] == {"x": 48, "y": 24}, tiled_level
    assert tiled_level["enemies"][0]["minX"] == 32, tiled_level
    assert {"x": 1, "y": 1, "w": 2, "tile": 2} in tiled_level["platforms"], tiled_level
    assert mod.level_warnings(tiled, "inline.tiled") == [], mod.level_warnings(tiled, "inline.tiled")
    noisy = {"width": 1, "height": 1, "tilewidth": 32, "tileheight": 32, "layers": [{"type": "objectgroup", "objects": [{"type": "mystery"}]}]}
    noisy_warnings = mod.level_warnings(noisy, "noisy.tiled")
    assert any("unknown Tiled object kind" in warning for warning in noisy_warnings), noisy_warnings
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        asset_dir = tmp_path / "assets"
        asset_dir.mkdir()
        hero_png = mod.write_png_rgba_store(
            2,
            1,
            bytes(
                [
                    255,
                    0,
                    0,
                    255,
                    0,
                    0,
                    255,
                    255,
                ]
            ),
        )
        (asset_dir / "hero.png").write_bytes(hero_png)
        pack_manifest = {"assets": [{"id": "hero", "type": "image", "path": "assets/hero.png"}]}
        pack_path = mod.write_asset_pack(pack_manifest, tmp_path, tmp_path / "assets.mpx")
        assert pack_path.exists(), pack_path
        assert pack_path.read_bytes().startswith(b"MPX1"), pack_path
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


def run_generated_smoke() -> None:
    generated_root = ROOT / "build" / "tests" / "native_generated_levels"
    generated = generated_root / "generated"
    if not (generated / "assets.ml").exists() or not (generated / "levels.ml").exists():
        raise RuntimeError("native generated smoke output is missing")
    smoke = ROOT / "build" / "tests" / "generated_smoke.ml"
    smoke.write_text(
        "\n".join(
            [
                "import generated.assets as gen",
                "import generated.levels as lvl",
                "import std.assert as a",
                "",
                "function main(args)",
                "  reg = gen.registry()",
                "  spr = reg.getSprite(\"player\")",
                "  a.assertEq(spr.width, 32, \"generated sprite width\")",
                "  sheet = gen.sheet_player()",
                "  a.assertEq(sheet.frameWidth, 32, \"generated sheet width\")",
                "  a.assertEq(lvl.count(), 3, \"generated level count\")",
                "  a.assertEq(lvl.width(0), 92, \"generated level width\")",
                "  a.assertEq(lvl.enemyMaxX(2, 3), 1460, \"generated enemy max\")",
                "  a.assertEq(lvl.coinX(2, 6), 914, \"generated coin x\")",
                "  a.assertEq(lvl.enemyKind(2, 1), 0, \"generated enemy kind\")",
                "  print \"=== GENERATED SMOKE DONE ===\"",
                "  return 0",
                "end function",
                "",
            ]
        ),
        encoding="utf-8",
    )
    exe = ROOT / "build" / "tests" / "generated_smoke.exe"
    cmd = [
        sys.executable,
        str(COMPILER),
        str(smoke),
        str(exe),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(generated_root),
    ]
    print("compile:", " ".join(cmd))
    subprocess.check_call(cmd, cwd=str(ROOT))
    print("run:", exe)
    subprocess.check_call([str(exe)], cwd=str(ROOT))

    procedural_root = ROOT / "build" / "tests" / "native_generated_procedural"
    if not (procedural_root / "generated" / "assets.ml").exists():
        raise RuntimeError("native procedural generated output is missing")
    procedural_smoke = ROOT / "build" / "tests" / "generated_procedural_smoke.ml"
    procedural_smoke.write_text(
        "\n".join(
            [
                "import generated.assets as gen",
                "import std.assert as a",
                "",
                "function main(args)",
                "  reg = gen.registry()",
                "  tiles = reg.getSprite(\"tiles\")",
                "  a.assertEq(tiles.width, 64, \"generated procedural tiles width\")",
                "  sheet = gen.sheet_tiles()",
                "  a.assertEq(sheet.frameWidth, 32, \"generated procedural sheet width\")",
                "  player = reg.getSprite(\"player\")",
                "  a.assertEq(player.width, 16, \"generated procedural player width\")",
                "  print \"=== GENERATED PROCEDURAL SMOKE DONE ===\"",
                "  return 0",
                "end function",
                "",
            ]
        ),
        encoding="utf-8",
    )
    procedural_exe = ROOT / "build" / "tests" / "generated_procedural_smoke.exe"
    cmd = [
        sys.executable,
        str(COMPILER),
        str(procedural_smoke),
        str(procedural_exe),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(procedural_root),
    ]
    print("compile:", " ".join(cmd))
    subprocess.check_call(cmd, cwd=str(ROOT))
    print("run:", procedural_exe)
    subprocess.check_call([str(procedural_exe)], cwd=str(ROOT))


def main() -> int:
    run_python_tests()
    build = ROOT / "build" / "tests"
    build.mkdir(parents=True, exist_ok=True)
    create_asset_pack_fixture()
    for test in TESTS:
        src = ROOT / "tests" / test
        exe = build / (Path(test).stem + ".exe")
        cmd = [sys.executable, str(COMPILER), str(src), str(exe), "-I", str(ROOT / "src"), "-I", str(ROOT.parent / "MiniLangCompilerPy")]
        print("compile:", " ".join(cmd))
        subprocess.check_call(cmd, cwd=str(ROOT))
        print("run:", exe)
        subprocess.check_call([str(exe)], cwd=str(ROOT))
    run_generated_smoke()
    print("MiniPixels tests passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
