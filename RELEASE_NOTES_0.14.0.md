# MiniPixels 0.14.0

MiniPixels 0.14.0 focuses on rendering throughput. CPU drawing, native window
presentation, tile traversal, and the optional GPU scene path now do substantially
less work per frame while preserving the existing public rendering API and pixel
output.

## Faster CPU canvas and sprites

The CPU canvas now uses specialized straight-alpha blending, direct packed-color
access, covered dirty-region elision, and allocation-free image-region blits. Scaled
sprites replace repeated division with reciprocal sampling, while rotated sprites
advance source coordinates incrementally across each scanline. Sprite sampling and
tinting avoid validation and packing work once clipping has established safe bounds.

On the release test system, the 320x180 GDI presenter increased from roughly 262 to
525 frames per second. Scaled and tinted sprite workload time fell from 734 to 437 ms,
and the rotated workload fell from 281 to 203 ms. Deterministic framebuffer hashes are
unchanged.

## Native Linux presentation

Linux XImage presentation now performs RGBA-to-BGRA conversion and both integer and
generic nearest-neighbor scaling in the existing native runtime bridge. This removes
dynamic MiniLang dispatch from the per-pixel presentation loop and delivered roughly
1.9x the previous presenter throughput in the tested resolutions.

## Lower platform and GPU overhead

The Windows presenter caches its active OpenGL context, client geometry, viewport,
and persistent texture-filter state. Fixed-resolution games no longer query and
allocate around client dimensions every frame, and title/FPS updates are bounded by
wall-clock time.

GPU images retain generation-safe texture handles, avoiding repeated native cache
lookups. GPU lines are emitted as horizontal or vertical runs instead of one quad per
pixel, maximum texture size is cached, and framebuffer readback reuses row storage.
Tilemaps eagerly cache immutable frame descriptors and directly traverse already
clipped visible rows.

## Verification

The complete Windows x64 and Linux x64 suites pass. Additional Linux tests cover the
native color conversion and both scaling paths. CPU canvas and sprite benchmarks keep
deterministic output hashes, and the committed MiniDoc HTML and Markdown references
are generated in strict mode with zero warnings.
