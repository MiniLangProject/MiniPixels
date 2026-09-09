#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import subprocess
import sys
import importlib.util
import binascii
import json
import struct
import tempfile
import zipfile
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
DEFAULT_TARGET = "windows-x64" if os.name == "nt" else "linux-x64"
TESTS = [
    "canvas_tests.ml",
    "systems_tests.ml",
    "asset_pack_tests.ml",
    "headless_game_tests.ml",
    "render_regression_tests.ml",
    "json_manifest_tests.ml",
    "generator_tests.ml",
    "foundation_tests.ml",
]


def output_path(name: str, target: str) -> Path:
    suffix = ".exe" if target == "windows-x64" else ""
    return ROOT / "build" / "tests" / f"{name}{suffix}"


def wsl_path(path: Path) -> str:
    resolved = path.resolve()
    drive = resolved.drive.rstrip(":").lower()
    tail = resolved.as_posix().split(":", 1)[-1]
    return f"/mnt/{drive}{tail}"


def executable_command(exe: Path, target: str, args: list[str] | None = None) -> list[str]:
    extra = list(args or [])
    if target == "linux-x64" and os.name == "nt":
        return [
            "wsl.exe",
            "-d",
            os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu"),
            "--cd",
            wsl_path(ROOT),
            "--",
            wsl_path(exe),
            *extra,
        ]
    return [str(exe), *extra]


def run_test_executable(exe: Path, target: str, args: list[str] | None = None) -> None:
    cmd = executable_command(exe, target, args)
    result = subprocess.run(cmd, cwd=str(ROOT), text=True, capture_output=True)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    if result.returncode != 0:
        raise subprocess.CalledProcessError(result.returncode, cmd)
    if "[FAIL]" in result.stdout:
        raise RuntimeError(f"MiniLang assertions failed in {exe.name}")


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    checked = kind + payload
    return struct.pack(">I", len(payload)) + checked + struct.pack(">I", binascii.crc32(checked) & 0xFFFFFFFF)


def filtered_rgba_png(width: int, height: int, *, fixed: bool = False) -> bytes:
    previous = bytes(width * 4)
    scanlines = bytearray()
    for y in range(height):
        row = bytearray()
        for x in range(width):
            row.extend(((x * 40 + y * 3) & 255, (y * 40 + x * 5) & 255, ((x + y) * 30) & 255, 255 - (x % 16) * 10))
        filter_type = y % 5
        encoded = bytearray(len(row))
        for index, current in enumerate(row):
            left = row[index - 4] if index >= 4 else 0
            above = previous[index]
            upper_left = previous[index - 4] if index >= 4 else 0
            if filter_type == 0:
                predictor = 0
            elif filter_type == 1:
                predictor = left
            elif filter_type == 2:
                predictor = above
            elif filter_type == 3:
                predictor = (left + above) // 2
            else:
                estimate = left + above - upper_left
                distances = (abs(estimate - left), abs(estimate - above), abs(estimate - upper_left))
                predictor = (left, above, upper_left)[distances.index(min(distances))]
            encoded[index] = (current - predictor) & 255
        scanlines.append(filter_type)
        scanlines.extend(encoded)
        previous = bytes(row)
    if fixed:
        compressor = zlib.compressobj(level=9, strategy=zlib.Z_FIXED)
        compressed = compressor.compress(bytes(scanlines)) + compressor.flush()
    else:
        compressed = zlib.compress(bytes(scanlines), level=9)
    header = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + png_chunk(b"IHDR", header) + png_chunk(b"IDAT", compressed) + png_chunk(b"IEND", b"")


