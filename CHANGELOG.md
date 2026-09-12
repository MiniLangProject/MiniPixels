# Changelog

## Unreleased

- Added target-native zlib/Deflate decoding into exact destination buffers for PNG and MPX payloads, retaining the MiniLang decoder as a validation fallback.
- Replaced per-entry MPX1 index I/O with bounded bulk index parsing.
- Added bounded file-order bulk preloading, optional resident packs, named preload groups, decoded-buffer reuse for deduplicated entries, and physical/logical I/O telemetry.
- Added global and per-asset `auto`, `fast`, `small`, and `none` compression profiles plus an asset-loading benchmark.

## 0.14.0 - 2026-09-11

- Reworked CPU canvas hot paths with covered-dirty-region elision, direct color packing, specialized straight-alpha blending, allocation-free image-region blits, and incremental scaled/rotated sprite sampling.
- Moved Linux RGBA-to-BGRA conversion and nearest/integer presentation scaling into the existing optimized native runtime bridge.
- Cached Windows OpenGL context, client geometry, viewport and texture-filter state, and avoided fixed-resolution resize polling and unbounded title updates in the game loop.
- Added per-image GPU texture handles, generation-safe cache invalidation, run-batched GPU lines, reusable readback storage, eager tile-frame descriptors, and bounds-check-free visible tile traversal.
- Added deterministic CPU canvas/sprite benchmarks and Linux native presenter conversion tests.

## 0.13.0 - 2026-09-11

- Preserved compatible source PNGs and switched generated PNGs to real Deflate, eliminating the stored-block size inflation in Python-built packs.
- Added automatic size-aware PCM WAV-to-MP3 transcoding with configurable bitrate/quality and a build-only `lameenc` dependency.
- Added transparent per-entry Deflate/RLE compression, decompression size limits, and identical-payload block deduplication for MPX1 and MPX3.
- Expanded asset reports with source, logical, stored, codec, transform, and deduplication metrics.
- Removed the legacy MPX2 and MPX3 version-3 protected-pack loaders; protected builds now accept only MPX3 version 4.

## 0.12.0

- Added random-access MPX3 protected packs with a signed/encrypted index and independently authenticated AES-256-GCM payload blocks, retaining legacy MPX2 read compatibility.
- Made unprotected MPX1 payloads file-backed and lazy instead of retaining the complete pack in memory.
- Added generated numeric-slot access, caches for text/data/localization, automatic decoded-source byte release, optional `preload()`, explicit pack closing, and cache/I/O statistics.

## 0.11.0

- Added mono/stereo MP3 support backed by a checksum-pinned `dr_mp3` bridge for Windows and Linux; sound effects decode lazily and music streams from compressed file or MPX bytes.
- Added automatic target-native audio bridge builds/copying, `musicClipFromBytes`, MP3/stereo capability queries, and stereo/streaming regression coverage.
- Added an experimental batched Windows OpenGL scene canvas with GPU sprites, primitives, framebuffer resizing, readback, texture invalidation, optional point lights, and a compile-safe Linux fallback.
- Added an optional native GPU runtime build, SDK packaging, cross-target smoke coverage, and renderer/API documentation.
- Optimized opaque-destination sprite blending and avoided redundant full-window clears in the Windows OpenGL and GDI presenters.

## 0.10.0

- Added arbitrary fixed, native-client, and fractional/multiple dynamic render resolutions with resize-safe Canvas storage, allocation caps, design-coordinate ratios, and per-frame resize notification.
- Added dynamic OpenGL texture reallocation for changing framebuffer sizes.
- Optimized unchanged-frame presentation on Windows and Linux, and made XImage convert/upload only dirty regions for native 1:1 output.
- Expanded renderer benchmarks across 320x180, 960x540, and 1920x1080 framebuffers with megapixel throughput reporting.

## 0.9.0

- Added the MPX2 protected asset envelope: complete MPX1 packs are encrypted with per-build AES-256-GCM keys and signed with ECDSA-P256-SHA256 before distribution.
- Added automatic obfuscated AES-key and embedded public-key generation, signature-before-decryption runtime loading, key-id binding, secure key wiping, and fail-closed tamper handling on Windows and Linux.
- Added `minipixels security init|status`, PEM signing-key support, CI secret overrides, and the `cryptography` build dependency.
- Added packed UTF-8 text catalogs with locale fallback and placeholders, canonical JSON `data` assets, and generated compile-time `constants` modules for scalar and structured game configuration.
- Added cross-platform ECDSA-P256 verification to MiniLang's platform crypto standard library.
- Added native Linux x64 support with an X11/XImage window, resize-aware presentation, focus-safe keyboard/mouse input, and monotonic frame timing.
- Added a non-blocking ALSA output backend for the existing multi-voice PCM mixer and POSIX directory creation for native tooling.
- Added `--target windows-x64|linux-x64` to the Python build, test, and example drivers, including correct PE/ELF output naming and target-aware manifests.
- Added Ubuntu CI coverage for the full native test suite, all examples, the renderer smoke test, and the native MiniLang CLI.

## 0.8.0

