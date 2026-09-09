// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels graphics canvas facilities for this project.

package minipixels.graphics.canvas

import minipixels.math.types as mt
import minipixels.graphics.sprite as sp
import std.math as math

/// Represents the canvas data used by the minipixels graphics canvas module.
struct Canvas
  /// Stores the width value associated with canvas.
  width as int
  /// Stores the height value associated with canvas.
  height as int
  /// Stores the pixels value associated with canvas.
  pixels as bytes
  /// Stores the camera x value associated with canvas.
  cameraX
  /// Stores the camera y value associated with canvas.
  cameraY
  /// Stores the sprite count value associated with canvas.
  spriteCount as int
  /// Stores the tile count value associated with canvas.
  tileCount as int
  /// Stores the draw calls value associated with canvas.
  drawCalls as int
  /// Image view sharing this canvas's pixel storage.
  imageView
  /// Whether the canvas contains pixels not yet uploaded by a presenter.
  dirty
  /// Inclusive minimum dirty x coordinate.
  dirtyX0
  /// Inclusive minimum dirty y coordinate.
  dirtyY0
  /// Exclusive maximum dirty x coordinate.
  dirtyX1
  /// Exclusive maximum dirty y coordinate.
  dirtyY1

  /// Clears clear maintained by the minipixels graphics canvas module.
  /// @param color color value consumed by this operation.
  function clear(color)
    return minipixels.graphics.canvas.clearCanvas(this, color)
  end function

  /// Updates pixel maintained by the minipixels graphics canvas module.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param color color value consumed by this operation.
  function setPixel(x, y, color)
    return minipixels.graphics.canvas.setPixel(this, x, y, color)
  end function

  /// Returns pixel maintained by the minipixels graphics canvas module.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function getPixel(x, y)
    return minipixels.graphics.canvas.getPixel(this, x, y)
  end function

  /// Draws line through the minipixels graphics canvas rendering path.
  /// @param x1 x1 value consumed by this operation.
  /// @param y1 y1 value consumed by this operation.
  /// @param x2 x2 value consumed by this operation.
  /// @param y2 y2 value consumed by this operation.
  /// @param color color value consumed by this operation.
  function drawLine(x1, y1, x2, y2, color)
    return minipixels.graphics.canvas.drawLine(this, x1, y1, x2, y2, color)
  end function

  /// Draws rect through the minipixels graphics canvas rendering path.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param w w value consumed by this operation.
  /// @param h h value consumed by this operation.
  /// @param color color value consumed by this operation.
  function drawRect(x, y, w, h, color)
    return minipixels.graphics.canvas.drawRect(this, x, y, w, h, color)
  end function

  /// Performs the fillRect operation for the minipixels graphics canvas canvas module.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param w w value consumed by this operation.
  /// @param h h value consumed by this operation.
  /// @param color color value consumed by this operation.
  function fillRect(x, y, w, h, color)
    return minipixels.graphics.canvas.fillRect(this, x, y, w, h, color)
  end function

  /// Draws circle through the minipixels graphics canvas rendering path.
  /// @param cx cx value consumed by this operation.
  /// @param cy cy value consumed by this operation.
  /// @param r r value consumed by this operation.
  /// @param color color value consumed by this operation.
  function drawCircle(cx, cy, r, color)
    return minipixels.graphics.canvas.drawCircle(this, cx, cy, r, color)
  end function

  /// Performs the fillCircle operation for the minipixels graphics canvas canvas module.
  /// @param cx cx value consumed by this operation.
  /// @param cy cy value consumed by this operation.
  /// @param r r value consumed by this operation.
  /// @param color color value consumed by this operation.
  function fillCircle(cx, cy, r, color)
    return minipixels.graphics.canvas.fillCircle(this, cx, cy, r, color)
  end function

  /// Performs the blit operation for the minipixels graphics canvas canvas module.
  /// @param image image value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function blit(image, x, y)
    return minipixels.graphics.canvas.blitImage(this, image, x, y)
  end function

  /// Performs the blitRegion operation for the minipixels graphics canvas canvas module.
  /// @param image image value consumed by this operation.
  /// @param sx sx value consumed by this operation.
  /// @param sy sy value consumed by this operation.
  /// @param sw sw value consumed by this operation.
  /// @param sh sh value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function blitRegion(image, sx, sy, sw, sh, x, y)
    return minipixels.graphics.canvas.blitRegion(this, image, sx, sy, sw, sh, x, y)
  end function

  /// Draws sprite through the minipixels graphics canvas rendering path.
  /// @param sprite sprite value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function drawSprite(sprite, x, y)
    return minipixels.graphics.canvas.drawSprite(this, sprite, x, y)
  end function

  /// Draws sprite ex through the minipixels graphics canvas rendering path.
  /// @param sprite sprite value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param flipX flipX value consumed by this operation.
  /// @param flipY flipY value consumed by this operation.
  /// @param scale scale value consumed by this operation.
  /// @param tint tint value consumed by this operation.
  function drawSpriteEx(sprite, x, y, flipX, flipY, scale, tint)
    return minipixels.graphics.canvas.drawSpriteEx(this, sprite, x, y, flipX, flipY, scale, tint)
  end function

  /// Draws a sprite with an arbitrary positive nearest-neighbour scale.
  /// @param sprite Sprite to draw.
  /// @param x Destination x coordinate.
  /// @param y Destination y coordinate.
  /// @param scale Positive fractional or integral scale.
  /// @param tint Multiplicative RGBA tint.
  function drawSpriteScaled(sprite, x, y, scale, tint)
    return minipixels.graphics.canvas.drawSpriteScaled(this, sprite, x, y, scale, tint)
  end function

  /// Draws a sprite rotated around its configured pivot.
  /// @param sprite Sprite to draw.
  /// @param x Pivot x coordinate.
  /// @param y Pivot y coordinate.
  /// @param radians Clockwise rotation in radians.
  /// @param scale Positive integer scale.
  /// @param tint Multiplicative RGBA tint.
  function drawSpriteRotated(sprite, x, y, radians, scale, tint)
    return minipixels.graphics.canvas.drawSpriteRotated(this, sprite, x, y, radians, scale, tint)
  end function

  /// Draws another canvas as a CPU render target.
  /// @param source Source canvas.
  /// @param x Destination x coordinate.
  /// @param y Destination y coordinate.
  function drawCanvas(source, x, y)
    return minipixels.graphics.canvas.drawCanvas(this, source, x, y)
  end function

  /// Performs the fillRectWorld operation for the minipixels graphics canvas canvas module.
  /// @param camera camera value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param w w value consumed by this operation.
  /// @param h h value consumed by this operation.
  /// @param color color value consumed by this operation.
  function fillRectWorld(camera, x, y, w, h, color)
    return minipixels.graphics.canvas.fillRectWorld(this, camera, x, y, w, h, color)
  end function

  /// Draws rect world through the minipixels graphics canvas rendering path.
  /// @param camera camera value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param w w value consumed by this operation.
  /// @param h h value consumed by this operation.
  /// @param color color value consumed by this operation.
  function drawRectWorld(camera, x, y, w, h, color)
    return minipixels.graphics.canvas.drawRectWorld(this, camera, x, y, w, h, color)
  end function

  /// Draws sprite world through the minipixels graphics canvas rendering path.
  /// @param camera camera value consumed by this operation.
  /// @param sprite sprite value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function drawSpriteWorld(camera, sprite, x, y)
    return minipixels.graphics.canvas.drawSpriteWorld(this, camera, sprite, x, y)
  end function

  /// Draws sprite world ex through the minipixels graphics canvas rendering path.
  /// @param camera camera value consumed by this operation.
  /// @param sprite sprite value consumed by this operation.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  /// @param flipX flipX value consumed by this operation.
  /// @param flipY flipY value consumed by this operation.
  /// @param scale scale value consumed by this operation.
  /// @param tint tint value consumed by this operation.
  function drawSpriteWorldEx(camera, sprite, x, y, flipX, flipY, scale, tint)
    return minipixels.graphics.canvas.drawSpriteWorldEx(this, camera, sprite, x, y, flipX, flipY, scale, tint)
  end function

  /// Performs the beginCamera operation for the minipixels graphics canvas canvas module.
  /// @param camera camera value consumed by this operation.
  function beginCamera(camera)
    this.cameraX = camera.x
    this.cameraY = camera.y
  end function

  /// Performs the endCamera operation for the minipixels graphics canvas canvas module.
  function endCamera()
    this.cameraX = 0
    this.cameraY = 0
  end function

  /// Reallocates this framebuffer and discards its previous pixels.
  /// @param width New pixel width.
  /// @param height New pixel height.
  function resize(width, height)
    return minipixels.graphics.canvas.resize(this, width, height)
  end function
