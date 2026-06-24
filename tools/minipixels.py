#!/usr/bin/env python3
"""MiniPixels project processor and build CLI."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
ASSET_ID_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
VERSION = "0.3.1"


def die(message: str, code: int = 1) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(code)


def load_project(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        die(f"{path}:{exc.lineno}:{exc.colno}: JSON syntax error: {exc.msg}")
    except OSError as exc:
        die(f"{path}: cannot read project file: {exc}")


def project_root(project_file: Path) -> Path:
    return project_file.resolve().parent


def validate(project_file: Path) -> dict:
    data = load_project(project_file)
    errors: list[str] = []
    for key in ["name", "main", "window"]:
        if key not in data:
            errors.append(f"{project_file}: missing required field '{key}'")
    window = data.get("window", {})
    for key in ["width", "height"]:
        if int(window.get(key, 0)) <= 0:
            errors.append(f"{project_file}: window.{key} must be greater than zero")
    if int(window.get("scale", 1)) <= 0:
        errors.append(f"{project_file}: window.scale must be greater than zero")

    root = project_root(project_file)
    main = data.get("main")
    if isinstance(main, str) and not (root / main).exists():
        errors.append(f"{project_file}: main source not found: {main}")

    seen: set[str] = set()
    for asset in data.get("assets", []):
        aid = asset.get("id")
        if not aid:
            errors.append(f"{project_file}: asset without id")
            continue
        if not ASSET_ID_RE.match(str(aid)):
            errors.append(f"{project_file}: asset id '{aid}' must be a MiniLang identifier")
        if aid in seen:
            errors.append(f"{project_file}: duplicate asset id '{aid}'")
        seen.add(aid)
        path = asset.get("path")
        if path and not (root / path).exists():
            errors.append(f"{project_file}: asset '{aid}' path does not exist: {path}")
        if path:
            asset["_absolute_path"] = str((root / path).resolve())
        sheet = asset.get("sheet")
        if sheet is not None:
            if not isinstance(sheet, dict):
                errors.append(f"{project_file}: asset '{aid}' sheet must be an object")
            else:
                fw = int(sheet.get("frameWidth", 0))
                fh = int(sheet.get("frameHeight", 0))
                if fw <= 0 or fh <= 0:
                    errors.append(f"{project_file}: asset '{aid}' sheet.frameWidth and sheet.frameHeight must be greater than zero")
                if int(sheet.get("spacing", 0)) < 0 or int(sheet.get("margin", 0)) < 0:
                    errors.append(f"{project_file}: asset '{aid}' sheet.spacing and sheet.margin must not be negative")

    levels = data.get("levels")
    if levels is not None:
        if not isinstance(levels, dict):
            errors.append(f"{project_file}: levels must be an object")
        else:
            path = levels.get("path")
            if not path:
                errors.append(f"{project_file}: levels.path is required")
            elif not (root / path).exists():
                errors.append(f"{project_file}: levels file does not exist: {path}")
            else:
                levels["_absolute_path"] = str((root / path).resolve())

    if errors:
        die("\n".join(errors))
    return data


def tiled_properties(obj: dict) -> dict:
    out = {}
    for prop in obj.get("properties", []):
        if isinstance(prop, dict) and "name" in prop:
            out[str(prop["name"])] = prop.get("value")
    return out


def object_kind(obj: dict) -> str:
    value = str(obj.get("type") or obj.get("name") or "").lower()
    if value:
        return value
    props = tiled_properties(obj)
    return str(props.get("kind") or props.get("type") or "").lower()


def tiled_object_layers(data: dict) -> list[dict]:
    return [layer for layer in data.get("layers", []) if layer.get("type") == "objectgroup"]


def tiled_tile_layers(data: dict) -> list[dict]:
    layers = [layer for layer in data.get("layers", []) if layer.get("type") == "tilelayer"]
    solid = []
    for layer in layers:
        name = str(layer.get("name", "")).lower()
        props = tiled_properties(layer)
        if name in ("collision", "collisions", "solid", "ground") or props.get("collision") is True or props.get("solid") is True:
            solid.append(layer)
    return solid if solid else layers


def tiled_int(obj: dict, key: str, default: int = 0) -> int:
    props = tiled_properties(obj)
    value = props.get(key, obj.get(key, default))
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def normalize_tiled_map(data: dict, source: str) -> dict:
    width = int(data.get("width", 0))
    height = int(data.get("height", 0))
    tile_width = int(data.get("tilewidth", 32))
    tile_height = int(data.get("tileheight", 32))
    if width <= 0 or height <= 0:
        die(f"{source}: Tiled map width and height must be greater than zero")

    platforms = []
    for layer in tiled_tile_layers(data):
        layer_width = int(layer.get("width", width))
        raw = layer.get("data", [])
        if not isinstance(raw, list):
            die(f"{source}: Tiled CSV-encoded layer data is required")
        for y in range(min(height, int(layer.get("height", height)))):
            x = 0
            while x < layer_width:
                idx = (y * layer_width) + x
                gid = int(raw[idx]) if idx < len(raw) else 0
                if gid <= 0:
                    x += 1
                    continue
                start = x
                while x < layer_width:
                    scan = (y * layer_width) + x
                    value = int(raw[scan]) if scan < len(raw) else 0
                    if value != gid:
                        break
                    x += 1
                platforms.append({"x": start, "y": y, "w": x - start, "tile": gid})

    spawn = {"x": 48, "y": max(0, (height - 3) * tile_height)}
    exit_pos = {"x": max(0, (width * tile_width) - (3 * tile_width)), "y": max(0, (height - 4) * tile_height)}
    enemies = []
    coins = []
    for layer in tiled_object_layers(data):
        for obj in layer.get("objects", []):
            kind = object_kind(obj)
            x = int(obj.get("x", 0))
            y = int(obj.get("y", 0))
            if kind == "spawn" or kind == "player":
                spawn = {"x": x, "y": y}
            elif kind == "exit" or kind == "goal":
                exit_pos = {"x": x, "y": y}
            elif kind == "coin":
                coins.append({"x": x, "y": y})
            elif kind == "enemy":
                width_px = int(obj.get("width", tile_width * 4))
                enemies.append(
                    {
                        "x": x,
                        "y": y,
                        "minX": tiled_int(obj, "minX", x),
                        "maxX": tiled_int(obj, "maxX", x + width_px),
                    }
                )

    return {
        "levels": [
            {
                "width": width,
                "height": height,
                "spawn": spawn,
                "exit": exit_pos,
                "platforms": platforms,
                "enemies": enemies,
                "coins": coins,
            }
        ]
    }


def normalize_level_source(data: dict, source: str) -> dict:
    if "levels" in data:
        return data
    if "layers" in data and "tilewidth" in data:
        return normalize_tiled_map(data, source)
    die(f"{source}: expected MiniPixels level JSON or Tiled JSON/TMJ map")


def level_warnings(levels: dict, source: str) -> list[str]:
    warnings: list[str] = []
    if "layers" in levels and "tilewidth" in levels:
        known = {"spawn", "player", "exit", "goal", "coin", "enemy"}
        found = {"spawn": False, "exit": False, "coin": False}
        for layer in tiled_object_layers(levels):
            for obj in layer.get("objects", []):
                kind = object_kind(obj)
                if kind in ("spawn", "player"):
                    found["spawn"] = True
                elif kind in ("exit", "goal"):
                    found["exit"] = True
                elif kind == "coin":
                    found["coin"] = True
                elif kind and kind not in known:
                    warnings.append(f"{source}: unknown Tiled object kind '{kind}'")
        if not tiled_tile_layers(levels):
            warnings.append(f"{source}: no tile layers found for collision/ground")
        for key, label in [("spawn", "spawn object"), ("exit", "exit object"), ("coin", "coin objects")]:
            if not found[key]:
                warnings.append(f"{source}: no {label} found")
        return warnings

    normalized = normalize_level_source(levels, source)
    parsed = validate_levels(normalized, source)
    for idx, level in enumerate(parsed):
        if not level["coins"]:
            warnings.append(f"{source}: level {idx} has no coins")
        if not level["platforms"]:
            warnings.append(f"{source}: level {idx} has no platforms")
    return warnings


def project_warnings(data: dict) -> list[str]:
    warnings: list[str] = []
    levels = data.get("levels")
    if isinstance(levels, dict) and levels.get("_absolute_path"):
        path = levels["_absolute_path"]
        try:
            raw = json.loads(Path(path).read_text(encoding="utf-8"))
            warnings.extend(level_warnings(raw, path))
        except Exception as exc:
            warnings.append(f"{path}: could not inspect levels: {exc}")
    if not data.get("assets"):
        warnings.append("project has no assets")
    return warnings


def color_rgba(color: list[int]) -> tuple[int, int, int, int]:
    vals = list(color) + [255, 255, 255, 255]
    return tuple(max(0, min(255, int(v))) for v in vals[:4])


def read_png_rgba(path: Path) -> tuple[int, int, bytes]:
    data = path.read_bytes()
    if not data.startswith(b"\x89PNG\r\n\x1a\n"):
        die(f"{path}: not a PNG file")
    pos = 8
    width = height = color_type = bit_depth = None
    compressed = bytearray()
    while pos + 8 <= len(data):
        length = struct.unpack(">I", data[pos : pos + 4])[0]
        ctype = data[pos + 4 : pos + 8]
        payload = data[pos + 8 : pos + 8 + length]
        pos += 12 + length
        if ctype == b"IHDR":
            width, height, bit_depth, color_type = struct.unpack(">IIBB", payload[:10])
        elif ctype == b"IDAT":
            compressed.extend(payload)
        elif ctype == b"IEND":
            break
    if width is None or height is None or bit_depth != 8 or color_type not in (2, 6):
        die(f"{path}: only 8-bit RGB/RGBA PNG assets are supported by this processor")
    channels = 4 if color_type == 6 else 3
    raw = zlib.decompress(bytes(compressed))
    stride = width * channels
    rows: list[bytearray] = []
    p = 0
    for _ in range(height):
        filt = raw[p]
        p += 1
        row = bytearray(raw[p : p + stride])
        p += stride
        prev = rows[-1] if rows else bytearray(stride)
        for i in range(stride):
            left = row[i - channels] if i >= channels else 0
            up = prev[i]
            up_left = prev[i - channels] if i >= channels else 0
            if filt == 1:
                row[i] = (row[i] + left) & 255
            elif filt == 2:
                row[i] = (row[i] + up) & 255
            elif filt == 3:
                row[i] = (row[i] + ((left + up) // 2)) & 255
            elif filt == 4:
                pa = abs(up - up_left)
                pb = abs(left - up_left)
                pc = abs(left + up - (2 * up_left))
                pr = left if pa <= pb and pa <= pc else (up if pb <= pc else up_left)
                row[i] = (row[i] + pr) & 255
            elif filt != 0:
                die(f"{path}: unsupported PNG filter {filt}")
        rows.append(row)
    out = bytearray(width * height * 4)
    for y, row in enumerate(rows):
        for x in range(width):
            si = x * channels
            di = (y * width + x) * 4
            out[di] = row[si]
            out[di + 1] = row[si + 1]
            out[di + 2] = row[si + 2]
            out[di + 3] = row[si + 3] if channels == 4 else 255
    return width, height, bytes(out)


def procedural_pixels(asset: dict) -> tuple[int, int, bytes]:
    asset_path = asset.get("_absolute_path")
    if asset_path and Path(asset_path).suffix.lower() == ".png":
        return read_png_rgba(Path(asset_path))
    w = int(asset.get("width", 16))
    h = int(asset.get("height", 16))
    kind = asset.get("kind", "checker")
    primary = color_rgba(asset.get("color", [255, 128, 0, 255]))
    secondary = color_rgba(asset.get("secondary", [40, 40, 50, 255]))
    transparent = (0, 0, 0, 0)
    buf = bytearray(w * h * 4)
    for y in range(h):
        for x in range(w):
            c = primary
            if kind == "player":
                if x in (0, w - 1) or y in (0, h - 1):
                    c = transparent
                elif y < h // 3:
                    c = (255, 232, 170, 255)
                elif x < w // 2:
                    c = primary
                else:
                    c = secondary
            elif kind == "tiles":
                tile = (x // max(1, w // 4) + y // max(1, h // 4)) % 2
                c = primary if tile == 0 else secondary
            elif kind == "checker":
                c = primary if ((x // 4) + (y // 4)) % 2 == 0 else secondary
            elif kind == "blank":
                c = transparent
            i = (y * w + x) * 4
            buf[i : i + 4] = bytes(c)
    return w, h, bytes(buf)


def is_embedded_asset(asset: dict) -> bool:
    kind = str(asset.get("type", "image")).lower()
    return kind in ("image", "procedural")


def embedded_assets(data: dict) -> list[dict]:
    return [asset for asset in data.get("assets", []) if is_embedded_asset(asset)]


def sheet_config(asset: dict) -> dict | None:
    sheet = asset.get("sheet")
    if not isinstance(sheet, dict):
        return None
    return {
        "frameWidth": int(sheet.get("frameWidth", 0)),
        "frameHeight": int(sheet.get("frameHeight", 0)),
        "spacing": int(sheet.get("spacing", 0)),
        "margin": int(sheet.get("margin", 0)),
    }


def bytes_literal(data: bytes, indent: str = "  ") -> str:
    if not data:
        return f"{indent}pix = bytes(0, 0)"
    counts = [0] * 256
    for b in data:
        counts[b] += 1
    default = max(range(256), key=lambda b: counts[b])
    lines = [f"{indent}pix = bytes({len(data)}, {default})"]
    for i, b in enumerate(data):
        if b != default:
            lines.append(f"{indent}pix[{i}] = {b}")
    return "\n".join(lines)


def load_levels(data: dict) -> dict | None:
    levels = data.get("levels")
    if not isinstance(levels, dict):
        return None
    path = levels.get("_absolute_path")
    if not path:
        return None
    try:
        raw = json.loads(Path(path).read_text(encoding="utf-8"))
        return normalize_level_source(raw, path)
    except json.JSONDecodeError as exc:
        die(f"{path}:{exc.lineno}:{exc.colno}: level JSON syntax error: {exc.msg}")
    except OSError as exc:
        die(f"{path}: cannot read levels file: {exc}")


def validate_levels(levels: dict, source: str) -> list[dict]:
    raw_levels = levels.get("levels", [])
    if not isinstance(raw_levels, list) or not raw_levels:
        die(f"{source}: levels must contain at least one level")
    out: list[dict] = []
    for idx, level in enumerate(raw_levels):
        width = int(level.get("width", 0))
        height = int(level.get("height", 0))
        if width <= 0 or height <= 0:
            die(f"{source}: level {idx} width and height must be greater than zero")
        platforms = level.get("platforms", [])
        enemies = level.get("enemies", [])
        coins = level.get("coins", [])
        if not isinstance(platforms, list) or not isinstance(enemies, list) or not isinstance(coins, list):
            die(f"{source}: level {idx} platforms, enemies, and coins must be arrays")
        spawn = level.get("spawn", {"x": 48, "y": 192})
        exit_pos = level.get("exit", {"x": (width * 32) - 96, "y": 160})
        out.append(
            {
                "width": width,
                "height": height,
                "spawn": {"x": int(spawn.get("x", 48)), "y": int(spawn.get("y", 192))},
                "exit": {"x": int(exit_pos.get("x", (width * 32) - 96)), "y": int(exit_pos.get("y", 160))},
                "platforms": platforms,
                "enemies": enemies,
                "coins": coins,
            }
        )
    return out


def generate_levels_module(data: dict, out_dir: Path) -> Path | None:
    levels_data = load_levels(data)
    if levels_data is None:
        return None
    source = data["levels"].get("_absolute_path", "levels")
    levels = validate_levels(levels_data, source)
    out = out_dir / "levels.ml"
    lines = [
        "package generated.levels",
        "",
        "function count()",
        f"  return {len(levels)}",
        "end function",
        "",
        "function fill(data, width, x, y, w, value)",
        "  i = 0",
        "  while i < w",
        "    data[(y * width) + x + i] = value",
        "    i = i + 1",
        "  end while",
        "end function",
        "",
    ]

    for fn_name, key, subkey in [
        ("width", "width", None),
        ("height", "height", None),
        ("spawnX", "spawn", "x"),
        ("spawnY", "spawn", "y"),
        ("exitX", "exit", "x"),
        ("exitY", "exit", "y"),
    ]:
        lines.append(f"function {fn_name}(level)")
        for idx, level in enumerate(levels):
            value = level[key] if subkey is None else level[key][subkey]
            lines.append(f"  if level == {idx} then return {value} end if")
        fallback = levels[-1][key] if subkey is None else levels[-1][key][subkey]
        lines.append(f"  return {fallback}")
        lines.append("end function")
        lines.append("")

    lines.append("function tileData(level)")
    lines.append("  w = width(level)")
    lines.append("  h = height(level)")
    lines.append("  data = array(w * h, 0)")
    for idx, level in enumerate(levels):
        lines.append(f"  if level == {idx} then")
        for platform in level["platforms"]:
            x = int(platform.get("x", 0))
            y = int(platform.get("y", 0))
            w = int(platform.get("w", 1))
            tile = int(platform.get("tile", 1))
            lines.append(f"    fill(data, w, {x}, {y}, {w}, {tile})")
        lines.append("  end if")
    lines.append("  return data")
    lines.append("end function")
    lines.append("")

    for collection, source_key, fields in [
        ("enemy", "enemies", ["x", "y", "minX", "maxX"]),
        ("coin", "coins", ["x", "y"]),
    ]:
        lines.append(f"function {collection}Count(level)")
        for idx, level in enumerate(levels):
            lines.append(f"  if level == {idx} then return {len(level[source_key])} end if")
        lines.append(f"  return {len(levels[-1][source_key])}")
        lines.append("end function")
        lines.append("")
        for field in fields:
            lines.append(f"function {collection}{field[0].upper() + field[1:]}(level, index)")
            for idx, level in enumerate(levels):
                lines.append(f"  if level == {idx} then")
                items = level[source_key]
                for item_idx, item in enumerate(items):
                    lines.append(f"    if index == {item_idx} then return {int(item.get(field, 0))} end if")
                lines.append("    return 0")
                lines.append("  end if")
            lines.append("  return 0")
            lines.append("end function")
            lines.append("")

    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(out)
    return out


def generate(project_file: Path, out_dir: Path) -> Path:
    data = validate(project_file)
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / "assets.ml"
    lines = [
        "package generated.assets",
        "",
        "import minipixels as mp",
        "import minipixels.assets.assets as assets",
        "",
    ]
    for asset in sorted(embedded_assets(data), key=lambda a: a["id"]):
        aid = asset["id"]
        w, h, pix = procedural_pixels(asset)
        func = f"make_{aid}"
        lines.append(f"function {func}()")
        lines.append(bytes_literal(pix))
        lines.append(f'  img = mp.image({w}, {h}, pix, "{aid}")')
        lines.append(f'  return mp.spriteFromImage(img, "{aid}")')
        lines.append("end function")
        lines.append("")
        sheet = sheet_config(asset)
        if sheet is not None:
            lines.append(f"function sheet_{aid}()")
            lines.append(f"  spr = make_{aid}()")
            lines.append(
                f'  return mp.spriteSheet(spr.image, {sheet["frameWidth"]}, {sheet["frameHeight"]}, {sheet["spacing"]}, {sheet["margin"]})'
            )
            lines.append("end function")
            lines.append("")
    lines.append("function registry()")
    lines.append("  reg = assets.create(64)")
    for asset in sorted(embedded_assets(data), key=lambda a: a["id"]):
        aid = asset["id"]
        lines.append(f'  reg.add("{aid}", make_{aid}())')
    lines.append("  return reg")
    lines.append("end function")
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    generate_levels_module(data, out_dir)
    print(out)
    return out


def pack(project_file: Path, output: Path) -> Path:
    data = validate(project_file)
    root = project_root(project_file)
    output.parent.mkdir(parents=True, exist_ok=True)
    entries = []
    blob = bytearray()
    for asset in sorted(data.get("assets", []), key=lambda a: a["id"]):
        path = root / asset.get("path", "")
        payload = path.read_bytes() if path.exists() else b""
        offset = len(blob)
        blob.extend(payload)
        entries.append((asset["id"], offset, len(payload), hashlib.sha256(payload).hexdigest()))
    index = json.dumps(entries, ensure_ascii=False, sort_keys=True).encode("utf-8")
    output.write_bytes(b"MPAK1\0" + struct.pack("<II", len(index), len(blob)) + index + blob)
    print(output)
    return output


def asset_report(data: dict, root: Path) -> dict:
    report = {"embedded": [], "runtime": [], "totals": {"embeddedBytes": 0, "runtimeBytes": 0}}
    levels = load_levels(data)
    if levels is not None:
        report["levels"] = {"count": len(validate_levels(levels, data["levels"].get("_absolute_path", "levels")))}
    for asset in sorted(data.get("assets", []), key=lambda a: a["id"]):
        raw_path = asset.get("path", "")
        path = root / raw_path if raw_path else None
        size = path.stat().st_size if path is not None and path.exists() else 0
        entry = {
            "id": asset["id"],
            "type": str(asset.get("type", "image")),
            "path": raw_path,
            "bytes": size,
        }
        sheet = sheet_config(asset)
        if sheet is not None:
            entry["sheet"] = sheet
        if is_embedded_asset(asset):
            report["embedded"].append(entry)
            report["totals"]["embeddedBytes"] += size
        else:
            report["runtime"].append(entry)
            report["totals"]["runtimeBytes"] += size
    return report


def write_asset_report(data: dict, root: Path, output: Path) -> Path:
    report_path = output.parent / "asset-report.json"
    report_path.write_text(json.dumps(asset_report(data, root), indent=2, sort_keys=True), encoding="utf-8")
    print(report_path)
    return report_path


def copy_runtime_assets(data: dict, root: Path, output: Path) -> None:
    copied: set[Path] = set()

    def copy_path(src: Path, rel: Path) -> None:
        src = src.resolve()
        if src in copied or not src.exists() or not src.is_file():
            return
        dst = output.parent / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
        copied.add(src)

    audio_src = root / "assets" / "audio"
    if audio_src.exists():
        audio_dst = output.parent / "assets" / "audio"
        if audio_dst.exists():
            shutil.rmtree(audio_dst)
        shutil.copytree(audio_src, audio_dst)
        for path in audio_src.rglob("*"):
            if path.is_file():
                copied.add(path.resolve())

    for asset in data.get("assets", []):
        if is_embedded_asset(asset):
            continue
        raw_path = asset.get("path")
        if not raw_path:
            continue
        copy_path(root / raw_path, Path(raw_path))


def build(project_file: Path, output: Path | None, compiler: Path, generated_dir: Path, keep_generated: bool = True) -> Path:
    data = validate(project_file)
    root = project_root(project_file)
    generate(project_file, generated_dir)
    main = root / data["main"]
    if output is None:
        output = root / "build" / f"{data.get('name', 'game')}.exe"
    output.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        sys.executable,
        str(compiler),
        str(main),
        str(output),
        "-I",
        str(ROOT / "src"),
        "-I",
        str(ROOT.parent / "MiniLangCompilerPy"),
        "-I",
        str(generated_dir.parent),
    ]
    print(" ".join(cmd))
    subprocess.check_call(cmd, cwd=str(root))
    copy_runtime_assets(data, root, output)
    write_asset_report(data, root, output)
    return output


def new_project(name: str) -> None:
    root = Path(name)
    (root / "src").mkdir(parents=True, exist_ok=True)
    (root / "assets").mkdir(parents=True, exist_ok=True)
    (root / "src" / "main.ml").write_text(
        'import minipixels as mp\n\nfunction main(args)\n  cfg = mp.createConfig("MiniPixels Game", 320, 180, 4)\n  return mp.runHeadless(cfg, void, void, void, void)\nend function\n',
        encoding="utf-8",
    )
    (root / "minipixels.json").write_text(
        json.dumps({"name": name, "main": "src/main.ml", "window": {"width": 320, "height": 180, "scale": 4}, "assets": []}, indent=2),
        encoding="utf-8",
    )
    print(root)


def print_project_info(project_file: Path) -> None:
    data = validate(project_file)
    window = data.get("window", {})
    print(f"MiniPixels {VERSION}")
    print(f"project: {data.get('name')}")
    print(f"main: {data.get('main')}")
    print(f"window: {window.get('width')}x{window.get('height')} scale {window.get('scale', 1)}")
    print(f"assets: {len(data.get('assets', []))}")
    levels = load_levels(data)
    if levels is not None:
        print(f"levels: {len(validate_levels(levels, data['levels'].get('_absolute_path', 'levels')))}")
    else:
        print("levels: none")


def doctor(project_file: Path) -> int:
    data = validate(project_file)
    warnings = project_warnings(data)
    print("MiniPixels doctor")
    print(f"project: {data.get('name')}")
    if not warnings:
        print("OK: no issues found")
        return 0
    for warning in warnings:
        print(f"warning: {warning}")
    return 0


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(prog="minipixels")
    p.add_argument("--version", action="version", version=f"MiniPixels {VERSION}")
    sub = p.add_subparsers(dest="cmd", required=True)
    sub.add_parser("new").add_argument("name")
    sub.add_parser("package").add_argument("--output-dir", default=str(ROOT / "dist"))
    for name in ["info", "doctor"]:
        sp = sub.add_parser(name)
        sp.add_argument("project", nargs="?", default="minipixels.json")
    for name in ["validate", "generate", "pack", "build", "run"]:
        sp = sub.add_parser(name)
        sp.add_argument("project", nargs="?", default="minipixels.json")
        sp.add_argument("--compiler", default=str(DEFAULT_COMPILER))
        sp.add_argument("--output")
        sp.add_argument("--generated-dir")
        sp.add_argument("--debug", action="store_true")
        sp.add_argument("--release", action="store_true")
        sp.add_argument("--headless", action="store_true")
        sp.add_argument("--verbose", action="store_true")

    args = p.parse_args(argv)
    if args.cmd == "new":
        new_project(args.name)
        return 0
    if args.cmd == "package":
        cmd = [sys.executable, str(ROOT / "tools" / "package_sdk.py"), "--output-dir", str(Path(args.output_dir).resolve())]
        subprocess.check_call(cmd, cwd=str(ROOT))
        return 0

    project = Path(args.project).resolve()
    if args.cmd == "info":
        print_project_info(project)
    elif args.cmd == "doctor":
        return doctor(project)
    elif args.cmd == "validate":
        validate(project)
        print("MiniPixels project is valid")
    elif args.cmd == "generate":
        gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
        generate(project, gen_dir)
    elif args.cmd == "pack":
        out = Path(args.output).resolve() if args.output else project.parent / "build" / "game.mpak"
        pack(project, out)
    elif args.cmd == "build":
        gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
        out = Path(args.output).resolve() if args.output else None
        build(project, out, Path(args.compiler).resolve(), gen_dir)
    elif args.cmd == "run":
        gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
        out = Path(args.output).resolve() if args.output else None
        exe = build(project, out, Path(args.compiler).resolve(), gen_dir)
        subprocess.check_call([str(exe)], cwd=str(project.parent))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
