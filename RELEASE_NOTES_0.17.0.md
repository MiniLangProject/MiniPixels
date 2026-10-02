# MiniPixels 0.17.0

Optional Steam integration and a refreshed example collection for Windows and Linux.

## Steam support, only when enabled

- Per-game opt-in configuration; normal builds need neither Steam nor the Steamworks SDK.
- Steam identity and language, achievements, integer stats and asynchronous persistence status.
- Lifecycle integration before window creation, callbacks during pauses, overlay input suppression and configurable simulation pause.
- Atomic per-user local saves ready for Steam Auto-Cloud configuration.
- Windows/Linux SteamPipe export with explicit file allowlists, preview-only scripts and no automatic upload.
- SDK 1.65 builds and a real Windows Steam-client smoke test verified; Linux loading and no-client fallback verified.
- Standalone-by-default `steam-demo`, developer guide and automated regression tests.

Developers provide their own official Steamworks SDK, game AppID and depot IDs.
No personal Steam account settings, SDK binaries or credentials are included.
AppID 480 is used only for development tests/examples.

**Limits:** Linux currently uses XImage and therefore has no in-game Steam overlay.
Auto-Cloud and app/depot settings must be configured in Steamworks. Steam Input,
Workshop, DLC helpers and networking are not part of this initial adapter.
Encrypted MPX delta-patch optimization is also a separate future task.

## Better-looking, more playable examples

- New generated artwork across all five graphics examples, with source/provenance and reproducible preparation tools.
- Reachable platformer layouts, ground-based orange enemies and properly grounded scenery.
- Improved run animation, 12-frame rotating coins and 12-frame portal animation.
- Smoother camera motion on jumps and platform transitions, refined parallax and foreground foliage.
- Fixed moving tile seams caused by incorrect flooring of negative fractional coordinates.
- Deterministic example captures and additional gameplay/rendering regression tests.

## Packaging and documentation

- Fixed asset-pack selection for custom build/export directories.
- Updated README, Steam/example guides and MiniDoc API references.
- The SDK ZIP includes engine sources, examples, tools, documentation and tests;
  the official Valve SDK remains a separately installed development dependency.

See [Steam integration](https://github.com/MiniLangProject/MiniPixels/blob/v0.17.0/docs/steam.md)
and the [changelog](https://github.com/MiniLangProject/MiniPixels/blob/v0.17.0/CHANGELOG.md).