end struct

/// Creates create for the minipixels graphics canvas module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function create(width, height)
  pixels = bytes(width * height * 4, 0)
  view = sp.Image(width, height, pixels, "render-target", false)
  return Canvas(width, height, pixels, 0, 0, 0, 0, 0, view, true, 0, 0, width, height)
end function

/// Reallocate a canvas while preserving the Canvas object itself.
/// Existing pixel contents are discarded and the new surface starts transparent.
/// @param c Canvas to resize.
/// @param width New pixel width.
/// @param height New pixel height.
function resize(c, width, height)
  if not (c is Canvas) then return false end if
  width = mt.floorInt(width)
  height = mt.floorInt(height)
  if width < 1 or height < 1 then return false end if
  if c.width == width and c.height == height then return false end if
  pixels = bytes(width * height * 4, 0)
  c.width = width
  c.height = height
  c.pixels = pixels
  c.imageView = sp.Image(width, height, pixels, "render-target", false)
  c.dirty = true
  c.dirtyX0 = 0
  c.dirtyY0 = 0
  c.dirtyX1 = width
  c.dirtyY1 = height
  return true
end function

/// Expands the pending upload region to include a rectangle.
/// @param c Canvas to mark.
/// @param x Rectangle x coordinate in canvas space.
/// @param y Rectangle y coordinate in canvas space.
/// @param w Rectangle width.
/// @param h Rectangle height.
function markDirty(c, x, y, w, h)
  x0 = mt.clamp(mt.floorInt(x), 0, c.width)
  y0 = mt.clamp(mt.floorInt(y), 0, c.height)
  x1 = mt.clamp(mt.floorInt(x + w), 0, c.width)
  y1 = mt.clamp(mt.floorInt(y + h), 0, c.height)
  if x0 >= x1 or y0 >= y1 then return end if
  if c.dirty == false then
    c.dirtyX0 = x0
    c.dirtyY0 = y0
    c.dirtyX1 = x1
    c.dirtyY1 = y1
    c.dirty = true
    return
  end if
  if x0 < c.dirtyX0 then c.dirtyX0 = x0 end if
  if y0 < c.dirtyY0 then c.dirtyY0 = y0 end if
  if x1 > c.dirtyX1 then c.dirtyX1 = x1 end if
  if y1 > c.dirtyY1 then c.dirtyY1 = y1 end if
