# MiniPixels 0.16.0

Seekable audio/video playback directly from MPX, with safer streaming and predictable preload I/O on Windows and Linux.

## Highlights

- Generated video assets and opt-in `stream: true` audio use MiniLang's native media players. The build driver packages the target media bridge automatically.
- A tokenized loopback HTTP range source reads only the requested MPX entry ranges; no plaintext temporary files or complete media-sized RAM copies are needed.
- Protected MPX3 version 5 stores media in independently authenticated 256 KiB AES-GCM chunks. Failed authentication invalidates the chunk cache and never publishes unauthenticated bytes.
- Fragmented and case-insensitive HTTP headers, suffix/open-ended byte ranges, validation and cancellable nonblocking socket I/O support reliable seeking and shutdown.
- Sparse preloads skip unrequested media gaps. Even oversized individual assets obey the configured read limit; raw single-entry buffers are reused as the final cache.
- Fresh Windows builds use explicit media-runtime output paths. Linux CI installs GStreamer and OpenSSL dependencies.

## Compatibility and dependencies

Rebuild protected asset packs: the loader accepts MPX3 version 5, not earlier MPX3/MPX2 containers. Public asset access remains unchanged. Close packed players before closing their pack.

`batchBytes` limits individual file reads and multi-entry coalescing, not total asset RAM. Compressed/encrypted assets still need their full codec/authentication buffers.

Linux streamed audio/video requires GStreamer base/good plugins; libav supplies MP3/H.264 decoding. Building MiniPixels' native runtime requires OpenSSL development headers. See README for Ubuntu package commands.

## Verification

The Windows and Linux/WSL suites cover native range requests, corrupt authentication tags, disconnected/stalled clients, protected pack loading, preload limits and deduplication, alongside existing engine and rendering tests. API documentation is regenerated with strict MiniDoc validation.
