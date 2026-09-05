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

The game loop uses a high-resolution monotonic clock, fixed simulation updates, a clamped catch-up budget, and a separate render cadence. `game.time.alpha` exposes interpolation progress; FPS and UPS are smoothed over half-second samples. Input is sampled only when the game window has focus and simulation pauses on focus loss by default.

## Renderer

MiniPixels renders into a fixed-size RGBA canvas and then presents that framebuffer to the native window. On Windows the default renderer mode is `auto`: MiniPixels first tries the OpenGL/WGL presenter and falls back to GDI if GPU initialization is not available. Linux uses the X11/XImage presenter and reports a fallback reason when OpenGL is requested.

```ml
cfg = mp.createConfig("Title", 320, 180, 4)
mp.useGpuRenderer(cfg)      # force OpenGL/WGL presentation when available
# mp.useCpuRenderer(cfg)    # force the classic GDI presentation path
mp.useIntegerScale(cfg)     # pixel-perfect integer scaling with letterboxing
mp.setSmoothing(cfg, false) # nearest-neighbor pixels by default
mp.setMaxFps(cfg, 120)      # use 0 for uncapped rendering
```

You can also set `cfg.renderer` manually to `"auto"`, `"opengl"`, `"gpu"`, `"gdi"`, or `"cpu"`. The OpenGL path uploads the canvas's dirty rectangle and uses the GPU for scaling and swapping the window framebuffer. Canvas drawing, collisions, animation state, and frame hashes stay CPU-side and deterministic.

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
canvas.drawSpriteRotated(sprite, x, y, radians, 1, mp.rgb(255, 255, 255))
mp.drawSpriteWorld(canvas, camera, sprite, worldX, worldY)
```

Coordinates are snapped to integer pixels. Out-of-bounds pixel writes are ignored safely.
`drawSpriteEx` supports clipping, horizontal/vertical flips, integer scale, tint, and alpha blending. `mp.renderTarget(...)` creates an off-screen canvas and `mp.drawRenderTarget(...)` composites it. `mp.saveCanvasPng(...)` writes deterministic visual captures. World helpers subtract a camera position without mutating canvas state.

## Colors

Colors use packed straight-alpha RGBA8888:

```ml
red = mp.rgb(255, 0, 0)
semi = mp.rgba(255, 255, 255, 128)
```

Canvas memory stores bytes as `R, G, B, A`. The OpenGL presenter uploads that layout directly; the GDI presenter converts it to BGRA for DIB presentation.

## Assets

Generated asset modules are plain MiniLang code:

```ml
import generated.assets as gen

function initialize(game)
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function
```

Both project generators write image, procedural, audio, and file assets into `build/assets.mpx` and emit lazy MiniLang loader functions. The runtime indexes pack entries with a hash map and caches payloads plus decoded images. Its non-interlaced PNG decoder supports stored/fixed/dynamic Deflate, all PNG scanline filters, and grayscale, RGB, indexed, grayscale-alpha, and RGBA color types. `mp.loadPng(path)` also hot-loads ordinary PNG files directly.

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

Each build also writes `asset-report.json` next to the executable with embedded/container/runtime asset sizes and sheet metadata.

Manual pack access is available when game code wants to load or explicitly evict a packed image:

```ml
pack = mp.openAssetPack("assets.mpx")
image = mp.loadPngFromPack(pack, "player")
sprite = mp.spriteFromImage(image, "player")
mp.unloadPackedAsset(pack, "player")
```

## Level Data

Project manifests can point at MiniPixels level JSON:

```json
{
  "levels": {
    "path": "assets/levels/levels.json"
  }
}
```

Both CLIs can generate `generated.levels` for MiniPixels `levels.json` and finite CSV-encoded Tiled JSON/TMJ maps:

```ml
import generated.levels as lvl