end function

/// Clears the pending upload region after presentation.
/// @param c Canvas whose dirty state is consumed.
function resetDirty(c)
  c.dirty = false
  c.dirtyX0 = 0
  c.dirtyY0 = 0
  c.dirtyX1 = 0
  c.dirtyY1 = 0
end function

/// Performs the resetStats operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
function resetStats(c)
  c.spriteCount = 0
  c.tileCount = 0
  c.drawCalls = 0
end function

/// Performs the index operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function inline index(c, x, y)
  return ((y * c.width) + x) * 4
end function

/// Clears canvas maintained by the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param color color value consumed by this operation.
function clearCanvas(c, color)
  r = mt.colorR(color)
  g = mt.colorG(color)
  b = mt.colorB(color)
  a = mt.colorA(color)
  n = len(c.pixels)
  if n >= 4 then
    c.pixels[0] = r
    c.pixels[1] = g
    c.pixels[2] = b
    c.pixels[3] = a
    filled = 4
    while filled < n
      amount = filled
      if amount > n - filled then amount = n - filled end if
      copyBytes(c.pixels, filled, c.pixels, 0, amount)
      filled = filled + amount
    end while
  end if
  c.imageView.opaque = a >= 255
  markDirty(c, 0, 0, c.width, c.height)
  c.drawCalls = c.drawCalls + 1
end function