def indexed_png() -> bytes:
    header = struct.pack(">IIBBBBB", 4, 1, 2, 3, 0, 0, 0)
    palette = bytes((255, 0, 0, 0, 255, 0, 0, 0, 255, 255, 255, 0))
    transparency = bytes((255, 192, 128, 0))
    compressed = zlib.compress(bytes((0, 0b00011011)), level=9)
    return (
        b"\x89PNG\r\n\x1a\n"
        + png_chunk(b"IHDR", header)
        + png_chunk(b"PLTE", palette)
        + png_chunk(b"tRNS", transparency)
        + png_chunk(b"IDAT", compressed)
        + png_chunk(b"IEND", b"")
    )


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
    large_pixels = bytes([17, 34, 51, 255]) * (129 * 128)
    (fixture_assets / "large.png").write_bytes(mod.write_png_rgba_store(129, 128, large_pixels))
    (fixture_assets / "tone.wav").write_bytes(bytes([82, 73, 73, 70, 1, 2, 3, 4]))
    png_fixtures = ROOT / "build" / "tests" / "png"
    png_fixtures.mkdir(parents=True, exist_ok=True)
    dynamic_png = filtered_rgba_png(64, 32)
    fixed_png = filtered_rgba_png(4, 5, fixed=True)
    assert ((dynamic_png[43] >> 1) & 3) == 2, "fixture must exercise dynamic Deflate"
    assert ((fixed_png[43] >> 1) & 3) == 1, "fixture must exercise fixed Deflate"
    (png_fixtures / "dynamic_filters.png").write_bytes(dynamic_png)
    (png_fixtures / "fixed_filters.png").write_bytes(fixed_png)
    (png_fixtures / "indexed.png").write_bytes(indexed_png())
    samples = (0, 1000, -1000, 32767, -32768, 500, -500, 0)
    pcm = struct.pack("<" + "h" * len(samples), *samples)
    wav = (
        b"RIFF"
        + struct.pack("<I", 36 + len(pcm))
        + b"WAVEfmt "
        + struct.pack("<IHHIIHH", 16, 1, 1, 22050, 44100, 2, 16)
        + b"data"
        + struct.pack("<I", len(pcm))
        + pcm
    )
    (ROOT / "build" / "tests" / "tone_valid.wav").write_bytes(wav)
    mod.write_asset_pack(
        {
            "assets": [
                {"id": "hero", "type": "image", "path": "assets/hero.png"},
                {"id": "large", "type": "image", "path": "assets/large.png"},
                {"id": "generated", "type": "procedural", "kind": "checker", "width": 4, "height": 2},
                {"id": "tone", "type": "audio", "path": "assets/tone.wav"},
            ]
        },
        fixture_root,
        ROOT / "build" / "tests" / "assets.mpx",
    )


