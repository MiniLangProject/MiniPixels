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

### Small native-resolution pose patches

`captureDepthPatch(surface,x,y,width,height)` copies a clipped integer rectangle
into an owned `DepthPatch`. Its `pixels` and `depth` buffers use six bytes per
pixel; `x/y` retain the original screen origin and `frameWidth/frameHeight`
retain the full source viewport. Rasterize an isolated fixed pose onto a
**full-resolution** cleared surface with the original camera, then capture its
small covered region. Reuse that scratch surface for other poses. Moving or
cropping the camera to rasterize directly into a small target can introduce
different floating-point rounding and is not this cache's contract.

```minilang
scratch = geometry.surface(canvas.create(640,480))
geometry.clear(scratch,0x00000000)
canvas.resetDirty(scratch.canvas)
geometry.drawAt(scratch,preparedPose,camera)
patch = geometry.captureDepthPatch(scratch,
  scratch.canvas.dirtyX0,scratch.canvas.dirtyY0,
  scratch.canvas.dirtyX1-scratch.canvas.dirtyX0,
  scratch.canvas.dirtyY1-scratch.canvas.dirtyY0)

// After the scene's ordinary color/depth restore:
geometry.drawDepthPatch(surface,patch)
```

`drawDepthPatch` tests each stored depth against the destination using the same
`<=` tie rule as direct rasterization. Clear depth (`65535`) never writes color
or depth, so alpha-cutout holes preserve both earlier scenery and later geometry.
No rescaling, interpolation or reprojection occurs. Nearer moving geometry can
be submitted before or after the patch. Visible writes mark the bounded Canvas
region dirty; empty and fully occluded patches are clean no-ops. Existing Canvas
opacity metadata stays conservative, including untouched transparent pixels.

This API is for opaque geometry and alpha cutouts. The caller must not flatten
blended translucent layers or planar shadow overlays into an opaque pose patch.
Visible source pixels whose alpha is not 255 are rejected. Color already blended
over an opaque background cannot be identified retrospectively; capture an
isolated pose on a transparent cleared surface. Capture errors 8310–8313 identify
invalid surfaces, noninteger/negative rectangles and nonopaque visible pixels.
Empty or entirely out-of-bounds rectangles produce valid empty patches instead.
Huge requested extents are clipped before allocation, without computing an
overflow-prone `x+width` or `y+height`.

Patches own their buffers independently of the scratch surface. Treat them as
immutable and rebuild after any pose, lighting, camera or resolution change.
Drawing returns false for invalid storage, invalid extents or a different
destination viewport; valid draws, including no-ops, return true. This catches
stale resized caches rather than stretching them. A patch adds no triangles to
the surface's rasterization statistics because it reuses already rasterized data.

## World-space lighting and physical materials

`lighting(x,y,z,ambient,color,intensity)` creates a directional key pointing
toward its source, with RGB ambient light. `addPointLight` adds a finite colored
point source with a smooth squared falloff to its range. `drawLitAt` evaluates
Lambert diffuse and optional view-dependent Blinn specular terms after the
mesh's actual translation, rotation and nonuniform scale. The key and point
directions therefore remain in world space as an object turns. Lit faces are
backface-culled by default; the final `cullBackfaces=false` argument retains
two-sided drawing when needed.

Mesh construction retains the original albedo and lit/unlit flags alongside
the legacy baked colors. `drawAt` remains compatible with existing scenes;
`drawLitAt` does not mutate those cached colors. Set `specular` and `shininess`
for polished surfaces. Flat shading is evaluated at each face's centroid; this
is direct lighting, not a physically based material pipeline or indirect/global
illumination. `repeatingTexture` wraps positive and negative UV coordinates
for material grain expressed in physical world units; ordinary `texture`
continues to clamp UVs for artwork and atlases.

`bakeLitMesh` evaluates a fixed pose once and returns its already lit geometry
in world space. Draw that result with `drawAt` without applying the original
transform again. It retains depth and texture behavior, and must be regenerated
after changing the lighting, view or pose. This avoids shading stationary
mechanisms repeatedly while still depth-testing them against the scene.

## Occluder depth maps and moving contact shadows

Render real opaque caster geometry using `drawDepthAt(shadow,mesh,lightCamera)`
into an ordinary `Surface`. An orthographic light camera represents a
directional light. `applyShadowMap(receiver,viewCamera,shadow,lightCamera)`
reconstructs every visible receiver pixel's world position from its depth,
compares it against the caster map, and applies four-tap edge filtering.
Receivers can be vertical, sloping or elevated. Cache the resulting static
color and depth, so static shadow mapping does not repeat every frame.

For moving lit meshes, assign `lights.shadow`, `lights.shadowCamera` and
optionally `lights.shadowBias` to the same map. Their directional diffuse and
specular terms then respect the static occluders at each face. Point sources do
not automatically acquire their own shadow maps. Opaque `drawDepthAt` ignores
texture cutouts; use `drawAt` for alpha-cutout casters when their holes matter.

`shadowMask(surface)` starts a non-accumulating dynamic shadow layer.
`drawPlanarShadowAt` projects a **closed mesh's actual source-facing silhouette**
along the directional source onto a chosen horizontal support plane. The
receiver's depth prevents the decal from painting across foreground geometry,
and one shared mask prevents overlapping triangles or casters from multiplying
darkness. These moving contact shadows assume a planar receiver; they do not
replace general dynamic shadow maps or shadow volumes.

## Limits and focused tests

Triangles crossing the near plane are rejected, not clipped. There is no
texture mipmapping, anisotropic filtering, automatic mesh importer, GPU
triangle submission, general translucent-surface sorting, per-pixel normal
mapping, indirect illumination or environment reflections. Author cameras
inside the supported depth range. The legacy `sphere(...,gloss=true)` highlight
is authored; use a neutral sphere with `drawLitAt` for actual light-dependent
specular response. Shadow depth shares the 16-bit depth quantization; choose
camera bounds, resolution and bias for the scene's physical scale.
Flat-color alpha follows Canvas blending and still writes depth; it is useful
for deliberately ordered planar decals, not a general transparent 3D material.

`tests/geometry3d_tests.ml` covers projection, submission-order-independent
depth, near-plane rejection, empty meshes, integral floating-point depth,
static depth caches, a genuinely perspective-interpolated texture lookup,
bilinear colors and transparent-border halos, and alpha cutouts preserving
depth holes. The transparent-cache regression also checks opacity metadata,
Canvas compositing, subsequent geometry through holes, and cache immutability.
The lighting regressions additionally cover directional changes, finite colored
point lights, immutable albedo, moving real occluders and reconstructed shadow
receivers, non-accumulating planar shadows, world-UV repetition, and exact
framebuffer/depth parity between live and cached fixed-pose lighting.
Pose-patch regressions additionally compare exact color and depth with direct
geometry through both front/back submission orders, preserve textured cutout
holes, verify owned storage after the scratch source changes, and exercise
clipping, huge/invalid bounds, opacity rejection, stale viewport rejection,
dirty tracking and fully occluded no-ops.

Compile with the MiniLang Python compiler using
`--target linux-x64 -I src -I <compiler-root>`, then run the resulting
executable. The generic tests create their tiny textures in memory and need
neither a display server nor the audio/image-decoding native runtime.
