// SPDX-License-Identifier: Apache-2.0

//! Decodes common non-interlaced PNG images from memory or disk.

package minipixels.assets.png

import std.bytes as by
import std.checksum.crc32 as crc
import std.fs as fs
import minipixels.graphics.sprite as sp

#if TARGET_OS == "windows"
/// @internal
extern function mpAssetInflateZlib(destination as bytes, destinationSize as u64, source as bytes, sourceOffset as u64, sourceSize as u64) from "minipixels_audio.dll" returns i32
#else
/// @internal
extern function mpAssetInflateZlib(destination as bytes, destinationSize as u64, source as bytes, sourceOffset as u64, sourceSize as u64) from "./libminipixels_audio.so" returns i32
#endif

/// PNG decoding error code.
const PNG_ERR = 9301
/// Maximum canonical Deflate Huffman code length.
const MAX_BITS = 15
/// Maximum decoded pixel count accepted from untrusted PNG metadata.
const MAX_IMAGE_PIXELS = 67108864
/// Lazily initialized fixed Deflate literal/length table.
fixedLiteralCache = void
/// Lazily initialized fixed Deflate distance table.
fixedDistanceCache = void

/// Mutable least-significant-bit-first Deflate reader.
struct BitReader
  /// Compressed input bytes.
  data
  /// Next unread byte offset.
  position
  /// Buffered low-order bits.
  bits
  /// Number of buffered bits.
  bitCount
  /// Whether an invalid read occurred.
  failed
end struct

/// Canonical Deflate Huffman decoding table.
struct Huffman
  /// Number of symbols for each bit length.
  counts
  /// Symbols ordered by bit length and canonical code.
  symbols
  /// Whether the table is valid.
  valid
end struct

/// Creates a consistent PNG error value.
/// @param message Human-readable decoding failure.
function pngError(message)
  return error(PNG_ERR, message)
end function

/// Returns whether an exact byte range is available.
/// @param data Byte buffer to inspect.
/// @param offset Starting byte offset.
/// @param size Required byte count.
function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

/// Divides non-negative integers while retaining an integer result.
/// @param value Dividend.
/// @param divisor Positive divisor.
function integerDivide(value, divisor)
  return (value - (value % divisor)) / divisor
end function

/// Divides non-negative integers and rounds up while retaining an integer result.
/// @param value Dividend.
/// @param divisor Positive divisor.
function integerCeilDivide(value, divisor)
  adjusted = value + divisor - 1
  return integerDivide(adjusted, divisor)
end function

/// Returns whether bytes begin with the PNG signature.
/// @param data Complete candidate byte buffer.
function isPng(data)
  if not hasRange(data, 0, 8) then return false end if
  return data[0] == 137 and data[1] == 80 and data[2] == 78 and data[3] == 71 and data[4] == 13 and data[5] == 10 and data[6] == 26 and data[7] == 10
end function

/// Returns whether a PNG chunk type matches four ASCII bytes.
/// @param data PNG byte buffer.
/// @param position Chunk length-field offset.
/// @param a First chunk-type byte.
/// @param b Second chunk-type byte.
/// @param c Third chunk-type byte.
/// @param d Fourth chunk-type byte.
function chunkIs(data, position, a, b, c, d)
  if not hasRange(data, position + 4, 4) then return false end if
  return data[position + 4] == a and data[position + 5] == b and data[position + 6] == c and data[position + 7] == d
end function

/// Reads bits from a Deflate stream.
/// @param reader Mutable bit reader.
/// @param count Number of low-order bits to consume.
function readBits(reader, count)
  if count == 0 then return 0 end if
  while reader.bitCount < count
    if reader.position >= len(reader.data) then
      reader.failed = true
      return -1
    end if
    reader.bits = reader.bits | (reader.data[reader.position] << reader.bitCount)
    reader.position = reader.position + 1
    reader.bitCount = reader.bitCount + 8
  end while
  mask = (1 << count) - 1
  value = reader.bits & mask
  reader.bits = reader.bits >> count
  reader.bitCount = reader.bitCount - count
  return value
end function

/// Aligns a Deflate reader to the next byte boundary.
/// @param reader Mutable bit reader.
function alignBits(reader)
  reader.bits = 0
  reader.bitCount = 0
end function

