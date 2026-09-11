// SPDX-License-Identifier: Apache-2.0

//! Provides an experimental batched GPU scene canvas on Windows.
//! CPU canvases remain valid texture sources; Linux reports the backend as unsupported.

package minipixels.graphics.gpu

#if TARGET_OS == "windows"
import minipixels.math.types as mt
import minipixels.graphics.sprite as sp
import minipixels.platform.windows as win

/// @internal
extern function mpGpuInit(w as int, h as int) from "minipixels_gpu.dll" returns i32
/// @internal
extern function mpGpuResize(w as int, h as int) from "minipixels_gpu.dll" returns i32
/// @internal
extern function mpGpuSwap(interval as int) from "minipixels_gpu.dll" returns i32
/// @internal
extern function mpGpuInfo() from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuBegin() from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuClear(color as u32) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuEnd(cw as int, ch as int, x as int, y as int, w as int, h as int) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuTexture(pixels as bytes, w as int, h as int, opaque as bool) from "minipixels_gpu.dll" returns i32
/// @internal
extern function mpGpuUpdate(pixels as bytes, w as int, h as int, opaque as bool) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuResetTextures() from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuShutdown() from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuSprite(id as int, iw as int, ih as int, sx as int, sy as int, sw as int, sh as int, x as int, y as int, dw as int, dh as int, color as u32) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuRect(x as int, y as int, w as int, h as int, color as u32) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuLine(x0 as int, y0 as int, x1 as int, y1 as int, color as u32) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuCircle(x as int, y as int, r as int, color as u32) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuLightReady() from "minipixels_gpu.dll" returns i32
/// @internal
extern function mpGpuLight(cx as int, cy as int, rx as int, ry as int, r as int, g as int, b as int) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuRead(pixels as bytes) from "minipixels_gpu.dll" returns void
/// @internal
extern function mpGpuUploads() from "minipixels_gpu.dll" returns u64
/// @internal
extern function mpGpuDrawCalls() from "minipixels_gpu.dll" returns u64

retained = array(4096)
retainedCount = 0
textureGeneration = 1
active = false
activeWindow = void
activeWidth = 0
activeHeight = 0

/// Reports whether this target supports the optional GPU scene runtime.
/// @returns True on Windows; the DLL and sufficient OpenGL support are still required.
function supported() returns bool
  return true
end function

/// Releases every cached GPU texture while keeping the scene canvas active.
function resetTextures()
  global retained, retainedCount, textureGeneration
  if not active then return end if
  mpGpuResetTextures()
  retained = array(4096)
  retainedCount = 0
  textureGeneration = textureGeneration + 1
end function

/// @internal
function texture(image)
  global retained, retainedCount, textureGeneration
  if image.gpuTextureGeneration == textureGeneration and image.gpuTextureId > 0 then return image.gpuTextureId end if
  id = mpGpuTexture(image.pixels, image.width, image.height, image.opaque)
  if id > 0 then
    // Keep the allocation alive so its pointer cannot be reused as a cache key.
    if retainedCount >= len(retained) then
      larger = array(len(retained) * 2)
      for i = 0 to retainedCount - 1
        larger[i] = retained[i]
      end for
      retained = larger
    end if
    retained[retainedCount] = image
    retainedCount = retainedCount + 1
  end if
  id = mt.abs(id)
  if id > 0 then
    image.gpuTextureId = id
    image.gpuTextureGeneration = textureGeneration
  end if
  return id
end function

/// Uploads changed pixels for an image that has already been drawn by the GPU canvas.
/// @param image Mutable CPU image whose backing storage is unchanged.
function invalidate(image)
  if active then mpGpuUpdate(image.pixels, image.width, image.height, image.opaque) end if
end function

/// @internal
function drawRegion(c, image, sx, sy, sw, sh, x, y, dw, dh, tint)
  if dw <= 0 or dh <= 0 then return end if
  if x >= c.width or y >= c.height or x + dw <= 0 or y + dh <= 0 then return end if
  id = texture(image)
  if id == 0 then return end if
  mpGpuSprite(id, image.width, image.height, sx, sy, sw, sh, mt.floorInt(x), mt.floorInt(y), mt.floorInt(dw), mt.floorInt(dh), tint)
end function