- Added configurable, growable input actions with buffered fixed-update edges, logical mouse coordinates, deltas, buttons, wheel input, and focus-safe releases.
- Reworked the game loop around a high-resolution monotonic clock with interpolation alpha, smoothed FPS/UPS, configurable frame limiting, focus pause, and cleanup-preserving callback errors.
- Added a growable scene stack with enter, exit, pause, resume, update, overlay render, and shutdown lifecycle hooks.
- Added CPU render targets, pivot-based sprite rotation, deterministic PNG screenshots, midpoint circle fills, grouped font spans, and dirty-region OpenGL uploads.
- Added cached sprite-sheet frames, hash-indexed asset registries/packs, lazy generated assets, cache eviction, and swept tile collision that prevents tunneling.
- Expanded PNG support to stored/fixed/dynamic Deflate, filters 0-4, grayscale, RGB, indexed transparency, grayscale-alpha, and RGBA hot-loading.
- Replaced the mixer-shaped audio placeholder with a buffered waveOut PCM mixer supporting simultaneous SFX, looping memory music, mono/stereo PCM, rate conversion, volume buses, channel volume, and pan.
- Added exact line/rectangle clipping and corrected vector length/normalization; vector operators now use MiniLang 1.2.4 inline operator overloads.
- Ported real asset-pack generation and finite CSV-encoded Tiled/TMJ import to the native MiniLang generator, with write-if-changed incremental output.
- Replaced long native CLI template concatenations with `StringBuilder`, avoiding a pathological MiniLang 1.2.4 compile path.
- Added a `std.test` foundation suite covering input, scenes, assets, collision, rendering, PNG, PCM audio, timing, and callback cleanup.
- Optimized framebuffer clears, opaque rectangle fills, and opaque sprite blits with MiniLang 1.2.4 native byte-copy operations.
- Removed the GDI frame-by-frame RGBA-to-BGRA conversion by describing the RGBA framebuffer with explicit DIB color masks.
- Fixed alpha blending for translucent rectangles and generic color blending.
- Added typed primitive engine fields and selective inline helpers for MiniLang 1.2.4 local type flow.
- Moved Python-generated procedural images into `assets.mpx` instead of emitting thousands of MiniLang byte assignments.
- Reworked PNG stored-block and IDAT assembly to allocate once and use native byte copies.
- Added compiler-project manifests and exact-hit incremental build caching to the Python CLI.
- Made `--debug`, `--release`, `--verbose`, and `run --headless` behavior explicit and functional.
- Reduced temporary allocations in bitmap-font drawing, debug digits, native JSON parsing, and native code generation.
- Fixed initial Win32 window titles to use the compiler's UTF-16 `wstr` marshaling.
- Made the test runner fail when MiniLang assertions print `[FAIL]`.

## 0.7.0

- Extended native `minipixels.tools.generator` from stubs to concrete `generated.levels` output for MiniPixels `levels.json`.
- Added native generated asset code for `procedural` sprites, including sheet helpers.
- Kept `image` assets buildable in native generated output through placeholder pixels while PNG embedding remains in the legacy Python path.
- Restored manifest support for `procedural` asset types and added generated-code compile smoke coverage.
- Added CI coverage for native generation of the Jump and Run example.

## 0.6.0

- Added `minipixels.tools.fsutil` for shared native tool filesystem helpers.
- Added `minipixels.tools.generator` with native generated module stubs.
- Added native CLI command `generate [project] [outDir]`.
- Added native generator tests and CI coverage for simple projects and templates.
- Added explicit manifest validation for asset types `image`, `procedural`, `audio`, and `file`.

## 0.5.0

- Added a native MiniLang JSON parser at `minipixels.tools.json`.
- Added native MiniPixels manifest loading and validation at `minipixels.tools.manifest`.
- Added native CLI commands `validate [project]` and `info <project>`.
- Extended native CLI and CI checks to validate real example manifests without the Python project processor.

## 0.4.0

- Added the first native MiniLang CLI at `tools/minipixels_cli.ml`.
- Added native `info`, `doctor`, and `new <name> [template]` commands.
- Added project templates: `basic`, `platformer`, and `pixel-art`.
- Started moving MiniPixels tooling away from Python; Python remains only for compiler bootstrap and the legacy build/generate/package pipeline for now.

## 0.3.1

- Added renderer diagnostics for GPU state and fallback reasons.
- Added presentation scale modes: stretch, aspect-fit, and integer pixel-perfect scaling.
- Added optional smoothing for the OpenGL presenter.
- Added a renderer benchmark and expanded renderer documentation.
- Added frame time to the debug stats overlay.

## 0.3.0

- Added optional OpenGL/WGL hardware-accelerated presentation on Windows.
- Added renderer selection through `cfg.renderer`, `mp.useGpuRenderer(cfg)`, and `mp.useCpuRenderer(cfg)`.
- Kept the existing GDI renderer as automatic fallback when GPU initialization is unavailable.

## 0.2.1

- Added the `examples/tiled-platformer` project demonstrating Tiled JSON/TMJ level import.
- Added CLI commands: `info`, `doctor`, and `package`.
- Added Tiled/level warnings for missing objects and unknown object kinds.
- Expanded manifest and Tiled import documentation.

## 0.2.0

- Added Windows CI for tests and example builds.
- Added SDK ZIP packaging with SHA256 checksum and workflow artifact upload.
- Added tag-based GitHub Release publishing for `v*` tags.
- Added build-time level JSON generation through `generated.levels`.
- Added build-time Tiled JSON/TMJ import for solid layers and basic object layers.
- Added framehash render regression tests.
- Added AudioClip, AudioMixer, and backend capability helpers as the next audio API layer.
- Added SpriteSheet metadata generation, asset reports, and runtime asset copying.
- Polished the Jump and Run example with HUD, particles, level intros, and data-driven levels.

## 0.1.0

- Initial MiniPixels prototype with Win32 windowing, fixed logical framebuffer, sprites, tilemaps, camera scrolling, input, basic audio, examples, and docs.
