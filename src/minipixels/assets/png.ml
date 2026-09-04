// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels assets png facilities for this project.

package minipixels.assets.png

import std.bytes as by
import minipixels.graphics.sprite as sp

/// Defines the png err constant used by the minipixels assets png module.
const PNG_ERR = 9301

/// Performs the pngError operation for the minipixels assets png module.
/// @param message Human-readable message associated with the operation.
function pngError(message)
  return error(PNG_ERR, message)
end function

/// Returns whether range is available.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param size Size in the units required by the operation.
function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

/// Returns whether png satisfies the required condition.
/// @param data Input data consumed by the operation.
function isPng(data)
  if not hasRange(data, 0, 8) then return false end if
  return data[0] == 137 and data[1] == 80 and data[2] == 78 and data[3] == 71 and data[4] == 13 and data[5] == 10 and data[6] == 26 and data[7] == 10
end function

/// Performs the inflateStored operation for the minipixels assets png module.
/// @param z z value consumed by this operation.
function inflateStored(z)
  if not hasRange(z, 0, 6) then return pngError("png zlib stream too small") end if
  pos = 2
  total = 0
  done = false
  while done == false
    if not hasRange(z, pos, 5) then return pngError("png stored block truncated") end if
    hdr = z[pos]
    pos = pos + 1
    done = (hdr & 1) != 0
    blockType = (hdr >> 1) & 3
    if blockType != 0 then return pngError("png deflate block is not stored") end if
    size = by.readU16LE(z, pos)
    nsize = by.readU16LE(z, pos + 2)
    pos = pos + 4
    if (size ^ nsize) != 0xFFFF then return pngError("png stored block length check failed") end if
    if not hasRange(z, pos, size) then return pngError("png stored block payload truncated") end if
    total = total + size
    pos = pos + size
  end while

  result = bytes(total, 0)
  pos = 2
  output = 0
  done = false
  while done == false
    hdr = z[pos]
    pos = pos + 1
    done = (hdr & 1) != 0
    size = by.readU16LE(z, pos)
    pos = pos + 4
    copyBytes(result, output, z, pos, size)
    output = output + size
    pos = pos + size
  end while
  return result
end function

/// Decodes decode for the minipixels assets png workflow.
/// @param data Input data consumed by the operation.
/// @param name Name of the affected item.
function decode(data, name)
  if not isPng(data) then return pngError("not a png") end if
  pos = 8
  width = 0
  height = 0
  bitDepth = 0
  colorType = 0
  idatSize = 0
  while pos + 8 <= len(data)
    length = by.readU32BE(data, pos)
    if typeof(length) != "int" or length < 0 then return pngError("invalid png chunk length") end if
    if not hasRange(data, pos + 8, length + 4) then return pngError("png chunk truncated") end if
    t0 = data[pos + 4]
    t1 = data[pos + 5]
    t2 = data[pos + 6]
    t3 = data[pos + 7]
    payload = pos + 8
    if t0 == 73 and t1 == 72 and t2 == 68 and t3 == 82 then
      if length < 13 then return pngError("png IHDR too small") end if
      width = by.readU32BE(data, payload)
      height = by.readU32BE(data, payload + 4)
      bitDepth = data[payload + 8]
      colorType = data[payload + 9]
    end if
    if t0 == 73 and t1 == 68 and t2 == 65 and t3 == 84 then
      idatSize = idatSize + length
    end if
    if t0 == 73 and t1 == 69 and t2 == 78 and t3 == 68 then
      break
    end if
    pos = pos + 12 + length
  end while
  if width <= 0 or height <= 0 then return pngError("png missing IHDR") end if
  if bitDepth != 8 or colorType != 6 then return pngError("png must be 8-bit RGBA") end if

  idat = bytes(idatSize, 0)
  idatOffset = 0
  pos = 8
  while pos + 8 <= len(data)
    length = by.readU32BE(data, pos)
    payload = pos + 8
    t0 = data[pos + 4]
    t1 = data[pos + 5]
    t2 = data[pos + 6]
    t3 = data[pos + 7]
    if t0 == 73 and t1 == 68 and t2 == 65 and t3 == 84 then
      copyBytes(idat, idatOffset, data, payload, length)
      idatOffset = idatOffset + length
    end if
    if t0 == 73 and t1 == 69 and t2 == 78 and t3 == 68 then break end if
    pos = pos + 12 + length
  end while
  raw = inflateStored(idat)
  if typeof(raw) == "error" then return raw end if
  stride = width * 4
  expected = (stride + 1) * height
  if len(raw) < expected then return pngError("png scanlines truncated") end if
  pix = bytes(width * height * 4, 0)
  y = 0
  while y < height
    src = y * (stride + 1)
    if raw[src] != 0 then return pngError("png scanline filter is not 0") end if
    copyBytes(pix, y * stride, raw, src + 1, stride)
    y = y + 1
  end while
  return sp.newImage(width, height, pix, name)
end function
