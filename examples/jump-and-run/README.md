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

- Character, enemy, coin, exit, and ground graphics are derived from Kenney Pixel Platformer, CC0: https://kenney.nl/assets/pixel-platformer
- `assets/LICENSE-KENNEY-PIXEL-PLATFORMER.txt` contains the original Kenney license text.
- `assets/audio/*.wav` are generated tones made for this example and released as CC0 in `assets/AUDIO-LICENSE.txt`.

The example intentionally uses compact sprite sheets. MiniPixels currently converts PNGs into generated MiniLang source at build time, so small sheets compile much faster than large background images.
