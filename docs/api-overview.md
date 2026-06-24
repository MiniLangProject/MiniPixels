# API Overview

## Game Loop

```ml
cfg = mp.createConfig("Title", 320, 180, 4)
mp.run(cfg, initialize, update, render, shutdown)
```

Callbacks:

- `initialize(game)`
- `update(game, dt)`
- `render(game, canvas)`
- `shutdown(game)`

The game loop runs on the main thread. Input is sampled only when the game window has focus. The window title includes the current FPS.

## Renderer

MiniPixels renders into a fixed-size RGBA canvas and then presents that framebuffer to the native window. On Windows the default renderer mode is `auto`: MiniPixels first tries the OpenGL/WGL presenter and falls back to the GDI presenter if GPU initialization is not available.

```ml
cfg = mp.createConfig("Title", 320, 180, 4)
mp.useGpuRenderer(cfg)      # force OpenGL/WGL presentation when available
# mp.useCpuRenderer(cfg)    # force the classic GDI presentation path
mp.useIntegerScale(cfg)     # pixel-perfect integer scaling with letterboxing
mp.setSmoothing(cfg, false) # nearest-neighbor pixels by default
```

You can also set `cfg.renderer` manually to `"auto"`, `"opengl"`, `"gpu"`, `"gdi"`, or `"cpu"`. The OpenGL path uploads the CPU canvas as a texture each frame and uses the GPU for scaling and swapping the window framebuffer. Canvas drawing, collisions, animation state, and frame hashes stay CPU-side and deterministic.

Presentation scale modes:

- `"stretch"` fills the whole client area, even when the aspect ratio changes.
- `"fit"` preserves the logical canvas aspect ratio and letterboxes the remaining area.
- `"integer"` preserves aspect ratio and scales by whole pixels for the sharpest pixel-art output.

Renderer diagnostics:

```ml
name = mp.activeRenderer(game)
gpu = mp.isGpuRenderer(game)
reason = mp.rendererFallbackReason(game)
```

For quick local checks, `tests/window_renderer_smoke.ml` opens a tiny window and prints the active backend. For rough presentation timing, build and run `benchmarks/renderer_bench.ml`.

OpenGL presentation may be capped by the graphics driver or display swap interval, so benchmark output around 60 FPS can mean the swap path is synchronized rather than slow.

## Canvas

```ml
canvas.clear(mp.rgb(20, 20, 30))
canvas.setPixel(10, 10, mp.rgb(255, 0, 0))
canvas.fillRect(20, 20, 32, 16, mp.rgba(255, 128, 0, 200))
canvas.drawSprite(sprite, x, y)
mp.drawSpriteWorld(canvas, camera, sprite, worldX, worldY)
```

Coordinates are snapped to integer pixels. Out-of-bounds pixel writes are ignored safely.
`drawSpriteEx` supports clipping, horizontal/vertical flips, integer scale, tint, and alpha blending. World helpers subtract a camera position without mutating canvas state.

## Colors

Colors use packed straight-alpha RGBA8888:

```ml
red = mp.rgb(255, 0, 0)
semi = mp.rgba(255, 255, 255, 128)
```

Canvas memory stores bytes as `R, G, B, A`. The OpenGL presenter uploads that layout directly; the GDI presenter converts it to BGRA for DIB presentation.

## Assets

The CLI reads image assets at build time and generates MiniLang code:

```ml
import generated.assets as gen

function initialize(game)
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function
```

Supported embedded PNGs are 8-bit RGB/RGBA. Assets with `type: "audio"` or `type: "file"` are copied next to the executable instead of being embedded as image code.

```json
{
  "id": "player",
  "type": "image",
  "path": "assets/sprites/player_sheet.png",
  "sheet": {
    "frameWidth": 28,
    "frameHeight": 32,
    "spacing": 0,
    "margin": 0
  }
}
```

For sheet metadata the generated module exposes helpers such as:

```ml
sheet = gen.sheet_player()
```

Each build also writes `asset-report.json` next to the executable with embedded/runtime asset sizes and sheet metadata.

## Level Data

