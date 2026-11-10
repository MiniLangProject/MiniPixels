# Optional 3D scene layer

Available since MiniPixels 0.22.0. This optional Windows/OpenGL module is
independent of the CPU renderer; importing it does not enable 3D automatically.

`minipixels.graphics.scene3d` adds a Windows/OpenGL pass on an active GPU
canvas. World coordinates are tile X/Y and upward elevation Z. The isometric
projection uses `(X-Y)*32`, `(X+Y)*16-Z*27.7128129211`, plus camera and zoom.

Call `begin(cameraX,cameraY,zoom,centerX,centerY)`, draw retained meshes, then
`finish()` before submitting ordinary 2D UI. A shared depth texture is resized
with the scene. Invalid/nested passes fail explicitly. Linux reports unsupported.

Meshes: `meshBegin()`, one or more `box(...)`, `meshEnd()` returns a positive
owned handle. `draw(handle)` reuses uploaded geometry. `drawAt(...)` adds a
world translation, rotation about Z and positive scale. `release(handle)` is
idempotent. Shutdown frees the GPU resources. Handles are never recycled;
old handles cannot accidentally reference a later mesh after reinitialization.

The native `mp3dSprite` operation draws cutout billboards in the same depth
convention. It discards alpha <= 0.5 before depth writes. General translucent
materials require their own ordered pass; this is not an alpha compositor.
`mp3d::actor` is the native adapter for existing game-owned skeletal shaders.
Hollowkeep retains its asset parsers, materials and animation/equipment logic.

This initial layer deliberately retains a fixed orthographic/isometric camera.
It does not claim a complete 3D engine, automatic sprite-to-mesh conversion,
cross-platform 3D support or identical visual results to a 2D renderer.

Run `pwsh -File tests/run_scene3d.ps1` for hidden real-context GPU tests.

## Authored orthographic model composition

`beginProjected(x,y,width,height,halfExtent)` projects an existing model camera
directly into a screen viewport. It uses the same shared depth attachment and
preserves scene colour. Depth starts clean, maintaining the caller's authored
painter order between models. Call `finish()` afterwards to restore 2D state.
The depth clear is scissored to the projected rectangle. Depth outside that
rectangle survives; callers must preserve the scissor while drawing their
projected model. The regular world `begin` still clears the complete depth target.
The backend owns this scene-depth attachment. Attachment setup and completeness
validation are cached until the scene colour identity or depth dimensions change;
ordinary projected actor passes reuse them. External mutation of the backend's
private FBO attachments is outside this API contract. The pass restores the GL
state it modifies, without copying unrelated lighting/fog/evaluator state banks.

The private `mp3dBeginProjectedPass` integration hook additionally accepts
`rebindTextures=true` with `owned2D=true`. This opt-in omits the texture binding/
environment snapshot and the intermediate world projection. Its caller must
rebind every sampled texture, leave texture parameters/environments untouched,
use its own projected model transform, and invalidate the 2D texture batch.
Hollowkeep satisfies this contract; public `begin`/`beginProjected` retain full
texture state preservation and their original world-view setup.

Unlike `begin`, this operation keeps model-view coordinates in the model's
original camera space, so normal-based material lighting stays unchanged. It
also reverses winding for the removed render-texture flip, including shaders
which use `gl_FrontFacing` to distinguish garment lining from outer surfaces.

Hollowkeep's reference-look mode uses this operation with its complete existing
scenery, lighting and projected-shadow composition. Its fragment adapter applies
the authored per-column masks directly to the model. This mode deliberately
retains silhouette textures for exact shadows and special effects; it is not
the allocation-free blockout benchmark described in the initial experiment.
