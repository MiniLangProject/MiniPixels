# MiniPixels 0.19.0

This release speeds up CPU canvas drawing and adds a bulk update API for
procedural full-frame effects. Existing `setPixel` calls keep their behavior;
games must opt into `Canvas.replacePixels` to use the bulk path.

## Rendering changes

- `Canvas.replacePixels(buffer)` copies a reusable, tightly packed RGBA buffer
  of exactly `width * height * 4` bytes into the canvas. It returns `false` for
  a mismatched size, detects opacity, and marks the full frame for presentation.
- Fractional upscaling reuses decoded and tinted source colors across repeated
  destination pixels. Translucent integer scaling blends directly into canvas
  bytes. Unit-scale flipped and tinted sprites use clipped byte-oriented paths.
- Rotated sprites avoid temporary corner arrays and use direct byte access for
  visible source and destination pixels. Alpha rectangles over opaque canvases
  reuse decoded color and advance by byte offset. Lines calculate camera offset
  and the dirty rectangle once per draw.

## Measured CPU performance

Local Windows x64 benchmarks with MiniLang Compiler 1.2.26, median of three runs:

| Isolated workload | Before | After |
| --- | ---: | ---: |
| 100 generated 320×180 frames, `setPixel` vs `replacePixels` | 467 ms | 35 ms |
| 6,000 rotated alpha/tinted sprites | 565 ms | 448 ms |
| 6,000 rotated opaque sprites | 259 ms | 180 ms |
| 3,000 translucent rectangles | 229 ms | 121 ms |
| 8,000 lines | 68 ms | 30 ms |

The bulk-pixel comparison includes generating RGBA bytes directly instead of
packing a color for each `setPixel` call. These numbers measure CPU rendering
in synthetic workloads, not game FPS or display presentation. Other scenes may
see different gains.

Windows and Linux rendering tests cover alpha, clipping, camera offsets,
opacity and dirty bounds, as well as sprite self-blits. Benchmark image hashes
match the previous implementation.

See the [changelog](https://github.com/MiniLangProject/MiniPixels/blob/v0.19.0/CHANGELOG.md).
