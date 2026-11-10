# Prepared images and native LZ4

Image and procedural assets are prepared during the build. Developers continue
to supply PNG files and call the same generated image, sprite, and sheet helpers.
The MPX contains MRI1 RGBA8888 data rather than PNG scanlines. The runtime checks
dimensions and exact byte length, constructs the image, and releases the source
payload cache. Standalone PNG loading and PNG payloads remain supported.

Python builds default to Deflate for compact prepared images; `compression:
"fast"` selects LZ4 and `"none"` stores the prepared pixels directly. The native
MiniLang generator uses LZ4 for compressed prepared images. Files, text, and
JSON retain their existing compression policy. Explicit project/asset choices
are respected, including `small` on custom `.rgba` and `.sprites` files.

LZ4 decoding uses the reference `LZ4_decompress_safe` implementation, pinned to
1.10.0 commit `ebb370ca83af193212df4dcbadcc5d87bc0de2f0`. The bridge checks source
ranges and exact output size and decodes into the final buffer without copying
the compressed subrange. SHA-256 signature bindings and AES-GCM authentication
remain ahead of decompression in protected packs. This change adds no background
threads or whole-pack residency requirement.

## Measurements

Local Windows x64 measurements on an AMD Ryzen 9 9900X with Compiler 1.3.3,
10 November 2026. Medians of five iterations after one warm-up, warm OS cache,
fresh engine pack/image caches for every iteration. These measure asset loading,
not full game startup or frame rate.

All 14 image assets from the jump-and-run example, 2,921,664 final RGBA bytes:

| Pack representation | Stored size | Open, preload and construct images |
| --- | ---: | ---: |
| Original PNG payloads | 944,220 bytes | 85.0 ms |
| MRI1, default compact profile | 1,077,322 bytes | 7.7 ms |
| MRI1, fast profile | 1,422,829 bytes | 1.5 ms |

These image packs are unprotected to isolate reconstruction and codec costs.
The pixel checksums agree for every representation; cache acquisition and image
opacity detection are included. The default therefore reduced this workload by
about 11 times at roughly 14% larger storage, while fast trades more storage for
lower latency. Actual ratios depend on the artwork.

The same image benchmark under Linux/WSL on the Windows-hosted project directory
measured 108 ms for PNG, 13 ms for the default profile, and 9 ms for fast, with
the same pixel checksum. These timings include WSL filesystem overhead and use
the Linux timer's millisecond resolution; they are not native-Linux disk results.

A separate protected MPX3 test used two real prepared game files totaling
17,673,024 logical bytes. With identical encrypted LZ4 data, opening and loading
the payloads fell from 51.6 ms with the previous MiniLang decoder to 11.0 ms with
the native decoder. Checksums were verified outside the timed region. This test
includes index verification, reads, authentication, and decompression, but not
the game's custom sprite construction. It does not change the behavior or speed
of files explicitly stored with `small`/Deflate.

## Reproduce

Build the native runtime into the benchmark output directory, compile
`benchmarks/asset_images_bench.ml` against `src` and the compiler stdlib, and pass
an unprotected MPX path. It reports open, payload, image, and total milliseconds
plus an order-independent pixel checksum. It supports Windows and Linux.
`benchmarks/asset_loading_bench.ml` measures bulk payload loading separately.

Rebuild the game executable, MPX, and native runtime together when upgrading.
An old executable cannot load newly prepared MRI1 assets. Keep the automatically
copied `minipixels-lz4-LICENSE.txt` with distributed games; Steam exports include
it. Existing signing keys do not need to change.
