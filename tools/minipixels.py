#!/usr/bin/env python3
"""MiniPixels project processor and build CLI."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import struct
import subprocess
import sys
import zlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_COMPILER = ROOT.parent / "MiniLangCompilerPy" / "mlc_win64.py"


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
        if aid in seen:
            errors.append(f"{project_file}: duplicate asset id '{aid}'")
        seen.add(aid)
        path = asset.get("path")
        if path and not (root / path).exists():
            errors.append(f"{project_file}: asset '{aid}' path does not exist: {path}")
        if path:
            asset["_absolute_path"] = str((root / path).resolve())

    if errors:
        die("\n".join(errors))
    return data


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


def bytes_literal(data: bytes, indent: str = "  ") -> str:
    lines = [f"{indent}pix = bytes({len(data)}, 0)"]
    for i in range(0, len(data), 16):
        chunk = data[i : i + 16]
        for j, b in enumerate(chunk):
            lines.append(f"{indent}pix[{i + j}] = {b}")
    return "\n".join(lines)


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
    for asset in sorted(data.get("assets", []), key=lambda a: a["id"]):
        aid = asset["id"]
        w, h, pix = procedural_pixels(asset)
        func = f"make_{aid}"
        lines.append(f"function {func}()")
        lines.append(bytes_literal(pix))
        lines.append(f'  img = mp.image({w}, {h}, pix, "{aid}")')
        lines.append(f'  return mp.spriteFromImage(img, "{aid}")')
        lines.append("end function")
        lines.append("")
    lines.append("function registry()")
    lines.append("  reg = assets.create(64)")
    for asset in sorted(data.get("assets", []), key=lambda a: a["id"]):
        aid = asset["id"]
        lines.append(f'  reg.add("{aid}", make_{aid}())')
    lines.append("  return reg")
    lines.append("end function")
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
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


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(prog="minipixels")
    sub = p.add_subparsers(dest="cmd", required=True)
    sub.add_parser("new").add_argument("name")
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

    project = Path(args.project).resolve()
    gen_dir = Path(args.generated_dir).resolve() if args.generated_dir else project.parent / "build" / "generated" / "generated"
    if args.cmd == "validate":
        validate(project)
        print("MiniPixels project is valid")
    elif args.cmd == "generate":
        generate(project, gen_dir)
    elif args.cmd == "pack":
        out = Path(args.output).resolve() if args.output else project.parent / "build" / "game.mpak"
        pack(project, out)
    elif args.cmd == "build":
        out = Path(args.output).resolve() if args.output else None
        build(project, out, Path(args.compiler).resolve(), gen_dir)
    elif args.cmd == "run":
        out = Path(args.output).resolve() if args.output else None
        exe = build(project, out, Path(args.compiler).resolve(), gen_dir)
        subprocess.check_call([str(exe)], cwd=str(project.parent))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