/// Builds a canonical Huffman table from symbol bit lengths.
/// @param lengths Bit length for every symbol.
function buildHuffman(lengths)
  counts = array(MAX_BITS + 1, 0)
  symbolCount = len(lengths)
  for symbolValue = 0 to symbolCount - 1
    length = lengths[symbolValue]
    if length < 0 or length > MAX_BITS then return Huffman(counts, [], false) end if
    counts[length] = counts[length] + 1
  end for
  if counts[0] == symbolCount then return Huffman(counts, [], false) end if
  remaining = 1
  for length = 1 to MAX_BITS
    remaining = (remaining << 1) - counts[length]
    if remaining < 0 then return Huffman(counts, [], false) end if
  end for
  offsets = array(MAX_BITS + 1, 0)
  for length = 1 to MAX_BITS - 1
    offsets[length + 1] = offsets[length] + counts[length]
  end for
  symbols = array(symbolCount - counts[0], 0)
  for symbolValue = 0 to symbolCount - 1
    length = lengths[symbolValue]
    if length > 0 then
      symbols[offsets[length]] = symbolValue
      offsets[length] = offsets[length] + 1
    end if
  end for
  return Huffman(counts, symbols, true)
end function

/// Decodes one symbol from a canonical Deflate table.
/// @param reader Mutable bit reader.
/// @param table Canonical decoding table.
function decodeSymbol(reader, table)
  if table.valid == false then return -1 end if
  code = 0
  first = 0
  symbolIndex = 0
  for length = 1 to MAX_BITS
    bit = readBits(reader, 1)
    if bit < 0 then return -1 end if
    code = code | bit
    count = table.counts[length]
    if code < first + count then
      index = symbolIndex + (code - first)
      if index < 0 or index >= len(table.symbols) then return -1 end if
      return table.symbols[index]
    end if
    symbolIndex = symbolIndex + count
    first = (first + count) << 1
    code = code << 1
  end for
  return -1
end function

/// Creates the fixed Deflate literal/length table.
function fixedLiteralTable()
  global fixedLiteralCache
  if fixedLiteralCache is Huffman then return fixedLiteralCache end if
  lengths = array(288, 0)
  for symbolValue = 0 to 143 lengths[symbolValue] = 8 end for
  for symbolValue = 144 to 255 lengths[symbolValue] = 9 end for
  for symbolValue = 256 to 279 lengths[symbolValue] = 7 end for
  for symbolValue = 280 to 287 lengths[symbolValue] = 8 end for
  fixedLiteralCache = buildHuffman(lengths)
  return fixedLiteralCache
end function

/// Creates the fixed Deflate distance table.
function fixedDistanceTable()
  global fixedDistanceCache
  if fixedDistanceCache is Huffman then return fixedDistanceCache end if
  fixedDistanceCache = buildHuffman(array(32, 5))
  return fixedDistanceCache
end function

/// Reads dynamic Deflate Huffman tables.
/// @param reader Mutable bit reader positioned after the block type.
function dynamicTables(reader)
  literalCount = readBits(reader, 5) + 257
  distanceCount = readBits(reader, 5) + 1
  codeCount = readBits(reader, 4) + 4
  if reader.failed then return pngError("png dynamic deflate header truncated") end if
  order = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]
  codeLengths = array(19, 0)
  for index = 0 to codeCount - 1
    codeLengths[order[index]] = readBits(reader, 3)
  end for
  codeTable = buildHuffman(codeLengths)
  if codeTable.valid == false then return pngError("png dynamic code-length table invalid") end if
  total = literalCount + distanceCount
  lengths = array(total, 0)
  offset = 0
  while offset < total
    symbolValue = decodeSymbol(reader, codeTable)
    if symbolValue < 0 then return pngError("png dynamic code lengths truncated") end if
    if symbolValue <= 15 then
      lengths[offset] = symbolValue
      offset = offset + 1
    else
      repeat = 0
      value = 0
      if symbolValue == 16 then
        if offset <= 0 then return pngError("png repeat code has no previous length") end if
        repeat = readBits(reader, 2) + 3
        value = lengths[offset - 1]
      else
        if symbolValue == 17 then
          repeat = readBits(reader, 3) + 3
          value = 0
        else
          if symbolValue != 18 then return pngError("png dynamic repeat code invalid") end if
          repeat = readBits(reader, 7) + 11
          value = 0
        end if
      end if
      if reader.failed or offset + repeat > total then return pngError("png dynamic repeat exceeds table") end if
      for index = 0 to repeat - 1
        lengths[offset] = value
        offset = offset + 1
      end for
    end if
  end while
  literalLengths = array(literalCount, 0)
  distanceLengths = array(distanceCount, 0)
  copyArray(literalLengths, 0, lengths, 0, literalCount)
  copyArray(distanceLengths, 0, lengths, literalCount, distanceCount)
  literalTable = buildHuffman(literalLengths)
  distanceTable = buildHuffman(distanceLengths)
  if literalTable.valid == false or distanceTable.valid == false then return pngError("png dynamic deflate table invalid") end if
  return [literalTable, distanceTable]
