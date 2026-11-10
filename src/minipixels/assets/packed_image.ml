// SPDX-License-Identifier: Apache-2.0

//! Prepares and loads MRI1 RGBA8888 images stored inside MPX packs.

package minipixels.assets.packed_image

import std.bytes as by
import minipixels.assets.png as png
import minipixels.graphics.sprite as sp

/// MRI1 consists of a four-byte magic, little-endian width/height, then RGBA pixels.
const HEADER_SIZE = 12

/// Validates dimensions before multiplication or pixel allocation.
/// @internal
function validDimensions(width, height)
  return typeof(width) == "int" and typeof(height) == "int" and width > 0 and height > 0 and width <= png.MAX_IMAGE_PIXELS and height <= png.MAX_IMAGE_PIXELS and width * height <= png.MAX_IMAGE_PIXELS
end function

/// Encodes build-prepared pixels without PNG filtering or color conversion.
/// @param width Pixel width.
/// @param height Pixel height.
/// @param pixels Exactly width * height * 4 RGBA8888 bytes.
function encode(width, height, pixels)
  if not validDimensions(width, height) then return error(png.PNG_ERR, "invalid packed image dimensions") end if
  if typeof(pixels) != "bytes" or len(pixels) != width * height * 4 then return error(png.PNG_ERR, "invalid packed image pixels") end if
  output = bytes(HEADER_SIZE + len(pixels), 0)
  output[0] = 77; output[1] = 82; output[2] = 73; output[3] = 49
  by.writeU32LE(output, 4, width)
  by.writeU32LE(output, 8, height)
  copyBytes(output, HEADER_SIZE, pixels, 0, len(pixels))
  return output
end function

/// Loads prepared MRI1 pixels or an ordinary PNG payload from a pack.
/// @param data Complete decompressed asset bytes.
/// @param name Image name retained by the engine.
function decode(data, name)
  if typeof(data) != "bytes" then return error(png.PNG_ERR, "invalid packed image bytes") end if
  if png.isPng(data) then return png.decode(data, name) end if
  if len(data) < HEADER_SIZE then return error(png.PNG_ERR, "packed image header truncated") end if
  if data[0] != 77 or data[1] != 82 or data[2] != 73 or data[3] != 49 then return error(png.PNG_ERR, "unsupported packed image format") end if
  width = by.readU32LE(data, 4)
  height = by.readU32LE(data, 8)
  if not validDimensions(width, height) then return error(png.PNG_ERR, "invalid packed image dimensions") end if
  size = width * height * 4
  if len(data) - HEADER_SIZE != size then return error(png.PNG_ERR, "packed image pixel size mismatch") end if
  return sp.newImage(width, height, slice(data, HEADER_SIZE, size), name)
end function
