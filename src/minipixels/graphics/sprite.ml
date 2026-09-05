// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels graphics sprite facilities for this project.

package minipixels.graphics.sprite

import minipixels.math.types as mt

/// Represents the image data used by the minipixels graphics sprite module.
struct Image
  /// Stores the width value associated with image.
  width as int
  /// Stores the height value associated with image.
  height as int
  /// Stores the pixels value associated with image.
  pixels as bytes
  /// Stores the name value associated with image.
  name
  /// Stores the opaque value associated with image.
  opaque as bool

  /// Returns pixel maintained by the minipixels graphics sprite module.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function getPixel(x, y)
    return minipixels.graphics.sprite.imageGetPixel(this, x, y)
  end function
end struct

/// Represents the sprite data used by the minipixels graphics sprite module.
struct Sprite
  /// Stores the image value associated with sprite.
  image
  /// Stores the sx value associated with sprite.
  sx as int
  /// Stores the sy value associated with sprite.
  sy as int
  /// Stores the width value associated with sprite.
  width as int
  /// Stores the height value associated with sprite.
  height as int
  /// Stores the pivot x value associated with sprite.
  pivotX
  /// Stores the pivot y value associated with sprite.
  pivotY
  /// Stores the name value associated with sprite.
  name
end struct

/// Represents the sprite sheet data used by the minipixels graphics sprite module.
struct SpriteSheet
  /// Stores the image value associated with sprite sheet.
  image
  /// Stores the frame width value associated with sprite sheet.
  frameWidth as int
  /// Stores the frame height value associated with sprite sheet.
  frameHeight as int
  /// Stores the spacing value associated with sprite sheet.
  spacing as int
  /// Stores the margin value associated with sprite sheet.
  margin as int
  /// Stores the columns value associated with sprite sheet.
  columns as int
  /// Stores the frame count value associated with sprite sheet.
  frameCount as int
  /// Lazily populated cache of immutable frame descriptors.
  frames

  /// Returns frame maintained by the minipixels graphics sprite module.
  /// @param index Zero-based index of the affected item.
  function getFrame(index)
    return minipixels.graphics.sprite.spriteSheetFrame(this, index)
  end function
end struct

/// Creates image for the minipixels graphics sprite module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param pixels pixels value consumed by this operation.
/// @param name Name of the affected item.
function newImage(width, height, pixels, name)
  if typeof(pixels) != "bytes" then
    pixels = bytes(width * height * 4, 0)
  end if
  return Image(width, height, pixels, name, pixelsAreOpaque(pixels, width * height))
end function

/// Performs the pixelsAreOpaque operation for the minipixels graphics sprite module.
/// @param pixels pixels value consumed by this operation.
/// @param pixelCount Number of pixel to process.
/// @returns Native bool result produced by the call.
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

/// Performs the solidImage operation for the minipixels graphics sprite module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param color color value consumed by this operation.
/// @param name Name of the affected item.
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

/// Performs the imageIndex operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function inline imageIndex(img, x, y)
  return ((y * img.width) + x) * 4
end function

/// Performs the imageSetPixel operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
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

/// Performs the imageGetPixel operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
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

/// Performs the spriteFromImage operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param name Name of the affected item.
function spriteFromImage(img, name)
  return Sprite(img, 0, 0, img.width, img.height, 0, 0, name)
end function

/// Performs the spriteRegion operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param sx sx value consumed by this operation.
/// @param sy sy value consumed by this operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param name Name of the affected item.
function spriteRegion(img, sx, sy, w, h, name)
  return Sprite(img, sx, sy, w, h, 0, 0, name)
end function

/// Performs the spriteSheet operation for the minipixels graphics sprite module.
/// @param img img value consumed by this operation.
/// @param frameWidth frameWidth value consumed by this operation.
/// @param frameHeight frameHeight value consumed by this operation.
/// @param spacing spacing value consumed by this operation.
/// @param margin margin value consumed by this operation.
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
  count = columns * rows
  return SpriteSheet(img, frameWidth, frameHeight, spacing, margin, columns, count, array(count))
end function

/// Performs the spriteSheetFrame operation for the minipixels graphics sprite module.
/// @param sheet sheet value consumed by this operation.
/// @param index Zero-based index of the affected item.
function spriteSheetFrame(sheet, index)
  if typeof(index) != "int" then index = 0 end if
  if index < 0 then index = 0 end if
  if index >= sheet.frameCount then index = sheet.frameCount - 1 end if
  cached = sheet.frames[index]
  if typeof(cached) != "void" then return cached end if
  col = index % sheet.columns
  row = 0
  scan = index
  while scan >= sheet.columns
    row = row + 1
    scan = scan - sheet.columns
  end while
  sx = sheet.margin + (col * (sheet.frameWidth + sheet.spacing))
  sy = sheet.margin + (row * (sheet.frameHeight + sheet.spacing))
  frame = Sprite(sheet.image, sx, sy, sheet.frameWidth, sheet.frameHeight, 0, 0, sheet.image.name + "#" + index)
  sheet.frames[index] = frame
  return frame
end function

/// Populates every frame descriptor cache ahead of a hot rendering loop.
/// @param sheet Sprite sheet to prewarm.
function cacheFrames(sheet)
  if sheet.frameCount <= 0 then return sheet end if
  for index = 0 to sheet.frameCount - 1
    spriteSheetFrame(sheet, index)
  end for
  return sheet
end function
