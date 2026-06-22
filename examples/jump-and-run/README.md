# MiniPixels Skyline Run

`jump-and-run` is a complete MiniPixels example game. It has a main menu, three scrolling platform levels, coins, enemies, stomp combat, exits, win/retry states, simple sounds, and animated sprites.

Run it from the MiniPixels repository root:

```powershell
python tools\minipixels.py run examples\jump-and-run\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Build only:

```powershell
python tools\minipixels.py build examples\jump-and-run\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Controls:

- Left/Right or A/D: move
- Up/W or Space: jump, start, restart

Asset notes:

- World, background, tile, portal, cloud, grass, and campfire graphics are adapted from GandalfHardcore FREE Platformer Assets: https://gandalfhardcore.itch.io/free-pixel-art-sidescroller-asset-pack-32x32-overworld
- The player, enemy, and coin sheets are compact runtime sprites made for this example to match the 32x32 pack.
- `assets/LICENSE-GANDALFHARDCORE.txt` summarizes the source license terms from the downloaded pack.
- `assets/audio/*.wav` are generated sounds made for this example and released as CC0 in `assets/AUDIO-LICENSE.txt`.

The example intentionally uses compact sprite sheets. MiniPixels currently converts PNGs into generated MiniLang source at build time, so small sheets compile much faster than large background images.