end function

/// Returns the RFC 1951 base length for a length symbol.
/// @param index Zero-based length-code index.
function lengthBase(index)
  values = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258]
  return values[index]
end function

/// Returns the RFC 1951 extra-bit count for a length symbol.
/// @param index Zero-based length-code index.
function lengthExtra(index)
  values = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0]
  return values[index]
end function

/// Returns the RFC 1951 base distance for a distance symbol.
/// @param index Zero-based distance-code index.
function distanceBase(index)
  values = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145, 8193, 12289, 16385, 24577]
  return values[index]
end function

/// Returns the RFC 1951 extra-bit count for a distance symbol.
/// @param index Zero-based distance-code index.
function distanceExtra(index)
  values = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13]
  return values[index]
end function

/// Computes an Adler-32 checksum over decoded zlib output.
/// @param data Uncompressed byte sequence.
function adler32(data)
  a = 1
  b = 0
  for index = 0 to len(data) - 1
    a = (a + data[index]) % 65521
    b = (b + a) % 65521
  end for
  return (b << 16) | a
end function

/// Portable fallback for zlib/Deflate streams rejected by the native bridge.
/// @param data Complete zlib stream.
/// @param expectedSize Required uncompressed byte count.
/// @internal
function _inflateZlibPortable(data, expectedSize)
  if not hasRange(data, 0, 6) then return pngError("png zlib stream too small") end if
  cmf = data[0]
  flags = data[1]
  if (cmf & 15) != 8 or ((cmf << 8) + flags) % 31 != 0 then return pngError("png zlib header invalid") end if
  if (flags & 32) != 0 then return pngError("png zlib preset dictionary is unsupported") end if
  if typeof(expectedSize) != "int" or expectedSize < 0 then return pngError("png inflated size invalid") end if
  output = bytes(expectedSize, 0)
  outputPosition = 0
  reader = BitReader(data, 2, 0, 0, false)
  finalBlock = false
  while finalBlock == false
    finalBlock = readBits(reader, 1) != 0
    blockType = readBits(reader, 2)
    if reader.failed then return pngError("png deflate block header truncated") end if
    if blockType == 0 then
      alignBits(reader)
      if not hasRange(data, reader.position, 4) then return pngError("png stored block truncated") end if
      size = by.readU16LE(data, reader.position)
      inverse = by.readU16LE(data, reader.position + 2)
      reader.position = reader.position + 4
      if (size ^ inverse) != 0xFFFF then return pngError("png stored block length check failed") end if
      if not hasRange(data, reader.position, size) or outputPosition + size > expectedSize then return pngError("png stored block payload invalid") end if
      copyBytes(output, outputPosition, data, reader.position, size)
      outputPosition = outputPosition + size
      reader.position = reader.position + size
    else
      if blockType == 3 then return pngError("png deflate block type is reserved") end if
      literalTable = void
      distanceTable = void
      if blockType == 1 then
        literalTable = fixedLiteralTable()
        distanceTable = fixedDistanceTable()
      else
        tables = dynamicTables(reader)
        if typeof(tables) == "error" then return tables end if
        literalTable = tables[0]
        distanceTable = tables[1]
      end if
      blockDone = false
      while blockDone == false
        symbolValue = decodeSymbol(reader, literalTable)
        if symbolValue < 0 then return pngError("png deflate literal stream invalid") end if
        if symbolValue < 256 then
          if outputPosition >= expectedSize then return pngError("png inflated output exceeds expected size") end if
          output[outputPosition] = symbolValue
          outputPosition = outputPosition + 1
        else
          if symbolValue == 256 then
            blockDone = true
          else
            if symbolValue < 257 or symbolValue > 285 then return pngError("png deflate length symbol invalid") end if
            lengthIndex = symbolValue - 257
            length = lengthBase(lengthIndex) + readBits(reader, lengthExtra(lengthIndex))
            distanceSymbol = decodeSymbol(reader, distanceTable)
            if distanceSymbol < 0 or distanceSymbol > 29 then return pngError("png deflate distance symbol invalid") end if
            distance = distanceBase(distanceSymbol) + readBits(reader, distanceExtra(distanceSymbol))
            if reader.failed or distance <= 0 or distance > outputPosition or outputPosition + length > expectedSize then return pngError("png deflate back-reference invalid") end if
            for index = 0 to length - 1
              output[outputPosition] = output[outputPosition - distance]
              outputPosition = outputPosition + 1
            end for
          end if
        end if
      end while
    end if
  end while
  if outputPosition != expectedSize then return pngError("png inflated size does not match image data") end if
  expectedAdler = by.readU32BE(data, len(data) - 4)
  if typeof(expectedAdler) == "int" and adler32(output) != expectedAdler then return pngError("png zlib checksum failed") end if
  return output
