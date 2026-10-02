# Jump and Run Assets

## Graphics

All current PNG graphics are newly AI-generated forest-adventure artwork. Original
images, exact prompts, and the reproducible crop/scale/sheet-assembly workflow are
documented in [`../../_art/README.md`](../../_art/README.md).

The compact runtime sheets preserve the existing 32px frame layout and level tile
IDs. Trees have their own `tree_sheet.png`: two native 64x64 frames drawn at 1:1,
with the same footprint and root baseline as the previous doubled 32px sprites.
Trees and bushes are downsampled from the detailed originals with area sampling;
the runtime renderer does not blur or enlarge their pixels.
`bg_base_0.png` through `bg_base_2.png` provide morning, autumn, and moonlit
landscapes; `bg_near_0.png` through `bg_near_2.png` are transparent parallax layers.
Sprites include a turquoise forest courier, orange slime, indigo bat, golden leaf
coins, portals, and matching scenery. The build packs only the runtime PNGs named
in the manifest, not the high-resolution source artwork.

Frame contract: player 0-1 idle, 2-5 legacy poses, 6 rise, 7 fall; the dedicated
`player_run_sheet.png` supplies eight equally timed poses (two
contact/support/push/flight half-strides), registered by the hood rather than the
changing silhouette. `coin_sheet.png` and `portal_sheet.png` contain twelve phases
each, playing in 1.2 and 1.8 seconds respectively. Coin floating is a separate
smooth 2-second oscillation. These sheets leave the existing tile IDs intact.
Enemy 0-3 slime and
4-7 bat. Level JSON retains its original kind IDs (`1` = ground slime, `0` = bat),
so kind is deliberately mapped to the matching sheet bank rather than multiplied
by four. Runtime drawing aligns the visible 31px sprite baseline to the 32px
physics footprint, including scaled scenery and portals.

The existing `LICENSE-GANDALFHARDCORE.txt`, `LICENSE-OGA-*.txt`, and
`LICENSE-KENNEY-PIXEL-PLATFORMER.txt` files are retained for historical attribution
of graphics shipped in older releases. Those graphics have been replaced.

## Audio

- `audio/jump.wav`
- `audio/coin.wav`
- `audio/hurt.wav`
- `audio/win.wav`

These WAV files are generated sounds created for this MiniPixels example and released as CC0. See `AUDIO-LICENSE.txt`.
