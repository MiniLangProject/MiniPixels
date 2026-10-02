"""Prepare the checked-in AI-generated art for the examples (requires Pillow).

No illustration is drawn here: this only crops the documented source grids,
fits their contents without stretching, and assembles runtime sprite sheets.
Run from any directory; sources and full generation prompts live in examples/_art.
"""
from pathlib import Path
from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "examples" / "_art" / "sources"
NEAREST = Image.Resampling.NEAREST


def source(name):
    return Image.open(SOURCES / f"{name}.png").convert("RGBA")


def save(image, relative):
    path = ROOT / "examples" / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, optimize=True)


def cells(name, columns, rows, trim=0):
    image = source(name)
    return [image.crop((round(x * image.width / columns) + trim,
                        round(y * image.height / rows) + trim,
                        round((x + 1) * image.width / columns) - trim,
                        round((y + 1) * image.height / rows) - trim))
            for y in range(rows) for x in range(columns)]


def silhouette(image):
    # Ignore nearly invisible antialias/glow pixels only when locating the crop;
    # the actual cropped RGBA pixels retain their original alpha.
    bounds = image.getchannel("A").point(lambda a: 255 if a >= 48 else 0).getbbox()
    if bounds is None:
        raise ValueError("empty generated sprite cell")
    return image.crop(bounds)