/// Updates pixel maintained by the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function setPixel(c, x, y, color)
  x = mt.floorInt(x - c.cameraX)
  y = mt.floorInt(y - c.cameraY)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return false end if
  i = index(c, x, y)
  c.pixels[i] = mt.colorR(color)
  c.pixels[i + 1] = mt.colorG(color)
  c.pixels[i + 2] = mt.colorB(color)
  c.pixels[i + 3] = mt.colorA(color)
  if mt.colorA(color) < 255 then c.imageView.opaque = false end if
  markDirty(c, x, y, 1, 1)
  return true
end function

/// Performs the blendPixelRaw operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function blendPixelRaw(c, x, y, color)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return false end if
  i = index(c, x, y)
  dst = mt.rgba(c.pixels[i], c.pixels[i + 1], c.pixels[i + 2], c.pixels[i + 3])
  blended = mt.alphaBlend(dst, color)
  c.pixels[i] = mt.colorR(blended)
  c.pixels[i + 1] = mt.colorG(blended)
  c.pixels[i + 2] = mt.colorB(blended)
  c.pixels[i + 3] = mt.colorA(blended)
  return true
end function

/// Returns pixel maintained by the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function getPixel(c, x, y)
  x = mt.floorInt(x - c.cameraX)
  y = mt.floorInt(y - c.cameraY)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return 0 end if
  i = index(c, x, y)
  return mt.rgba(c.pixels[i], c.pixels[i + 1], c.pixels[i + 2], c.pixels[i + 3])
end function

/// Performs the blendPixel operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function blendPixel(c, x, y, color)
  if mt.colorA(color) >= 255 then
    return setPixel(c, x, y, color)
  end if
  dst = getPixel(c, x, y)
  return setPixel(c, x, y, mt.alphaBlend(dst, color))
end function

/// Draws pixel fast through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function drawPixelFast(c, x, y, color)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return false end if
  a = mt.colorA(color)
  if a <= 0 then return false end if
  if a >= 255 then
    i = index(c, x, y)
    c.pixels[i] = mt.colorR(color)
    c.pixels[i + 1] = mt.colorG(color)
    c.pixels[i + 2] = mt.colorB(color)
    c.pixels[i + 3] = a
    return true
  end if
  return blendPixel(c, x, y, color)
end function

/// Performs the fillRect operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function fillRect(c, x, y, w, h, color)
  if w <= 0 or h <= 0 then return end if
  x = mt.floorInt(x - c.cameraX)
  y = mt.floorInt(y - c.cameraY)
  w = mt.floorInt(w)
  h = mt.floorInt(h)
  x0 = mt.clamp(x, 0, c.width)
  y0 = mt.clamp(y, 0, c.height)
  x1 = mt.clamp(x + w, 0, c.width)
  y1 = mt.clamp(y + h, 0, c.height)
  a = mt.colorA(color)
  r = mt.colorR(color)
  g = mt.colorG(color)
  b = mt.colorB(color)
  if x0 < x1 and y0 < y1 and a >= 255 then
    rowStart = index(c, x0, y0)
    rowBytes = (x1 - x0) * 4
    c.pixels[rowStart] = r
    c.pixels[rowStart + 1] = g
    c.pixels[rowStart + 2] = b
    c.pixels[rowStart + 3] = a
    filled = 4
    while filled < rowBytes
      amount = filled
      if amount > rowBytes - filled then amount = rowBytes - filled end if
      copyBytes(c.pixels, rowStart + filled, c.pixels, rowStart, amount)
      filled = filled + amount
    end while
    yy = y0 + 1
    while yy < y1
      copyBytes(c.pixels, index(c, x0, yy), c.pixels, rowStart, rowBytes)
      yy = yy + 1
    end while
  else
    yy = y0
    while yy < y1
      xx = x0
      while xx < x1
        blendPixelRaw(c, xx, yy, color)
        xx = xx + 1
      end while
      yy = yy + 1
    end while
  end if
  if a < 255 then c.imageView.opaque = false end if
  markDirty(c, x0, y0, x1 - x0, y1 - y0)
  c.drawCalls = c.drawCalls + 1
end function

/// Draws rect through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function drawRect(c, x, y, w, h, color)
  drawLine(c, x, y, x + w - 1, y, color)
  drawLine(c, x, y + h - 1, x + w - 1, y + h - 1, color)
  drawLine(c, x, y, x, y + h - 1, color)
  drawLine(c, x + w - 1, y, x + w - 1, y + h - 1, color)
