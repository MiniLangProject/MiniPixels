package minipixels.assets.pack

import std.fs as fs
import std.bytes as by
import minipixels.assets.png as png

const PACK_ERR = 9302

struct AssetPack
  path
  data
  names
  kinds
  offsets
  sizes
  count
end struct

function packError(message)
  return error(PACK_ERR, message)
end function

function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

function isPack(data)
  if not hasRange(data, 0, 8) then return false end if
  return data[0] == 77 and data[1] == 80 and data[2] == 88 and data[3] == 49
end function

function open(path)
  data = try(fs.readAllBytes(path))
  if typeof(data) == "error" then return data end if
  if not isPack(data) then return packError("not a MiniPixels asset pack") end if
  count = by.readU32LE(data, 4)
  if typeof(count) != "int" or count < 0 then return packError("invalid asset count") end if
  names = array(count)
  kinds = array(count, 0)
  offsets = array(count, 0)
  sizes = array(count, 0)
  pos = 8
  i = 0
  while i < count
    if not hasRange(data, pos, 12) then return packError("asset pack index truncated") end if
    nameLen = by.readU16LE(data, pos)
    pos = pos + 2
    if not hasRange(data, pos, nameLen + 10) then return packError("asset pack name truncated") end if
    nameBytes = slice(data, pos, nameLen)
    name = decode(nameBytes)
    if typeof(name) != "string" then return packError("asset pack name is not utf-8") end if
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
    i = i + 1
  end while
  return AssetPack(path, data, names, kinds, offsets, sizes, count)
end function

function find(pack, name)
  if not (pack is AssetPack) then return -1 end if
  i = 0
  while i < pack.count
    if pack.names[i] == name then return i end if
    i = i + 1
  end while
  return -1
end function

function getBytes(pack, name)
  index = find(pack, name)
  if index < 0 then return packError("asset not found: " + name) end if
  return slice(pack.data, pack.offsets[index], pack.sizes[index])
end function

function getKind(pack, name)
  index = find(pack, name)
  if index < 0 then return -1 end if
  return pack.kinds[index]
end function

function loadPng(pack, name)
  payload = getBytes(pack, name)
  if typeof(payload) == "error" then return payload end if
  return png.decode(payload, name)
end function
