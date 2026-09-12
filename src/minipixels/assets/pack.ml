// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels assets pack facilities for this project.

package minipixels.assets.pack

import std.io.file as fileio
import std.bytes as by
import std.crypto as crypto
import std.crypto.aes_gcm as aes
import std.crypto.ecdsa_p256 as ecdsa
import std.ds.hashmap as hm
import minipixels.assets.png as png

/// Defines the pack err constant used by the minipixels assets pack module.
const PACK_ERR = 9302
/// Maximum encrypted index accepted before signature verification.
const MAX_INDEX_SIZE = 67108864
/// No container-level payload compression.
const CODEC_NONE = 0
/// MPC1-wrapped zlib/Deflate payload compression.
const CODEC_DEFLATE = 1
/// MPR1 byte-run compression used by the native MiniLang packer.
const CODEC_RLE = 2
/// Maximum logical size of one decompressed asset.
const MAX_DECOMPRESSED_ASSET_SIZE = 536870912
/// Default upper bound for one temporary contiguous preload read.
const DEFAULT_PRELOAD_BATCH_BYTES = 16777216

/// Represents the asset pack data used by the minipixels assets pack module.
struct AssetPack
  /// Stores the path value associated with asset pack.
  path
  /// Stores the data value associated with asset pack.
  data
  /// Open random-access file handle used by MPX3 packs.
  file
  /// Whether payload bytes remain in the source file until first access.
  fileBacked
  /// Whether payloads are independently encrypted MPX3 blocks.
  protected
  /// AES key retained only while a lazy MPX3 pack is open.
  key
  /// Stores the names value associated with asset pack.
  names
  /// Stores the kinds value associated with asset pack.
  kinds
  /// Per-entry container compression codec.
  codecs
  /// Stores the offsets value associated with asset pack.
  offsets
  /// Logical payload sizes where available.
  sizes
  /// Number of bytes stored in the backing file for each entry.
  storedSizes
  /// Per-entry AES-GCM nonces for MPX3 payload blocks.
  nonces
  /// Per-entry AES-GCM authentication tags for MPX3 payload blocks.
  tags
  /// Canonical slot for entries that share one identical stored block.
  owners
  /// Stores the count value associated with asset pack.
  count
  /// Hash index mapping names to entry slots.
  index
  /// Cache of sliced payload byte buffers.
  payloadCache
  /// Whether each payload slot currently contains cached bytes.
  payloadLoaded
  /// Cache of decoded image objects.
  imageCache
  /// Whether each image slot currently contains a decoded image.
  imageLoaded
  /// Number of payload-cache hits.
  payloadHits
  /// Number of payload reads or slices.
  payloadMisses
  /// Number of decoded-image cache hits.
  imageHits
  /// Number of image decodes.
  imageMisses
  /// Bytes currently retained by the payload cache.
  cachedPayloadBytes
  /// Stored payload bytes read from the backing file.
  storedBytesRead
  /// Logical payload bytes materialized by cache misses.
  decodedBytes
  /// Number of contiguous reads issued by bulk preloading.
  bulkReads
end struct

/// Snapshot of asset-pack cache and I/O activity.
struct AssetPackStats
  entries
  payloadHits
  payloadMisses
  imageHits
  imageMisses
  cachedPayloadBytes
  lazyFile
  storedBytesRead
  decodedBytes
  bulkReads
end struct

/// Performs the packError operation for the minipixels assets pack module.
/// @param message Human-readable message associated with the operation.
function packError(message)
  return error(PACK_ERR, message)
end function

/// Returns whether range is available.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param size Size in the units required by the operation.
function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

/// Returns whether pack satisfies the required condition.
/// @param data Input data consumed by the operation.
function isPack(data)
  if not hasRange(data, 0, 8) then return false end if
  return data[0] == 77 and data[1] == 80 and data[2] == 88 and data[3] == 49
end function

