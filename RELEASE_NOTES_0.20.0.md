# MiniPixels 0.20.0

This release accelerates two CPU rendering paths with MiniLang's typed inline
x64 assembly. It also improves discovery of installed Visual Studio C++ tools
for optional Windows GPU builds.

## Rendering

- Image and full-frame opacity detection scan alpha bytes in one assembly loop.
  The existing size check protects the direct byte reads.
- Opaque horizontally flipped sprites copy four RGBA bytes per pixel through
  32-bit loads and stores. The row checks both buffers before entering the
  assembly block; short rows keep the existing byte-copy path.
- New regression cases cover empty and truncated opacity scans, clipping, and
  overlapping horizontal sprite self-blits. The sprite benchmark now includes
  the opaque flipped path.

## Measured performance

Local Windows x64 A/B benchmarks using the same MiniLangCompilerPy source and
identical pixel data:

| CPU workload | Previous code | 0.20.0 code |
| --- | ---: | ---: |
| 300 opacity scans of an opaque 320×180 frame | 36.8 ms | 7.9 ms |
| 10,000 opaque flipped 32×32 sprite draws | 172 ms | 31 ms |

The values are medians from repeated synthetic runs. The sprite image hash was
identical before and after. These timings do not measure whole-game FPS or GPU
presentation. Windows and Linux test suites passed for the rendering changes.

## Compiler requirement

Source builds require MiniLangCompilerPy commit `1ba5719` or newer, or a
MiniLangCompilerML binary rebuilt from commit `b9de207` or newer. The released
1.2.26 compiler binaries predate the required inline ASM operations.

See the [changelog](https://github.com/MiniLangProject/MiniPixels/blob/v0.20.0/CHANGELOG.md).
