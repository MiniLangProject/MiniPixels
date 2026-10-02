# Example artwork

All five examples use a shared forest-adventure art set generated with the built-in
image-generation tool in Codex. The original PNGs are in `sources/`; the full
prompts and generation metadata are preserved in `generation.json`. These are new
illustrations, not edits of the previously bundled third-party graphics.

Runtime files live in each example's `assets/` directory and are packed into MPX
normally. High-resolution source images are not included in game asset packs.

## Reproduce runtime assets

From the repository root, with `requirements.txt` installed:

```sh
python tools/prepare_example_art.py
python tests/example_art_tests.py
python tools/build_examples.py
python tools/capture_examples.py --update-docs
```

Use `--target linux-x64` on the last two commands for Linux. Preparing the checked-in
sources is deterministic and requires neither image generation nor an API key.
New AI generations are not expected to reproduce identical pixels from the prompts.

The preparation script performs only the user-approved cropping, scaling, and
sheet assembly. Most graphics use nearest-neighbor sampling; foreground foliage
uses area sampling while reducing the detailed originals to retain thin leaves.
Animation groups share a scale and baseline, retain
transparent backgrounds, and have a one-pixel frame margin. Sprite proportions are
preserved; terrain textures fill their tile cells. The native 64px trees have a
two-pixel margin and a 62px baseline, preserving their previous world footprint.
They render 1:1, not as enlarged 32px thumbnails. Bushes remain native 32px sprites.
Backgrounds, terrain, rocks, characters and animations are unchanged by this
foliage preparation. Screenshots render 60 actual
headless engine frames so characters settle onto platforms before inspection.

The rock cell uses an explicit bottom crop at source y=430 (on the 1024px-tall
atlas): the next row's pine tip intrudes into the nominal first-row cell. Keeping
that fragment would align the fragment, rather than the rock, with the ground.
The art tests check continuous opaque contact above the rock's baseline.

| Source | Layout | Runtime use |
| --- | --- | --- |
| `player.png` | 4 x 2 | Eight 32px frames; 16px derivatives for smaller demos |
| `player_run_balanced.png` | 4 x 2 | Eight run phases, common scale and hood registration; equal contact/support/push/flight half-strides |
| `coin_spin.png` | 4 x 3 | Twelve phases including front, edge, and back; 1.2-second rotation |
| `portal_loop.png` | 4 x 3 | Twelve interior energy phases; 1.8-second loop |
| `enemy.png` | 4 x 2 | Four slime and four bat frames |
| `terrain.png` | 4 x 3 | Mossy top tiles, dirt, and platform textures |
| `decor.png` | 3 x 2 | 32px props plus two native 64px trees in `tree_sheet.png` |
| `objects.png` | 3 x 2 | Two coins, two portals, fern, sign |
| `bg0.png` / `bg1.png` / `bg2.png` | Single landscapes | Morning, autumn, and moonlit backgrounds |
| `near.png` | Three rows | Transparent foreground forest strips |

The older `player_run.png` and `player_run_push.png` sources are retained for
provenance but are no longer used. The separate long-legged push pose caused a
visible imbalance. Run sprites are now registered by the hood at a common scale,
not centered independently by the changing foot/scarf silhouette. Flight poses
retain their raised feet. Coins use an independent smooth, small floating offset;
the rotation never changes their vertical position. All runtime sheets are baked
during art preparation; gameplay only selects frames from the packed sheets.

`tests/example_art_tests.py` checks dimensions, alpha, sprite frame bounds, and
manifest paths. `tools/capture_examples.py` checks all five demos plus the three
Jump and Run levels, and produces `build/example-previews/overview.png` for visual
inspection. Both are exercised by CI. Geometric tests cannot replace visual review
of newly generated characters or animation poses.

Older attribution files in `jump-and-run/assets/` remain as historical documentation
for earlier releases; they do not describe the replacement graphics. Example audio
is unchanged and retains its existing CC0 notice.