/// Expands a stored payload range according to its index codec.
/// Deflate reads directly from the supplied range into the final logical buffer.
/// @internal
function _decodePayloadRange(codec, payload, offset, storedSize, expectedSize)
  if not hasRange(payload, offset, storedSize) then return packError("asset payload range is invalid") end if
  if codec == CODEC_NONE then
    if expectedSize >= 0 and storedSize != expectedSize then return packError("asset payload size mismatch") end if
    if offset == 0 and storedSize == len(payload) then return payload end if
    return slice(payload, offset, storedSize)
  end if
  if codec != CODEC_DEFLATE and codec != CODEC_RLE then return packError("unsupported asset compression codec") end if
  if storedSize < 8 or payload[offset] != 77 or payload[offset + 1] != 80 then
    return packError("compressed asset envelope is invalid")
  end if
  if codec == CODEC_DEFLATE and (payload[offset + 2] != 67 or payload[offset + 3] != 49) then return packError("compressed asset envelope is invalid") end if
  if codec == CODEC_RLE and (payload[offset + 2] != 82 or payload[offset + 3] != 49) then return packError("compressed asset envelope is invalid") end if
  logicalSize = by.readU32LE(payload, offset + 4)
  if logicalSize < 0 or logicalSize > MAX_DECOMPRESSED_ASSET_SIZE then return packError("compressed asset size exceeds limit") end if
  if expectedSize >= 0 and logicalSize != expectedSize then return packError("compressed asset size mismatch") end if
  if codec == CODEC_DEFLATE then
    decoded = try(png.inflateZlibRange(payload, offset + 8, storedSize - 8, logicalSize))
    if typeof(decoded) == "error" then return packError("asset decompression failed") end if
    return decoded
  end if
  decoded = bytes(logicalSize, 0)
  source = offset + 8
  sourceEnd = offset + storedSize
  target = 0
  while source < sourceEnd
    control = payload[source]
    source = source + 1
    if (control & 128) != 0 then
      run = (control & 127) + 3
      if source >= sourceEnd or target + run > logicalSize then return packError("RLE asset payload is invalid") end if
      value = payload[source]
      source = source + 1
      for i = 0 to run - 1
        decoded[target + i] = value
      end for
      target = target + run
    else
      run = control + 1
      if source + run > sourceEnd or target + run > logicalSize then return packError("RLE asset payload is invalid") end if
      copyBytes(decoded, target, payload, source, run)
      source = source + run
      target = target + run
    end if
  end while
  if target != logicalSize then return packError("RLE asset payload is truncated") end if
  return decoded
end function

/// Expands one authenticated/read payload according to its index codec.
/// @internal
function _decodePayload(codec, payload, expectedSize)
  return _decodePayloadRange(codec, payload, 0, len(payload), expectedSize)
end function

/// Reads one unsigned little-endian 64-bit size from an MPX3 header or index.
/// @internal
function _readU64LE(data, offset)
  low = by.readU32LE(data, offset)
  high = by.readU32LE(data, offset + 4)
  if typeof(low) != "int" or typeof(high) != "int" then return -1 end if
  return low + high * 4294967296
end function