/// Experimental batched render target backed by an OpenGL framebuffer.
struct GpuCanvas
  width
  height
  imageView

  /// Clears the complete scene target to an opaque color.
  /// @param color Packed RGBA clear color; the target remains opaque.
  function clear(color)
    mpGpuClear(color)
  end function

  /// Resizes and clears the GPU framebuffer.
  /// @param width New logical width.
  /// @param height New logical height.
  /// @returns True when the framebuffer was resized or already has this size.
  function resize(width, height) returns bool
    global activeWidth, activeHeight
    if width < 1 or height < 1 then return false end if
    width = mt.floorInt(width)
    height = mt.floorInt(height)
    if mpGpuResize(width, height) == 0 then return false end if
    this.width = width
    this.height = height
    activeWidth = width
    activeHeight = height
    win.setRenderSize(activeWindow, width, height)
    return true
  end function

  /// Draws a sprite at its natural size.
  /// @param spr Sprite and source region to draw.
  /// @param x Destination pivot x coordinate.
  /// @param y Destination pivot y coordinate.
  function drawSprite(spr, x, y)
    drawRegion(this, spr.image, spr.sx, spr.sy, spr.width, spr.height, x - spr.pivotX, y - spr.pivotY, spr.width, spr.height, 0xffffffff)
  end function

  /// Draws a tinted sprite at a uniform scale.
  /// @param spr Sprite and source region to draw.
  /// @param x Destination pivot x coordinate.
  /// @param y Destination pivot y coordinate.
  /// @param scale Positive uniform scale.
  /// @param tint Packed RGBA color multiplier.
  function drawSpriteScaled(spr, x, y, scale, tint)
    drawRegion(this, spr.image, spr.sx, spr.sy, spr.width, spr.height, x - spr.pivotX * scale, y - spr.pivotY * scale, spr.width * scale, spr.height * scale, tint)
  end function

  /// Draws a CPU canvas. GPU canvases are not valid sources.
  /// @param source CPU canvas to upload and draw.
  /// @param x Destination x coordinate.
  /// @param y Destination y coordinate.
  function drawCanvas(source, x, y)
    drawRegion(this, source.imageView, 0, 0, source.width, source.height, x, y, source.width, source.height, 0xffffffff)
  end function

  /// Draws a source image region without scaling.
  /// @param image CPU image to upload and draw.
  /// @param sx Source x coordinate.
  /// @param sy Source y coordinate.
  /// @param sw Source width.
  /// @param sh Source height.
  /// @param x Destination x coordinate.
  /// @param y Destination y coordinate.
  function blitRegion(image, sx, sy, sw, sh, x, y)
    drawRegion(this, image, sx, sy, sw, sh, x, y, sw, sh, 0xffffffff)
  end function

  /// Draws a filled rectangle.
  /// @param x Left coordinate.
  /// @param y Top coordinate.
  /// @param w Rectangle width.
  /// @param h Rectangle height.
  /// @param color Packed RGBA color.
  function fillRect(x, y, w, h, color)
    mpGpuRect(mt.floorInt(x), mt.floorInt(y), mt.floorInt(w), mt.floorInt(h), color)
  end function

  /// Draws a one-pixel rectangle outline.
  /// @param x Left coordinate.
  /// @param y Top coordinate.
  /// @param w Rectangle width.
  /// @param h Rectangle height.
  /// @param color Packed RGBA color.
  function drawRect(x, y, w, h, color)
    this.fillRect(x, y, w, 1, color)
    this.fillRect(x, y + h - 1, w, 1, color)
    this.fillRect(x, y + 1, 1, h - 2, color)
    this.fillRect(x + w - 1, y + 1, 1, h - 2, color)
  end function

  /// Draws a one-pixel line.
  /// @param x0 Start x coordinate.
  /// @param y0 Start y coordinate.
  /// @param x1 End x coordinate.
  /// @param y1 End y coordinate.
  /// @param color Packed RGBA color.
  function drawLine(x0, y0, x1, y1, color)
    mpGpuLine(mt.floorInt(x0), mt.floorInt(y0), mt.floorInt(x1), mt.floorInt(y1), color)
  end function

  /// Draws a filled circle.
  /// @param x Center x coordinate.
  /// @param y Center y coordinate.
  /// @param r Radius in pixels.
  /// @param color Packed RGBA color.
  function fillCircle(x, y, r, color)
    mpGpuCircle(mt.floorInt(x), mt.floorInt(y), mt.floorInt(r), color)
  end function

  /// Applies an additive screen-blend point light when shader support is available.
  /// @param x Center x coordinate.
  /// @param y Center y coordinate.
  /// @param radiusX Horizontal radius.
  /// @param radiusY Vertical radius.
  /// @param red Red light strength from zero to 255.
  /// @param green Green light strength from zero to 255.
  /// @param blue Blue light strength from zero to 255.
  /// @returns True when the optional light shader is available.
  function drawLight(x, y, radiusX, radiusY, red, green, blue) returns bool
    if mpGpuLightReady() == 0 then return false end if
    mpGpuLight(mt.floorInt(x), mt.floorInt(y), mt.floorInt(radiusX), mt.floorInt(radiusY), red, green, blue)
    return true
  end function
