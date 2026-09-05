// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels assets pack facilities for this project.

package minipixels.assets.pack

import std.fs as fs
import std.bytes as by
import std.ds.hashmap as hm
import minipixels.assets.png as png

/// Defines the pack err constant used by the minipixels assets pack module.
const PACK_ERR = 9302

/// Represents the asset pack data used by the minipixels assets pack module.
struct AssetPack
  /// Stores the path value associated with asset pack.
  path
  /// Stores the data value associated with asset pack.
  data
  /// Stores the names value associated with asset pack.
  names
  /// Stores the kinds value associated with asset pack.
  kinds
  /// Stores the offsets value associated with asset pack.
  offsets
  /// Stores the sizes value associated with asset pack.
  sizes
  /// Stores the count value associated with asset pack.
  count
  /// Hash index mapping names to entry slots.
  index
  /// Cache of sliced payload byte buffers.
  payloadCache
  /// Cache of decoded image objects.
  imageCache
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
function open(path)
  data = try(fs.readAllBytes(path))
  if typeof(data) == "error" then return data end if
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
  return AssetPack(path, data, names, kinds, offsets, sizes, count, index, hm.HashMap.withCapacity((count * 2) + 1), hm.HashMap.withCapacity((count * 2) + 1))
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
/// @param name Name of the affected item.
function getBytes(pack, name)
  index = find(pack, name)
  if index < 0 then return packError("asset not found: " + name) end if
  cached = pack.payloadCache.get(name)
  if typeof(cached) == "bytes" then return cached end if
  payload = slice(pack.data, pack.offsets[index], pack.sizes[index])
  pack.payloadCache.set(name, payload)
  return payload
end function

/// Returns kind maintained by the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param name Name of the affected item.
function getKind(pack, name)
  index = find(pack, name)
  if index < 0 then return -1 end if
  return pack.kinds[index]
end function

/// Loads png for the minipixels assets pack module.
/// @param pack pack value consumed by this operation.
/// @param name Name of the affected item.
function loadPng(pack, name)
  cached = pack.imageCache.get(name)
  if typeof(cached) != "void" then return cached end if
  payload = getBytes(pack, name)
  if typeof(payload) == "error" then return payload end if
  image = png.decode(payload, name)
  if typeof(image) != "error" then pack.imageCache.set(name, image) end if
  return image
end function

/// Removes cached payload and decoded image data for one entry.
/// @param pack Asset pack whose caches are updated.
/// @param name Stable asset name.
function unload(pack, name)
  if find(pack, name) < 0 then return false end if
  pack.payloadCache.remove(name)
  pack.imageCache.remove(name)
  return true
end function

/// Clears every derived payload and image cache while retaining the pack index.
/// @param pack Asset pack whose caches are cleared.
function clearCache(pack)
  pack.payloadCache.clear()
  pack.imageCache.clear()
end function
