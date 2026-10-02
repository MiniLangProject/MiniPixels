"""Render actual example frames through the engine, without opening a window.

Build examples first. Supports Windows and Linux (including WSL cross-targets).
Screenshots are checked for valid dimensions and assembled for visual review.
"""
import argparse
import os
import subprocess
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


def wsl_path(path):
    path = path.resolve()
    return f"/mnt/{path.drive[0].lower()}{path.as_posix().split(':', 1)[1]}"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", choices=["windows-x64", "linux-x64"], default="windows-x64" if os.name == "nt" else "linux-x64")
    parser.add_argument("--output-dir", type=Path, default=ROOT / "build" / "example-previews")
    parser.add_argument("--update-docs", action="store_true", help="Refresh documentation screenshots after a successful capture")
    args = parser.parse_args()
    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=True)
    captures = [(name, name, []) for name in ("moving-sprite", "scrolling-world", "pixel-effects", "tiled-platformer", "jump-and-run")]
    captures += [("jump-and-run", f"jump-and-run-level-{i}", ["play", str(i)]) for i in range(3)]
    for name, label, extra in captures:
        project = ROOT / "examples" / name
        exe = project / "build" / (name + (".exe" if args.target == "windows-x64" else ""))
        path = output / f"{label}.png"
        command = [str(exe), "--screenshot", str(path), *extra]
        if args.target == "linux-x64" and os.name == "nt":
            command = ["wsl.exe", "-d", os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu"),
                       "--cd", wsl_path(project), "--", wsl_path(exe), "--screenshot", wsl_path(path), *extra]
        subprocess.run(command, cwd=project, check=True, timeout=30)
        with Image.open(path) as image:
            assert image.size == ((400, 225) if name == "jump-and-run" else (320, 180)), label
            assert len(image.getcolors(image.width * image.height)) > 64, f"empty/flat scene: {label}"
        print(path)
    overview = Image.new("RGB", (1600, 1800), (12, 28, 42))
    for i, (_, label, _) in enumerate(captures):
        with Image.open(output / f"{label}.png") as image:
            overview.paste(image.resize((800, 450), Image.Resampling.NEAREST), ((i % 2) * 800, (i // 2) * 450))
    overview.save(output / "overview.png", optimize=True)
    if args.update_docs:
        docs = ROOT / "docs" / "images"
        docs.mkdir(parents=True, exist_ok=True)
        for _, label, _ in captures[:5]:
            with Image.open(output / f"{label}.png") as image:
                image.resize((1600, 900), Image.Resampling.NEAREST).save(docs / f"{label}.png", optimize=True)
        with Image.open(output / "jump-and-run-level-0.png") as image:
            image.resize((1600, 900), Image.Resampling.NEAREST).save(docs / "jump-and-run-gameplay.png", optimize=True)
        levels = Image.new("RGB", (1200, 225))
        for i in range(3):
            with Image.open(output / f"jump-and-run-level-{i}.png") as image:
                levels.paste(image, (i * 400, 0))
        levels.resize((2400, 450), Image.Resampling.NEAREST).save(docs / "jump-and-run-levels.png", optimize=True)
        sprites = Image.new("RGBA", (704, 352), (12, 28, 42, 255))
        assets = ROOT / "examples" / "jump-and-run" / "assets"
        for y, path in enumerate(("sprites/player_sheet.png", "sprites/player_run_sheet.png", "sprites/coin_sheet.png", "sprites/portal_sheet.png", "sprites/enemy_sheet.png", "tiles/decor_sheet.png", "tiles/game_tiles.png")):
            with Image.open(assets / path) as image:
                sprites.alpha_composite(image, (0, y * 40))
        with Image.open(assets / "tiles/tree_sheet.png") as image:
            sprites.alpha_composite(image, (0, 280))
        sprites.resize((1408, 704), Image.Resampling.NEAREST).save(docs / "jump-and-run-sprites.png", optimize=True)
    print("All eight engine screenshots passed")


if __name__ == "__main__":
    main()
