package minipixels.graphics.canvas

import minipixels.math.types as mt
import minipixels.graphics.sprite as sp

struct Canvas
  width
  height
  pixels
  cameraX
  cameraY
  spriteCount
  tileCount
  drawCalls

  function clear(color)
    return minipixels.graphics.canvas.clearCanvas(this, color)
  end function

  function setPixel(x, y, color)
    return minipixels.graphics.canvas.setPixel(this, x, y, color)
  end function

  function getPixel(x, y)
    return minipixels.graphics.canvas.getPixel(this, x, y)
  end function

  function drawLine(x1, y1, x2, y2, color)
    return minipixels.graphics.canvas.drawLine(this, x1, y1, x2, y2, color)
  end function

  function drawRect(x, y, w, h, color)
    return minipixels.graphics.canvas.drawRect(this, x, y, w, h, color)
  end function

  function fillRect(x, y, w, h, color)
    return minipixels.graphics.canvas.fillRect(this, x, y, w, h, color)
  end function

  function drawCircle(cx, cy, r, color)
    return minipixels.graphics.canvas.drawCircle(this, cx, cy, r, color)
  end function

  function fillCircle(cx, cy, r, color)
    return minipixels.graphics.canvas.fillCircle(this, cx, cy, r, color)
  end function

  function blit(image, x, y)
    return minipixels.graphics.canvas.blitImage(this, image, x, y)
  end function

  function blitRegion(image, sx, sy, sw, sh, x, y)
    return minipixels.graphics.canvas.blitRegion(this, image, sx, sy, sw, sh, x, y)
  end function

  function drawSprite(sprite, x, y)
    return minipixels.graphics.canvas.drawSprite(this, sprite, x, y)
  end function

  function drawSpriteEx(sprite, x, y, flipX, flipY, scale, tint)
    return minipixels.graphics.canvas.drawSpriteEx(this, sprite, x, y, flipX, flipY, scale, tint)
  end function

  function fillRectWorld(camera, x, y, w, h, color)
    return minipixels.graphics.canvas.fillRectWorld(this, camera, x, y, w, h, color)
  end function

  function drawRectWorld(camera, x, y, w, h, color)
    return minipixels.graphics.canvas.drawRectWorld(this, camera, x, y, w, h, color)
  end function

  function drawSpriteWorld(camera, sprite, x, y)
    return minipixels.graphics.canvas.drawSpriteWorld(this, camera, sprite, x, y)
  end function

  function drawSpriteWorldEx(camera, sprite, x, y, flipX, flipY, scale, tint)
    return minipixels.graphics.canvas.drawSpriteWorldEx(this, camera, sprite, x, y, flipX, flipY, scale, tint)
  end function

  function beginCamera(camera)
    this.cameraX = camera.x
    this.cameraY = camera.y
  end function

  function endCamera()
    this.cameraX = 0
    this.cameraY = 0
  end function
end struct

function create(width, height)
  return Canvas(width, height, bytes(width * height * 4, 0), 0, 0, 0, 0, 0)
end function

function resetStats(c)
  c.spriteCount = 0
  c.tileCount = 0
  c.drawCalls = 0
end function

function index(c, x, y)
  return ((y * c.width) + x) * 4
end function

function clearCanvas(c, color)
  r = mt.colorR(color)
  g = mt.colorG(color)
  b = mt.colorB(color)
  a = mt.colorA(color)
  i = 0
  n = len(c.pixels)
  while i < n
    c.pixels[i] = r
    c.pixels[i + 1] = g
    c.pixels[i + 2] = b
    c.pixels[i + 3] = a
    i = i + 4
  end while
  c.drawCalls = c.drawCalls + 1
end function

function setPixel(c, x, y, color)
  x = mt.floorInt(x - c.cameraX)
  y = mt.floorInt(y - c.cameraY)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return false end if
  i = index(c, x, y)
  c.pixels[i] = mt.colorR(color)
  c.pixels[i + 1] = mt.colorG(color)
  c.pixels[i + 2] = mt.colorB(color)
  c.pixels[i + 3] = mt.colorA(color)
  return true
end function

