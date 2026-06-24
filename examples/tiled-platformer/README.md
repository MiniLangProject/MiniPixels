# MiniPixels Tiled Platformer

This example demonstrates the build-time Tiled JSON/TMJ importer.

Files:

- `assets/maps/demo.tmj`: a compact Tiled JSON map.
- `minipixels.json`: points `levels.path` at the Tiled map.
- `src/main.ml`: imports `generated.levels` and builds a tilemap from it.

Run:

```powershell
python tools\minipixels.py run examples\tiled-platformer\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Tiled conventions used here:

- Tile layer named `collision`
- Object types `spawn`, `exit`, and `coin`
- Non-zero tile IDs become solid platform runs