/// Opens an MPX1 index while leaving its payloads file-backed and lazy.
/// @internal
function _openFile1(path, file, header)
  if not isPack(header) then
    fileio.close(file)
    return packError("not a MiniPixels asset pack")
  end if
  count = by.readU32LE(header, 4)
  actualFileSize = fileio.size(file)
  if typeof(count) != "int" or count < 0 or typeof(actualFileSize) == "error" or count * 12 > actualFileSize - 8 then
    fileio.close(file)
    return packError("invalid MPX1 asset count")
  end if
  names = array(count)
  kinds = array(count, 0)
  codecs = array(count, 0)
  offsets = array(count, 0)
  sizes = array(count, 0)
  nameIndex = hm.HashMap.withCapacity((count * 2) + 1)
  indexData = bytes(0, 0)
  indexSize = 0
  payloadBase = 8
  if count > 0 then
    prefixSize = actualFileSize - 8
    if prefixSize > 65547 then prefixSize = 65547 end if
    prefix = _readRange(file, 8, prefixSize)
    if typeof(prefix) == "error" then
      fileio.close(file)
      return prefix
    end if
    if not hasRange(prefix, 0, 2) then
      fileio.close(file)
      return packError("MPX1 asset index truncated")
    end if
    firstNameLen = by.readU16LE(prefix, 0)
    if firstNameLen <= 0 or not hasRange(prefix, 0, firstNameLen + 12) then
      fileio.close(file)
      return packError("MPX1 first asset entry truncated")
    end if
    payloadBase = by.readU32LE(prefix, firstNameLen + 4)
    indexSize = payloadBase - 8
    if payloadBase < 8 or indexSize > MAX_INDEX_SIZE or payloadBase > actualFileSize then
      fileio.close(file)
      return packError("MPX1 asset index size is invalid")
    end if
    if indexSize <= len(prefix) then
      indexData = prefix
    else
      indexData = _readRange(file, 8, indexSize)
      if typeof(indexData) == "error" then
        fileio.close(file)
        return indexData
      end if
    end if
  end if
  pos = 0
  i = 0
  while i < count
    if not hasRange(indexData, pos, 2) then
      fileio.close(file)
      return packError("MPX1 asset index truncated")
    end if
    nameLen = by.readU16LE(indexData, pos)
    if nameLen <= 0 or pos + nameLen + 12 > indexSize then
      fileio.close(file)
      return packError("MPX1 asset name truncated")
    end if
    name = decode(slice(indexData, pos + 2, nameLen))
    if typeof(name) != "string" or nameIndex.has(name) then
      fileio.close(file)
      return packError("invalid or duplicate MPX1 asset name")
    end if
    kind = indexData[pos + nameLen + 2]
    codec = indexData[pos + nameLen + 3]
    if codec != CODEC_NONE and codec != CODEC_DEFLATE and codec != CODEC_RLE then
      fileio.close(file)
      return packError("unsupported asset compression codec")
    end if
    offset = by.readU32LE(indexData, pos + nameLen + 4)
    size = by.readU32LE(indexData, pos + nameLen + 8)
    if offset < 0 or size < 0 or offset + size > actualFileSize then
      fileio.close(file)
      return packError("MPX1 payload range is invalid")
    end if
    names[i] = name
    kinds[i] = kind
    codecs[i] = codec
    offsets[i] = offset
    sizes[i] = size
    nameIndex.set(name, i)
    pos = pos + nameLen + 12
    i = i + 1
  end while
  if pos != indexSize then
    fileio.close(file)
    return packError("MPX1 asset index has invalid trailing data")
  end if
  if count > 0 then
    for i = 0 to count - 1
      if offsets[i] < payloadBase then
        fileio.close(file)
        return packError("MPX1 payload overlaps the pack index")
      end if
    end for
  end if
  owners = array(count, 0)
  blocks = hm.HashMap.withCapacity((count * 2) + 1)
  if count > 0 then
    for i = 0 to count - 1
      blockKey = "" + offsets[i] + ":" + sizes[i] + ":" + codecs[i]
      owner = blocks.get(blockKey)
      if typeof(owner) == "int" then
        owners[i] = owner
      else
        owners[i] = i
        blocks.set(blockKey, i)
      end if
    end for
  end if
  return AssetPack(path, void, file, true, false, void, names, kinds, codecs, offsets, sizes, sizes, array(count), array(count), owners, count, nameIndex, array(count, false), array(count, false), array(count, false), array(count, false), 0, 0, 0, 0, 0, 0, 0, 0)
end function

/// Opens an ordinary MPX1 asset pack with lazy random-access payload reads.
/// @param path Path to the asset pack.
function open(path)
  file = fileio.openRead(path)
  if typeof(file) == "error" then return file end if
  header = _readRange(file, 0, 8)
  if typeof(header) == "error" then
    fileio.close(file)
    return header
  end if
  return _openFile1(path, file, header)