end function

/// Inflates a zlib-wrapped Deflate range directly into an exact-sized buffer.
/// The normal path runs in the native runtime and avoids slicing the compressed
/// source. The portable decoder retains precise validation diagnostics.
/// @param data Byte sequence containing the zlib stream.
/// @param offset Start of the complete zlib stream.
/// @param size Compressed stream size.
/// @param expectedSize Required uncompressed byte count.
function inflateZlibRange(data, offset, size, expectedSize)
  if not hasRange(data, offset, size) or size < 6 then return pngError("png zlib stream too small") end if
  if typeof(expectedSize) != "int" or expectedSize < 0 then return pngError("png inflated size invalid") end if
  output = bytes(expectedSize, 0)
  if mpAssetInflateZlib(output, expectedSize, data, offset, size) != 0 then return output end if
  stream = slice(data, offset, size)
  return _inflateZlibPortable(stream, expectedSize)
end function

/// Inflates a complete zlib-wrapped Deflate stream.
/// @param data Complete zlib stream.
/// @param expectedSize Required uncompressed byte count.
function inflateZlib(data, expectedSize)
  if typeof(data) != "bytes" then return pngError("png zlib stream too small") end if
  return inflateZlibRange(data, 0, len(data), expectedSize)
end function

/// Inflates a stored-block zlib stream for backward compatibility.
/// @param data Complete zlib stream using stored blocks.
function inflateStored(data)
  if not hasRange(data, 0, 6) then return pngError("png zlib stream too small") end if
  reader = BitReader(data, 2, 0, 0, false)
  total = 0
  finalBlock = false
  while finalBlock == false
    finalBlock = readBits(reader, 1) != 0
    blockType = readBits(reader, 2)
    if blockType != 0 then return pngError("png deflate block is not stored") end if
    alignBits(reader)
    if not hasRange(data, reader.position, 4) then return pngError("png stored block truncated") end if
    size = by.readU16LE(data, reader.position)
    inverse = by.readU16LE(data, reader.position + 2)
    if (size ^ inverse) != 0xFFFF then return pngError("png stored block length check failed") end if
    reader.position = reader.position + 4
    if not hasRange(data, reader.position, size) then return pngError("png stored block payload truncated") end if
    total = total + size
    reader.position = reader.position + size
  end while
  return inflateZlib(data, total)
end function

/// Returns the PNG Paeth predictor for three neighboring bytes.
/// @param a Left byte.
/// @param b Byte above.
/// @param c Upper-left byte.
function paeth(a, b, c)
  estimate = a + b - c
  distanceA = estimate - a
  if distanceA < 0 then distanceA = 0 - distanceA end if
  distanceB = estimate - b
  if distanceB < 0 then distanceB = 0 - distanceB end if
  distanceC = estimate - c
  if distanceC < 0 then distanceC = 0 - distanceC end if
  if distanceA <= distanceB and distanceA <= distanceC then return a end if
  if distanceB <= distanceC then return b end if
  return c