end function

/// Draws line through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param x1 x1 value consumed by this operation.
/// @param y1 y1 value consumed by this operation.
/// @param x2 x2 value consumed by this operation.
/// @param y2 y2 value consumed by this operation.
/// @param color color value consumed by this operation.
function drawLine(c, x1, y1, x2, y2, color)
  x1 = mt.floorInt(x1)
  y1 = mt.floorInt(y1)
  x2 = mt.floorInt(x2)
  y2 = mt.floorInt(y2)
  dx = mt.abs(x2 - x1)
  dy = 0 - mt.abs(y2 - y1)
  sx = -1
  sy = -1
  if x1 < x2 then sx = 1 end if
  if y1 < y2 then sy = 1 end if
  err = dx + dy
  while true
    setPixel(c, x1, y1, color)
    if x1 == x2 and y1 == y2 then break end if
    e2 = 2 * err
    if e2 >= dy then
      err = err + dy
      x1 = x1 + sx
    end if
    if e2 <= dx then
      err = err + dx
      y1 = y1 + sy
    end if
  end while
  c.drawCalls = c.drawCalls + 1
end function

/// Draws circle through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param cx cx value consumed by this operation.
/// @param cy cy value consumed by this operation.
/// @param r r value consumed by this operation.
/// @param color color value consumed by this operation.
function drawCircle(c, cx, cy, r, color)
  x = r
  y = 0
  err = 0
  while x >= y
    setPixel(c, cx + x, cy + y, color)
    setPixel(c, cx + y, cy + x, color)
    setPixel(c, cx - y, cy + x, color)
    setPixel(c, cx - x, cy + y, color)
    setPixel(c, cx - x, cy - y, color)
    setPixel(c, cx - y, cy - x, color)
    setPixel(c, cx + y, cy - x, color)
    setPixel(c, cx + x, cy - y, color)
    y = y + 1
    if err <= 0 then
      err = err + (2 * y) + 1
    else
      x = x - 1
      err = err - (2 * x) + 1
    end if
  end while
  c.drawCalls = c.drawCalls + 1
end function

/// Performs the fillCircle operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param cx cx value consumed by this operation.
/// @param cy cy value consumed by this operation.
/// @param r r value consumed by this operation.
/// @param color color value consumed by this operation.
function fillCircle(c, cx, cy, r, color)
  if r < 0 then return end if
  previousDrawCalls = c.drawCalls
  x = r
  y = 0
  decision = 1 - r
  while y <= x
    fillRect(c, cx - x, cy + y, (x * 2) + 1, 1, color)
    if y != 0 then fillRect(c, cx - x, cy - y, (x * 2) + 1, 1, color) end if
    if x != y then
      fillRect(c, cx - y, cy + x, (y * 2) + 1, 1, color)
      if x != 0 then fillRect(c, cx - y, cy - x, (y * 2) + 1, 1, color) end if
    end if
    y = y + 1
    if decision < 0 then
      decision = decision + (2 * y) + 1
    else
      x = x - 1
      decision = decision + (2 * (y - x)) + 1
    end if
  end while
  c.drawCalls = previousDrawCalls + 1
end function

/// Performs the blitImage operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param img img value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function blitImage(c, img, x, y)
  return blitRegion(c, img, 0, 0, img.width, img.height, x, y)
end function

/// Performs the blitRegion operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param img img value consumed by this operation.
/// @param sx sx value consumed by this operation.
/// @param sy sy value consumed by this operation.
/// @param sw sw value consumed by this operation.
/// @param sh sh value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function blitRegion(c, img, sx, sy, sw, sh, x, y)
  spr = sp.Sprite(img, sx, sy, sw, sh, 0, 0, img.name)
  return drawSpriteEx(c, spr, x, y, false, false, 1, mt.rgba(255, 255, 255, 255))
end function

/// Draws sprite through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param spr spr value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function drawSprite(c, spr, x, y)
  return drawSpriteEx(c, spr, x, y, false, false, 1, mt.rgba(255, 255, 255, 255))
end function