end function

/// Reads an exact byte range from an open random-access file.
/// @internal
function _readRange(file, offset, size)
  if typeof(size) != "int" or size < 0 then return packError("invalid asset range size") end if
  result = bytes(size, 0)
  actual = fileio.readExactAt(file, offset, result, 0, size)
  if typeof(actual) == "error" then return actual end if
  return result
end function

/// Opens an MPX3 pack by authenticating and decrypting only its compact index.
/// Payload blocks remain encrypted on disk until first access.
/// @internal
function _openProtected3(path, file, header, key, publicKey, expectedKeyId)
  if header[4] != 4 or header[5] != 0 or header[6] != 1 or header[7] != 1 or by.readU16LE(header, 8) != 64 or by.readU16LE(header, 10) != 0 then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("unsupported MPX3 header or algorithm suite")
  end if
  indexSize = _readU64LE(header, 12)
  indexCipherSize = _readU64LE(header, 20)
  storedFileSize = _readU64LE(header, 28)
  actualFileSize = fileio.size(file)
  metadataSize = 64 + indexCipherSize + 16 + 64
  if typeof(actualFileSize) == "error" or indexSize < 8 or indexSize > MAX_INDEX_SIZE or indexSize != indexCipherSize or metadataSize > storedFileSize or storedFileSize != actualFileSize then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("invalid MPX3 size")
  end if
  storedKeyId = slice(header, 48, 8)
  if not crypto.constantTimeEquals(storedKeyId, expectedKeyId) then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("MPX3 signing key mismatch")
  end if
  metadata = _readRange(file, 0, metadataSize)
  if typeof(metadata) == "error" then
    fileio.close(file)
    crypto.secureZero(key)
    return metadata
  end if
  signedLength = 64 + indexCipherSize + 16
  signed = slice(metadata, 0, signedLength)
  signature = slice(metadata, signedLength, 64)
  if not ecdsa.verify(publicKey, signed, signature) then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("MPX3 signature verification failed")
  end if
  nonce = slice(header, 36, 12)
  ciphertext = slice(metadata, 64, indexCipherSize)
  tag = slice(metadata, 64 + indexCipherSize, 16)
  indexData = try(aes.decrypt(key, nonce, ciphertext, tag, header))
  if typeof(indexData) == "error" then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("MPX3 index decryption failed")
  end if
  if not hasRange(indexData, 0, 8) or indexData[0] != 77 or indexData[1] != 80 or indexData[2] != 73 or indexData[3] != 51 then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("invalid MPX3 index")
  end if
  count = by.readU32LE(indexData, 4)
  if typeof(count) != "int" or count < 0 or count * 56 > len(indexData) - 8 then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("invalid MPX3 asset count")
  end if
  names = array(count)
  kinds = array(count, 0)
  codecs = array(count, 0)
  offsets = array(count, 0)
  sizes = array(count, 0)
  storedSizes = array(count, 0)
  nonces = array(count)
  tags = array(count)
  nameIndex = hm.HashMap.withCapacity((count * 2) + 1)
  pos = 8
  maximumEnd = metadataSize
  i = 0
  while i < count
    if not hasRange(indexData, pos, 56) then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 index truncated")
    end if
    nameLen = by.readU16LE(indexData, pos)
    pos = pos + 2
    if nameLen <= 0 or not hasRange(indexData, pos, nameLen + 54) then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 asset name truncated")
    end if
    name = decode(slice(indexData, pos, nameLen))
    if typeof(name) != "string" or nameIndex.has(name) then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("invalid or duplicate MPX3 asset name")
    end if
    pos = pos + nameLen
    kind = indexData[pos]
    codec = indexData[pos + 1]
    if codec != CODEC_NONE and codec != CODEC_DEFLATE and codec != CODEC_RLE then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("unsupported MPX3 asset compression codec")
    end if
    pos = pos + 2
    offset = _readU64LE(indexData, pos)
    size = _readU64LE(indexData, pos + 8)
    cipherSize = _readU64LE(indexData, pos + 16)
    pos = pos + 24
    entryNonce = slice(indexData, pos, 12)
    entryTag = slice(indexData, pos + 12, 16)
    pos = pos + 28
    if offset < metadataSize or size < 0 or cipherSize < 0 or offset + cipherSize > storedFileSize then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 payload range is invalid")
    end if
    if codec == CODEC_NONE and size != cipherSize then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 payload size is invalid")
    end if
    if codec != CODEC_NONE and size > MAX_DECOMPRESSED_ASSET_SIZE then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 decompressed asset size exceeds limit")
    end if
    names[i] = name
    kinds[i] = kind
    codecs[i] = codec
    offsets[i] = offset
    sizes[i] = size
    storedSizes[i] = cipherSize
    nonces[i] = entryNonce
    tags[i] = entryTag
    nameIndex.set(name, i)
    if offset + cipherSize > maximumEnd then maximumEnd = offset + cipherSize end if
    i = i + 1
  end while
  if pos != len(indexData) or maximumEnd != storedFileSize then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("MPX3 index has invalid trailing data")
  end if
  owners = array(count, 0)
  blocks = hm.HashMap.withCapacity((count * 2) + 1)
  if count > 0 then
    for i = 0 to count - 1
      blockKey = "" + offsets[i] + ":" + storedSizes[i]
      owner = blocks.get(blockKey)
      if typeof(owner) == "int" then
        if codecs[owner] != codecs[i] or sizes[owner] != sizes[i] or not crypto.constantTimeEquals(nonces[owner], nonces[i]) or not crypto.constantTimeEquals(tags[owner], tags[i]) then
          fileio.close(file)
          crypto.secureZero(key)
          return packError("MPX3 shared payload metadata mismatch")
        end if
        owners[i] = owner
      else
        owners[i] = i
        blocks.set(blockKey, i)
      end if
    end for
  end if
  keyCopy = slice(key, 0, len(key))
  crypto.secureZero(key)
  return AssetPack(path, void, file, true, true, keyCopy, names, kinds, codecs, offsets, sizes, storedSizes, nonces, tags, owners, count, nameIndex, array(count, false), array(count, false), array(count, false), array(count, false), 0, 0, 0, 0, 0, 0, 0, 0)
