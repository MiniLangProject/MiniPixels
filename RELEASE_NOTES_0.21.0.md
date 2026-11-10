# MiniPixels 0.21.0

This release speeds up asset loading by preparing image pixels at build time
and decoding LZ4 blocks in the native runtime.

## Faster images and LZ4

- Python and native MiniLang builds convert image/procedural assets to MRI1
  RGBA8888 payloads, avoiding PNG filter reconstruction and color conversion
  during game startup. Generated image, sprite, and sheet APIs stay unchanged.
- Python image defaults retain compact Deflate compression; `fast` uses LZ4
  and `none` stores prepared pixels directly. The native generator uses LZ4
  for compressed images. Direct PNG loading remains available.
- MPX LZ4 blocks decode through the pinned LZ4 1.10.0 reference implementation,
  directly from bounded source ranges into exact-sized output buffers.
- Signature bindings and AES-GCM authentication remain ahead of decompression.
  Explicit compression settings for file/text/data assets are preserved.
- Native builds copy the LZ4 license beside the runtime; Steam exports include it.

## Measured performance

Windows x64, Ryzen 9 9900X, Compiler 1.3.3; warm file cache, medians after warm-up:

| Workload | Previous path | New path |
| --- | ---: | ---: |
| 14 example images, compact default | 85 ms | 7.7 ms |
| Same images, fast profile | 85 ms | 1.5 ms |
| Protected LZ4 payloads, 16.85 MiB logical data | 52 ms | 11 ms |

The image comparison uses unprotected packs; default image storage grows about
14% for this sample. The LZ4 comparison includes authentication and decompression
but excludes game-specific sprite construction. These are asset benchmarks,
not promises for complete game startup or frame rate. See the
[measurement details](https://github.com/MiniLangProject/MiniPixels/blob/v0.21.0/docs/asset-loading-performance.md).

## Validation and upgrading

Windows and Linux/WSL test suites pass, including malformed inputs, native buffer
bounds, pixel fidelity, and protected prepared images. All six examples build
on both targets; eight captured scenes are pixel-identical to 0.20.1. MiniDoc
validation reports zero warnings. The SDK publishes only after both platform
CI jobs pass.

Rebuild the executable, MPX, and native runtime together. Old executables cannot
load newly prepared MRI1 images. Existing signing keys can be retained. Keep
`minipixels-lz4-LICENSE.txt` with distributed games. The compiler baseline remains
MiniLangCompilerPy 1.3.3; the compiler is installed separately from this source SDK.