/// Performs the fillScaledPixel operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function fillScaledPixel(c, x, y, scale, color)
  a = mt.colorA(color)
  if a <= 0 then return end if
  x0 = mt.clamp(x, 0, c.width)
  y0 = mt.clamp(y, 0, c.height)
  x1 = mt.clamp(x + scale, 0, c.width)
  y1 = mt.clamp(y + scale, 0, c.height)
  if x0 >= x1 or y0 >= y1 then return end if
  r = mt.colorR(color)
  g = mt.colorG(color)
  b = mt.colorB(color)
  yy = y0
  while yy < y1
    xx = x0
    while xx < x1
      if a >= 255 then
        i = index(c, xx, yy)
        c.pixels[i] = r
        c.pixels[i + 1] = g
        c.pixels[i + 2] = b
        c.pixels[i + 3] = a
      else
        blendPixel(c, xx, yy, color)
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
end function

/// Draws sprite fast1x through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param spr spr value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function drawSpriteFast1x(c, spr, x, y)
  x0 = mt.clamp(x, 0, c.width)
  y0 = mt.clamp(y, 0, c.height)
  x1 = mt.clamp(x + spr.width, 0, c.width)
  y1 = mt.clamp(y + spr.height, 0, c.height)
  if x0 >= x1 or y0 >= y1 then return end if
  markDirty(c, x0, y0, x1 - x0, y1 - y0)
  destinationOpaque = c.imageView.opaque
  // Source-over compositing cannot make an opaque destination transparent.
  // Keep the flag so subsequent sprites can use the opaque blend fast path.

  yy = y0
  while yy < y1
    srcY = spr.sy + (yy - y)
    srcX = spr.sx + (x0 - x)
    si = ((srcY * spr.image.width) + srcX) * 4
    di = ((yy * c.width) + x0) * 4
    if spr.image.opaque then
      copyBytes(c.pixels, di, spr.image.pixels, si, (x1 - x0) * 4)
    else
      xx = x0
      while xx < x1
        a = spr.image.pixels[si + 3]
        if a >= 255 then
          c.pixels[di] = spr.image.pixels[si]
          c.pixels[di + 1] = spr.image.pixels[si + 1]
          c.pixels[di + 2] = spr.image.pixels[si + 2]
          c.pixels[di + 3] = 255
        else
          if a > 0 and destinationOpaque then
            inv = 255 - a
            c.pixels[di] = mt.clamp(mt.floorInt(((spr.image.pixels[si] * a) + (c.pixels[di] * inv)) / 255), 0, 255)
            c.pixels[di + 1] = mt.clamp(mt.floorInt(((spr.image.pixels[si + 1] * a) + (c.pixels[di + 1] * inv)) / 255), 0, 255)
            c.pixels[di + 2] = mt.clamp(mt.floorInt(((spr.image.pixels[si + 2] * a) + (c.pixels[di + 2] * inv)) / 255), 0, 255)
            c.pixels[di + 3] = 255
          else
            if a > 0 then
              dst = mt.rgba(c.pixels[di], c.pixels[di + 1], c.pixels[di + 2], c.pixels[di + 3])
              src = mt.rgba(spr.image.pixels[si], spr.image.pixels[si + 1], spr.image.pixels[si + 2], a)
              blended = mt.alphaBlend(dst, src)
              c.pixels[di] = mt.colorR(blended)
              c.pixels[di + 1] = mt.colorG(blended)
              c.pixels[di + 2] = mt.colorB(blended)
              c.pixels[di + 3] = mt.colorA(blended)
            end if
          end if
        end if
        si = si + 4
        di = di + 4
        xx = xx + 1
      end while
    end if
    yy = yy + 1
  end while
  c.spriteCount = c.spriteCount + 1
  c.drawCalls = c.drawCalls + 1
end function