end function

/// Opens an authenticated MPX3 version-4 pack. Only its index is verified and
/// decrypted up front; caller-owned AES key bytes are always wiped.
/// @param path Path to the protected pack.
/// @param key Obfuscated build key reconstructed by generated game code.
/// @param publicKey Embedded 64-byte P-256 public key.
/// @param expectedKeyId Embedded 8-byte public-key fingerprint prefix.
function openProtected(path, key, publicKey, expectedKeyId)
  if typeof(key) != "bytes" or len(key) != 32 then return packError("invalid protected-pack AES key") end if
  if typeof(publicKey) != "bytes" or len(publicKey) != 64 then
    crypto.secureZero(key)
    return packError("invalid protected-pack public key")
  end if
  if typeof(expectedKeyId) != "bytes" or len(expectedKeyId) != 8 then
    crypto.secureZero(key)
    return packError("invalid protected-pack key id")
  end if
  file = fileio.openRead(path)
  if typeof(file) == "error" then
    crypto.secureZero(key)
    return file
  end if
  header = _readRange(file, 0, 64)
  if typeof(header) == "error" then
    fileio.close(file)
    crypto.secureZero(key)
    return header
  end if
  if header[0] != 77 or header[1] != 80 or header[2] != 88 or header[3] != 51 then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("not an MPX3 protected asset pack")
  end if
  return _openProtected3(path, file, header, key, publicKey, expectedKeyId)
end function

