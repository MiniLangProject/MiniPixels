# Jump and Run Assets

Graphics:

- World/tiles/background/decor source: GandalfHardcore FREE Platformer Assets
- URL: https://gandalfhardcore.itch.io/free-pixel-art-sidescroller-asset-pack-32x32-overworld
- License: see `LICENSE-GANDALFHARDCORE.txt`
- Player source: OpenGameArt A platformer in the forest
- URL: https://opengameart.org/content/a-platformer-in-the-forest
- License: Creative Commons Zero, CC0. See `LICENSE-OGA-BUCH-FOREST-PLATFORMER.txt`
- Enemy source: OpenGameArt Bat (32x32)
- URL: https://opengameart.org/content/bat-32x32
- License: Creative Commons Zero, CC0. See `LICENSE-OGA-BAT-32X32.txt`
- Enemy source: Kenney Pixel Platformer
- URL: https://kenney.nl/assets/pixel-platformer
- License: Creative Commons Zero, CC0. See `LICENSE-KENNEY-PIXEL-PLATFORMER.txt`

The checked-in PNGs are compact runtime sprite sheets and level background layers assembled or adapted for this example. `bg_base_0.png` through `bg_base_2.png` are the per-level sky/mountain/forest composites, `bg_near_0.png` through `bg_near_2.png` are the nearer parallax forest layers, and `decor_sheet.png` contains the matching scenery sprites that survived visual cleanup. The Python build stores these files in `assets.mpx`; MiniLang runtime code opens the pack and decodes the packed PNG payloads. The original ZIP is not redistributed with the repository.

Audio:

- `audio/jump.wav`
- `audio/coin.wav`
- `audio/hurt.wav`
- `audio/win.wav`

These WAV files are generated sounds created for this MiniPixels example and released as CC0. See `AUDIO-LICENSE.txt`.