/// Draws sprite ex through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param spr spr value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param flipX flipX value consumed by this operation.
/// @param flipY flipY value consumed by this operation.
/// @param scale scale value consumed by this operation.
/// @param tint tint value consumed by this operation.
function drawSpriteEx(c, spr, x, y, flipX, flipY, scale, tint)
  if typeof(scale) != "int" or scale < 1 then scale = 1 end if
  x = mt.floorInt(x - spr.pivotX)
  y = mt.floorInt(y - spr.pivotY)
  if x >= c.width or y >= c.height or x + (spr.width * scale) <= 0 or y + (spr.height * scale) <= 0 then return end if
  markDirty(c, x, y, spr.width * scale, spr.height * scale)
  white = mt.rgba(255, 255, 255, 255)
  if scale == 1 and flipX == false and flipY == false and tint == white then
    return drawSpriteFast1x(c, spr, x, y)
  end if
  yy = 0
  while yy < spr.height
    xx = 0
    while xx < spr.width
      srcX = xx
      srcY = yy
      if flipX then srcX = spr.width - 1 - xx end if
      if flipY then srcY = spr.height - 1 - yy end if
      color = sp.imageGetPixel(spr.image, spr.sx + srcX, spr.sy + srcY)
      if mt.colorA(color) > 0 then
        if tint != white then
          color = mt.tintColor(color, tint)
        end if
        if scale == 1 then
          drawPixelFast(c, x + xx, y + yy, color)
        else
          fillScaledPixel(c, x + (xx * scale), y + (yy * scale), scale, color)
        end if
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  c.spriteCount = c.spriteCount + 1
  c.drawCalls = c.drawCalls + 1
end function

/// Draws a sprite at an arbitrary nearest-neighbour scale. Unlike drawSpriteEx,
/// this path intentionally accepts fractional scaling for smooth camera zoom.
/// @param c Target canvas.
/// @param spr Sprite to draw.
/// @param x Horizontal pivot position.
/// @param y Vertical pivot position.
/// @param scale Positive scale factor.
/// @param tint Multiplicative RGBA tint.
function drawSpriteScaled(c, spr, x, y, scale, tint)
  if scale <= 0 then return end if
  if scale == 1 then return drawSpriteEx(c, spr, x, y, false, false, 1, tint) end if
  x = mt.floorInt(x - spr.pivotX * scale)
  y = mt.floorInt(y - spr.pivotY * scale)
  scaledWidth = mt.floorInt(spr.width * scale + 0.5)
  scaledHeight = mt.floorInt(spr.height * scale + 0.5)
  if scaledWidth < 1 then scaledWidth = 1 end if
  if scaledHeight < 1 then scaledHeight = 1 end if
  x0 = mt.clamp(x, 0, c.width)
  y0 = mt.clamp(y, 0, c.height)
  x1 = mt.clamp(x + scaledWidth, 0, c.width)
  y1 = mt.clamp(y + scaledHeight, 0, c.height)
  if x0 >= x1 or y0 >= y1 then return end if
  white = mt.rgba(255, 255, 255, 255)
  yy = y0
  while yy < y1
    sourceY = mt.clamp(mt.floorInt((yy - y) / scale), 0, spr.height - 1)
    xx = x0
    while xx < x1
      sourceX = mt.clamp(mt.floorInt((xx - x) / scale), 0, spr.width - 1)
      color = sp.imageGetPixel(spr.image, spr.sx + sourceX, spr.sy + sourceY)
      if tint != white then color = mt.tintColor(color, tint) end if
      if mt.colorA(color) > 0 then drawPixelFast(c, xx, yy, color) end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  markDirty(c, x0, y0, x1 - x0, y1 - y0)
  if spr.image.opaque == false or mt.colorA(tint) < 255 then c.imageView.opaque = false end if
  c.spriteCount = c.spriteCount + 1
  c.drawCalls = c.drawCalls + 1
end function

