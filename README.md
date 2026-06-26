# MiniPixels

Current version: `0.7.0`

MiniPixels is a pixel-oriented 2D game engine prototype for MiniLang. It uses the existing `MiniLangCompilerPy` compiler and builds native Windows x64 executables.

MiniPixels focuses on a small but working 2D engine slice: a Win32 window, fixed logical framebuffer, optional OpenGL/WGL presentation, nearest-neighbor scaling, focus-aware keyboard input, sprites, MiniPixels asset packs with runtime PNG decoding, runtime file assets, tilemaps, camera scrolling, simple collision, bitmap text, basic audio, headless tests, and example projects.

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

Build the native MiniLang CLI:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py tools\minipixels_cli.ml build\tools\minipixels.exe -I src -I ..\MiniLangCompilerPy
build\tools\minipixels.exe info
build\tools\minipixels.exe validate examples\moving-sprite\minipixels.json
build\tools\minipixels.exe info examples\moving-sprite\minipixels.json
build\tools\minipixels.exe generate examples\pixel-effects\minipixels.json
build\tools\minipixels.exe generate examples\jump-and-run\minipixels.json examples\jump-and-run\build\generated\generated
build\tools\minipixels.exe new my-game platformer
```

The native CLI currently provides `info`, `doctor`, `validate`, `generate`, and `new`. Native `generate` writes importable `generated.assets` and `generated.levels` modules, supports `procedural` sprites, emits sheet helpers, and imports MiniPixels `levels.json`. The full image asset pack pipeline, Tiled/TMJ import, runtime asset copying, `build`, `run`, and `package` still live in the Python tool while those pieces are moved into MiniLang.

Tooling split:

| Task | Native MiniLang CLI | Python CLI |
| --- | --- | --- |
| Create a project | `new` | `new` |
| Inspect/validate manifests | `info`, `doctor`, `validate` | `info`, `doctor`, `validate` |
| Generate `generated.assets` | `procedural` sprites and placeholder `image` sprites | procedural sprites plus image loaders backed by `assets.mpx` |
| Generate `generated.levels` | MiniPixels `levels.json` | MiniPixels `levels.json` and Tiled JSON/TMJ |
| Create/copy runtime assets | Not yet | `assets.mpx` for images/audio/files |
| Build/run/package | Not yet | `build`, `run`, `package`, `pack` |

Run tests:

```powershell
python tests\run_tests.py
```

Optional window renderer smoke test:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py tests\window_renderer_smoke.ml build\tests\window_renderer_smoke.exe -I src -I ..\MiniLangCompilerPy
build\tests\window_renderer_smoke.exe
```

Optional renderer benchmark:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py benchmarks\renderer_bench.ml build\benchmarks\renderer_bench.exe -I src -I ..\MiniLangCompilerPy
build\benchmarks\renderer_bench.exe
```

Build all examples:

```powershell
python tools\build_examples.py
```

Create the SDK bundle:

```powershell
python tools\package_sdk.py
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
  mp.useGpuRenderer(cfg)
  return mp.run(cfg, void, update, render, void)
