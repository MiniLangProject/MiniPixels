// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels assets pack facilities for this project.

package minipixels.assets.pack

import std.fs as fs
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
  /// Stores the offsets value associated with asset pack.
  offsets
  /// Stores the sizes value associated with asset pack.
  sizes
  /// Per-entry AES-GCM nonces for MPX3 payload blocks.
  nonces
  /// Per-entry AES-GCM authentication tags for MPX3 payload blocks.
  tags
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

/// Opens open for the minipixels assets pack module.
/// @param path Path of the file or directory used by the operation.
/// @param data Complete MPX1 byte buffer.
function _openData(path, data)
  if not isPack(data) then return packError("not a MiniPixels asset pack") end if
  count = by.readU32LE(data, 4)
  if typeof(count) != "int" or count < 0 then return packError("invalid asset count") end if
  if count * 12 > len(data) - 8 then return packError("asset count exceeds pack index bounds") end if
  names = array(count)
  kinds = array(count, 0)
  offsets = array(count, 0)
  sizes = array(count, 0)
  index = hm.HashMap.withCapacity((count * 2) + 1)
  pos = 8
  i = 0
  while i < count
    if not hasRange(data, pos, 12) then return packError("asset pack index truncated") end if
    nameLen = by.readU16LE(data, pos)
    if nameLen <= 0 then return packError("asset pack name is empty") end if
    pos = pos + 2
    if not hasRange(data, pos, nameLen + 10) then return packError("asset pack name truncated") end if
    nameBytes = slice(data, pos, nameLen)
    name = decode(nameBytes)
    if typeof(name) != "string" then return packError("asset pack name is not utf-8") end if
    if index.has(name) then return packError("duplicate asset name: " + name) end if
    pos = pos + nameLen
    kind = data[pos]
    pos = pos + 2
    offset = by.readU32LE(data, pos)
    size = by.readU32LE(data, pos + 4)
    pos = pos + 8
    if not hasRange(data, offset, size) then return packError("asset pack payload out of range") end if
    names[i] = name
    kinds[i] = kind
    offsets[i] = offset
    sizes[i] = size
    index.set(name, i)
    i = i + 1
  end while
  if count > 0 then
    for i = 0 to count - 1
      if offsets[i] < pos then return packError("asset payload overlaps the pack index") end if
    end for
  end if
  return AssetPack(path, data, void, false, false, void, names, kinds, offsets, sizes, array(count), array(count), count, index, array(count, false), array(count, false), array(count, false), array(count, false), 0, 0, 0, 0, 0)
end function

/// Reads one unsigned little-endian 64-bit size from an MPX2 header.
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
  offsets = array(count, 0)
  sizes = array(count, 0)
  nameIndex = hm.HashMap.withCapacity((count * 2) + 1)
  pos = 8
  i = 0
  while i < count
    nameSizeData = _readRange(file, pos, 2)
    if typeof(nameSizeData) == "error" then
      fileio.close(file)
      return nameSizeData
    end if
    nameLen = by.readU16LE(nameSizeData, 0)
    if nameLen <= 0 or pos + 12 + nameLen > actualFileSize then
      fileio.close(file)
      return packError("MPX1 asset name truncated")
    end if
    entry = _readRange(file, pos + 2, nameLen + 10)
    if typeof(entry) == "error" then
      fileio.close(file)
      return entry
    end if
    name = decode(slice(entry, 0, nameLen))
    if typeof(name) != "string" or nameIndex.has(name) then
      fileio.close(file)
      return packError("invalid or duplicate MPX1 asset name")
    end if
    kind = entry[nameLen]
    offset = by.readU32LE(entry, nameLen + 2)
    size = by.readU32LE(entry, nameLen + 6)
    if offset < 0 or size < 0 or offset + size > actualFileSize then
      fileio.close(file)
      return packError("MPX1 payload range is invalid")
    end if
    names[i] = name
    kinds[i] = kind
    offsets[i] = offset
    sizes[i] = size
    nameIndex.set(name, i)
    pos = pos + nameLen + 12
    i = i + 1
  end while
  if count > 0 then
    for i = 0 to count - 1
      if offsets[i] < pos then
        fileio.close(file)
        return packError("MPX1 payload overlaps the pack index")
      end if
    end for
  end if
  return AssetPack(path, void, file, true, false, void, names, kinds, offsets, sizes, array(count), array(count), count, nameIndex, array(count, false), array(count, false), array(count, false), array(count, false), 0, 0, 0, 0, 0)
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
  if header[4] != 3 or header[5] != 0 or header[6] != 1 or header[7] != 1 or by.readU16LE(header, 8) != 64 or by.readU16LE(header, 10) != 0 then
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
  offsets = array(count, 0)
  sizes = array(count, 0)
  nonces = array(count)
  tags = array(count)
  nameIndex = hm.HashMap.withCapacity((count * 2) + 1)
  pos = 8
  previousEnd = metadataSize
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
    pos = pos + 2
    offset = _readU64LE(indexData, pos)
    size = _readU64LE(indexData, pos + 8)
    cipherSize = _readU64LE(indexData, pos + 16)
    pos = pos + 24
    entryNonce = slice(indexData, pos, 12)
    entryTag = slice(indexData, pos + 12, 16)
    pos = pos + 28
    if offset < previousEnd or size != cipherSize or offset + cipherSize > storedFileSize then
      fileio.close(file)
      crypto.secureZero(key)
      return packError("MPX3 payload range is invalid")
    end if
    names[i] = name
    kinds[i] = kind
    offsets[i] = offset
    sizes[i] = size
    nonces[i] = entryNonce
    tags[i] = entryTag
    nameIndex.set(name, i)
    previousEnd = offset + cipherSize
    i = i + 1
  end while
  if pos != len(indexData) or previousEnd != storedFileSize then
    fileio.close(file)
    crypto.secureZero(key)
    return packError("MPX3 index has invalid trailing data")
  end if
  keyCopy = slice(key, 0, len(key))
  crypto.secureZero(key)
  return AssetPack(path, void, file, true, true, keyCopy, names, kinds, offsets, sizes, nonces, tags, count, nameIndex, array(count, false), array(count, false), array(count, false), array(count, false), 0, 0, 0, 0, 0)