w = lvl.width(levelIndex)
h = lvl.height(levelIndex)
data = lvl.tileData(levelIndex)
enemyCount = lvl.enemyCount(levelIndex)
coinCount = lvl.coinCount(levelIndex)
```

Tiled collision layers are converted into horizontal solid runs; spawn, exit, coin, and enemy objects become ordinary generated accessors. The full manifest and Tiled conventions are documented in `docs/manifest-reference.md`.

## Text

MiniPixels includes a small 5x7 bitmap font for menus, HUDs, and debug labels:

```ml
mp.drawText(canvas, "COINS 03", 8, 8, 1, mp.rgb(255, 255, 255))
mp.drawTextCentered(canvas, "SKYLINE RUN", 44, 3, mp.rgb(78, 205, 196))
width = mp.textWidth("READY", 2)
```

## Input

The `game.input` state preserves compatibility booleans like `left`, `right`, `jump`, and `escape`, while its action table is growable and configurable. Edges are buffered until a fixed update, so a short key press cannot disappear between render and simulation frames:

```ml
if mp.inputPressed(game.input, "jump") then
  mp.playSound("assets\\audio\\jump.wav")
end if
if mp.inputReleased(game.input, "fire") then
  mp.stopSound()
end if
mp.bindKeys(game.input, "dash", 0x10, 0x43) # Shift or C
```

Logical `mouseX`/`mouseY`, `mouseDeltaX`/`mouseDeltaY`, `mouseWheel`, `mouseInside`, and mouse-button actions are updated from the active viewport. Input is released when the window loses focus.

## Scenes

Scenes can be registered, changed, or stacked for overlays and pause menus. Lifecycle hooks receive `(game, scene)`; update and render additionally receive `dt` or `canvas`.

```ml
menu = mp.scene("menu", void, onEnter, onExit, updateMenu, renderMenu)
pause = mp.scene("pause", void, void, void, updatePause, renderPause, void, void, true)
mp.registerScene(game, menu)
mp.registerScene(game, pause)
mp.changeScene(game, "menu")
mp.pushScene(game, "pause")
```

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

Legacy one-shot helpers remain available through `PlaySoundW`:

```ml
mp.playSound("assets\\audio\\coin.wav")
mp.playSoundSync("assets\\audio\\intro.wav")
mp.playSoundLoop("assets\\audio\\theme.wav")
mp.playMusic("assets\\audio\\theme.wav")
mp.stopSound()
```

Games get a lazily opened PCM mixer (waveOut on Windows, ALSA on Linux) with independent SFX voices and a dedicated music voice:

```ml
game.audio.setMasterVolume(90)
game.audio.setSfxVolume(75)
coin = mp.audioClip("assets\\audio\\coin.wav", "coin")
mp.playAudio(game.audio, coin)
game.audio.playMusic(mp.musicClip("assets\\audio\\theme.wav", "theme"))
game.audio.mute()
```

Generated packed-audio helpers return memory-backed clips, so WAV files can stay inside `assets.mpx`:

```ml
coin = gen.audio_coin_sfx()
mp.playAudio(game.audio, coin)
```

Standalone mixers are also available:

```ml
mixer = mp.audioMixer(4)
jump = mp.audioClip("assets\\audio\\jump.wav", "jump")
theme = mp.musicClip("assets\\audio\\theme.wav", "theme")
mixer.playSfx(jump)
mixer.playMusic(theme)
mixer.setChannel(0, 75, -30)
mixer.stopAll()
```

PCM WAV input supports mono/stereo 8/16/24/32-bit samples, nearest-rate conversion to 44.1 kHz stereo, looping memory-backed music, master/bus/clip/channel volume, and pan. `mp.audioBackend()` reports `waveout-pcm`; capability helpers report multi-SFX and volume support.

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

The collider resolves X and Y separately, checks every crossed row/column to prevent tunneling, and clamps bodies to world bounds. `mp.lineRect(...)` uses exact segment clipping rather than a broad-phase approximation.