function setPixelRaw(c, x, y, color)
  x = mt.floorInt(x)
  y = mt.floorInt(y)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return false end if
  i = index(c, x, y)
  c.pixels[i] = mt.colorR(color)
  c.pixels[i + 1] = mt.colorG(color)
  c.pixels[i + 2] = mt.colorB(color)
  c.pixels[i + 3] = mt.colorA(color)
  return true
end function

function getPixel(c, x, y)
  x = mt.floorInt(x - c.cameraX)
  y = mt.floorInt(y - c.cameraY)
  if x < 0 or y < 0 or x >= c.width or y >= c.height then return 0 end if
  i = index(c, x, y)
  return mt.rgba(c.pixels[i], c.pixels[i + 1], c.pixels[i + 2], c.pixels[i + 3])
end function

function blendPixel(c, x, y, color)
  if mt.colorA(color) >= 255 then
    return setPixel(c, x, y, color)
  end if
  dst = getPixel(c, x, y)
  return setPixel(c, x, y, mt.alphaBlend(dst, color))
end function

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
  yy = y0
  while yy < y1
    xx = x0
    while xx < x1
      setPixelRaw(c, xx, yy, color)
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  c.drawCalls = c.drawCalls + 1
end function

function drawRect(c, x, y, w, h, color)
  drawLine(c, x, y, x + w - 1, y, color)
  drawLine(c, x, y + h - 1, x + w - 1, y + h - 1, color)
  drawLine(c, x, y, x, y + h - 1, color)
  drawLine(c, x + w - 1, y, x + w - 1, y + h - 1, color)
end function

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

function fillCircle(c, cx, cy, r, color)
  y = 0 - r
  while y <= r
    x = 0 - r
    while x <= r
      if x * x + y * y <= r * r then
        setPixel(c, cx + x, cy + y, color)
      end if
      x = x + 1
    end while
    y = y + 1
  end while
  c.drawCalls = c.drawCalls + 1
end function

function blitImage(c, img, x, y)
  return blitRegion(c, img, 0, 0, img.width, img.height, x, y)
end function

function blitRegion(c, img, sx, sy, sw, sh, x, y)
  spr = sp.Sprite(img, sx, sy, sw, sh, 0, 0, img.name)
  return drawSpriteEx(c, spr, x, y, false, false, 1, mt.rgba(255, 255, 255, 255))
end function

function drawSprite(c, spr, x, y)
  return drawSpriteEx(c, spr, x, y, false, false, 1, mt.rgba(255, 255, 255, 255))
end function

function drawSpriteEx(c, spr, x, y, flipX, flipY, scale, tint)
  if typeof(scale) != "int" or scale < 1 then scale = 1 end if
  x = mt.floorInt(x - spr.pivotX)
  y = mt.floorInt(y - spr.pivotY)
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
        if tint != mt.rgba(255, 255, 255, 255) then
          color = mt.tintColor(color, tint)
        end if
        if scale == 1 then
          blendPixel(c, x + xx, y + yy, color)
        else
          fillRect(c, x + (xx * scale), y + (yy * scale), scale, scale, color)
        end if
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  c.spriteCount = c.spriteCount + 1
  c.drawCalls = c.drawCalls + 1
end function

function screenX(camera, x)
  return x - camera.x
end function

function screenY(camera, y)
  return y - camera.y
end function

function fillRectWorld(c, camera, x, y, w, h, color)
  return fillRect(c, screenX(camera, x), screenY(camera, y), w, h, color)
end function

function drawRectWorld(c, camera, x, y, w, h, color)
  return drawRect(c, screenX(camera, x), screenY(camera, y), w, h, color)
end function

function drawSpriteWorld(c, camera, spr, x, y)
  return drawSprite(c, spr, screenX(camera, x), screenY(camera, y))
end function

function drawSpriteWorldEx(c, camera, spr, x, y, flipX, flipY, scale, tint)
  return drawSpriteEx(c, spr, screenX(camera, x), screenY(camera, y), flipX, flipY, scale, tint)
end function

function hash(c)
  h = 2166136261
  for each b in c.pixels
    h = h ^ b
    h = (h * 16777619) & 0x7FFFFFFF
  end for
  return h
end function