end function

/// Opens an authenticated MPX3 or legacy MPX2 pack. MPX3 verifies/decrypts
/// only its index up front; caller-owned AES key bytes are always wiped.
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
  if header[0] == 77 and header[1] == 80 and header[2] == 88 and header[3] == 51 then
    return _openProtected3(path, file, header, key, publicKey, expectedKeyId)
  end if
  fileio.close(file)
  data = try(fs.readAllBytes(path))
  if typeof(data) == "error" then
    crypto.secureZero(key)
    return data
  end if
  if not hasRange(data, 0, 144) or data[0] != 77 or data[1] != 80 or data[2] != 88 or data[3] != 50 then
    crypto.secureZero(key)
    return packError("not a protected MiniPixels asset pack")
  end if
  if data[4] != 2 or data[5] != 0 or data[6] != 1 or data[7] != 1 or by.readU16LE(data, 8) != 64 or by.readU16LE(data, 10) != 0 then
    crypto.secureZero(key)
    return packError("unsupported MPX2 header or algorithm suite")
  end if
  plaintextSize = _readU64LE(data, 12)
  ciphertextSize = _readU64LE(data, 20)
  expectedSize = 64 + ciphertextSize + 16 + 64
  if plaintextSize < 8 or plaintextSize != ciphertextSize or expectedSize != len(data) then
    crypto.secureZero(key)
    return packError("invalid MPX2 payload size")
  end if
  storedKeyId = slice(data, 40, 8)
  if not crypto.constantTimeEquals(storedKeyId, expectedKeyId) then
    crypto.secureZero(key)
    return packError("MPX2 signing key mismatch")
  end if
  signedLength = 64 + ciphertextSize + 16
  signed = slice(data, 0, signedLength)
  signature = slice(data, signedLength, 64)
  if not ecdsa.verify(publicKey, signed, signature) then
    crypto.secureZero(key)
    return packError("MPX2 signature verification failed")
  end if
  header = slice(data, 0, 64)
  nonce = slice(data, 28, 12)
  ciphertext = slice(data, 64, ciphertextSize)
  tag = slice(data, 64 + ciphertextSize, 16)
  plaintext = try(aes.decrypt(key, nonce, ciphertext, tag, header))
  crypto.secureZero(key)
  if typeof(plaintext) == "error" then return packError("MPX2 decryption failed") end if
  if len(plaintext) != plaintextSize then return packError("MPX2 plaintext size mismatch") end if
  return _openData(path, plaintext)
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
  if not pack.fileBacked and typeof(pack.data) != "bytes" then return packError("asset pack is closed") end if
  pack.payloadMisses = pack.payloadMisses + 1
  payload = void
  if pack.protected then
    ciphertext = _readRange(pack.file, pack.offsets[index], pack.sizes[index])
    if typeof(ciphertext) == "error" then return ciphertext end if
    payload = try(aes.decrypt(pack.key, pack.nonces[index], ciphertext, pack.tags[index], bytes(0, 0)))
    if typeof(payload) == "error" then return packError("MPX3 asset authentication failed: " + pack.names[index]) end if
  else if pack.fileBacked then
    payload = _readRange(pack.file, pack.offsets[index], pack.sizes[index])
    if typeof(payload) == "error" then return payload end if
  else
    payload = slice(pack.data, pack.offsets[index], pack.sizes[index])
  end if
  pack.payloadCache[index] = payload
  pack.payloadLoaded[index] = true
  pack.cachedPayloadBytes = pack.cachedPayloadBytes + len(payload)
  return payload
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
  if not (pack is AssetPack) then return AssetPackStats(0, 0, 0, 0, 0, 0, false) end if
  return AssetPackStats(pack.count, pack.payloadHits, pack.payloadMisses, pack.imageHits, pack.imageMisses, pack.cachedPayloadBytes, pack.fileBacked)
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