/// Finds find used by the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param name Name of the affected item.
function find(pack, name)
  if not (pack is AssetPack) then return -1 end if
  if typeof(name) != "string" then return -1 end if
  index = pack.index.get(name)
  if typeof(index) != "int" then return -1 end if
  return index
end function

/// Returns bytes maintained by the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param index Pre-resolved entry slot.
function getBytesAt(pack, index)
  if not (pack is AssetPack) or typeof(index) != "int" or index < 0 or index >= pack.count then return packError("invalid asset slot") end if
  if pack.payloadLoaded[index] then
    pack.payloadHits = pack.payloadHits + 1
    return pack.payloadCache[index]
  end if
  owner = pack.owners[index]
  if owner != index then
    payload = getBytesAt(pack, owner)
    if typeof(payload) == "error" then return payload end if
    pack.payloadCache[index] = payload
    pack.payloadLoaded[index] = true
    pack.cachedPayloadBytes = pack.cachedPayloadBytes + len(payload)
    return payload
  end if
  if not pack.fileBacked and typeof(pack.data) != "bytes" then return packError("asset pack is closed") end if
  pack.payloadMisses = pack.payloadMisses + 1
  payload = void
  if pack.protected then
    ciphertext = _readRange(pack.file, pack.offsets[index], pack.storedSizes[index])
    if typeof(ciphertext) == "error" then return ciphertext end if
    pack.storedBytesRead = pack.storedBytesRead + pack.storedSizes[index]
    payload = try(aes.decrypt(pack.key, pack.nonces[index], ciphertext, pack.tags[index], bytes(0, 0)))
    if typeof(payload) == "error" then return packError("MPX3 asset authentication failed: " + pack.names[index]) end if
  else if pack.fileBacked then
    payload = _readRange(pack.file, pack.offsets[index], pack.storedSizes[index])
    if typeof(payload) == "error" then return payload end if
    pack.storedBytesRead = pack.storedBytesRead + pack.storedSizes[index]
  else
    payload = slice(pack.data, pack.offsets[index], pack.storedSizes[index])
  end if
  expectedSize = -1
  if pack.protected then expectedSize = pack.sizes[index] end if
  payload = _decodePayload(pack.codecs[index], payload, expectedSize)
  if typeof(payload) == "error" then return payload end if
  pack.payloadCache[index] = payload
  pack.payloadLoaded[index] = true
  pack.cachedPayloadBytes = pack.cachedPayloadBytes + len(payload)
  pack.decodedBytes = pack.decodedBytes + len(payload)
  return payload
end function