end function

/// Reconstructs PNG scanlines for filter types 0 through 4.
/// @param raw Inflated filter bytes and row payloads.
/// @param widthBytes Bytes in one reconstructed row.
/// @param height Number of rows.
/// @param bytesPerPixel Filter predictor byte stride.
function unfilter(raw, widthBytes, height, bytesPerPixel)
  scanlines = bytes(widthBytes * height, 0)
  for y = 0 to height - 1
    rawStart = y * (widthBytes + 1)
    filter = raw[rawStart]
    if filter < 0 or filter > 4 then return pngError("png scanline filter is invalid") end if
    rowStart = y * widthBytes
    for x = 0 to widthBytes - 1
      source = raw[rawStart + 1 + x]
      left = 0
      above = 0
      upperLeft = 0
      if x >= bytesPerPixel then left = scanlines[rowStart + x - bytesPerPixel] end if
      if y > 0 then above = scanlines[rowStart + x - widthBytes] end if
      if y > 0 and x >= bytesPerPixel then upperLeft = scanlines[rowStart + x - widthBytes - bytesPerPixel] end if
      value = source
      if filter == 1 then value = source + left end if
      if filter == 2 then value = source + above end if
      if filter == 3 then value = source + integerDivide(left + above, 2) end if
      if filter == 4 then value = source + paeth(left, above, upperLeft) end if
      scanlines[rowStart + x] = value & 255
    end for
  end for
  return scanlines
end function

/// Returns an indexed-color palette entry for bit depths 1, 2, 4, or 8.
/// @param scanlines Reconstructed packed scanlines.
/// @param rowStart Starting byte offset of the row.
/// @param x Pixel x coordinate.
/// @param bitDepth Indexed sample bit depth.
function paletteIndex(scanlines, rowStart, x, bitDepth)
  if bitDepth == 8 then return scanlines[rowStart + x] end if
  perByte = integerDivide(8, bitDepth)
  packed = scanlines[rowStart + integerDivide(x, perByte)]
  shift = 8 - bitDepth - ((x % perByte) * bitDepth)
  return (packed >> shift) & ((1 << bitDepth) - 1)
end function

/// Converts reconstructed PNG samples into RGBA8888 pixels.
/// @param scanlines Reconstructed sample data.
/// @param width Image width.
/// @param height Image height.
/// @param colorType PNG color-type identifier.
/// @param bitDepth PNG sample bit depth.
/// @param palette Optional PLTE payload.
/// @param transparency Optional tRNS payload.
function toRgba(scanlines, width, height, colorType, bitDepth, palette, transparency)
  pixels = bytes(width * height * 4, 0)
  channels = 1
  if colorType == 2 then channels = 3 end if
  if colorType == 4 then channels = 2 end if
  if colorType == 6 then channels = 4 end if
  rowBytes = integerCeilDivide(width * channels * bitDepth, 8)
  for y = 0 to height - 1
    rowStart = y * rowBytes
    for x = 0 to width - 1
      r = 0
      g = 0
      b = 0
      a = 255
      if colorType == 6 then
        source = rowStart + (x * 4)
        r = scanlines[source]
        g = scanlines[source + 1]
        b = scanlines[source + 2]
        a = scanlines[source + 3]
      else
        if colorType == 2 then
          source = rowStart + (x * 3)
          r = scanlines[source]
          g = scanlines[source + 1]
          b = scanlines[source + 2]
          if typeof(transparency) == "bytes" and len(transparency) >= 6 then
            if r == by.readU16BE(transparency, 0) and g == by.readU16BE(transparency, 2) and b == by.readU16BE(transparency, 4) then a = 0 end if
          end if
        else
          if colorType == 0 or colorType == 4 then
            source = rowStart + (x * channels)
            r = scanlines[source]
            g = r
            b = r
            if colorType == 4 then a = scanlines[source + 1] end if
            if colorType == 0 and typeof(transparency) == "bytes" and len(transparency) >= 2 then
              if r == by.readU16BE(transparency, 0) then a = 0 end if
            end if
          else
            index = paletteIndex(scanlines, rowStart, x, bitDepth)
            paletteOffset = index * 3
            if typeof(palette) != "bytes" or paletteOffset + 2 >= len(palette) then return pngError("png palette index is out of range") end if
            r = palette[paletteOffset]
            g = palette[paletteOffset + 1]
            b = palette[paletteOffset + 2]
            if typeof(transparency) == "bytes" and index < len(transparency) then a = transparency[index] end if
          end if
        end if
      end if
      destination = ((y * width) + x) * 4
      pixels[destination] = r
      pixels[destination + 1] = g
      pixels[destination + 2] = b
      pixels[destination + 3] = a
    end for
  end for
  return pixels
