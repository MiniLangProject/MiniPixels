"""Validate the dimensions, frame boundaries and provenance of example graphics."""
import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


def test_example_art():
    dimensions = {
        "jump-and-run/assets/sprites/player_sheet.png": (256, 32),
        "jump-and-run/assets/sprites/player_run_sheet.png": (256, 32),
        "jump-and-run/assets/sprites/coin_sheet.png": (384, 32),
        "jump-and-run/assets/sprites/portal_sheet.png": (384, 32),
        "jump-and-run/assets/sprites/enemy_sheet.png": (256, 32),
        "jump-and-run/assets/tiles/game_tiles.png": (704, 32),
        "jump-and-run/assets/tiles/decor_sheet.png": (192, 32),
        "jump-and-run/assets/tiles/tree_sheet.png": (128, 64),
        "moving-sprite/assets/player.png": (16, 16),
        "scrolling-world/assets/sprites/player.png": (32, 16),
        "scrolling-world/assets/tiles/world.png": (64, 16),
        "scrolling-world/assets/near.png": (640, 125),
        "tiled-platformer/assets/tiles.png": (64, 32),
        "tiled-platformer/assets/items.png": (128, 32),
        "tiled-platformer/assets/player.png": (16, 16),
    }
    for index in range(3):
        dimensions[f"jump-and-run/assets/tiles/bg_base_{index}.png"] = (400, 225)
        dimensions[f"jump-and-run/assets/tiles/bg_near_{index}.png"] = (800, 156)
    for name in ("moving-sprite", "scrolling-world", "tiled-platformer"):
        dimensions[f"{name}/assets/background.png"] = (320, 180)
    dimensions["pixel-effects/assets/landscape.png"] = (320, 180)
    for relative, size in dimensions.items():
        with Image.open(ROOT / "examples" / relative) as image:
            assert image.size == size, (relative, image.size, size)
            assert image.mode == "RGBA", (relative, image.mode)
            assert image.getchannel("A").getextrema()[1] > 200, relative
            if "bg_base" in relative or "background" in relative or "landscape" in relative:
                assert image.getchannel("A").getextrema() == (255, 255), relative
            if "bg_near" in relative:
                assert image.getchannel("A").crop((0, 0, 800, 40)).getbbox() is None, relative
            if "sheet" in relative or "items.png" in relative:
                frame_size = 64 if "tree_sheet" in relative else 32
                margin = 2 if frame_size == 64 else 1
                for x in range(0, image.width, frame_size):
                    alpha = image.crop((x, 0, x + frame_size, frame_size)).getchannel("A")
                    bounds = alpha.point(lambda a: 255 if a >= 48 else 0).getbbox()
                    assert bounds and bounds[2] - bounds[0] >= 4 and bounds[3] - bounds[1] >= 4, (relative, x)
                    assert bounds[0] >= margin and bounds[1] >= margin and bounds[2] <= frame_size - margin and bounds[3] <= frame_size - margin, (relative, x, bounds)
                    if frame_size == 64:
                        assert bounds[3] == 62, "native tree roots must retain their existing world baseline"
                        frame = image.crop((x, 0, x + 64, 64))
                        # A native 64px tree must contain real one-pixel detail,
                        # not simply duplicate the old 32px pixels in 2x2 blocks.
                        differences = sum(frame.getpixel((px, py)) != frame.getpixel((px + 1, py))
                                          for py in range(64) for px in range(0, 64, 2))
                        assert differences > 100, "tree is only a doubled thumbnail"
    with Image.open(ROOT / "examples/jump-and-run/assets/tiles/decor_sheet.png") as image:
        rock = image.crop((32, 0, 64, 32)).getchannel("A")
        # The contact pixels must belong to the rock, not a detached fragment of
        # the next source-atlas row separated by a transparent horizontal gap.
        for y in range(24, 31):
            contact = sum(rock.getpixel((x, y)) >= 128 for x in range(32))
            assert contact >= 3, ("rock has a gap above its ground contact", y, contact)
    with Image.open(ROOT / "examples/jump-and-run/assets/sprites/player_run_sheet.png") as image:
        frames = [image.crop((i * 32, 0, i * 32 + 32, 32)) for i in range(8)]
        assert len({frame.tobytes() for frame in frames}) == 8, "run poses must be distinct"
        heads = [frame.getchannel("A").crop((0, 0, 32, 13)).point(lambda a: 255 if a >= 48 else 0).getbbox() for frame in frames]
        assert max(h[1] for h in heads) - min(h[1] for h in heads) <= 1, "head must not bob asymmetrically"
        centers = [(h[0] + h[2]) / 2 for h in heads]
        assert max(centers) - min(centers) <= 1, "swinging feet must not shift the head sideways"
        def planted_foot_x(frame):
            alpha = frame.getchannel("A")
            xs = [x for y in range(27, 31) for x in range(32) if alpha.getpixel((x, y)) >= 128]
            assert xs, "missing planted foot"
            return sum(xs) / len(xs)
        steps = [planted_foot_x(frames[start]) - planted_foot_x(frames[start + 2]) for start in (0, 4)]
        assert min(steps) > 3, "both stances must travel from front contact to rear push"
        assert abs(steps[0] - steps[1]) < 3, "both half-strides must have similar reach"
    for name in ("coin", "portal"):
        with Image.open(ROOT / f"examples/jump-and-run/assets/sprites/{name}_sheet.png") as image:
            frames = [image.crop((i * 32, 0, i * 32 + 32, 32)) for i in range(12)]
            assert len({frame.tobytes() for frame in frames}) == 12, f"{name} needs twelve distinct phases"
            bounds = [frame.getchannel("A").point(lambda a: 255 if a >= 48 else 0).getbbox() for frame in frames]
            assert max(b[3] for b in bounds) - min(b[3] for b in bounds) <= 1, f"{name} baseline wobbles"
            assert max(b[1] for b in bounds) - min(b[1] for b in bounds) <= 1, f"{name} height wobbles"
            widths = [b[2] - b[0] for b in bounds]
            if name == "coin":
                assert widths[3] < widths[0] / 3 and widths[9] < widths[6] / 3, "rotation needs two genuinely edge-on phases"
                assert widths[0] > widths[1] > widths[2] > widths[3]
                assert widths[6] > widths[7] > widths[8] > widths[9]
                assert widths[3] < widths[4] < widths[5] < widths[6]
                assert widths[9] < widths[10] < widths[11] < widths[0]
            else:
                assert max(widths) - min(widths) <= 1, "stone arch must not change size"
    provenance = json.loads((ROOT / "examples/_art/generation.json").read_text())
    for asset in provenance["assets"].values():
        assert (ROOT / "examples/_art" / asset["file"]).is_file()
        assert len(asset["prompt"]) > 100
    for name in ("moving-sprite", "scrolling-world", "pixel-effects", "jump-and-run", "tiled-platformer"):
        manifest = json.loads((ROOT / "examples" / name / "minipixels.json").read_text())
        for asset in manifest["assets"]:
            if asset["type"] == "image":
                assert (ROOT / "examples" / name / asset["path"]).is_file()
                if asset["id"] == "trees":
                    assert asset["sheet"]["frameWidth"] == 64 and asset["sheet"]["frameHeight"] == 64
    print("Example artwork tests passed (dimensions, alpha, frame margins, manifests, provenance)")


if __name__ == "__main__":
    test_example_art()
