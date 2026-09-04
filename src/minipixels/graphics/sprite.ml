package minipixels.graphics.sprite

import minipixels.math.types as mt

struct Image
  width as int
  height as int
  pixels as bytes
  name
  opaque as bool

  function getPixel(x, y)
    return minipixels.graphics.sprite.imageGetPixel(this, x, y)
  end function
end struct

struct Sprite
  image
  sx as int
  sy as int
  width as int
  height as int
  pivotX
  pivotY
  name
end struct

struct SpriteSheet
  image
  frameWidth as int
  frameHeight as int
  spacing as int
  margin as int
  columns as int
  frameCount as int

  function getFrame(index)
    return minipixels.graphics.sprite.spriteSheetFrame(this, index)
  end function
end struct

function newImage(width, height, pixels, name)
  if typeof(pixels) != "bytes" then
    pixels = bytes(width * height * 4, 0)
  end if
  return Image(width, height, pixels, name, pixelsAreOpaque(pixels, width * height))
end function

function pixelsAreOpaque(pixels as bytes, pixelCount as int) returns bool
  if len(pixels) < pixelCount * 4 then return false end if
  i = 3
  limit = pixelCount * 4
  while i < limit
    if pixels[i] != 255 then return false end if
    i = i + 4
  end while
  return true
end function

function solidImage(width, height, color, name)
  pix = bytes(width * height * 4, 0)
  img = Image(width, height, pix, name, mt.colorA(color) >= 255)
  for y = 0 to height - 1
    for x = 0 to width - 1
      imageSetPixel(img, x, y, color)
    end for
  end for
  return img
end function

function inline imageIndex(img, x, y)
  return ((y * img.width) + x) * 4
end function

function imageSetPixel(img, x, y, color)
  if x < 0 or y < 0 or x >= img.width or y >= img.height then return false end if
  i = imageIndex(img, x, y)
  img.pixels[i] = mt.colorR(color)
  img.pixels[i + 1] = mt.colorG(color)
  img.pixels[i + 2] = mt.colorB(color)
  img.pixels[i + 3] = mt.colorA(color)
  if img.pixels[i + 3] < 255 then img.opaque = false end if
  return true
end function

function imageGetPixel(img, x, y)
  if x < 0 or y < 0 or x >= img.width or y >= img.height then return 0 end if
  i = imageIndex(img, x, y)
  if typeof(i) != "int" then return 0 end if
  if i < 0 or i + 3 >= len(img.pixels) then return 0 end if
  r = img.pixels[i]
  g = img.pixels[i + 1]
  b = img.pixels[i + 2]
  a = img.pixels[i + 3]
  if typeof(r) != "int" or typeof(g) != "int" or typeof(b) != "int" or typeof(a) != "int" then return 0 end if
  return mt.rgba(r, g, b, a)
end function

function spriteFromImage(img, name)
  return Sprite(img, 0, 0, img.width, img.height, 0, 0, name)
end function

function spriteRegion(img, sx, sy, w, h, name)
  return Sprite(img, sx, sy, w, h, 0, 0, name)
end function

function spriteSheet(img, frameWidth, frameHeight, spacing, margin)
  available = img.width - (margin * 2) + spacing
  step = frameWidth + spacing
  columns = 0
  while available >= step
    columns = columns + 1
    available = available - step
  end while
  if columns < 1 then columns = 1 end if
  availableY = img.height - (margin * 2) + spacing
  stepY = frameHeight + spacing
  rows = 0
  while availableY >= stepY
    rows = rows + 1
    availableY = availableY - stepY
  end while
  if rows < 1 then rows = 1 end if
  return SpriteSheet(img, frameWidth, frameHeight, spacing, margin, columns, columns * rows)
end function

function spriteSheetFrame(sheet, index)
  if typeof(index) != "int" then index = 0 end if
  if index < 0 then index = 0 end if
  if index >= sheet.frameCount then index = sheet.frameCount - 1 end if
  col = index % sheet.columns
  row = 0
  scan = index
  while scan >= sheet.columns
    row = row + 1
    scan = scan - sheet.columns
  end while
  sx = sheet.margin + (col * (sheet.frameWidth + sheet.spacing))
  sy = sheet.margin + (row * (sheet.frameHeight + sheet.spacing))
  return Sprite(sheet.image, sx, sy, sheet.frameWidth, sheet.frameHeight, 0, 0, sheet.image.name + "#" + index)
end function