/// Preloads selected asset slots with contiguous, bounded file reads.
/// Already cached slots are skipped. File-order sorting turns a long sequence of
/// small random reads into a small number of sequential reads without retaining
/// the temporary batch buffer.
/// @param pack Open asset pack.
/// @param slots Array of pre-resolved entry slots.
/// @param maxBatchBytes Maximum temporary read size, or a non-positive value for the default.
function preloadSlots(pack, slots, maxBatchBytes)
  if not (pack is AssetPack) then return packError("invalid asset pack") end if
  if typeof(slots) != "array" then return packError("asset preload slots must be an array") end if
  if typeof(maxBatchBytes) != "int" or maxBatchBytes <= 0 then maxBatchBytes = DEFAULT_PRELOAD_BATCH_BYTES end if
  if len(slots) == 0 then return true end if
  if not pack.fileBacked then
    for i = 0 to len(slots) - 1
      loaded = getBytesAt(pack, slots[i])
      if typeof(loaded) == "error" then return loaded end if
    end for
    return true
  end if

  // Resolve duplicates once, reject invalid slots, and sort by physical offset.
  requested = array(pack.count, false)
  seen = array(pack.count, false)
  ordered = array(len(slots), -1)
  orderedCount = 0
  for i = 0 to len(slots) - 1
    slot = slots[i]
    if typeof(slot) != "int" or slot < 0 or slot >= pack.count then return packError("invalid asset preload slot") end if
    requested[slot] = true
    owner = pack.owners[slot]
    if not pack.payloadLoaded[owner] and not seen[owner] then
      seen[owner] = true
      insertAt = orderedCount
      while insertAt > 0 and pack.offsets[ordered[insertAt - 1]] > pack.offsets[owner]
        ordered[insertAt] = ordered[insertAt - 1]
        insertAt = insertAt - 1
      end while
      ordered[insertAt] = owner
      orderedCount = orderedCount + 1
    end if
  end for

  cursor = 0
  while cursor < orderedCount
    first = ordered[cursor]
    batchStart = pack.offsets[first]
    batchEnd = batchStart + pack.storedSizes[first]
    batchLimit = cursor + 1
    while batchLimit < orderedCount
      candidate = ordered[batchLimit]
      candidateEnd = pack.offsets[candidate] + pack.storedSizes[candidate]
      if candidateEnd - batchStart > maxBatchBytes then
        break
      end if
      if candidateEnd > batchEnd then batchEnd = candidateEnd end if
      batchLimit = batchLimit + 1
    end while
    region = _readRange(pack.file, batchStart, batchEnd - batchStart)
    if typeof(region) == "error" then return region end if
    pack.bulkReads = pack.bulkReads + 1
    pack.storedBytesRead = pack.storedBytesRead + len(region)

    item = cursor
    while item < batchLimit
      slot = ordered[item]
      if not pack.payloadLoaded[slot] then
        relativeOffset = pack.offsets[slot] - batchStart
        payload = void
        if pack.protected then
          stored = slice(region, relativeOffset, pack.storedSizes[slot])
          payload = try(aes.decrypt(pack.key, pack.nonces[slot], stored, pack.tags[slot], bytes(0, 0)))
          if typeof(payload) == "error" then return packError("MPX3 asset authentication failed: " + pack.names[slot]) end if
          payload = _decodePayload(pack.codecs[slot], payload, pack.sizes[slot])
        else
          payload = _decodePayloadRange(pack.codecs[slot], region, relativeOffset, pack.storedSizes[slot], -1)
        end if
        if typeof(payload) == "error" then return payload end if
        pack.payloadCache[slot] = payload
        pack.payloadLoaded[slot] = true
        pack.payloadMisses = pack.payloadMisses + 1
        pack.cachedPayloadBytes = pack.cachedPayloadBytes + len(payload)
        pack.decodedBytes = pack.decodedBytes + len(payload)
      end if
      item = item + 1
    end while
    cursor = batchLimit
  end while
  for i = 0 to pack.count - 1
    if requested[i] and not pack.payloadLoaded[i] then
      owner = pack.owners[i]
      if not pack.payloadLoaded[owner] then return packError("asset preload alias is unavailable") end if
      payload = pack.payloadCache[owner]
      pack.payloadCache[i] = payload
      pack.payloadLoaded[i] = true
      pack.payloadHits = pack.payloadHits + 1
      pack.cachedPayloadBytes = pack.cachedPayloadBytes + len(payload)
    end if
  end for
  return true
end function

/// Preloads every payload in an asset pack through bounded contiguous reads.
/// @param pack Open asset pack.
/// @param maxBatchBytes Maximum temporary read size, or a non-positive value for the default.
function preloadAll(pack, maxBatchBytes)
  if not (pack is AssetPack) then return packError("invalid asset pack") end if
  slots = array(pack.count, 0)
  if pack.count > 0 then
    for i = 0 to pack.count - 1
      slots[i] = i
    end for
  end if
  return preloadSlots(pack, slots, maxBatchBytes)
end function

/// Returns bytes for a named entry while retaining the compatible string API.
/// @param pack Asset pack to read.
/// @param name Stable asset name.
function getBytes(pack, name)
  index = find(pack, name)
  if index < 0 then return packError("asset not found: " + name) end if
  return getBytesAt(pack, index)
end function