end struct

/// Creates the singleton GPU scene canvas for an OpenGL window.
/// @param window Window opened with the opengl renderer.
/// @param width Logical scene width.
/// @param height Logical scene height.
/// @param vsync True to synchronize buffer swaps.
function create(window, width, height, vsync)
  global active, activeWindow, activeWidth, activeHeight
  if active or window.renderer != "opengl" or width < 1 or height < 1 then return void end if
  swapInterval = 0
  if vsync then swapInterval = 1 end if
  mpGpuSwap(swapInterval)
  if mpGpuInit(width, height) == 0 then return void end if
  active = true
  activeWindow = window
  activeWidth = width
  activeHeight = height
  win.setRenderSize(window, width, height)
  window.renderer = "opengl-scene"
  return GpuCanvas(width, height, sp.Image(1, 1, bytes(4, 255), "gpu-view", true, 0, 0))
end function

/// Starts one GPU scene frame.
/// @param window Window used to create the GPU canvas.
/// @returns True when the frame was started.
function begin(window) returns bool
  if not active or window != activeWindow then return false end if
  win.updateViewport(window)
  mpGpuBegin()
  return true
end function

/// Resolves the GPU scene into the window backbuffer; call window present afterwards.
/// @param window Window used to create the GPU canvas.
/// @returns True when the scene was resolved.
function finish(window) returns bool
  if not active or window != activeWindow then return false end if
  mpGpuEnd(win.clientWidth(window), win.clientHeight(window), win.viewportX(window), win.viewportY(window), win.viewportW(window), win.viewportH(window))
  return true
end function

/// Copies the scene into an equally sized CPU canvas.
/// @param destination CPU canvas that receives straight RGBA pixels.
/// @returns True when the dimensions match and the pixels were copied.
function readback(destination) returns bool
  if not active or destination.width != activeWidth or destination.height != activeHeight then return false end if
  mpGpuRead(destination.pixels)
  destination.imageView.opaque = true
  destination.dirty = true
  destination.dirtyX0 = 0
  destination.dirtyY0 = 0
  destination.dirtyX1 = destination.width
  destination.dirtyY1 = destination.height
  return true
end function

/// Prints the current OpenGL device information to standard output.
function printInfo()
  if active then mpGpuInfo() end if
end function

/// Returns texture upload bytes recorded in the current frame.
/// @returns Number of source bytes uploaded in the current frame.
function uploadBytes() returns int
  if not active then return 0 end if
  return mpGpuUploads()
end function

/// Returns native draw calls recorded in the current frame.
/// @returns Number of native batches submitted in the current frame.
function drawCalls() returns int
  if not active then return 0 end if
  return mpGpuDrawCalls()
end function

/// Releases the GPU scene canvas and its cached textures.
function shutdown()
  global active, activeWindow, activeWidth, activeHeight, retained, retainedCount, textureGeneration
  if active then mpGpuShutdown() end if
  active = false
  activeWindow = void
  activeWidth = 0
  activeHeight = 0
  retained = array(4096)
  retainedCount = 0
  textureGeneration = textureGeneration + 1
end function

#else

/// Reports whether this target supports the optional GPU scene runtime.
/// @returns Always false on non-Windows targets.
function supported() returns bool
  return false
end function

/// GPU scene canvases are currently unavailable on non-Windows targets.
function create(window, width, height, vsync)
  return void
end function

/// Returns false because no GPU scene frame can start on this target.
function begin(window)
  return false
end function

/// Returns false because no GPU scene frame can finish on this target.
function finish(window)
  return false
end function

/// Returns false because GPU readback is unavailable on this target.
function readback(destination)
  return false
end function

/// Leaves non-Windows builds unchanged.
function resetTextures()
end function

/// Leaves non-Windows builds unchanged.
function invalidate(image)
end function

/// Leaves non-Windows builds unchanged.
function printInfo()
end function

/// Returns zero because GPU uploads are unavailable on this target.
function uploadBytes()
  return 0
end function

/// Returns zero because GPU draw calls are unavailable on this target.
function drawCalls()
  return 0
end function

/// Leaves non-Windows builds unchanged.
function shutdown()
end function

#endif