/// Draws a sprite rotated around its configured pivot using inverse sampling.
/// @param c Destination canvas.
/// @param spr Sprite to draw.
/// @param x Pivot x coordinate.
/// @param y Pivot y coordinate.
/// @param radians Clockwise rotation in radians.
/// @param scale Positive integer scale.
/// @param tint Multiplicative RGBA tint.
function drawSpriteRotated(c, spr, x, y, radians, scale, tint)
  if typeof(scale) != "int" or scale < 1 then scale = 1 end if
  if radians == 0 then return drawSpriteEx(c, spr, x, y, false, false, scale, tint) end if
  cosine = math.cos(radians)
  sine = math.sin(radians)
  pivotX = spr.pivotX
  pivotY = spr.pivotY
  left = 0 - pivotX
  top = 0 - pivotY
  right = spr.width - pivotX
  bottom = spr.height - pivotY
  x0 = mt.floorInt(x + (left * cosine - top * sine) * scale)
  x1 = x0
  y0 = mt.floorInt(y + (left * sine + top * cosine) * scale)
  y1 = y0
  cornersX = [right, right, left]
  cornersY = [top, bottom, bottom]
  for corner = 0 to 2
    rx = mt.floorInt(x + (cornersX[corner] * cosine - cornersY[corner] * sine) * scale)
    ry = mt.floorInt(y + (cornersX[corner] * sine + cornersY[corner] * cosine) * scale)
    if rx < x0 then x0 = rx end if
    if rx > x1 then x1 = rx end if
    if ry < y0 then y0 = ry end if
    if ry > y1 then y1 = ry end if
  end for
  x0 = mt.clamp(x0, 0, c.width - 1)
  y0 = mt.clamp(y0, 0, c.height - 1)
  x1 = mt.clamp(x1 + 1, 0, c.width)
  y1 = mt.clamp(y1 + 1, 0, c.height)
  if x0 >= x1 or y0 >= y1 then return end if
  white = mt.rgba(255, 255, 255, 255)
  yy = y0
  while yy < y1
    xx = x0
    while xx < x1
      dx = (xx + 0.5 - x) / scale
      dy = (yy + 0.5 - y) / scale
      sourceX = mt.floorInt((dx * cosine) + (dy * sine) + pivotX)
      sourceY = mt.floorInt((0 - dx * sine) + (dy * cosine) + pivotY)
      if sourceX >= 0 and sourceY >= 0 and sourceX < spr.width and sourceY < spr.height then
        color = sp.imageGetPixel(spr.image, spr.sx + sourceX, spr.sy + sourceY)
        if tint != white then color = mt.tintColor(color, tint) end if
        if mt.colorA(color) > 0 then drawPixelFast(c, xx, yy, color) end if
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  markDirty(c, x0, y0, x1 - x0, y1 - y0)
  if spr.image.opaque == false or mt.colorA(tint) < 255 then c.imageView.opaque = false end if
  c.spriteCount = c.spriteCount + 1
  c.drawCalls = c.drawCalls + 1
end function

/// Draws a source canvas as a reusable CPU render target.
/// @param destination Destination canvas.
/// @param source Source canvas.
/// @param x Destination x coordinate.
/// @param y Destination y coordinate.
function drawCanvas(destination, source, x, y)
  return blitImage(destination, source.imageView, x, y)
end function

/// Performs the screenX operation for the minipixels graphics canvas module.
/// @param camera camera value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
function screenX(camera, x)
  return x - camera.x
end function

/// Performs the screenY operation for the minipixels graphics canvas module.
/// @param camera camera value consumed by this operation.
/// @param y Vertical coordinate used by the operation.
function screenY(camera, y)
  return y - camera.y
end function

/// Performs the fillRectWorld operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function fillRectWorld(c, camera, x, y, w, h, color)
  return fillRect(c, screenX(camera, x), screenY(camera, y), w, h, color)
end function

/// Draws rect world through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function drawRectWorld(c, camera, x, y, w, h, color)
  return drawRect(c, screenX(camera, x), screenY(camera, y), w, h, color)
end function

/// Draws sprite world through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param spr spr value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function drawSpriteWorld(c, camera, spr, x, y)
  return drawSprite(c, spr, screenX(camera, x), screenY(camera, y))
end function

/// Draws sprite world ex through the minipixels graphics canvas rendering path.
/// @param c c value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param spr spr value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param flipX flipX value consumed by this operation.
/// @param flipY flipY value consumed by this operation.
/// @param scale scale value consumed by this operation.
/// @param tint tint value consumed by this operation.
function drawSpriteWorldEx(c, camera, spr, x, y, flipX, flipY, scale, tint)
  return drawSpriteEx(c, spr, screenX(camera, x), screenY(camera, y), flipX, flipY, scale, tint)
end function

/// Performs the hash operation for the minipixels graphics canvas module.
/// @param c c value consumed by this operation.
function hash(c)
  h = 2166136261
  for each b in c.pixels
    h = h ^ b
    h = (h * 16777619) & 0x7FFFFFFF
  end for
  return h
end function
