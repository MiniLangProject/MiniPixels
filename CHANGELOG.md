# Changelog

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
