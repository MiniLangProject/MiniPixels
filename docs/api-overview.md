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

MiniPixels renders into an RGBA canvas and then presents that framebuffer to the native window. The framebuffer can stay fixed, track native client pixels, or use a configurable fraction/multiple of the client size. On Windows the default renderer mode is `auto`: MiniPixels first tries the OpenGL/WGL presenter and falls back to GDI if GPU initialization is not available. Linux uses the X11/XImage presenter and reports a fallback reason when OpenGL is requested.

```ml
cfg = mp.createConfig("Title", 320, 180, 4)
mp.useGpuRenderer(cfg)      # force OpenGL/WGL presentation when available
# mp.useCpuRenderer(cfg)    # force the classic GDI presentation path
mp.useIntegerScale(cfg)     # pixel-perfect integer scaling with letterboxing
mp.setSmoothing(cfg, false) # nearest-neighbor pixels by default
mp.setMaxFps(cfg, 120)      # use 0 for uncapped rendering
```

Framebuffer resolution policies:

```ml
mp.useFixedRenderResolution(cfg, 640, 360) # independent of window size (default)
mp.useNativeRenderResolution(cfg)          # follows current client pixels
mp.useScaledRenderResolution(cfg, 0.75)    # follows 75% of each client dimension
mp.setMaxRenderPixels(cfg, 2073600)        # retain aspect ratio and cap at 1080p pixels
mp.setDesignResolution(cfg, 320, 180)      # optional game-coordinate reference
```

Native and scaled policies resize the existing `game.canvas` object before `initialize` and after window resize events. Pixel contents are discarded on a size change. Game code can inspect `game.renderWidth`, `game.renderHeight`, and `game.resolutionChanged`. `game.renderScaleX/Y` describe the ratio from the optional design size to render pixels, with `designToRenderX/Y` and `renderToDesignX/Y` helpers. Rendering APIs remain explicitly pixel-based rather than silently transforming coordinates.

You can also set `cfg.renderer` manually to `"auto"`, `"opengl"`, `"gpu"`, `"gdi"`, or `"cpu"`. The OpenGL path uploads the canvas's dirty rectangle and uses the GPU for scaling and swapping the window framebuffer. It reallocates its backing texture only when the framebuffer crosses a power-of-two boundary. Both platforms skip unchanged presentation until the window requests repainting; the Linux XImage path additionally converts and uploads only dirty regions at native 1:1 size. Canvas drawing, collisions, animation state, and frame hashes stay CPU-side and deterministic.

Windows also offers the separate experimental `minipixels.graphics.gpu` scene canvas. It batches sprites and primitives directly into an OpenGL framebuffer and supports explicit resize, readback, mutable-texture invalidation, and optional point lights. Build `native/build-gpu.ps1` into the executable directory, open an `opengl` window, and use the explicit frame lifecycle:

```ml
import minipixels.graphics.gpu as gpu
import minipixels.platform.windows as win

scene = gpu.create(window, 640, 360, true)
if typeof(scene) != "void" then
  gpu.begin(window)
  scene.clear(0x101820ff)
  scene.drawSprite(player, x, y)
  gpu.finish(window)
  win.present(window, scene)
end if
```

Call `gpu.shutdown()` before closing the window. This experimental API is not a drop-in replacement for the stable CPU `Canvas`: GPU-to-GPU canvas sources, rotated sprites, automatic `mp.run` integration, and Linux GPU rendering are not implemented yet.

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

For quick local checks, `tests/window_renderer_smoke.ml` opens a tiny window and prints the active backend. `tests/gpu_scene_smoke.ml` exercises GPU drawing, resizing, readback, presentation, and the Linux fallback. For rough presentation timing, build and run `benchmarks/renderer_bench.ml`.

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

Canvas memory stores bytes as `R, G, B, A`. OpenGL uploads that layout directly; GDI describes it with explicit DIB channel masks and avoids a frame-by-frame conversion.

## Assets

Generated asset modules are plain MiniLang code:

```ml
import generated.assets as gen

function initialize(game)
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function
```

Project generation writes image, procedural, audio, file, text, and JSON data assets into `build/assets.mpx` and emits lazy MiniLang loader functions. Constants become generated MiniLang code rather than runtime pack entries. Opening reads only the pack index; payload ranges are fetched on first use. Generated accessors use pre-resolved numeric slots, cache decoded images/text/data, and release source bytes when the decoded object no longer needs them. `gen.preload()` optionally warms all generated assets during a loading screen. The non-interlaced PNG decoder supports stored/fixed/dynamic Deflate, all PNG scanline filters, and grayscale, RGB, indexed, grayscale-alpha, and RGBA color types. `mp.loadPng(path)` also hot-loads ordinary PNG files directly.

The Python driver writes protected assets as random-access MPX3. It signs an encrypted index and stores every payload as an independent AES-256-GCM block, so startup does not read or decrypt the whole pack. `python tools/minipixels.py security init <manifest>` creates the build-only P-256 signing key and enables protection. Generated game code reconstructs the obfuscated AES key and performs verification/decryption transparently. Legacy MPX2 packs are still accepted by the runtime.

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

Localized text assets generate one helper per locale and a ready-to-use service:

```ml
texts = gen.localization_ui()
texts.setLocale("de-DE")
caption = texts.get("menu.play")
score = texts.format("hud.score", [42])
```

Locale lookup falls back from a regional locale such as `de-DE` to `de`, then to the asset's configured default locale. Missing keys return the key itself. `data` helpers return canonical JSON text; `constants` modules expose flattened scalar constants and a `data()` accessor for the complete nested value.

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

Games get a lazily opened PCM mixer (waveOut on Windows, ALSA on Linux) with independent SFX voices and a dedicated music voice. WAV and MP3 can both be mono or stereo:

```ml
game.audio.setMasterVolume(90)
game.audio.setSfxVolume(75)
coin = mp.audioClip("assets\\audio\\coin.mp3", "coin")
mp.playAudio(game.audio, coin)
game.audio.playMusic(mp.musicClip("assets\\audio\\theme.mp3", "theme"))
game.audio.mute()
```

Generated packed-audio helpers retain the original compressed bytes, so WAV and MP3 files can stay inside `assets.mpx`:

```ml
coin = gen.audio_coin_sfx()
mp.playAudio(game.audio, coin)
```

Standalone mixers are also available:

```ml
mixer = mp.audioMixer(4)
jump = mp.audioClip("assets\\audio\\jump.wav", "jump")
theme = mp.musicClip("assets\\audio\\theme.mp3", "theme")
mixer.playSfx(jump)
mixer.playMusic(theme)
mixer.setChannel(0, 75, -30)
mixer.stopAll()
```

PCM WAV input supports mono/stereo 8/16/24/32-bit samples. MP3 input is decoded lazily to signed 16-bit PCM for sound effects and incrementally for the dedicated music voice, so packed music remains compressed in memory. Both formats preserve independent left/right channels and use nearest-rate conversion to 44.1 kHz stereo, looping, master/bus/clip/channel volume, and pan. `mp.audioSupportsMp3()` and `mp.audioSupportsStereo()` expose the new capabilities. The legacy `playSound*` helpers remain WAV-only.

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
