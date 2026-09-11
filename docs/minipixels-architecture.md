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
- Camera, parallax helpers, cached tilemap rendering with viewport culling, swept AABB/tile collisions, bitmap-font text, scene stacking, and a waveOut/ALSA-backed multi-voice WAV/MP3 mixer.
- Python CLI `tools/minipixels.py` for `new`, `validate`, `generate`, `pack`, `build`, `run`, and `package`, delegating compilation to `MiniLangCompilerPy`.
- Native MiniLang CLI `tools/minipixels_cli.ml` for `info`, `doctor`, `validate`, `generate`, and `new`.
- Example projects covering sprites, scrolling worlds, pixel effects, Tiled import, and a jump-and-run game.

## Module plan

- `minipixels`: user-facing facade with config, game state, `run`, `runHeadless`, and convenience functions.
- `minipixels.core.time`: frame/update counters and fixed-step timing state.
- `minipixels.math.types`: vectors, rectangles, transforms, color packing, RNG, timers.
- `minipixels.graphics.canvas`: framebuffer, clipping, primitives, sprite blits, render targets.
- `minipixels.graphics.gpu`: experimental Windows OpenGL scene framebuffer, batching, readback, and point lights, with non-Windows stubs.
- `minipixels.graphics.sprite`: images, generated MPPM asset format, sprites, sprite sheets.
- `minipixels.animation.animation`: frame-duration animation player.
- `minipixels.input.input`: keyboard snapshots, action mapping.
- `minipixels.platform.windows`: Win32 window/event/present backend.
- `minipixels.platform.linux`: X11 window/event/present backend.
- `minipixels.world.camera`, `tilemap`, `entity`: camera, parallax, tilemaps, entities.
- `minipixels.collision.collision`: primitive collisions and simple tile collision.
- `minipixels.assets.assets`: generated/static asset registry.
- `minipixels.assets.pack`: lazy MPX1 reader plus the authenticated, random-access MPX3 version-4 loader.
- `minipixels.assets.text`: packed UTF-8 catalogs and locale fallback service.
- `minipixels.assets.png`: general non-interlaced PNG decoder plus deterministic encoder.
- `minipixels.audio.audio`: legacy Windows WAV helpers and a buffered waveOut/ALSA WAV/MP3 stereo mixer with streamed MP3 music.
- `minipixels.debug.debug`: counters, overlays, and framebuffer hash.
- `minipixels.scene.scene`: synchronous scene stack.

## Rendering strategy

The public framebuffer format is straight-alpha RGBA8888 with packed colors as `0xRRGGBBAA`. `Canvas.pixels` stores bytes in `R,G,B,A` order. A framebuffer policy selects a fixed size, the native client size, or a fractional/multiple client size with an aspect-preserving pixel cap. Runtime resize reallocates the pixel storage while retaining the public Canvas object and publishes the new render/design ratios on Game.

GDI uses explicit DIB color masks, avoiding a frame-by-frame channel conversion. The OpenGL/WGL presenter updates only the tracked dirty rectangle of the logical RGBA texture, grows or shrinks its power-of-two texture when necessary, and lets the GPU scale it to the client area. Unchanged Windows frames skip presentation until WM_PAINT or WM_SIZE invalidates the retained output. Linux converts and scales into a retained native XImage through optimized C routines in the already-required native runtime; unchanged frames likewise skip native presentation, while native 1:1 dirty frames convert and upload only their changed rectangle. Presentation scale modes independently support stretch, aspect-fit, and integer pixel-perfect output.

The optional Windows GPU scene path is deliberately separate from the portable CPU framebuffer. A small C++ runtime owns an OpenGL framebuffer and resident texture cache, batches compatible sprite/rectangle work, and resolves the logical scene into the existing window viewport. MiniLang retains cached source images so native pointer keys remain valid and exposes explicit invalidation when mutable pixels change. Framebuffer resize and readback are explicit; the runtime validates the owning OpenGL context and keeps the scene opaque for a cheaper source-over blend path. Linux compiles the same module to unsupported stubs rather than acquiring a Windows DLL dependency.

## Game-loop strategy