end function

/// Decodes a non-interlaced PNG byte sequence.
/// @param data Complete PNG file bytes.
/// @param name Name assigned to the decoded image.
function decode(data, name)
  if not isPng(data) then return pngError("not a png") end if
  position = 8
  width = 0
  height = 0
  bitDepth = 0
  colorType = 0
  compression = 0
  filterMethod = 0
  interlace = 0
  idatSize = 0
  palette = void
  transparency = void
  while position + 8 <= len(data)
    length = by.readU32BE(data, position)
    if typeof(length) != "int" or length < 0 or not hasRange(data, position + 8, length + 4) then return pngError("png chunk truncated") end if
    payload = position + 8
    expectedCrc = by.readU32BE(data, payload + length)
    actualCrc = crc.computeRange(data, position + 4, length + 4)
    if expectedCrc != actualCrc then return pngError("png chunk checksum failed") end if
    if chunkIs(data, position, 73, 72, 68, 82) then
      if length != 13 then return pngError("png IHDR size is invalid") end if
      width = by.readU32BE(data, payload)
      height = by.readU32BE(data, payload + 4)
      bitDepth = data[payload + 8]
      colorType = data[payload + 9]
      compression = data[payload + 10]
      filterMethod = data[payload + 11]
      interlace = data[payload + 12]
    end if
    if chunkIs(data, position, 80, 76, 84, 69) then palette = slice(data, payload, length) end if
    if chunkIs(data, position, 116, 82, 78, 83) then transparency = slice(data, payload, length) end if
    if chunkIs(data, position, 73, 68, 65, 84) then idatSize = idatSize + length end if
    if chunkIs(data, position, 73, 69, 78, 68) then break end if
    position = position + 12 + length
  end while
  if width <= 0 or height <= 0 then return pngError("png missing IHDR") end if
  if width * height > MAX_IMAGE_PIXELS then return pngError("png dimensions exceed the decode limit") end if
  if compression != 0 or filterMethod != 0 then return pngError("png compression or filter method is unsupported") end if
  if interlace != 0 then return pngError("interlaced png is unsupported") end if
  if colorType != 0 and colorType != 2 and colorType != 3 and colorType != 4 and colorType != 6 then return pngError("png color type is unsupported") end if
  if colorType == 3 then
    if bitDepth != 1 and bitDepth != 2 and bitDepth != 4 and bitDepth != 8 then return pngError("indexed png bit depth is unsupported") end if
    if typeof(palette) != "bytes" then return pngError("indexed png is missing PLTE") end if
  else
    if bitDepth != 8 then return pngError("png must use 8-bit samples") end if
  end if
  channels = 1
  if colorType == 2 then channels = 3 end if
  if colorType == 4 then channels = 2 end if
  if colorType == 6 then channels = 4 end if
  rowBytes = integerCeilDivide(width * channels * bitDepth, 8)
  bytesPerPixel = integerCeilDivide(channels * bitDepth, 8)
  if bytesPerPixel < 1 then bytesPerPixel = 1 end if
  expected = (rowBytes + 1) * height
  idat = bytes(idatSize, 0)
  idatOffset = 0
  position = 8
  while position + 8 <= len(data)
    length = by.readU32BE(data, position)
    payload = position + 8
    if chunkIs(data, position, 73, 68, 65, 84) then
      copyBytes(idat, idatOffset, data, payload, length)
      idatOffset = idatOffset + length
    end if
    if chunkIs(data, position, 73, 69, 78, 68) then break end if
    position = position + 12 + length
  end while
  raw = inflateZlib(idat, expected)
  if typeof(raw) == "error" then return raw end if
  scanlines = unfilter(raw, rowBytes, height, bytesPerPixel)
  if typeof(scanlines) == "error" then return scanlines end if
  pixels = toRgba(scanlines, width, height, colorType, bitDepth, palette, transparency)
  if typeof(pixels) == "error" then return pixels end if
  return sp.newImage(width, height, pixels, name)
