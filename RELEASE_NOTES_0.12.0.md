# MiniPixels 0.12.0

MiniPixels 0.12.0 makes packed assets lazy, directly addressable, and independently
authenticated. Existing game manifests and generated asset helpers continue to work
without application-side changes.

## Lazy random-access packs

Opening an MPX1 or MPX3 file now reads only its compact index. Payload bytes remain
file-backed until first use, so startup time and retained memory no longer scale with
the complete pack size. Per-slot payload and decoded-image caches make repeated access
constant-time. Successfully decoded PNG, text, and JSON data entries release their raw
source bytes automatically.

Generated asset modules resolve each manifest name once and then use its numeric slot
directly. They also cache text catalogs, localization services, and decoded JSON text.
Games that prefer predictable loading-screen work over first-use latency can call the
generated `preload()` helper.

## MPX3 asset protection

Protected builds now emit MPX3. Its encrypted index is signed with ECDSA P-256 and
contains the authenticated metadata for every payload. Each asset is encrypted and
authenticated independently with AES-256-GCM, allowing lazy reads without weakening
tamper detection. Index modification fails while opening the pack; payload modification
fails when the affected asset is first accessed.

MiniPixels retains read compatibility with legacy MPX2 packs. New protected builds use
MPX3 automatically and require no changes to normal build, run, or package commands.

## Runtime controls and diagnostics

The public API now exposes slot-based byte, kind, PNG, and text access. `assetPackStats()`
reports payload/image cache hits and misses, retained raw bytes, entry count, and whether
the pack is lazy and file-backed. `closeAssetPack()` closes the backing file and wipes
the retained MPX3 AES key; later reads fail closed.

## Verification

The complete Windows and Linux test suites cover lazy MPX1 and MPX3 loading, cache
reuse, source-byte release, wrong keys, signed-index tampering, deferred payload
authentication, generated preload behavior, and pack closing. All examples build as
native Windows x64 PE and Linux x64 ELF executables. The committed MiniDoc HTML and
Markdown references are generated in strict mode with zero warnings.