Project manifests can point at MiniPixels level JSON or Tiled JSON/TMJ:

```json
{
  "levels": {
    "path": "assets/levels/levels.json"
  }
}
```

The build generates `generated.levels`:

```ml
import generated.levels as lvl

w = lvl.width(levelIndex)
h = lvl.height(levelIndex)
data = lvl.tileData(levelIndex)
enemyCount = lvl.enemyCount(levelIndex)
coinCount = lvl.coinCount(levelIndex)
```

This keeps example game code small while still producing plain MiniLang for the runtime. The full manifest and Tiled conventions are documented in `docs/manifest-reference.md`.

## Text

MiniPixels includes a small 5x7 bitmap font for menus, HUDs, and debug labels:

```ml
mp.drawText(canvas, "COINS 03", 8, 8, 1, mp.rgb(255, 255, 255))
mp.drawTextCentered(canvas, "SKYLINE RUN", 44, 3, mp.rgb(78, 205, 196))
width = mp.textWidth("READY", 2)
```

## Input

The `game.input` state exposes booleans like `left`, `right`, `jump`, and `escape`. The facade also has edge helpers:

```ml
if mp.inputPressed(game.input, "jump") then
  mp.playSound("assets\\audio\\jump.wav")
end if
if mp.inputReleased(game.input, "fire") then
  mp.stopSound()
end if
```

Input is sampled only when the game window has focus.

## Animation

```ml
sheet = mp.spriteSheet(playerSprite.image, 32, 32, 0, 0)
run = mp.animationFromSheet(sheet, 2, 4, 0.08)
run.setPingPong(false)
run.play()
run.update(dt)
canvas.drawSprite(run.currentSprite(), x, y)
```

Animations support `play`, `pause`, `stop`, `reset`, looping, ping-pong playback, per-frame durations, and speed scaling.

## Audio

The first audio layer uses the WinMM backend on Windows:

```ml
mp.playSound("assets\\audio\\coin.wav")
mp.playSoundSync("assets\\audio\\intro.wav")
mp.playSoundLoop("assets\\audio\\theme.wav")
mp.playMusic("assets\\audio\\theme.wav")
mp.stopSound()
```

Games also get `game.audio`, a small state layer for SFX/music volume and mute handling:

```ml
game.audio.setMasterVolume(90)
game.audio.setSfxVolume(75)
coin = mp.audioClip("assets\\audio\\coin.wav", "coin")
mp.playAudio(game.audio, coin)
mp.playMusicWithState(game.audio, "assets\\audio\\theme.wav")
game.audio.mute()
```

For game code that wants a mixer-shaped API, use `AudioMixer`:

```ml
mixer = mp.audioMixer(4)
jump = mp.audioClip("assets\\audio\\jump.wav", "jump")
theme = mp.musicClip("assets\\audio\\theme.wav", "theme")
mixer.playSfx(jump)
mixer.playMusic(theme)
mixer.stopAll()
```

The current backend is still WinMM, so this is a stable high-level API rather than a true multi-voice software mixer. `mp.audioBackend()`, `mp.audioSupportsMultipleSfx()`, and `mp.audioSupportsVolumeControl()` make backend capability limits explicit.

## Releases

```powershell
python tools\package_sdk.py
```

This writes `dist/MiniPixels-<version>-sdk.zip` and a `.sha256` file. GitHub Actions uploads the SDK bundle as a workflow artifact and publishes it as a release asset when a `v*` tag is pushed.

## Tilemaps

```ml
sheet = mp.spriteSheet(tileSprite.image, 16, 16, 0, 0)
map = mp.tilemap(16, 16, 80, 20, mp.tileset(sheet), 2)
map.addLayer(mp.tileLayer("world", 80, 20, data, true, false, 1, 1))
map.addLayer(mp.tileLayer("collision", 80, 20, data, false, true, 1, 1))
```

Collision:

```ml
rect = mp.recti(player.x, player.y, 12, 15)
res = mp.tileMoveAndCollide(map, rect, vx, vy)
```

The collider resolves X and Y separately and clamps bodies to world bounds.
