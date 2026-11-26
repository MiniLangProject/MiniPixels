# Portable Canvas 3D geometry

`minipixels.graphics.geometry3d` is a MiniLang CPU triangle renderer for an
ordinary MiniPixels `Canvas`. It supports headless Linux captures without a
native GPU bridge or a window. It complements the existing native 3D path.

Use MiniLangCompilerPy commit
[`9c7fe12428124c97f16dfbab430ffaa1f143a1cb`](https://github.com/MiniLangProject/MiniLangCompilerPy/commit/9c7fe12428124c97f16dfbab430ffaa1f143a1cb)
or a later revision containing its call-frame fix. Earlier 1.3.12 builds can
overwrite caller locals when optional arguments extend beyond register slots.
The module's default camera and transform calls use that corrected path.

## Geometry and cameras

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

Builders include `triangle`, `quad`, `box`, `beam`, `cylinder`, and a unit
`sphere`. Boxes use an X/Y center and base Z; beams connect two base-center
positions. `drawAt` applies translation, rotation around Z, and independent
axis scales. Face lighting is prepared in mesh-local space and is not
recomputed after a transform. Flat and textured triangles can share a mesh.

## Textured triangles and cutouts

```minilang
import minipixels.assets.png as png

art = png.load("playfield.png")
material = geometry.texture(art,0xffffffff,128,true)
geometry.texturedQuad(model,
  geometry.Point(-0.3,0.0,0.001),
  geometry.Point( 0.3,0.0,0.001),
  geometry.Point( 0.3,1.2,0.001),
  geometry.Point(-0.3,1.2,0.001),material)
```

`texture(image,tint=0xffffffff,alphaCutoff=128,bilinear=true)` accepts a
MiniPixels `Image` and returns a material or an error for invalid images.
The material shares its source pixel buffer and snapshots image dimensions
and opacity. Treat the image as immutable while the material is in use;
create a new material after replacing or modifying source pixels or opacity.

`texturedTriangle(mesh,a,b,c,uvA,uvB,uvC,material,lit=false)` appends a triangle
with independent `Point` and `UV(u,v)` vertices.
`texturedQuad(mesh,a,b,c,d,material,uvs=void,lit=false)` appends two triangles.
Both return a boolean and reject invalid material/UV-array arguments.
The default quad order is bottom-left, bottom-right, top-right, top-left;
its default UVs are (0,1), (1,1), (1,0), (0,0). V=0 denotes the image's top.
A four-element UV array supports atlas regions and rectifying diamond-shaped
isometric image crops onto a real mesh face. UV values are clamped to [0,1].

Perspective rasterization interpolates inverse camera depth, U/depth and
V/depth, then divides to recover the sample coordinates. Orthographic
rasterization interpolates U and V directly. This preserves a coherent
perspective across a printed floor or other tilted quad instead of affinely
stretching each triangle. `sampleTexture(material,u,v)` also exposes the
same sampler for direct tests.

Bilinear filtering is enabled by default; false selects nearest-neighbor
sampling. For images with transparency, bilinear sampling interpolates
premultiplied color and alpha before recovering RGB. Transparent edge colors
therefore do not produce black or white fringes. Tint multiplies RGB only;
`lit=true` additionally applies the same local face lighting as flat geometry.

Alpha uses **cutout coverage**, not blended glass: samples below the cutoff
write neither color nor depth; surviving samples write opaque color and depth.
The cutoff is clamped to 1–255. Transparent sprite backgrounds can therefore
reveal both previously drawn and later depth-tested geometry through their
holes. Partially transparent texture samples are not composited as translucent
surfaces. Source images should have appropriate coverage for their chosen
cutoff; the renderer does not perform multisample edge antialiasing.

## Depth and scene caches

Rasterization uses pixel-center scanline coverage and a full-resolution
unsigned 16-bit depth buffer. One unit is 1/4096 world unit. Perspective
rendering interpolates inverse depth. Flat spans use Canvas `fillRect`;
textured spans depth-test and sample directly into the same Canvas pixels.
Submission order does not determine opaque visibility, except for equal
quantized depth. The supported depth range ends at 15.99 world units.

For a fixed scene, render static geometry once and call
`copySurface(live,cached)` each frame before drawing moving meshes. The copy
includes color, depth, and the source Canvas opacity metadata, including
transparent holes. Dynamic objects remain correctly occluded by cached
geometry; compositing a transparent copied Canvas keeps its alpha behavior.
Both surfaces must have the same dimensions. Memory for color and depth is
six bytes per pixel per surface, excluding textures, meshes and runtime
overhead. The caller owns cache invalidation and Canvas resizing. Immutable
textured scenery can be cached without repeating texture sampling each frame.

## Limits and focused tests

Triangles crossing the near plane are rejected, not clipped. There is no
texture mipmapping, anisotropic filtering, automatic mesh importer, GPU
triangle submission, general translucent-surface sorting, dynamic world-space
lighting, or shadow mapping. Author cameras inside the supported depth range.
Sphere gloss is an authored highlight, not an environment reflection.
Flat-color alpha follows Canvas blending and still writes depth; it is useful
for deliberately ordered planar decals, not a general transparent 3D material.

`tests/geometry3d_tests.ml` covers projection, submission-order-independent
depth, near-plane rejection, empty meshes, integral floating-point depth,
static depth caches, a genuinely perspective-interpolated texture lookup,
bilinear colors and transparent-border halos, and alpha cutouts preserving
depth holes. The transparent-cache regression also checks opacity metadata,
Canvas compositing, subsequent geometry through holes, and cache immutability.

Compile with the MiniLang Python compiler using
`--target linux-x64 -I src -I <compiler-root>`, then run the resulting
executable. The generic tests create their tiny textures in memory and need
neither a display server nor the audio/image-decoding native runtime.