/// Returns kind maintained by the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param name Name of the affected item.
function getKind(pack, name)
  index = find(pack, name)
  if index < 0 then return -1 end if
  return pack.kinds[index]
end function

/// Returns the type code of a pre-resolved asset slot.
/// @param pack Asset pack to inspect.
/// @param index Pre-resolved entry slot.
function getKindAt(pack, index)
  if not (pack is AssetPack) or typeof(index) != "int" or index < 0 or index >= pack.count then return -1 end if
  return pack.kinds[index]
end function

/// Loads png for the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param index Pre-resolved entry slot.
function loadPngAt(pack, index)
  if not (pack is AssetPack) or typeof(index) != "int" or index < 0 or index >= pack.count then return packError("invalid asset slot") end if
  if pack.imageLoaded[index] then
    pack.imageHits = pack.imageHits + 1
    return pack.imageCache[index]
  end if
  pack.imageMisses = pack.imageMisses + 1
  payload = getBytesAt(pack, index)
  if typeof(payload) == "error" then return payload end if
  image = png.decode(payload, pack.names[index])
  if typeof(image) != "error" then
    pack.imageCache[index] = image
    pack.imageLoaded[index] = true
    dropPayloadAt(pack, index)
  end if
  return image
end function

/// Loads and caches a named PNG image.
/// @param pack Asset pack to read.
/// @param name Stable asset name.
function loadPng(pack, name)
  index = find(pack, name)
  if index < 0 then return packError("asset not found: " + name) end if
  return loadPngAt(pack, index)
end function

/// Releases only cached raw bytes for one pre-resolved slot.
/// @param pack Asset pack whose payload cache is updated.
/// @param index Pre-resolved entry slot.
function dropPayloadAt(pack, index)
  if not (pack is AssetPack) or typeof(index) != "int" or index < 0 or index >= pack.count or not pack.payloadLoaded[index] then return false end if
  pack.cachedPayloadBytes = pack.cachedPayloadBytes - len(pack.payloadCache[index])
  pack.payloadCache[index] = false
  pack.payloadLoaded[index] = false
  return true
end function

/// Removes cached payload and decoded image data for one entry.
/// @param pack Asset pack whose caches are updated.
/// @param name Stable asset name.
function unload(pack, name)
  index = find(pack, name)
  if index < 0 then return false end if
  dropPayloadAt(pack, index)
  pack.imageCache[index] = false
  pack.imageLoaded[index] = false
  return true
end function

/// Clears every derived payload and image cache while retaining the pack index.
/// @param pack Asset pack whose caches are cleared.
function clearCache(pack)
  if not (pack is AssetPack) then return end if
  if pack.count > 0 then
    for i = 0 to pack.count - 1
      pack.payloadCache[i] = false
      pack.payloadLoaded[i] = false
      pack.imageCache[i] = false
      pack.imageLoaded[i] = false
    end for
  end if
  pack.cachedPayloadBytes = 0
end function

/// Returns current cache hit/miss and resident-byte counters.
/// @param pack Asset pack to inspect.
function stats(pack)
  if not (pack is AssetPack) then return AssetPackStats(0, 0, 0, 0, 0, 0, false, 0, 0, 0) end if
  return AssetPackStats(pack.count, pack.payloadHits, pack.payloadMisses, pack.imageHits, pack.imageMisses, pack.cachedPayloadBytes, pack.fileBacked, pack.storedBytesRead, pack.decodedBytes, pack.bulkReads)
end function

/// Closes a lazy pack and wipes its retained AES key.
/// @param pack Asset pack to close.
function close(pack)
  if not (pack is AssetPack) then return false end if
  clearCache(pack)
  if pack.fileBacked then
    if pack.protected then crypto.secureZero(pack.key) end if
    result = fileio.close(pack.file)
    pack.protected = false
    pack.fileBacked = false
    pack.file = false
    pack.data = false
    return typeof(result) != "error"
  end if
  pack.data = false
  return true
end function
