# MiniPixels

MiniPixels is a pixel-oriented 2D game engine prototype for MiniLang. It uses the existing `MiniLangCompilerPy` compiler and builds native Windows x64 executables.

The first version focuses on a small but working vertical slice: a Win32 window, fixed logical framebuffer, nearest-neighbor scaling, keyboard input, sprites, build-time PNG assets, tilemaps, camera scrolling, simple collision, headless tests, and example projects.

![Moving Sprite](docs/images/moving-sprite.png)

## Requirements

- Windows
- A checkout of `MiniLangCompilerPy` next to this repository, or a path passed with `--compiler`
- Python 3 for the MiniPixels CLI

Expected sibling layout during local development:

```text
MiniLangCompilerPy/
MiniPixels/
```

## Quickstart

Build and run the Moving Sprite example:

```powershell
cd MiniPixels
python tools\minipixels.py run examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Build without running:

```powershell
python tools\minipixels.py build examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Run tests:

```powershell
python tests\run_tests.py
```

## Minimal Game

```ml
import minipixels as mp

x = 40
y = 40

function update(game, dt)
  global x, y
  if game.input.left then x = x - (90 * dt) end if
  if game.input.right then x = x + (90 * dt) end if
  if game.input.up then y = y - (90 * dt) end if
  if game.input.down then y = y + (90 * dt) end if
end function

function render(game, canvas)
  canvas.clear(mp.rgb(20, 20, 30))
  canvas.fillRect(x, y, 16, 16, mp.rgb(255, 128, 0))
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Game", 320, 180, 4)
  return mp.run(cfg, void, update, render, void)
end function
```

## Project Layout

```text
game/
  minipixels.json
  src/
    main.ml
  assets/
    player.png
```

Example project file:

```json
{
  "name": "moving-sprite",
  "main": "src/main.ml",
  "window": {
    "title": "MiniPixels Moving Sprite",
    "width": 320,
    "height": 180,
    "scale": 4
  },
  "assets": [
    {
      "id": "player",
      "type": "image",
      "path": "assets/player.png"
    }
  ]
}
```

## Examples

### Moving Sprite

![Moving Sprite](docs/images/moving-sprite.png)

```powershell
python tools\minipixels.py run examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates a PNG sprite, keyboard movement, pixel snapping, FPS in the window title, and framebuffer scaling.

### Scrolling World

![Scrolling World](docs/images/scrolling-world.png)

```powershell
python tools\minipixels.py run examples\scrolling-world\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates tilemaps, camera scrolling, simple platform collision, world-edge clamping, parallax bands, and jump movement.

### Jump and Run

![Jump and Run](docs/images/jump-and-run.png)

```powershell
python tools\minipixels.py run examples\jump-and-run\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates a complete small platform game with a main menu, three levels, coins, enemies, stomp combat, exit gates, scrolling camera, sounds, animation, and free CC0/open assets.

### Pixel Effects

![Pixel Effects](docs/images/pixel-effects.png)

```powershell
python tools\minipixels.py run examples\pixel-effects\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates direct per-pixel framebuffer manipulation from MiniLang.

## CLI

```powershell
python tools\minipixels.py new MyGame
python tools\minipixels.py validate examples\moving-sprite\minipixels.json
python tools\minipixels.py generate examples\moving-sprite\minipixels.json
python tools\minipixels.py pack examples\moving-sprite\minipixels.json
python tools\minipixels.py build examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
python tools\minipixels.py run examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

The CLI validates project JSON, reads 8-bit RGB/RGBA PNG files at build time, generates deterministic MiniLang asset modules, optionally packs assets into `.mpak`, and invokes the regular MiniLang compiler.

## Engine Modules

- `minipixels`: public facade and game loop
- `minipixels.graphics.canvas`: framebuffer, primitives, sprite drawing
- `minipixels.graphics.sprite`: images, sprites, sprite sheets
- `minipixels.platform.windows`: Win32 window, input, DIB renderer
- `minipixels.input.input`: keyboard snapshot and action helpers
- `minipixels.world.camera`: pixel-snapped 2D camera
- `minipixels.world.tilemap`: tile rendering and AABB tile collisions
- `minipixels.animation.animation`: frame-duration sprite animations
- `minipixels.assets.assets`: generated asset registry
- `minipixels.debug.debug`: counters and framebuffer hash helpers

## Current Status

Implemented:

- Native Win32 window
- Fixed logical resolution and resize stretch
- CPU RGBA8888 framebuffer
- Nearest-neighbor DIB presentation
- Keyboard input only while the game window has focus
- FPS in the window title
- Safe pixel operations and primitive drawing
- PNG-to-MiniLang build-time asset generation
- Sprites, sprite sheets, animation
- Camera, scrolling, parallax bands
- Tilemap culling and simple collision
- Headless tests

Not yet implemented:

- GPU renderer
- Runtime PNG hot-loading
- Audio mixer beyond the minimal WinMM hook
- Full editor tooling
- Advanced physics or ECS

More detail is in [docs/getting-started.md](docs/getting-started.md), [docs/examples.md](docs/examples.md), and [docs/minipixels-architecture.md](docs/minipixels-architecture.md).
