#!/usr/bin/env python3
"""MiniPixels project processor and build CLI."""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import shutil
import struct
import subprocess
import sys
import zlib
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parent
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))
from asset_security import generate_signing_key, key_id, load_signing_key, protect_pack, raw_public_key


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"
ASSET_ID_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
VERSION = "0.10.0"
DEFAULT_TARGET = "windows-x64" if os.name == "nt" else "linux-x64"


def asset_protection(data: dict) -> dict | None:
    config = data.get("assetProtection")
    if not isinstance(config, dict) or config.get("enabled") is not True:
        return None
    return config


def write_bytes_if_changed(path: Path, content: bytes) -> bool:
    """Write bytes only when content changed, preserving incremental-build mtimes."""
    if path.exists() and path.read_bytes() == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)
    return True


def write_text_if_changed(path: Path, content: str) -> bool:
    """Write UTF-8 text only when content changed."""
    encoded = content.encode("utf-8")
    return write_bytes_if_changed(path, encoded)


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
    text_catalogs: list[tuple[str, str, dict[str, str]]] = []
    for asset in data.get("assets", []):
        if not isinstance(asset, dict):
            errors.append(f"{project_file}: every asset must be an object")
            continue
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
        kind = str(asset.get("type", "image")).lower()
        if kind not in ("image", "procedural", "audio", "file", "text", "data", "constants"):
            errors.append(f"{project_file}: asset '{aid}' has unsupported type '{kind}'")
        if kind in ("text", "constants") and path and (root / path).is_file():
            try:
                structured = json.loads((root / path).read_text(encoding="utf-8"))
                if not isinstance(structured, dict):
                    errors.append(f"{project_file}: asset '{aid}' must contain a JSON object")
                elif kind == "text" and any(not isinstance(k, str) or not isinstance(v, str) for k, v in structured.items()):
                    errors.append(f"{project_file}: text asset '{aid}' values must all be strings")
                elif kind == "text":
                    text_catalogs.append((str(asset.get("locale", aid)), str(aid), structured))
            except (OSError, UnicodeError, json.JSONDecodeError) as exc:
                errors.append(f"{project_file}: asset '{aid}' is not valid UTF-8 JSON: {exc}")
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

    localization = data.get("localization", {})
    if localization is not None and not isinstance(localization, dict):
        errors.append(f"{project_file}: localization must be an object")
        localization = {}
    if text_catalogs:
        locales = [locale for locale, _, _ in text_catalogs]
        if len(set(locales)) != len(locales):
            errors.append(f"{project_file}: text asset locales must be unique")
        default_locale = str(localization.get("defaultLocale", text_catalogs[0][0]))
        base = next((catalog for locale, _, catalog in text_catalogs if locale == default_locale), None)
        if base is None:
            errors.append(f"{project_file}: localization.defaultLocale '{default_locale}' has no text asset")
        else:
            placeholder = re.compile(r"\{[0-9]+\}")
            for locale, aid, catalog in text_catalogs:
                missing = sorted(set(base) - set(catalog))
                extra = sorted(set(catalog) - set(base))
                if missing:
                    errors.append(f"{project_file}: text asset '{aid}' is missing keys: {', '.join(missing)}")
                if extra:
                    errors.append(f"{project_file}: text asset '{aid}' has extra keys: {', '.join(extra)}")
                for name in sorted(set(base) & set(catalog)):
                    if set(placeholder.findall(base[name])) != set(placeholder.findall(catalog[name])):
                        errors.append(f"{project_file}: text asset '{aid}' has different placeholders for '{name}'")

    protection = data.get("assetProtection")
    if protection is not None:
        if not isinstance(protection, dict):
            errors.append(f"{project_file}: assetProtection must be an object")
        elif protection.get("enabled") not in (True, False, None):
            errors.append(f"{project_file}: assetProtection.enabled must be boolean")
        elif "signingKey" in protection and not isinstance(protection.get("signingKey"), str):
            errors.append(f"{project_file}: assetProtection.signingKey must be a path string")

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


