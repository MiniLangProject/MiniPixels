# MiniPixels Architecture

## Repository findings

MiniLang is a small dynamically typed language compiled by `MiniLangCompilerPy/mlc_win64.py` into native Windows x64 PE executables. The compiler supports multi-file `package`/`import`, structs, first-class functions, arrays, mutable `bytes`, value-or-error handling, Win32 `extern function` imports, and `nativeCallback(fn, "wndproc")` for WNDPROC callbacks.

The standard library already provides file I/O, byte utilities, arrays, math helpers, random helpers, and assertions. There is no general native struct marshaler, so MiniPixels packs Win32 structures into `bytes` buffers and passes them through `nativeBytesPtr(...)`. Out-parameters are parsed but not fully generated, so APIs such as `PeekMessageW` are declared with `bytes` buffers.

## Implemented first vertical slice

This first version is a real vertical prototype, not the full future engine. It contains:

- CPU RGBA framebuffer with safe pixel access, clear, primitive drawing, blitting, sprites, sprite sheets, and animation.
- Headless game loop for deterministic tests.
- Win32 window backend using `RegisterClassExW`, a MiniLang WNDPROC callback, `PeekMessageW`, `GetAsyncKeyState`, and `StretchDIBits`.
- Keyboard input snapshots for common keys.
- Camera, parallax helpers, tilemap rendering with viewport culling, AABB/tile collisions, bitmap-font style debug text, and simple audio stub via `PlaySoundW`.
- Python CLI `tools/minipixels.py` for `new`, `validate`, `generate`, `pack`, `build`, and `run`, delegating compilation to `MiniLangCompilerPy`.
- Three example projects.

## Module plan

- `minipixels`: user-facing facade with config, game state, `run`, `runHeadless`, and convenience functions.
- `minipixels.core.time`: frame/update counters and fixed-step timing state.
- `minipixels.math.types`: vectors, rectangles, transforms, color packing, RNG, timers.
- `minipixels.graphics.canvas`: framebuffer, clipping, primitives, sprite blits, render targets.
- `minipixels.graphics.sprite`: images, generated MPPM asset format, sprites, sprite sheets.
- `minipixels.animation.animation`: frame-duration animation player.
- `minipixels.input.input`: keyboard snapshots, action mapping.
- `minipixels.platform.windows`: Win32 window/event/present backend.
- `minipixels.world.camera`, `tilemap`, `entity`: camera, parallax, tilemaps, entities.
- `minipixels.collision.collision`: primitive collisions and simple tile collision.
- `minipixels.assets.assets`: generated/static asset registry.
- `minipixels.audio.audio`: small PlaySoundW wrapper plus headless no-op path.
- `minipixels.debug.debug`: counters, overlays, and framebuffer hash.
- `minipixels.scene.scene`: synchronous scene stack.

## Rendering strategy

The public framebuffer format is straight-alpha RGBA8888 with packed colors as `0xRRGGBBAA`. `Canvas.pixels` stores bytes in `R,G,B,A` order. Win32 DIB presentation uses a temporary BGRA buffer because `StretchDIBits` with a 32-bit BI_RGB DIB expects little-endian BGR channel order. Scaling uses nearest-neighbor by manually expanding logical pixels into the scaled DIB buffer.

## Game-loop strategy

The headless path runs deterministic fixed updates and renders exactly the requested frame count. The Win32 path polls messages, snapshots keyboard input, clamps the frame duration, processes a fixed-step accumulator, renders once per frame, and presents the framebuffer. Escape requests shutdown. Native resources are released by destroying the window after the loop.

## Asset strategy

The CLI validates `minipixels.json`, reads 8-bit RGB/RGBA PNG assets at build time, generates deterministic MiniLang asset modules, and can pack referenced assets into a deterministic `.mpak` byte stream. Runtime game code does not need a JSON or PNG parser in release builds.

## Files created

- `src/**/*.ml` MiniPixels runtime modules.
- `tools/minipixels.py` CLI and asset/project processor.
- `docs/*.md` architecture and user documentation.
- `examples/*` three complete example projects.
- `tests/*.ml` and `tests/run_tests.py` deterministic runtime tests.
- `benchmarks/canvas_bench.ml` basic framebuffer benchmark.

## Risks and next steps

- PNG loading is implemented in the build-time processor. Add a WIC-backed runtime image loader in `platform/windows` next for debug hot-loading.
- Audio is a minimal WinMM `PlaySoundW` wrapper; streaming music and mixer channels are future work.
- The window backend is a reference DIB renderer. It is correct and simple, but D3D11/OpenGL backends will be needed for larger games.
- `nativeCallback` currently supports WNDPROC only; richer callback APIs should remain backend-internal.
