# MiniPixels Architecture

## Repository findings

MiniLang is a small dynamically typed language compiled by `MiniLangCompilerPy/mlc_win64.py` into native Windows x64 PE executables. The compiler supports multi-file `package`/`import`, structs, first-class functions, arrays, mutable `bytes`, value-or-error handling, Win32 `extern function` imports, and `nativeCallback(fn, "wndproc")` for WNDPROC callbacks.

The standard library already provides file I/O, byte utilities, arrays, math helpers, random helpers, and assertions. There is no general native struct marshaler, so MiniPixels packs Win32 structures into `bytes` buffers and passes them through `nativeBytesPtr(...)`. Out-parameters are parsed but not fully generated, so APIs such as `PeekMessageW` are declared with `bytes` buffers.

## Implemented engine slice

MiniPixels is a working engine prototype, not the full future engine. It contains:

- CPU RGBA framebuffer with safe pixel access, clear, primitive drawing, blitting, sprites, sprite sheets, and animation.
- Headless game loop for deterministic tests.
- Win32 window backend using `RegisterClassExW`, a MiniLang WNDPROC callback, `PeekMessageW`, `GetAsyncKeyState`, `StretchDIBits`, and optional OpenGL/WGL presentation.
- Keyboard input snapshots for common keys.
- Camera, parallax helpers, tilemap rendering with viewport culling, AABB/tile collisions, bitmap-font style debug text, and a WinMM-backed audio layer.
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
- `minipixels.world.camera`, `tilemap`, `entity`: camera, parallax, tilemaps, entities.
- `minipixels.collision.collision`: primitive collisions and simple tile collision.
- `minipixels.assets.assets`: generated/static asset registry.
- `minipixels.audio.audio`: small PlaySoundW wrapper plus headless no-op path.
- `minipixels.debug.debug`: counters, overlays, and framebuffer hash.
- `minipixels.scene.scene`: synchronous scene stack.

## Rendering strategy

The public framebuffer format is straight-alpha RGBA8888 with packed colors as `0xRRGGBBAA`. `Canvas.pixels` stores bytes in `R,G,B,A` order. GDI presentation uses a temporary BGRA buffer because `StretchDIBits` with a 32-bit BI_RGB DIB expects little-endian BGR channel order. The OpenGL/WGL presenter uploads the logical canvas as an RGBA texture and lets the GPU scale it to the client area. Scale modes support stretch, aspect-fit, and integer pixel-perfect presentation.

## Game-loop strategy

The headless path runs deterministic fixed updates and renders exactly the requested frame count. The Win32 path polls messages, snapshots keyboard input, clamps the frame duration, processes a fixed-step accumulator, renders once per frame, and presents the framebuffer. Escape requests shutdown. Native resources are released by destroying the window after the loop.

## Asset strategy

The Python CLI validates `minipixels.json`, reads 8-bit RGB/RGBA PNG assets at build time, generates deterministic MiniLang asset modules, copies runtime assets, imports MiniPixels or Tiled level data, and can pack referenced assets into a deterministic `.mpak` byte stream. Runtime game code does not need a JSON or PNG parser in release builds.

The native MiniLang CLI already validates manifests and generates importable `generated.assets`/`generated.levels` modules for procedural sprites and MiniPixels `levels.json`. Native PNG decoding, runtime asset copying, Tiled/TMJ import, build/run, and packaging remain in the Python pipeline for now.

## Files created

- `src/**/*.ml` MiniPixels runtime modules.
- `tools/minipixels.py` CLI and asset/project processor.
- `docs/*.md` architecture and user documentation.
- `examples/*` three complete example projects.
- `tests/*.ml` and `tests/run_tests.py` deterministic runtime tests.
- `benchmarks/canvas_bench.ml` basic framebuffer benchmark.

## Risks and next steps

- PNG loading is implemented in the Python build-time processor. Add native PNG embedding or a WIC-backed runtime image loader in `platform/windows` next for image work outside the Python pipeline.
- Audio is a minimal WinMM `PlaySoundW` wrapper; streaming music and mixer channels are future work.
- The window backend has GDI and OpenGL/WGL presentation. D3D11 and GPU render targets would be natural next steps for larger games.
- `nativeCallback` currently supports WNDPROC only; richer callback APIs should remain backend-internal.