def adler32(data: bytes) -> int:
    a = 1
    b = 0
    for value in data:
        a = (a + value) % 65521
        b = (b + a) % 65521
    return ((b << 16) | a) & 0xFFFFFFFF


def zlib_store(data: bytes) -> bytes:
    out = bytearray([0x78, 0x01])
    pos = 0
    while pos < len(data) or (pos == 0 and len(data) == 0):
        chunk = data[pos : pos + 65535]
        pos += len(chunk)
        final = 1 if pos >= len(data) else 0
        out.append(final)
        out.extend(struct.pack("<H", len(chunk)))
        out.extend(struct.pack("<H", 0xFFFF ^ len(chunk)))
        out.extend(chunk)
        if len(data) == 0:
            break
    out.extend(struct.pack(">I", adler32(data)))
    return bytes(out)


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", zlib.crc32(kind + payload) & 0xFFFFFFFF)


def write_png_rgba_store(width: int, height: int, rgba: bytes) -> bytes:
    if len(rgba) != width * height * 4:
        die("internal error: RGBA buffer size does not match image dimensions")
    rows = bytearray()
    stride = width * 4
    for y in range(height):
        rows.append(0)
        start = y * stride
        rows.extend(rgba[start : start + stride])
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + png_chunk(b"IHDR", ihdr)
        + png_chunk(b"IDAT", zlib_store(bytes(rows)))
        + png_chunk(b"IEND", b"")
    )


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


def is_container_image_asset(asset: dict) -> bool:
    return str(asset.get("type", "image")).lower() in ("image", "procedural")


def container_image_assets(data: dict) -> list[dict]:
    return [asset for asset in data.get("assets", []) if is_container_image_asset(asset)]


def container_assets(data: dict) -> list[dict]:
    return [
        asset
        for asset in data.get("assets", [])
        if str(asset.get("type", "image")).lower() in ("image", "procedural", "audio", "file", "text", "data")
    ]


def container_audio_assets(data: dict) -> list[dict]:
    return [asset for asset in data.get("assets", []) if str(asset.get("type", "image")).lower() == "audio"]


def text_catalog_payload(path: Path) -> bytes:
    """Encode a deterministic UTF-8 key/value catalog for the MiniPixels runtime."""
    values = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(values, dict) or any(not isinstance(k, str) or not isinstance(v, str) for k, v in values.items()):
        die(f"{path}: text assets must be JSON objects containing only string values")
    out = bytearray(b"MPT1")
    out.extend(struct.pack("<I", len(values)))
    for name, value in sorted(values.items()):
        encoded_name = name.encode("utf-8")
        encoded_value = value.encode("utf-8")
        if not encoded_name or len(encoded_name) > 0xFFFF:
            die(f"{path}: translation key length must be between 1 and 65535 UTF-8 bytes")
        out.extend(struct.pack("<HI", len(encoded_name), len(encoded_value)))
        out.extend(encoded_name)
        out.extend(encoded_value)
    return bytes(out)


