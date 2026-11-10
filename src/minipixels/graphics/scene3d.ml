// SPDX-License-Identifier: Apache-2.0
//! Optional retained 3D pass. Coordinates are world X/Y and upward elevation Z.
//! begin/finish share the GPU canvas; draw ordinary 2D UI only after finish.
package minipixels.graphics.scene3d

#if TARGET_OS == "windows"
/// @internal
extern function mp3dBegin(cameraX as double,cameraY as double,zoom as double,centerX as double,centerY as double) from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dEnd() from "minipixels_gpu.dll" returns void
/// @internal
extern function mp3dBeginProjected(x as double,y as double,width as int,height as int,halfExtent as double) from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dMeshBegin() from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dBox(x as double,y as double,z as double,sx as double,sy as double,sz as double,color as u32) from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dMeshEnd() from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dMeshDraw(handle as int) from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dMeshDelete(handle as int) from "minipixels_gpu.dll" returns void
/// @internal
extern function mp3dMeshDrawAt(handle as int,x as double,y as double,z as double,yaw as double,sx as double,sy as double,sz as double) from "minipixels_gpu.dll" returns int
/// @internal
extern function mp3dMetric(field as int) from "minipixels_gpu.dll" returns u64

/// Starts a depth-tested isometric pass on the active GPU canvas.
/// @param cameraX Camera horizontal offset in pixels.
/// @param cameraY Camera vertical offset in pixels.
/// @param zoom Positive scene zoom, at most 64.
/// @param centerX Screen origin X in pixels.
/// @param centerY Screen origin Y in pixels.
/// @returns True when the pass starts; false if unavailable or invalid.
function begin(cameraX,cameraY,zoom,centerX,centerY) returns bool
  return mp3dBegin(cameraX,cameraY,zoom,centerX,centerY)==1
end function
/// Restores 2D canvas state, including matrices, shader, buffers and target.
function finish() mp3dEnd() end function
/// Composes a live orthographic model into a screen viewport. Colour is kept,
/// depth starts clean, and the model's own camera-space normals stay intact.
/// @param x Viewport left in screen pixels.
/// @param y Viewport top in screen pixels.
/// @param width Viewport width in pixels, 1 through 4096.
/// @param height Viewport height in pixels, 1 through 4096.
/// @param halfExtent Positive half extent of the model camera.
/// @returns True when the projected pass starts; false if unavailable or invalid.
function beginProjected(x,y,width,height,halfExtent) returns bool
  return mp3dBeginProjected(x,y,width,height,halfExtent)==1
end function
/// Starts construction of one immutable GPU mesh. Builders cannot nest.
/// @returns True when a new builder starts.
function meshBegin() returns bool return mp3dMeshBegin()==1 end function
/// Appends a solid box, shaded per face; nonpositive extents invalidate the build.
/// @param x World tile X origin.
/// @param y World tile Y origin.
/// @param z Upward elevation.
/// @param sx Positive width along world X.
/// @param sy Positive width along world Y.
/// @param sz Positive height along world Z.
/// @param color Packed RGBA face colour.
/// @returns True when valid geometry is appended.
function box(x,y,z,sx,sy,sz,color) returns bool return mp3dBox(x,y,z,sx,sy,sz,color)==1 end function
/// Uploads the mesh once. Zero means invalid or empty geometry.
/// @returns A positive mesh handle, or zero for an invalid or unsupported upload.
function meshEnd() returns int return mp3dMeshEnd() end function
/// Draws resident geometry without uploading vertex data again.
/// @param handle Live mesh handle returned by meshEnd.
/// @returns True when the live mesh is drawn.
function draw(handle) returns bool return mp3dMeshDraw(handle)==1 end function
/// Reuses a mesh with a world transform; yaw rotates around upward Z.
/// @param handle Live mesh handle returned by meshEnd.
/// @param x World tile X translation.
/// @param y World tile Y translation.
/// @param z Upward elevation.
/// @param yaw Rotation in degrees around world Z.
/// @param sx Positive world X scale.
/// @param sy Positive world Y scale.
/// @param sz Positive world Z scale.
/// @returns True when the transformed mesh is drawn.
function drawAt(handle,x,y,z,yaw=0,sx=1,sy=1,sz=1) returns bool
  return mp3dMeshDrawAt(handle,x,y,z,yaw,sx,sy,sz)==1
end function
/// Releases an owned mesh; stale handles are harmless and never recycled.
/// @param handle Owned mesh handle to release; stale handles are ignored.
function release(handle) mp3dMeshDelete(handle) end function
/// Draw calls, triangles, resident mesh bytes, resident mesh count.
/// @param field 0: pass draws; 1: pass triangles; 2: resident bytes; 3: resident meshes.
function metric(field) return mp3dMetric(field) end function
#else
/// @param cameraX Camera horizontal offset in pixels.
/// @param cameraY Camera vertical offset in pixels.
/// @param zoom Positive scene zoom, at most 64.
/// @param centerX Screen origin X in pixels.
/// @param centerY Screen origin Y in pixels.
/// @returns True when the pass starts; false if unavailable or invalid.
function begin(cameraX,cameraY,zoom,centerX,centerY) returns bool return false end function
function finish() end function
/// @param x Viewport left in screen pixels.
/// @param y Viewport top in screen pixels.
/// @param width Viewport width in pixels, 1 through 4096.
/// @param height Viewport height in pixels, 1 through 4096.
/// @param halfExtent Positive half extent of the model camera.
/// @returns True when the projected pass starts; false if unavailable or invalid.
function beginProjected(x,y,width,height,halfExtent) returns bool return false end function
/// @returns True when a new builder starts.
function meshBegin() returns bool return false end function
/// @param x World tile X origin.
/// @param y World tile Y origin.
/// @param z Upward elevation.
/// @param sx Positive width along world X.
/// @param sy Positive width along world Y.
/// @param sz Positive height along world Z.
/// @param color Packed RGBA face colour.
/// @returns True when valid geometry is appended.
function box(x,y,z,sx,sy,sz,color) returns bool return false end function
/// @returns A positive mesh handle, or zero for an invalid or unsupported upload.
function meshEnd() returns int return 0 end function
/// @param handle Live mesh handle returned by meshEnd.
/// @returns True when the live mesh is drawn.
function draw(handle) returns bool return false end function
/// @param handle Live mesh handle returned by meshEnd.
/// @param x World tile X translation.
/// @param y World tile Y translation.
/// @param z Upward elevation.
/// @param yaw Rotation in degrees around world Z.
/// @param sx Positive world X scale.
/// @param sy Positive world Y scale.
/// @param sz Positive world Z scale.
/// @returns True when the transformed mesh is drawn.
function drawAt(handle,x,y,z,yaw=0,sx=1,sy=1,sz=1) returns bool return false end function
/// @param handle Owned mesh handle to release; stale handles are ignored.
function release(handle) end function
/// @param field 0: pass draws; 1: pass triangles; 2: resident bytes; 3: resident meshes.
function metric(field) return 0 end function
#endif