end function
```

`createConfig` uses `renderer = "auto"` by default. On Windows that tries the OpenGL/WGL presenter first and falls back to the classic GDI presenter if GPU initialization is unavailable. Use `mp.useCpuRenderer(cfg)` when you want the old GDI path explicitly.

Presentation scaling can be selected per game:

```ml
mp.useStretchScale(cfg)  # fill the whole window
mp.useFitScale(cfg)      # keep aspect ratio
mp.useIntegerScale(cfg)  # pixel-perfect integer scaling
mp.setSmoothing(cfg, false)
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
      "path": "assets/player.png",
      "sheet": {
        "frameWidth": 32,
        "frameHeight": 32,
        "spacing": 0,
        "margin": 0
      }
    },
    {
      "id": "jumpSound",
      "type": "audio",
      "path": "assets/audio/jump.wav"
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

![Jump and Run Gameplay](docs/images/jump-and-run-gameplay.png)

![Jump and Run Levels](docs/images/jump-and-run-levels.png)

![Jump and Run Sprites](docs/images/jump-and-run-sprites.png)

```powershell
python tools\minipixels.py run examples\jump-and-run\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates a complete small platform game with a main menu, three levels, coins, enemies, stomp combat, exit gates, scrolling camera, sounds, animation, and compact runtime assets adapted from the GandalfHardcore 32x32 sidescroller pack.

### Pixel Effects

![Pixel Effects](docs/images/pixel-effects.png)

```powershell
python tools\minipixels.py run examples\pixel-effects\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates direct per-pixel framebuffer manipulation from MiniLang.

### Tiled Platformer

```powershell
python tools\minipixels.py run examples\tiled-platformer\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Demonstrates the Python build pipeline's Tiled JSON/TMJ importer with a solid tile layer and object-layer spawn, exit, coins, and enemy patrol data. The native MiniLang generator currently writes a level stub for Tiled maps until native Tiled import is added.

## CLI

```powershell
python tools\minipixels.py new MyGame
python tools\minipixels.py info examples\moving-sprite\minipixels.json
python tools\minipixels.py doctor examples\tiled-platformer\minipixels.json
python tools\minipixels.py validate examples\moving-sprite\minipixels.json
python tools\minipixels.py generate examples\moving-sprite\minipixels.json
python tools\minipixels.py pack examples\moving-sprite\minipixels.json
python tools\minipixels.py build examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
python tools\minipixels.py run examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
python tools\minipixels.py package
```

The Python CLI validates project JSON, reads 8-bit RGB/RGBA image assets at build time, writes a deterministic MiniPixels asset container (`assets.mpx`), generates deterministic MiniLang asset modules, emits SpriteSheet helper factories for assets with `sheet` metadata, includes runtime assets such as `type: "audio"` or `type: "file"` in the pack, generates `generated.levels` from MiniPixels or Tiled JSON when `levels.path` is present, writes `asset-report.json`, and invokes the regular MiniLang compiler. Image payloads inside `assets.mpx` are PNG-encoded in the MiniPixels runtime profile and decoded by MiniLang code through `mp.loadPngFromPack(...)`. Audio payloads can be loaded as bytes and played directly from memory through WinMM `SND_MEMORY` clips, so example builds no longer need loose WAV files next to the executable. The native MiniLang CLI can already validate manifests and generate importable modules for `procedural` sprites and MiniPixels `levels.json`.

## MPX Asset Pack Format

`assets.mpx` is MiniPixels' deterministic runtime asset container. It is intentionally simple: a fixed header, a compact entry table, and contiguous payload bytes.

All multi-byte integers are unsigned little-endian values.

```text
offset  size      field
0       4         magic bytes: "MPX1"
4       4         entry count: u32
8       variable  entry table
...     variable  payload bytes
```

Each entry table record is:

```text
size      field
2         asset id byte length: u16
N         asset id as UTF-8 bytes, no terminator
1         kind: u8
1         flags: u8, currently 0
4         payload offset from start of file: u32
4         payload size in bytes: u32
```

Current `kind` values:

| Kind | Asset type | Payload |
| --- | --- | --- |
| `1` | `image` | MiniPixels PNG-profile bytes |
| `2` | `audio` | Original audio file bytes, usually WAV |
| `3` | `file` | Original file bytes |

Image assets are transcoded by the Python CLI into the MiniPixels PNG profile before they are written to the pack. That profile is deliberately narrow so the MiniLang runtime decoder stays small: 8-bit RGBA, PNG filter type `0`, non-interlaced, and a zlib stream made of stored Deflate blocks. Audio and file assets are stored byte-for-byte.

Runtime APIs:

```ml
pack = mp.openAssetPack("assets.mpx")
img = mp.loadPngFromPack(pack, "player")
raw = mp.loadBytesFromPack(pack, "coin_sfx")
kind = mp.assetKindFromPack(pack, "coin_sfx")
```

## Mini Code Examples

Text:

```ml
mp.drawText(canvas, "LEVEL 1", 8, 8, 1, mp.rgb(255, 255, 255))
mp.drawTextCentered(canvas, "READY", 72, 2, mp.rgb(255, 220, 80))
```

Animation:

```ml
sheet = gen.sheet_player()
run = mp.animationFromSheet(sheet, 2, 4, 0.08)
run.play()
run.update(dt)
canvas.drawSprite(run.currentSprite(), x, y)
```

Camera-space drawing:

```ml
mp.drawSpriteWorld(canvas, camera, playerSprite, player.x, player.y)
mp.fillRectWorld(canvas, camera, coin.x, coin.y, 4, 4, mp.rgb(255, 220, 80))
```

Input and audio:

```ml
coin = mp.audioClip("assets\\audio\\coin.wav", "coin")
mixer = mp.audioMixer(4)
if mp.inputPressed(game.input, "jump") then
  mixer.playSfx(coin)
end if
mixer.setSfxVolume(80)
mixer.playMusic(mp.musicClip("assets\\audio\\theme.wav", "theme"))
mixer.stopAll()
```

Packed audio:

```ml
clip = gen.audio_coin_sfx()
mp.playAudio(game.audio, clip)
```

## Engine Modules

- `minipixels`: public facade and game loop
- `minipixels.graphics.canvas`: framebuffer, primitives, sprite drawing
- `minipixels.graphics.font`: 5x7 bitmap text helpers
- `minipixels.graphics.sprite`: images, sprites, sprite sheets
- `minipixels.assets.pack`: MiniPixels `.mpx` asset container reader
- `minipixels.assets.png`: MiniPixels PNG-profile decoder for packed RGBA images
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
- Nearest-neighbor GDI presentation and optional OpenGL/WGL presentation
- Keyboard input only while the game window has focus
- FPS in the window title
- Safe pixel operations and primitive drawing
- MiniPixels `.mpx` asset container generation in the Python pipeline
- Runtime PNG decoding in MiniLang for packed RGBA image assets
- Native MiniLang generation for procedural sprites and MiniPixels `levels.json`
- Runtime asset packing for image/audio/file assets
- Sprites, sprite sheets, animation
- Facade helpers for world drawing, text, input edges, animation-from-sheet, and audio state/loop/stop
- Build-time SpriteSheet metadata and `asset-report.json`
- Build-time level JSON generation through `generated.levels`
- Camera, scrolling, parallax bands
- Tilemap culling and simple collision
- Headless and framehash regression tests
- GitHub Actions CI for tests and example builds
- SDK ZIP packaging with SHA256 checksum and release upload on `v*` tags
- Version file, changelog, and first-game guide

Not yet implemented:

- General-purpose PNG hot-loading outside MiniPixels asset packs
- Native asset-pack generation and native Tiled/TMJ import
- Cross-platform audio mixer beyond the WinMM hook
- Full editor tooling
- Advanced physics or ECS

More detail is in [docs/getting-started.md](docs/getting-started.md), [docs/first-game.md](docs/first-game.md), [docs/manifest-reference.md](docs/manifest-reference.md), [docs/examples.md](docs/examples.md), and [docs/minipixels-architecture.md](docs/minipixels-architecture.md). Release notes are in [CHANGELOG.md](CHANGELOG.md).