The headless path runs deterministic fixed updates and renders exactly the requested frame count. Windowed paths use a monotonic high-resolution clock, poll native events, buffer input edges, clamp the frame duration, process a bounded fixed-step accumulator, publish interpolation alpha, render once per frame, and apply an optional frame limit. Callback errors still pass through scene/audio/window cleanup. Escape requests shutdown.

## Asset strategy

Both generators validate `minipixels.json`, write an `assets.mpx` byte stream, generate lazy MiniLang asset modules, import MiniPixels or Tiled level data, and include referenced image, audio, text, and data assets in the same container. Runtime game code does not need a JSON parser for text catalogs in release builds. The Python path preserves compatible source PNGs, Deflate-compresses generated PNGs, and transcodes PCM WAV assets to MP3 when that reduces their size. File, text, and JSON payloads select Deflate or RLE only when useful. The native MiniLang generator uses dependency-free RLE where beneficial. The Python build driver also emits detailed size/codec reports, builds/copies the native runtime bridge, and writes compiler project manifests.

Protected builds convert the deterministic MPX1 stream into MPX3. Compression and identical-payload deduplication occur before encryption. A fresh per-build AES-256-GCM key encrypts the compact index and each unique stored block independently. An ECDSA-P256-SHA256 signature authenticates the header and encrypted index; that index binds every payload codec, logical/stored size, offset, nonce and GCM tag. Startup therefore verifies/decrypts only metadata, while payload authentication and decompression happen on first access. The generated game module embeds only the public verification identity and a deliberately obfuscated AES key; the runtime retains its reconstructed key only while the lazy pack is open and wipes it on close. Signing keys remain build-only PEM secrets and may be supplied by the project key directory or CI environment.

An unprotected `.mpx` file starts with `MPX1`, followed by a little-endian entry table and payload blocks. The former reserved entry byte identifies raw, Deflate, or dependency-free RLE storage; repeated entries may reference the same exact block. Both MPX1 and MPX3 payloads stay file-backed until first access. The protected loader accepts only MPX3 version 4; MPX2 and older MPX3 versions are rejected. Authentication precedes bounded decompression. Names resolve through a hash index, generated accessors bypass it with stable slots, and per-slot arrays cache logical payloads/images in constant time. Successfully decoded PNG, text, and data entries release their source-byte cache. Counters expose cache hits, misses and retained raw bytes. The PNG runtime handles stored/fixed/dynamic Deflate blocks, filters 0 through 4, and standard 8-bit color types plus 1/2/4-bit palettes; Adam7 interlace remains unsupported.

The native MiniLang CLI validates manifests and generates real `assets.mpx`, `generated.assets`, and `generated.levels` outputs for images, procedural sprites, audio/files, MiniPixels levels, and finite CSV-encoded Tiled/TMJ maps. Compiler launching, build reports, and SDK packaging remain in the Python driver.

## Files created

- `src/**/*.ml` MiniPixels runtime modules.
- `tools/minipixels.py` CLI and asset/project processor.
- `docs/*.md` architecture and user documentation.
- `examples/*` three complete example projects.
- `tests/*.ml` and `tests/run_tests.py` deterministic runtime tests.
- `benchmarks/canvas_bench.ml` measures full-frame CPU pixel throughput and verifies its framebuffer hash.
- `benchmarks/sprite_bench.ml` separates 1x, scaled/tinted, and rotated CPU sprite throughput.
- `benchmarks/renderer_bench.ml` measures complete window presentation at several framebuffer sizes.

## Risks and next steps

- PNG hot-loading intentionally excludes Adam7 interlace and 16-bit samples.
- MP3 sound effects decode on first use, while MP3 music uses a per-voice source-frame buffer. WAV remains direct PCM and the final mixer output is interleaved 44.1-kHz signed-16 stereo.
- Windows has GDI and OpenGL/WGL presentation plus an experimental GPU-native scene path; Linux currently uses X11/XImage. Wayland and a Linux GPU presenter are natural next steps.
- The GPU scene canvas is not yet integrated into `mp.run` and does not yet implement rotated sprites or GPU-canvas texture sources.
- `nativeCallback` currently supports WNDPROC only; richer callback APIs should remain backend-internal.
