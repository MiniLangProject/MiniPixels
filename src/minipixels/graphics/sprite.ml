package minipixels.graphics.sprite

import minipixels.math.types as mt

struct Image
  width
  height
  pixels
  name

  function getPixel(x, y)
    return minipixels.graphics.sprite.imageGetPixel(this, x, y)
  end function
end struct

struct Sprite
  image
  sx
  sy
  width
  height
  pivotX
  pivotY
  name
end struct

struct SpriteSheet
  image
  frameWidth
  frameHeight
  spacing
  margin
  columns

  function getFrame(index)
    return minipixels.graphics.sprite.spriteSheetFrame(this, index)
  end function
end struct

function newImage(width, height, pixels, name)
  if typeof(pixels) != "bytes" then
    pixels = bytes(width * height * 4, 0)
  end if
  return Image(width, height, pixels, name)
end function

function solidImage(width, height, color, name)
  pix = bytes(width * height * 4, 0)
  img = Image(width, height, pix, name)
  for y = 0 to height - 1
    for x = 0 to width - 1
      imageSetPixel(img, x, y, color)
    end for
  end for
  return img
end function

function imageIndex(img, x, y)
  return ((y * img.width) + x) * 4
end function

function imageSetPixel(img, x, y, color)
  if x < 0 or y < 0 or x >= img.width or y >= img.height then return false end if
  i = imageIndex(img, x, y)
  img.pixels[i] = mt.colorR(color)
  img.pixels[i + 1] = mt.colorG(color)
  img.pixels[i + 2] = mt.colorB(color)
  img.pixels[i + 3] = mt.colorA(color)
  return true
end function

function imageGetPixel(img, x, y)
  if x < 0 or y < 0 or x >= img.width or y >= img.height then return 0 end if
  i = imageIndex(img, x, y)
  return mt.rgba(img.pixels[i], img.pixels[i + 1], img.pixels[i + 2], img.pixels[i + 3])
end function

function spriteFromImage(img, name)
  return Sprite(img, 0, 0, img.width, img.height, 0, 0, name)
end function

function spriteRegion(img, sx, sy, w, h, name)
  return Sprite(img, sx, sy, w, h, 0, 0, name)
end function

function spriteSheet(img, frameWidth, frameHeight, spacing, margin)
  columns = (img.width - (margin * 2) + spacing) / (frameWidth + spacing)
  if columns < 1 then columns = 1 end if
  return SpriteSheet(img, frameWidth, frameHeight, spacing, margin, columns)
end function

function spriteSheetFrame(sheet, index)
  col = index % sheet.columns
  row = index / sheet.columns
  sx = sheet.margin + (col * (sheet.frameWidth + sheet.spacing))
  sy = sheet.margin + (row * (sheet.frameHeight + sheet.spacing))
  return Sprite(sheet.image, sx, sy, sheet.frameWidth, sheet.frameHeight, 0, 0, sheet.image.name + "#" + index)
end function