end function

/// Loads and decodes a PNG directly from disk.
/// @param path PNG file path.
function load(path)
  data = try(fs.readAllBytes(path))
  if typeof(data) == "error" then return data end if
  return minipixels.assets.png.decode(data, path)
end function

/// Wraps raw bytes in a zlib stream made from deterministic stored blocks.
/// @param raw Uncompressed payload.
function encodeStoredZlib(raw)
  blockCount = integerCeilDivide(len(raw), 65535)
  if blockCount < 1 then blockCount = 1 end if
  output = bytes(2 + len(raw) + (blockCount * 5) + 4, 0)
  output[0] = 0x78
  output[1] = 0x01
  source = 0
  destination = 2
  for blockIndex = 0 to blockCount - 1
    remaining = len(raw) - source
    size = remaining
    if size > 65535 then size = 65535 end if
    if blockIndex == blockCount - 1 then output[destination] = 1 end if
    by.writeU16LE(output, destination + 1, size)
    by.writeU16LE(output, destination + 3, size ^ 0xFFFF)
    if size > 0 then copyBytes(output, destination + 5, raw, source, size) end if
    source = source + size
    destination = destination + size + 5
  end for
  by.writeU32BE(output, destination, adler32(raw))
  return output
end function

/// Creates one PNG chunk including its CRC-32 checksum.
/// @param chunkType Four chunk-type bytes.
/// @param payload Chunk payload bytes.
function encodeChunk(chunkType, payload)
  checked = chunkType + payload
  result = bytes(12 + len(payload), 0)
  by.writeU32BE(result, 0, len(payload))
  copyBytes(result, 4, checked, 0, len(checked))
  by.writeU32BE(result, 8 + len(payload), crc.compute(checked))
  return result
end function

/// Encodes RGBA8888 pixels as a deterministic non-interlaced PNG.
/// @param width Image width.
/// @param height Image height.
/// @param pixels Width-times-height RGBA byte buffer.
function encodeRgba(width, height, pixels)
  if typeof(width) != "int" or typeof(height) != "int" or width <= 0 or height <= 0 then return pngError("png dimensions are invalid") end if
  if width * height > MAX_IMAGE_PIXELS then return pngError("png dimensions exceed the encode limit") end if
  if typeof(pixels) != "bytes" or len(pixels) != width * height * 4 then return pngError("png rgba payload size is invalid") end if
  raw = bytes((width * 4 + 1) * height, 0)
  for y = 0 to height - 1
    destination = y * (width * 4 + 1)
    copyBytes(raw, destination + 1, pixels, y * width * 4, width * 4)
  end for
  header = bytes(13, 0)
  by.writeU32BE(header, 0, width)
  by.writeU32BE(header, 4, height)
  header[8] = 8
  header[9] = 6
  signature = bytes(8, 0)
  signature[0] = 137
  signature[1] = 80
  signature[2] = 78
  signature[3] = 71
  signature[4] = 13
  signature[5] = 10
  signature[6] = 26
  signature[7] = 10
  ihdrType = bytes(4, 0)
  ihdrType[0] = 73
  ihdrType[1] = 72
  ihdrType[2] = 68
  ihdrType[3] = 82
  idatType = bytes(4, 0)
  idatType[0] = 73
  idatType[1] = 68
  idatType[2] = 65
  idatType[3] = 84
  iendType = bytes(4, 0)
  iendType[0] = 73
  iendType[1] = 69
  iendType[2] = 78
  iendType[3] = 68
  return signature + encodeChunk(ihdrType, header) + encodeChunk(idatType, encodeStoredZlib(raw)) + encodeChunk(iendType, bytes(0, 0))
end function

/// Saves RGBA8888 pixels to a PNG file.
/// @param path Destination path.
/// @param width Image width.
/// @param height Image height.
/// @param pixels Width-times-height RGBA byte buffer.
function saveRgba(path, width, height, pixels)
  encoded = encodeRgba(width, height, pixels)
  if typeof(encoded) == "error" then return encoded end if
  return fs.writeAllBytes(path, encoded)
end function