def create_protected_asset_fixture() -> Path:
    spec = importlib.util.spec_from_file_location("minipixels_cli_protected", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    project = ROOT / "build" / "tests" / "protected_project"
    assets = project / "assets"
    source = project / "src"
    assets.mkdir(parents=True, exist_ok=True)
    source.mkdir(parents=True, exist_ok=True)
    (assets / "de.json").write_text(json.dumps({"menu.start": "Start", "coins": "Münzen: {0}"}, ensure_ascii=False), encoding="utf-8")
    (assets / "en.json").write_text(json.dumps({"menu.start": "Start", "coins": "Coins: {0}"}), encoding="utf-8")
    (assets / "world.json").write_text(json.dumps({"map": [1, 2, 3], "enemy": {"health": 7}}), encoding="utf-8")
    (assets / "balance.json").write_text(json.dumps({"player": {"speed": 120}, "enemies": {"slime": {"health": 3}}, "waves": [2, 4, 8]}), encoding="utf-8")
    key_dir = project / ".minipixels"
    mod.generate_signing_key(key_dir / "asset-signing-key.pem", key_dir / "asset-signing-public.pem")
    manifest = {
        "name": "protected-smoke",
        "main": "src/main.ml",
        "window": {"width": 32, "height": 32, "scale": 1},
        "assetProtection": {"enabled": True, "signingKey": ".minipixels/asset-signing-key.pem"},
        "localization": {"defaultLocale": "de"},
        "assets": [
            {"id": "de", "type": "text", "locale": "de", "path": "assets/de.json"},
            {"id": "en", "type": "text", "locale": "en", "path": "assets/en.json"},
            {"id": "world", "type": "data", "path": "assets/world.json"},
            {"id": "balance", "type": "constants", "path": "assets/balance.json"},
        ],
    }
    project_file = project / "minipixels.json"
    project_file.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    (source / "main.ml").write_text("function main(args) return 0 end function\n", encoding="utf-8")
    generated = project / "build" / "generated" / "generated"
    mod.generate(project_file, generated)
    pack = project / "build" / "assets.mpx"
    data = pack.read_bytes()
    assert data.startswith(b"MPX2"), data[:4]
    assert b"menu.start" not in data and b"world" not in data and b"MPT1" not in data
    tampered = bytearray(data)
    tampered[80] ^= 1
    (project / "build" / "assets-tampered.mpx").write_bytes(tampered)
    assert (generated / "asset_security.ml").is_file()
    assert (generated / "constants" / "balance.ml").is_file()
    return project


def run_python_tests() -> None:
    spec = importlib.util.spec_from_file_location("minipixels_cli", ROOT / "tools" / "minipixels.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("could not load tools/minipixels.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    assert mod.VERSION == "0.10.0", mod.VERSION
    with tempfile.TemporaryDirectory(prefix="minipixels_security_") as td:
        security_root = Path(td)
        security_manifest = security_root / "minipixels.json"
        security_manifest.write_text(
            json.dumps(
                {
                    "name": "security-init",
                    "main": "src/main.ml",
                    "window": {"width": 32, "height": 32, "scale": 1},
                    "assets": [],
                }
            ),
            encoding="utf-8",
        )
        mod.security_init(security_manifest)
        initialized = json.loads(security_manifest.read_text(encoding="utf-8"))
        assert initialized["assetProtection"]["enabled"] is True, initialized
        private_key = security_root / ".minipixels" / "asset-signing-key.pem"
        public_key = security_root / ".minipixels" / "asset-signing-public.pem"
        assert private_key.read_bytes().startswith(b"-----BEGIN PRIVATE KEY-----")
        assert public_key.read_bytes().startswith(b"-----BEGIN PUBLIC KEY-----")
        assert "/.minipixels/asset-signing-key.pem" in (security_root / ".gitignore").read_text(encoding="utf-8")
        assert "PRIVATE KEY" not in security_manifest.read_text(encoding="utf-8")
    package_spec = importlib.util.spec_from_file_location("package_sdk", ROOT / "tools" / "package_sdk.py")
    if package_spec is None or package_spec.loader is None:
        raise RuntimeError("could not load tools/package_sdk.py")
    package_mod = importlib.util.module_from_spec(package_spec)
    package_spec.loader.exec_module(package_mod)
    data = {
        "assets": [
            {"id": "hero", "type": "image", "path": "assets/hero.png", "sheet": {"frameWidth": 16, "frameHeight": 24}},
            {"id": "music", "type": "audio", "path": "assets/audio/theme.wav"},
            {"id": "script", "type": "file", "path": "assets/script.txt"},
            {"id": "legacy", "path": "assets/legacy.png"},
            {"id": "generated", "type": "procedural", "kind": "checker", "width": 4, "height": 2},
        ]
    }
    ids = [asset["id"] for asset in mod.container_image_assets(data)]
    assert ids == ["hero", "legacy", "generated"], ids
    audio_ids = [asset["id"] for asset in mod.container_audio_assets(data)]
    assert audio_ids == ["music"], audio_ids
    assert mod.sheet_config(data["assets"][0]) == {"frameWidth": 16, "frameHeight": 24, "spacing": 0, "margin": 0}
    report = mod.asset_report(data, ROOT)
    assert [entry["id"] for entry in report["embedded"]] == [], report
    assert [entry["id"] for entry in report["container"]] == ["generated", "hero", "legacy", "music", "script"], report
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
        procedural_pack = mod.write_asset_pack(
            {"assets": [{"id": "generated", "type": "procedural", "kind": "checker", "width": 4, "height": 2}]},
            tmp_path,
            tmp_path / "procedural.mpx",
        )
        procedural_data = procedural_pack.read_bytes()
        assert b"generated" in procedural_data, procedural_data
        assert procedural_data.count(b"\x89PNG\r\n\x1a\n") == 1, procedural_data
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


def run_generated_smoke(compiler: Path, target: str) -> None:
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
                "  a.assertEq(spr.width, 256, \"generated sprite uses packed PNG width\")",
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
    exe = output_path("generated_smoke", target)
    cmd = [
        sys.executable,
        str(compiler),
        str(smoke),
        str(exe),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(generated_root),
        "--target",
        target,
    ]
    print("compile:", " ".join(cmd))
    subprocess.check_call(cmd, cwd=str(ROOT))
    print("run:", exe)
    run_test_executable(exe, target)

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
    procedural_exe = output_path("generated_procedural_smoke", target)
    cmd = [
        sys.executable,
        str(compiler),
        str(procedural_smoke),
        str(procedural_exe),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(procedural_root),
        "--target",
        target,
    ]
    print("compile:", " ".join(cmd))
    subprocess.check_call(cmd, cwd=str(ROOT))
    print("run:", procedural_exe)
    run_test_executable(procedural_exe, target)


def run_protected_asset_smoke(compiler: Path, target: str, project: Path) -> None:
    source = project / "src" / "protected_smoke.ml"
    source.write_text(
        "\n".join(
            [
                "import minipixels as mp",
                "import generated.assets as gen",
                "import generated.asset_security as security",
                "import generated.constants.balance as balance",
                "import std.assert as a",
                "",
                "function main(args)",
                "  pack = gen.assetPack()",
                "  a.assertTrue(typeof(pack) != \"error\", \"protected MPX2 opens\")",
                "  a.assertEq(mp.assetKindFromPack(pack, \"de\"), 4, \"text kind\")",
                "  a.assertEq(mp.assetKindFromPack(pack, \"world\"), 5, \"data kind\")",
                "  i18n = gen.localization()",
                "  a.assertEq(i18n.text(\"menu.start\"), \"Start\", \"default locale\")",
                "  a.assertEq(i18n.format(\"coins\", [5]), \"Münzen: 5\", \"text formatting\")",
                "  i18n.setLocale(\"en-US\")",
                "  a.assertEq(i18n.format(\"coins\", [8]), \"Coins: 8\", \"language fallback\")",
                "  a.assertEq(balance.PLAYER_SPEED, 120, \"compiled scalar constant\")",
                "  a.assertEq(balance.ENEMIES_SLIME_HEALTH, 3, \"compiled nested constant\")",
                "  values = balance.data()",
                "  a.assertEq(values.get(\"waves\")[2], 8, \"compiled structured constants\")",
                "  wrong = security.aesKey()",
                "  wrong[0] = wrong[0] ^ 1",
                "  rejectedKey = try(mp.openProtectedAssetPack(\"build/assets.mpx\", wrong, security.publicKey(), security.keyId()))",
                "  a.assertTrue(typeof(rejectedKey) == \"error\", \"wrong AES key rejected\")",
                "  rejectedTamper = try(mp.openProtectedAssetPack(\"build/assets-tampered.mpx\", security.aesKey(), security.publicKey(), security.keyId()))",
                "  a.assertTrue(typeof(rejectedTamper) == \"error\", \"tampered signature rejected\")",
                "  print \"=== PROTECTED ASSET SMOKE DONE ===\"",
                "  return 0",
                "end function",
                "",
            ]
        ),
        encoding="utf-8",
    )
    exe = output_path("protected_asset_smoke", target)
    cmd = [
        sys.executable,
        str(compiler),
        str(source),
        str(exe),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(project / "build" / "generated"),
        "--target",
        target,
    ]
    print("compile:", " ".join(cmd))
    subprocess.check_call(cmd, cwd=str(ROOT))
    print("run:", exe)
    command = executable_command(exe, target)
    if target == "linux-x64" and os.name == "nt":
        command = [
            "wsl.exe",
            "-d",
            os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu"),
            "--cd",
            wsl_path(project),
            "--",
            wsl_path(exe),
        ]
    result = subprocess.run(command, cwd=str(project), text=True, capture_output=True)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    if result.returncode != 0 or "[FAIL]" in result.stdout:
        raise RuntimeError(f"protected asset smoke failed ({target})")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Compile and run the MiniPixels test suite")
    parser.add_argument("--target", choices=("windows-x64", "linux-x64"), default=DEFAULT_TARGET)
    parser.add_argument("--compiler", default=str(COMPILER))
    args = parser.parse_args(argv)
    target = args.target
    compiler = Path(args.compiler).resolve()
    run_python_tests()
    build = ROOT / "build" / "tests"
    build.mkdir(parents=True, exist_ok=True)
    create_asset_pack_fixture()
    protected_project = create_protected_asset_fixture()
    for test in TESTS:
        src = ROOT / "tests" / test
        exe = output_path(Path(test).stem, target)
        cmd = [
            sys.executable,
            str(compiler),
            str(src),
            str(exe),
            "-I",
            str(ROOT / "src"),
            "-I",
            str(ROOT.parent / "MiniLangCompilerPy"),
            "--target",
            target,
        ]
        print("compile:", " ".join(cmd))
        subprocess.check_call(cmd, cwd=str(ROOT))
        print("run:", exe)
        run_test_executable(exe, target)
        if test == "foundation_tests.ml":
            report_name = "foundation-results.xml" if target == "windows-x64" else "foundation-results-linux.xml"
            junit = build / report_name
            run_test_executable(exe, target, ["--format", "junit", "--output", f"build/tests/{report_name}", "--quiet"])
            if not junit.is_file():
                raise RuntimeError("std.test did not write its JUnit report")
    run_generated_smoke(compiler, target)
    run_protected_asset_smoke(compiler, target, protected_project)
    print(f"MiniPixels tests passed ({target})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
