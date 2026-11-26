# Portable Canvas 3D geometry

`minipixels.graphics.geometry3d` is a MiniLang CPU triangle renderer for an
ordinary MiniPixels `Canvas`. It works without a native GPU bridge or a window,
including headless Linux captures. It complements the existing native 3D path.

Use MiniLangCompilerPy commit
[`9c7fe12428124c97f16dfbab430ffaa1f143a1cb`](https://github.com/MiniLangProject/MiniLangCompilerPy/commit/9c7fe12428124c97f16dfbab430ffaa1f143a1cb)
or a later revision containing its call-frame fix. Earlier 1.3.12 builds can
overwrite caller locals when optional arguments extend beyond register slots.
This module's default camera/transform calls exercise that corrected path.

```minilang
import minipixels.graphics.canvas as canvas
import minipixels.graphics.geometry3d as geometry

target = canvas.create(640,480)
surface = geometry.surface(target)
camera = geometry.camera(320.0,240.0,260.0,0.0,0.0,0.0)
model = geometry.mesh()
geometry.box(model,0.0,0.0,0.0,0.5,0.7,0.2,0xd4b780ff)
geometry.clear(surface,0x101c22ff)
geometry.drawAt(surface,model,camera)
```

World X/Y form the ground plane; Z points upward. `camera` accepts screen
center, pixel scale, target position, pitch/yaw in radians, distance, and a
perspective flag. Orthographic mode preserves parallel lines. `project`
returns screen X/Y, camera depth, and visibility.

Meshes contain flat-shaded opaque triangles. Builders include `triangle`,
`quad`, `box`, `beam`, `cylinder`, and a unit `sphere`. Boxes use an X/Y center
and a base Z; beams connect two base-center positions. `drawAt` applies
translation, rotation around Z, and independent axis scales. Face lighting is
prepared in mesh-local space and is not recomputed after a transform.

Rasterization uses pixel-center scanline spans and a full-resolution unsigned
16-bit depth buffer. A unit is 1/4096 world unit. Perspective rendering
interpolates inverse depth; visible spans are sent to Canvas `fillRect`.
Submission order does not determine opaque visibility, except for equal
quantized depth. The supported depth range ends at 15.99 world units.

For a fixed scene, render static geometry to one surface and use
`copySurface(live,cached)` each frame before drawing moving meshes. This copies
both color and depth; dynamic objects remain correctly occluded by cached
geometry. Both surfaces must have the same dimensions. Memory for color and
depth is six bytes per pixel per surface, excluding mesh/runtime overhead.
The caller owns cache invalidation and canvas resizing.

Current limits are explicit: triangles crossing the near plane are rejected,
not clipped; there are no textures, transparency, antialiasing, dynamic
world-space lighting, or general shadow maps. Author a camera that keeps the
whole scene inside the supported range. Sphere gloss is an authored highlight,
not an environment reflection. Opaque RGBA colors are expected.

`tests/geometry3d_tests.ml` covers projection, depth order, rejected geometry,
empty meshes, integral floating-point depth, and preserving depth through a
static cache. Compile it with the MiniLang
Python compiler using `--target linux-x64 -I src -I <compiler-root>`, then run
the resulting executable. No display server or audio runtime is required.
