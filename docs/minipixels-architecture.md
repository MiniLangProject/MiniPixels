# MiniPixels Architecture

## Repository findings

MiniLang is a small dynamically typed language compiled by `MiniLangCompilerPy/mlc_win64.py` into native Windows x64 PE or Linux x64 ELF executables. The compiler supports multi-file `package`/`import`, target conditionals, structs, first-class functions, arrays, mutable `bytes`, value-or-error handling, native `extern function` imports, and `nativeCallback(fn, "wndproc")` for WNDPROC callbacks.

The standard library already provides portable file I/O, time, byte utilities, arrays, math helpers, random helpers, and assertions. MiniPixels packs ABI structures and out-parameters into `bytes` buffers and passes them through `nativeBytesPtr(...)` where required.

## Implemented engine slice

MiniPixels is a working engine prototype, not the full future engine. It contains:

- CPU RGBA framebuffer with safe pixel access, clear, primitive drawing, blitting, sprites, sprite sheets, and animation.
- Headless game loop for deterministic tests.
- Win32 window backend using `RegisterClassExW`, a MiniLang WNDPROC callback, `PeekMessageW`, `GetAsyncKeyState`, `StretchDIBits`, and optional OpenGL/WGL presentation with dirty-region uploads.
- Linux X11 backend using event polling, focus-safe keyboard/mouse input, resizable XImage presentation, and portable monotonic timing.
- Buffered, configurable keyboard and logical-pointer actions that are consumed by fixed updates.
- Camera, parallax helpers, cached tilemap rendering with viewport culling, swept AABB/tile collisions, bitmap-font text, scene stacking, and a waveOut/ALSA-backed multi-voice PCM mixer.
- Python CLI `tools/minipixels.py` for `new`, `validate`, `generate`, `pack`, `build`, `run`, and `package`, delegating compilation to `MiniLangCompilerPy`.
- Native MiniLang CLI `tools/minipixels_cli.ml` for `info`, `doctor`, `validate`, `generate`, and `new`.
- Example projects covering sprites, scrolling worlds, pixel effects, Tiled import, and a jump-and-run game.

## Module plan

- `minipixels`: user-facing facade with config, game state, `run`, `runHeadless`, and convenience functions.
- `minipixels.core.time`: frame/update counters and fixed-step timing state.
- `minipixels.math.types`: vectors, rectangles, transforms, color packing, RNG, timers.
- `minipixels.graphics.canvas`: framebuffer, clipping, primitives, sprite blits, render targets.
- `minipixels.graphics.sprite`: images, generated MPPM asset format, sprites, sprite sheets.
- `minipixels.animation.animation`: frame-duration animation player.
- `minipixels.input.input`: keyboard snapshots, action mapping.
- `minipixels.platform.windows`: Win32 window/event/present backend.
- `minipixels.platform.linux`: X11 window/event/present backend.
- `minipixels.world.camera`, `tilemap`, `entity`: camera, parallax, tilemaps, entities.
- `minipixels.collision.collision`: primitive collisions and simple tile collision.
- `minipixels.assets.assets`: generated/static asset registry.
- `minipixels.assets.pack`: deterministic `.mpx` container reader.
- `minipixels.assets.png`: general non-interlaced PNG decoder plus deterministic encoder.
- `minipixels.audio.audio`: legacy Windows PlaySoundW helpers and a buffered waveOut/ALSA PCM mixer.
- `minipixels.debug.debug`: counters, overlays, and framebuffer hash.
- `minipixels.scene.scene`: synchronous scene stack.

## Rendering strategy

The public framebuffer format is straight-alpha RGBA8888 with packed colors as `0xRRGGBBAA`. `Canvas.pixels` stores bytes in `R,G,B,A` order. GDI uses explicit DIB color masks, avoiding a frame-by-frame channel conversion. The OpenGL/WGL presenter updates only the tracked dirty rectangle of the logical RGBA texture and lets the GPU scale it to the client area. Linux converts and scales into a retained native XImage. Scale modes support stretch, aspect-fit, and integer pixel-perfect presentation.

## Game-loop strategy

The headless path runs deterministic fixed updates and renders exactly the requested frame count. Windowed paths use a monotonic high-resolution clock, poll native events, buffer input edges, clamp the frame duration, process a bounded fixed-step accumulator, publish interpolation alpha, render once per frame, and apply an optional frame limit. Callback errors still pass through scene/audio/window cleanup. Escape requests shutdown.

## Asset strategy

Both generators validate `minipixels.json`, write a deterministic `assets.mpx` byte stream, generate lazy MiniLang asset modules, import MiniPixels or Tiled level data, and include referenced audio/file assets in the same container. Runtime game code does not need a JSON parser in release builds. Generated audio factories load WAV bytes from the same pack and create memory-backed mixer clips. The Python build driver also emits reports and compiler project manifests so unchanged builds use the compiler's exact-hit artifact cache.

The `.mpx` file starts with `MPX1`, followed by a little-endian entry table and contiguous payload bytes. Pack entries and decoded images are hash-indexed and cached. The PNG runtime handles stored/fixed/dynamic Deflate blocks, filters 0 through 4, and standard 8-bit color types plus 1/2/4-bit palettes; Adam7 interlace remains unsupported. Its encoder produces deterministic filter-0 RGBA files for screenshots and procedural assets.

The native MiniLang CLI validates manifests and generates real `assets.mpx`, `generated.assets`, and `generated.levels` outputs for images, procedural sprites, audio/files, MiniPixels levels, and finite CSV-encoded Tiled/TMJ maps. Compiler launching, build reports, and SDK packaging remain in the Python driver.

## Files created

- `src/**/*.ml` MiniPixels runtime modules.
- `tools/minipixels.py` CLI and asset/project processor.
- `docs/*.md` architecture and user documentation.
- `examples/*` three complete example projects.
- `tests/*.ml` and `tests/run_tests.py` deterministic runtime tests.
- `benchmarks/canvas_bench.ml` basic framebuffer benchmark.

## Risks and next steps

- PNG hot-loading intentionally excludes Adam7 interlace and 16-bit samples.
- The mixer decodes complete PCM WAV clips in memory; compressed formats and streaming music remain future work.
- Windows has GDI and OpenGL/WGL presentation; Linux currently uses X11/XImage. Wayland and a GPU presenter are natural next steps.
- `nativeCallback` currently supports WNDPROC only; richer callback APIs should remain backend-internal.
