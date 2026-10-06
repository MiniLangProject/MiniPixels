# MiniPixels 0.18.0

Security, performance, and cross-platform reliability fixes from the full engine audit.

## Upgrade requirement

Protected assets now use **MPX3 version 6**. Rebuild the game executable, generated
asset modules, asset pack, and native runtime together with the normal Python
`build` command. Older protected packs and the previous native streaming ABI are
intentionally unsupported. Existing signing keys remain valid; do not regenerate
them for this upgrade. Unprotected MPX1 packs are unchanged.

## Asset integrity and loading

- The signed index now includes SHA-256 ciphertext digests for ordinary payloads
  and every 256 KiB media chunk. Both lazy reads and streaming verify these before
  decryption, rejecting modifications even when the embedded AES key is known.
- Regression tests include correctly re-encrypted attacks and same-tag GHASH
  forgeries that retain the original valid ECDSA signature.
- Stable O(n log n) preload sorting replaces quadratic insertion sorting. In the
  local 8,000-entry reverse-order benchmark, preloading fell from about 268 ms to
  about 2 ms. This measures that benchmark, not total game startup time.
- Packs are selected beside the executable before development fallback paths;
  an invalid installed pack is not silently replaced by another pack.

## Runtime and build fixes

- Linux native libraries use executable-relative `$ORIGIN` paths, including when
  launched from another working directory or Steam.
- ALSA refills available capacity with bounded work and preserves unsent PCM after
  partial writes, temporary backpressure, and recoverable underruns. Steady 30 FPS
  games are no longer restricted to one 1024-frame audio write per update.
- Continuous half-open tile bounds fix fractional movement into walls and floors.
- Custom executable output paths no longer trigger recursive audio-directory
  cleanup that could delete project source assets.
- Steam depot staging includes the optional Windows GPU runtime when present.

## Validation and publication

- Expanded cryptographic, source-preservation, foreign-working-directory, ALSA,
  collision, preload-order, and Steam packaging regression coverage.
- Full Windows/Linux tests and all six examples were validated locally, with
  eight pixel-identical cross-platform scenes and a Windows GPU pixel smoke test.
- GitHub release publication now depends on successful Windows and Linux jobs.
  CI executes the GPU smoke; hosts lacking framebuffer support explicitly report
  that pixel checks are unavailable.
- Updated README, migration documentation, architecture notes, and MiniDoc.

The SDK ZIP contains engine sources, examples, tools, documentation, and tests.
The official Steamworks SDK and developer credentials are not included.

See the [changelog](https://github.com/MiniLangProject/MiniPixels/blob/v0.18.0/CHANGELOG.md)
and [asset protection reference](https://github.com/MiniLangProject/MiniPixels/blob/v0.18.0/docs/manifest-reference.md#protected-asset-builds).