def fit_frames(images, size=32, common_scale=True, center=False, resample=NEAREST, padding=1):
    cutouts = [silhouette(image) for image in images]
    limits = [min((size - 2 * padding) / image.width, (size - 2 * padding) / image.height) for image in cutouts]
    scale = min(limits)
    result = []
    for index, image in enumerate(cutouts):
        factor = scale if common_scale else limits[index]
        resized = image.resize((max(1, round(image.width * factor)), max(1, round(image.height * factor))), resample)
        frame = Image.new("RGBA", (size, size))
        y = (size - resized.height) // 2 if center else size - padding - resized.height
        frame.paste(resized, ((size - resized.width) // 2, y))
        result.append(frame)
    return result


def sheet(frames):
    image = Image.new("RGBA", (sum(frame.width for frame in frames), frames[0].height))
    x = 0
    for frame in frames:
        image.paste(frame, (x, 0))
        x += frame.width
    return image


def run_cycle(images):
    # Register by the hood, not the full silhouette: a swinging foot/scarf must
    # never pull the whole character sideways. One common scale for all poses.
    cutouts = [silhouette(frame) for frame in images]
    scale = 28 / max(frame.height for frame in cutouts)
    frames = []
    for image in cutouts:
        resized = image.resize((round(image.width * scale), round(image.height * scale)), NEAREST)
        head = resized.getchannel("A").crop((0, 0, resized.width, 10))
        bounds = head.point(lambda a: 255 if a >= 48 else 0).getbbox()
        x = round(17 - (bounds[0] + bounds[2]) / 2)
        # Top registration preserves the authored raised feet in flight phases.
        frame = Image.new("RGBA", (32, 32))
        frame.paste(resized, (x, 3))
        frames.append(frame)
    return frames


def main():
    players = cells("player", 4, 2)
    player32 = fit_frames(players)
    save(sheet(player32), "jump-and-run/assets/sprites/player_sheet.png")
    # Both half-strides use contact -> support -> push -> flight at equal cadence.
    # No separately generated, differently proportioned long-leg pose in the loop.
    run = cells("player_run_balanced", 4, 2)
    run_frames = run_cycle([run[i] for i in (0, 1, 2, 3, 6, 5, 4, 7)])
    save(sheet(run_frames), "jump-and-run/assets/sprites/player_run_sheet.png")
    save(sheet(fit_frames(cells("coin_spin", 4, 3), center=True)),
         "jump-and-run/assets/sprites/coin_sheet.png")
    save(sheet(fit_frames(cells("portal_loop", 4, 3))),
         "jump-and-run/assets/sprites/portal_sheet.png")
    player16 = fit_frames(players, 16)
    save(player16[0], "moving-sprite/assets/player.png")
    save(sheet(player16[2:4]), "scrolling-world/assets/sprites/player.png")
    save(player16[0], "tiled-platformer/assets/player.png")

    enemies = cells("enemy", 4, 2)
    enemy_frames = fit_frames(enemies[:4]) + fit_frames(enemies[4:], center=True)
    save(sheet(enemy_frames), "jump-and-run/assets/sprites/enemy_sheet.png")
    decor_sources = cells("decor", 3, 2)
    # This generated atlas does not honor the nominal row split for the pine:
    # its tip enters the bottom of the rock's cell. Exclude that next-row content
    # before finding the rock silhouette, otherwise it floats above its baseline.
    rock_source = source("decor")
    decor_sources[1] = rock_source.crop((rock_source.width // 3, 0,
                                       rock_source.width * 2 // 3,
                                       round(rock_source.height * 430 / 1024)))
    decor = fit_frames(decor_sources, common_scale=False)
    # Area sampling retains thin fronds instead of picking isolated source pixels.
    # The final sprites still render 1:1 on the game's pixel grid, without blur.
    for index in (0, 2):
        decor[index] = fit_frames([decor_sources[index]], resample=Image.Resampling.BOX)[0]
    save(sheet(decor), "jump-and-run/assets/tiles/decor_sheet.png")
    # Trees occupy the same 64px world footprint as before, but have native detail
    # instead of enlarging a 32px thumbnail 2x. Preserve the former 62px baseline.
    trees = fit_frames(decor_sources[3:5], size=64, common_scale=False,
                       resample=Image.Resampling.BOX, padding=2)
    save(sheet(trees), "jump-and-run/assets/tiles/tree_sheet.png")
    objects = cells("objects", 3, 2)
    coins = fit_frames(objects[:2], common_scale=True, center=True)
    portals = fit_frames(objects[2:4], common_scale=True)
    small_decor = fit_frames(objects[4:], common_scale=False)
    small_decor[0] = fit_frames([objects[4]], resample=Image.Resampling.BOX)[0]

    terrain = [tile.resize((32, 32), NEAREST) for tile in cells("terrain", 4, 3, trim=3)]
    # Preserve all 22 frame IDs referenced by existing authored level data.
    tiles = [terrain[0], *coins, *portals, *small_decor,
             *terrain[:4], terrain[2], terrain[1], *terrain[4:8],
             *terrain[:4], terrain[2]]
    assert len(tiles) == 22
    save(sheet(tiles), "jump-and-run/assets/tiles/game_tiles.png")
    save(sheet([terrain[0], terrain[4], terrain[8], terrain[1]]).resize((64, 16), NEAREST),
         "scrolling-world/assets/tiles/world.png")
    save(sheet([terrain[0], terrain[4]]), "tiled-platformer/assets/tiles.png")
    save(sheet([*coins, *portals]), "tiled-platformer/assets/items.png")

    strips = cells("near", 1, 3)
    for index in range(3):
        background = ImageOps.fit(source(f"bg{index}"), (400, 225), method=NEAREST)
        save(background, f"jump-and-run/assets/tiles/bg_base_{index}.png")
        strip = silhouette(strips[index])
        factor = min(800 / strip.width, 156 / strip.height)
        resized = strip.resize((round(strip.width * factor), round(strip.height * factor)), NEAREST)
        layer = Image.new("RGBA", (800, 156))
        layer.paste(resized, ((800 - resized.width) // 2, 156 - resized.height))
        save(layer, f"jump-and-run/assets/tiles/bg_near_{index}.png")
        if index == 0:
            for example in ("moving-sprite", "scrolling-world", "tiled-platformer"):
                save(background.resize((320, 180), NEAREST), f"{example}/assets/background.png")
            save(ImageOps.contain(layer, (640, 125), method=NEAREST), "scrolling-world/assets/near.png")
        if index == 2:
            save(background.resize((320, 180), NEAREST), "pixel-effects/assets/landscape.png")
    print("Prepared all example artwork from the checked-in generated sources")


if __name__ == "__main__":
    main()