def normalized_json_payload(path: Path) -> bytes:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        die(f"{path}: invalid data asset: {exc}")
    return (json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode("utf-8")


def _ml_scalar(value) -> str:
    if value is None:
        return "void"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        if not math.isfinite(value):
            raise ValueError("constants must not contain NaN or infinity")
        return repr(value)
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    raise TypeError(type(value).__name__)


def _constant_name(parts: list[str]) -> str:
    return "_".join(re.sub(r"[^A-Za-z0-9_]", "_", part).upper() for part in parts)


def _constant_leaves(value, parts: list[str]):
    if isinstance(value, dict):
        for key, child in sorted(value.items()):
            yield from _constant_leaves(child, parts + [str(key)])
    elif not isinstance(value, list):
        yield _constant_name(parts), value


def _emit_embedded_value(value, lines: list[str], counter: list[int]) -> str:
    if not isinstance(value, (dict, list)):
        return _ml_scalar(value)
    name = f"value{counter[0]}"
    counter[0] += 1
    if isinstance(value, list):
        lines.append(f"  {name} = array({len(value)})")
        for index, child in enumerate(value):
            expression = _emit_embedded_value(child, lines, counter)
            lines.append(f"  {name}[{index}] = {expression}")
    else:
        lines.append(f"  {name} = hm.HashMap.withCapacity({len(value) * 2 + 1})")
        for key, child in sorted(value.items()):
            expression = _emit_embedded_value(child, lines, counter)
            lines.append(f"  {name}.set({json.dumps(str(key), ensure_ascii=False)}, {expression})")
    return name


def generate_constants_modules(data: dict, out_dir: Path) -> list[Path]:
    outputs: list[Path] = []
    for asset in sorted(data.get("assets", []), key=lambda item: item["id"]):
        if str(asset.get("type", "")).lower() != "constants":
            continue
        aid = asset["id"]
        source = Path(asset["_absolute_path"])
        value = json.loads(source.read_text(encoding="utf-8"))
        if not isinstance(value, dict):
            die(f"{source}: constants asset must contain a JSON object")
        lines = [f"package generated.constants.{aid}", "", "import std.ds.hashmap as hm", ""]
        seen_names: set[str] = set()
        try:
            for name, scalar in _constant_leaves(value, []):
                if not name or not ASSET_ID_RE.match(name) or name in seen_names:
                    die(f"{source}: constants produce an invalid or duplicate identifier '{name}'")
                seen_names.add(name)
                lines.append(f"const {name} = {_ml_scalar(scalar)}")
            lines.extend(["", "function data()"])
            setup: list[str] = []
            result = _emit_embedded_value(value, setup, [0])
            lines.extend(setup)
            lines.extend([f"  return {result}", "end function", ""])
        except (TypeError, ValueError) as exc:
            die(f"{source}: unsupported constants value: {exc}")
        output = out_dir / "constants" / f"{aid}.ml"
        write_text_if_changed(output, "\n".join(lines))
        outputs.append(output)
        print(output)
    return outputs


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
        "function fillPlatform(data, width, x, y, w, left, middle, alt, right)",
        "  if w <= 0 then return end if",
        "  if w == 1 then",
        "    data[(y * width) + x] = middle",
        "    return",
        "  end if",
        "  data[(y * width) + x] = left",
        "  i = 1",
        "  while i < w - 1",
        "    value = middle",
        "    if alt > 0 and i % 3 == 0 then value = alt end if",
        "    data[(y * width) + x + i] = value",
        "    i = i + 1",
        "  end while",
        "  data[(y * width) + x + w - 1] = right",
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
            if any(key in platform for key in ("left", "middle", "alt", "right")):
                left = int(platform.get("left", tile))
                middle = int(platform.get("middle", tile))
                alt = int(platform.get("alt", middle))
                right = int(platform.get("right", tile))
                lines.append(f"    fillPlatform(data, w, {x}, {y}, {w}, {left}, {middle}, {alt}, {right})")
            else:
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

    lines.append("function enemyKind(level, index)")
    for idx, level in enumerate(levels):
        lines.append(f"  if level == {idx} then")
        for item_idx, item in enumerate(level["enemies"]):
            lines.append(f"    if index == {item_idx} then return {int(item.get('kind', 0))} end if")
        lines.append("    return 0")
        lines.append("  end if")
    lines.append("  return 0")
    lines.append("end function")
    lines.append("")

    write_text_if_changed(out, "\n".join(lines) + "\n")
    print(out)
    return out


def _emit_bytes_function(lines: list[str], name: str, values: bytes) -> None:
    lines.append(f"function {name}()")
    lines.append(f"  value = bytes({len(values)}, 0)")
    for index, byte in enumerate(values):
        lines.append(f"  value[{index}] = {byte}")
    lines.append("  return value")
    lines.append("end function")
    lines.append("")


def write_asset_security_module(path: Path, protected) -> Path:
    """Emit per-build key material without a contiguous AES key literal."""
    order = list(range(32))
    # Fisher-Yates with OS randomness keeps the emitted layout different for every protected build.
    for index in range(31, 0, -1):
        selected = int.from_bytes(os.urandom(4), "little") % (index + 1)
        order[index], order[selected] = order[selected], order[index]
    mask = os.urandom(32)
    encoded = bytes(protected.aes_key[slot] ^ mask[index] ^ ((index * 73 + 41) & 0xFF) for index, slot in enumerate(order))
    lines = [
        "package generated.asset_security",
        "",
        "// Generated per protected build. This raises the extraction cost but is not a hardware trust boundary.",
        "function aesKey()",
        "  key = bytes(32, 0)",
        "  mask = bytes(32, 0)",
        "  encoded = bytes(32, 0)",
    ]
    for index, byte in enumerate(mask):
        lines.append(f"  mask[{index}] = {byte}")
    for index, byte in enumerate(encoded):
        lines.append(f"  encoded[{index}] = {byte}")
    for index, slot in enumerate(order):
        lines.append(f"  key[{slot}] = encoded[{index}] ^ mask[{index}] ^ {((index * 73 + 41) & 0xFF)}")
    lines.extend(["  return key", "end function", ""])
    _emit_bytes_function(lines, "publicKey", protected.public_key)
    _emit_bytes_function(lines, "keyId", protected.key_id)
    write_text_if_changed(path, "\n".join(lines))
    return path


def write_asset_pack(data: dict, root: Path, output: Path, security_module: Path | None = None) -> Path:
    output.parent.mkdir(parents=True, exist_ok=True)
    entries: list[dict] = []
    blob = bytearray()

    for asset in sorted(data.get("assets", []), key=lambda a: a["id"]):
        kind = str(asset.get("type", "image")).lower()
        if kind == "procedural":
            width, height, rgba = procedural_pixels(asset)
            payload = write_png_rgba_store(width, height, rgba)
            type_code = 1
        elif kind == "image":
            raw_path = asset.get("path")
            if not raw_path:
                continue
            path = root / raw_path
            width, height, rgba = read_png_rgba(path)
            payload = write_png_rgba_store(width, height, rgba)
            type_code = 1
        elif kind == "audio":
            raw_path = asset.get("path")
            if not raw_path:
                continue
            path = root / raw_path
            payload = path.read_bytes()
            type_code = 2
        elif kind == "file":
            raw_path = asset.get("path")
            if not raw_path:
                continue
            path = root / raw_path
            payload = path.read_bytes()
            type_code = 3
        elif kind == "text":
            raw_path = asset.get("path")
            if not raw_path:
                continue
            payload = text_catalog_payload(root / raw_path)
            type_code = 4
        elif kind == "data":
            raw_path = asset.get("path")
            if not raw_path:
                continue
            payload = normalized_json_payload(root / raw_path)
            type_code = 5
        else:
            continue
        offset = len(blob)
        blob.extend(payload)
        entries.append({"id": asset["id"], "type": type_code, "offset": offset, "size": len(payload)})

    index_size = 8
    for entry in entries:
        name = entry["id"].encode("utf-8")
        index_size += 2 + len(name) + 1 + 1 + 4 + 4

    payload_base = index_size
    index = bytearray(b"MPX1")
    index.extend(struct.pack("<I", len(entries)))
    for entry in entries:
        name = entry["id"].encode("utf-8")
        index.extend(struct.pack("<H", len(name)))
        index.extend(name)
        index.append(entry["type"])
        index.append(0)
        index.extend(struct.pack("<I", payload_base + entry["offset"]))
        index.extend(struct.pack("<I", entry["size"]))

    content = bytes(index) + bytes(blob)
    protection = asset_protection(data)
    if protection is not None:
        try:
            signing_key = load_signing_key(root, protection)
            protected = protect_pack(content, signing_key)
        except (RuntimeError, ValueError) as exc:
            die(str(exc))
        content = protected.data
        if security_module is not None:
            write_asset_security_module(security_module, protected)
    write_bytes_if_changed(output, content)
    print(output)
    return output


def generate(project_file: Path, out_dir: Path) -> Path:
    data = validate(project_file)
    out_dir.mkdir(parents=True, exist_ok=True)
    root = project_root(project_file)
    pack_path = out_dir.parent.parent / "assets.mpx"
    protection = asset_protection(data)
    security_module = out_dir / "asset_security.ml" if protection is not None else None
    write_asset_pack(data, root, pack_path, security_module)
    out = out_dir / "assets.ml"
    lines = [
        "package generated.assets",
        "",
        "import minipixels as mp",
        "import minipixels.assets.assets as assets",
        "",
    ]
    if protection is not None:
        lines.insert(4, "import generated.asset_security as security")
    pack_assets = sorted(container_assets(data), key=lambda a: a["id"])
    image_assets = sorted(container_image_assets(data), key=lambda a: a["id"])
    audio_assets = sorted(container_audio_assets(data), key=lambda a: a["id"])
    text_assets = sorted((asset for asset in pack_assets if str(asset.get("type", "")).lower() == "text"), key=lambda a: a["id"])
    data_assets = sorted((asset for asset in pack_assets if str(asset.get("type", "")).lower() == "data"), key=lambda a: a["id"])
    if pack_assets:
        lines.extend(
            [
                "assetPackCache = void",
                "",
                "function assetPack()",
                "  global assetPackCache",
                "  if assetPackCache == void then",
                ('    assetPackCache = try(mp.openProtectedAssetPack("assets.mpx", security.aesKey(), security.publicKey(), security.keyId()))' if protection is not None else '    assetPackCache = try(mp.openAssetPack("assets.mpx"))'),
                ('    if typeof(assetPackCache) == "error" then assetPackCache = try(mp.openProtectedAssetPack("build/assets.mpx", security.aesKey(), security.publicKey(), security.keyId())) end if' if protection is not None else '    if typeof(assetPackCache) == "error" then assetPackCache = try(mp.openAssetPack("build/assets.mpx")) end if'),
                "  end if",
                "  return assetPackCache",
                "end function",
                "",
            ]
        )
    for asset in image_assets:
        aid = asset["id"]
        lines.append(f"sprite_{aid}_cache = void")
        lines.append("")
        lines.append(f"function make_{aid}()")
        lines.append(f"  global sprite_{aid}_cache")
        lines.append(f"  if sprite_{aid}_cache == void then")
        lines.append(f'    img = mp.loadPngFromPack(assetPack(), "{aid}")')
        lines.append(f'    sprite_{aid}_cache = mp.spriteFromImage(img, "{aid}")')
        lines.append("  end if")
        lines.append(f"  return sprite_{aid}_cache")
        lines.append("end function")
        lines.append("")
        sheet = sheet_config(asset)
        if sheet is not None:
            lines.append(f"sheet_{aid}_cache = void")
            lines.append("")
            lines.append(f"function sheet_{aid}()")
            lines.append(f"  global sheet_{aid}_cache")
            lines.append(f"  if sheet_{aid}_cache == void then")
            lines.append(f"    spr = make_{aid}()")
            lines.append(
                f'    sheet_{aid}_cache = mp.spriteSheet(spr.image, {sheet["frameWidth"]}, {sheet["frameHeight"]}, {sheet["spacing"]}, {sheet["margin"]})'
            )
            lines.append("  end if")
            lines.append(f"  return sheet_{aid}_cache")
            lines.append("end function")
            lines.append("")
    for asset in audio_assets:
        aid = asset["id"]
        lines.append(f"audio_{aid}_cache = void")
        lines.append("")
        lines.append(f"function audio_{aid}()")
        lines.append(f"  global audio_{aid}_cache")
        lines.append(f"  if audio_{aid}_cache == void then")
        lines.append(f'    audio_{aid}_cache = mp.audioClipFromBytes(mp.loadBytesFromPack(assetPack(), "{aid}"), "{aid}")')
        lines.append("  end if")
        lines.append(f"  return audio_{aid}_cache")
        lines.append("end function")
        lines.append("")
    for asset in text_assets:
        aid = asset["id"]
        locale = str(asset.get("locale", aid))
        lines.append(f"function text_{aid}()")
        lines.append(f"  return mp.loadTextCatalogFromPack(assetPack(), {json.dumps(aid)}, {json.dumps(locale)})")
        lines.append("end function")
        lines.append("")
    if text_assets:
        default_locale = str(data.get("localization", {}).get("defaultLocale", text_assets[0].get("locale", text_assets[0]["id"])))
        lines.append("function localization()")
        lines.append(f"  service = mp.localization({json.dumps(default_locale)})")
        for asset in text_assets:
            lines.append(f"  service.add(text_{asset['id']}())")
        lines.append("  return service")
        lines.append("end function")
        lines.append("")
    for asset in data_assets:
        aid = asset["id"]
        lines.append(f"function data_{aid}()")
        lines.append(f"  return decode(mp.loadBytesFromPack(assetPack(), {json.dumps(aid)}))")
        lines.append("end function")
        lines.append("")
    lines.append("function registry()")
    lines.append("  reg = assets.create(64)")
    for asset in image_assets:
        aid = asset["id"]
        lines.append(f'  reg.addLazy("{aid}", make_{aid})')
    lines.append("  return reg")
    lines.append("end function")
    write_text_if_changed(out, "\n".join(lines) + "\n")
    generate_levels_module(data, out_dir)
    generate_constants_modules(data, out_dir)
    print(out)
    return out


def pack(project_file: Path, output: Path) -> Path:
    data = validate(project_file)
    root = project_root(project_file)
    security_module = root / "build" / "generated" / "generated" / "asset_security.ml" if asset_protection(data) is not None else None
    return write_asset_pack(data, root, output, security_module)


def asset_report(data: dict, root: Path) -> dict:
    report = {"embedded": [], "container": [], "runtime": [], "totals": {"embeddedBytes": 0, "containerBytes": 0, "runtimeBytes": 0}}
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
        kind = str(asset.get("type", "image")).lower()
        if kind == "procedural":
            width, height, rgba = procedural_pixels(asset)
            size = len(write_png_rgba_store(width, height, rgba))
            entry["bytes"] = size
        if kind in ("image", "procedural", "audio", "file", "text", "data"):
            report["container"].append(entry)
            report["totals"]["containerBytes"] += size
        elif kind == "constants":
            report["embedded"].append(entry)
            report["totals"]["embeddedBytes"] += size
        else:
            report["runtime"].append(entry)
            report["totals"]["runtimeBytes"] += size
    return report


def write_asset_report(data: dict, root: Path, output: Path) -> Path:
    report_path = output.parent / "asset-report.json"
    write_text_if_changed(report_path, json.dumps(asset_report(data, root), indent=2, sort_keys=True) + "\n")
    print(report_path)
    return report_path


def copy_runtime_assets(data: dict, root: Path, output: Path) -> None:
    copied: set[Path] = set()
    stale_audio = output.parent / "assets" / "audio"
    if stale_audio.exists():
        shutil.rmtree(stale_audio)

    def copy_path(src: Path, rel: Path) -> None:
        src = src.resolve()
        if src in copied or not src.exists() or not src.is_file():
            return
        dst = output.parent / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
        copied.add(src)

    for asset in data.get("assets", []):
        kind = str(asset.get("type", "image")).lower()
        if kind in ("image", "procedural", "audio", "file", "text", "data", "constants"):
            continue
        raw_path = asset.get("path")
        if not raw_path:
            continue
        copy_path(root / raw_path, Path(raw_path))
    pack_source = (root / "build" / "assets.mpx").resolve()
    pack_target = (output.parent / "assets.mpx").resolve()
    if pack_source.is_file() and pack_source != pack_target:
        shutil.copy2(pack_source, pack_target)


def build(
    project_file: Path,
    output: Path | None,
    compiler: Path,
    generated_dir: Path,
    target: str = DEFAULT_TARGET,
    subsystem: str = "windows",
    debug: bool = False,
    incremental: bool = True,
    verbose: bool = False,
) -> Path:
    data = validate(project_file)
    root = project_root(project_file)
    generate(project_file, generated_dir)
    main = root / data["main"]
    if output is None:
        suffix = ".exe" if target == "windows-x64" else ""
        output = root / "build" / f"{data.get('name', 'game')}{suffix}"
    output.parent.mkdir(parents=True, exist_ok=True)
    manifest_path = output.parent / "minilang.toml"
    compiler_root = compiler.parent
    if not (compiler_root / "std").is_dir() and (compiler_root.parent / "std").is_dir():
        compiler_root = compiler_root.parent
    include_paths = [ROOT / "src", compiler_root, generated_dir.parent]
    compiler_args = ["--profile-calls"] if debug else []
    manifest_lines = [
        "[project]",
        f"entry = {json.dumps(str(main))}",
        f"output = {json.dumps(str(output))}",
        "include = [" + ", ".join(json.dumps(str(path)) for path in include_paths) + "]",
        f"target = {json.dumps(target)}",
        f"subsystem = {json.dumps(subsystem)}",
        f"incremental = {'true' if incremental else 'false'}",
        f"cache_dir = {json.dumps(str(output.parent / '.minilang-cache'))}",
        "compiler_args = [" + ", ".join(json.dumps(arg) for arg in compiler_args) + "]",
        "",
    ]
    write_text_if_changed(manifest_path, "\n".join(manifest_lines))
    compiler_command = [sys.executable, str(compiler)] if compiler.suffix.lower() == ".py" else [str(compiler)]
    cmd = compiler_command + ["--project", str(manifest_path)]
    if verbose:
        print("compiler:", " ".join(cmd))
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


def security_init(project_file: Path, force: bool = False) -> None:
    data = load_project(project_file)
    root = project_root(project_file)
    config = data.get("assetProtection")
    if config is None:
        config = {"enabled": True, "signingKey": ".minipixels/asset-signing-key.pem"}
        data["assetProtection"] = config
    elif not isinstance(config, dict):
        die(f"{project_file}: assetProtection must be an object")
    else:
        config["enabled"] = True
        config.setdefault("signingKey", ".minipixels/asset-signing-key.pem")
    private_path = (root / str(config["signingKey"])).resolve()
    public_path = private_path.with_name("asset-signing-public.pem")
    if (private_path.exists() or public_path.exists()) and not force:
        die(f"asset signing keys already exist at {private_path.parent}; use --force to replace them")
    public = generate_signing_key(private_path, public_path)
    write_text_if_changed(project_file, json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    ignore_path = root / ".gitignore"
    try:
        ignored = str(private_path.relative_to(root)).replace("\\", "/")
    except ValueError:
        ignored = None
    if ignored is not None:
        existing = ignore_path.read_text(encoding="utf-8") if ignore_path.exists() else ""
        if ignored not in {line.strip().lstrip("/") for line in existing.splitlines()}:
            separator = "" if not existing or existing.endswith("\n") else "\n"
            write_text_if_changed(ignore_path, existing + separator + f"/{ignored}\n")
    print(f"private signing key: {private_path}")
    print(f"public signing key:  {public_path}")
    print(f"public key id:       {key_id(public).hex()}")
    print("asset protection enabled; keep the private key out of version control")


def security_status(project_file: Path) -> None:
    data = validate(project_file)
    config = asset_protection(data)
    if config is None:
        print("asset protection: disabled")
        return
    try:
        private_key = load_signing_key(project_root(project_file), config)
        public = raw_public_key(private_key.public_key())
    except (RuntimeError, ValueError) as exc:
        print("asset protection: enabled")
        print(f"signing key: unavailable ({exc})")
        return
    print("asset protection: enabled")
    print("encryption: AES-256-GCM")
    print("signature: ECDSA-P256-SHA256")
    print(f"public key id: {key_id(public).hex()}")


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
    security_parser = sub.add_parser("security")
    security_parser.add_argument("action", choices=("init", "status"))
    security_parser.add_argument("project", nargs="?", default="minipixels.json")
    security_parser.add_argument("--force", action="store_true")
    for name in ["info", "doctor"]:
        sp = sub.add_parser(name)
        sp.add_argument("project", nargs="?", default="minipixels.json")
    validate_parser = sub.add_parser("validate")
    validate_parser.add_argument("project", nargs="?", default="minipixels.json")
    generate_parser = sub.add_parser("generate")
    generate_parser.add_argument("project", nargs="?", default="minipixels.json")
    generate_parser.add_argument("--generated-dir")
    pack_parser = sub.add_parser("pack")
    pack_parser.add_argument("project", nargs="?", default="minipixels.json")
    pack_parser.add_argument("--output")
    for name in ["build", "run"]:
        sp = sub.add_parser(name)
        sp.add_argument("project", nargs="?", default="minipixels.json")
        sp.add_argument("--compiler", default=str(DEFAULT_COMPILER))
        sp.add_argument("--target", choices=("windows-x64", "linux-x64"), default=DEFAULT_TARGET)
        sp.add_argument("--output")
        sp.add_argument("--generated-dir")
        mode = sp.add_mutually_exclusive_group()
        mode.add_argument("--debug", action="store_true", help="instrument MiniLang function calls")
        mode.add_argument("--release", action="store_true", help="build without debug instrumentation (default)")
        sp.add_argument("--headless", action="store_true", help="build with the console subsystem")
        sp.add_argument("--no-incremental", action="store_true", help="bypass the compiler artifact cache")
        sp.add_argument("--verbose", action="store_true", help="print the compiler invocation")

    args = p.parse_args(argv)
    if args.cmd == "new":
        new_project(args.name)
        return 0
    if args.cmd == "package":
        cmd = [sys.executable, str(ROOT / "tools" / "package_sdk.py"), "--output-dir", str(Path(args.output_dir).resolve())]
        subprocess.check_call(cmd, cwd=str(ROOT))
        return 0

    if args.cmd == "security":
        project = Path(args.project).resolve()
        if args.action == "init":
            security_init(project, args.force)
        else:
            security_status(project)
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
        out = Path(args.output).resolve() if args.output else project.parent / "build" / "assets.mpx"
        pack(project, out)
    elif args.cmd == "build":
        gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
        out = Path(args.output).resolve() if args.output else None
        subsystem = "console" if args.headless or args.target == "linux-x64" else "windows"
        build(
            project,
            out,
            Path(args.compiler).resolve(),
            gen_dir,
            target=args.target,
            subsystem=subsystem,
            debug=args.debug,
            incremental=not args.no_incremental,
            verbose=args.verbose,
        )
    elif args.cmd == "run":
        gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
        out = Path(args.output).resolve() if args.output else None
        subsystem = "console" if args.headless or args.target == "linux-x64" else "windows"
        exe = build(
            project,
            out,
            Path(args.compiler).resolve(),
            gen_dir,
            target=args.target,
            subsystem=subsystem,
            debug=args.debug,
            incremental=not args.no_incremental,
            verbose=args.verbose,
        )
        if args.target != DEFAULT_TARGET:
            die(f"built {args.target} output at {exe}; run it on a matching host")
        subprocess.check_call([str(exe)], cwd=str(project.parent))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
