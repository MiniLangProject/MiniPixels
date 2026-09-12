// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools generator facilities for this project.

package minipixels.tools.generator

import minipixels.tools.fsutil as fsu
import minipixels.tools.json as json
import minipixels.tools.manifest as manifest
import minipixels.assets.png as png
import std.array as arr
import std.bytes as by
import std.fs as fs
import std.sort as sorting
import std.string as strings
import std.string_builder as sb

/// Represents the generate result data used by the minipixels tools generator module.
struct GenerateResult
  /// Stores the ok value associated with generate result.
  ok
  /// Stores the out dir value associated with generate result.
  outDir
  /// Stores the warnings value associated with generate result.
  warnings
  /// Stores the errors value associated with generate result.
  errors
end struct

/// Stored representation selected for one native pack payload.
struct PackedPayload
  codec
  data
end struct

/// Performs the result operation for the minipixels tools generator module.
/// @param outDir outDir value consumed by this operation.
function result(outDir)
  return GenerateResult(true, outDir, [], [])
end function

/// Adds warning to the state managed by the minipixels tools generator module.
/// @param r r value consumed by this operation.
/// @param msg msg value consumed by this operation.
function addWarning(r, msg)
  r.warnings = arr.append(r.warnings, msg)
end function

/// Adds error to the state managed by the minipixels tools generator module.
/// @param r r value consumed by this operation.
/// @param msg msg value consumed by this operation.
function addError(r, msg)
  r.ok = false
  r.errors = arr.append(r.errors, msg)
end function

/// Performs the defaultOutDir operation for the minipixels tools generator module.
/// @param projectPath Path associated with project.
function defaultOutDir(projectPath)
  root = manifest.dirname(projectPath)
  return fs.joinPath(fs.joinPath(fs.joinPath(root, "build"), "generated"), "generated")
end function

/// Performs the quote operation for the minipixels tools generator module.
/// @param text Text consumed by the operation.
function quote(text)
  return "\"" + text + "\""
end function

/// Quotes a generated source path after normalizing directory separators.
/// @param text Path text.
function quotePath(text)
  return quote(strings.replaceAll(text, "\\", "/"))
end function

/// Returns the ASCII code of one validated identifier character.
/// @param ch One-character string.
function identifierCode(ch)
  uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  lowercase = "abcdefghijklmnopqrstuvwxyz"
  digits = "0123456789"
  offset = strings.indexOf(uppercase, ch, 0)
  if offset >= 0 then return 65 + offset end if
  offset = strings.indexOf(lowercase, ch, 0)
  if offset >= 0 then return 97 + offset end if
  offset = strings.indexOf(digits, ch, 0)
  if offset >= 0 then return 48 + offset end if
  return 95
end function

/// Encodes the manifest's ASCII-safe identifiers as bytes.
/// @param text Validated MiniLang identifier.
function identifierBytes(text)
  result = bytes(len(text), 0)
  for index = 0 to len(text) - 1
    result[index] = identifierCode(text[index])
  end for
  return result
end function

/// Joins join for the minipixels tools generator workflow.
/// @param root root value consumed by this operation.
/// @param rel rel value consumed by this operation.
function join(root, rel)
  return fs.joinPath(root, rel)
end function

/// Divides non-negative integers while retaining an integer result.
/// @param value Dividend.
/// @param divisor Positive divisor.
function integerDivide(value, divisor)
  return (value - (value % divisor)) / divisor
end function

/// Orders manifest assets by stable id for reproducible output.
/// @param left First asset object.
/// @param right Second asset object.
function assetLess(left, right)
  leftId = stringField(left, "id", "")
  rightId = stringField(right, "id", "")
  count = len(leftId)
  if len(rightId) < count then count = len(rightId) end if
  for index = 0 to count - 1
    leftCode = identifierCode(leftId[index])
    rightCode = identifierCode(rightId[index])
    if leftCode < rightCode then return true end if
    if leftCode > rightCode then return false end if
  end for
  return len(leftId) < len(rightId)
end function

/// Returns a sorted copy of a JSON asset array.
/// @param root Parsed project root.
function sortedAssets(root)
  items = arrayField(root, "assets")
  result = []
  if len(items) > 0 then
    for index = 0 to len(items) - 1
      if stringField(items[index], "type", "image") != "constants" then result = arr.append(result, items[index]) end if
    end for
  end if
  sorting.sortBy(result, assetLess)
  return result
end function

/// Performs the numberField operation for the minipixels tools generator module.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function numberField(obj, key, fallback)
  return json.asNumber(json.get(obj, key), fallback)
end function

/// Performs the stringField operation for the minipixels tools generator module.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function stringField(obj, key, fallback)
  return json.asString(json.get(obj, key), fallback)
end function

/// Performs the arrayField operation for the minipixels tools generator module.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
function arrayField(obj, key)
  v = json.get(obj, key)
  if typeof(v) == "void" or v.kind != "array" then return [] end if
  return v.arrayItems
end function

/// Performs the objectField operation for the minipixels tools generator module.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
function objectField(obj, key)
  v = json.get(obj, key)
  if typeof(v) == "void" or v.kind != "object" then return void end if
  return v
end function

/// Performs the colorPart operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param index Zero-based index of the affected item.
/// @param fallback Value returned when no explicit result is available.
function colorPart(asset, key, index, fallback)
  color = json.get(asset, key)
  if typeof(color) == "void" or color.kind != "array" then return fallback end if
  if len(color.arrayItems) <= index then return fallback end if
  item = color.arrayItems[index]
  return json.asNumber(item, fallback)
end function

/// Performs the sheetWidth operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function sheetWidth(asset, fallback)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return fallback end if
  return numberField(sheet, "frameWidth", fallback)
end function

/// Performs the sheetHeight operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function sheetHeight(asset, fallback)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return fallback end if
  return numberField(sheet, "frameHeight", fallback)
end function

/// Performs the assetWidth operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
function assetWidth(asset)
  return numberField(asset, "width", sheetWidth(asset, 16))
end function

/// Performs the assetHeight operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
function assetHeight(asset)
  return numberField(asset, "height", sheetHeight(asset, 16))
end function

/// Renders one procedural manifest asset into RGBA8888 pixels.
/// @param asset Procedural asset object.
function renderProceduralPixels(asset)
  width = assetWidth(asset)
  height = assetHeight(asset)
  kind = stringField(asset, "kind", "checker")
  primary = [colorPart(asset, "color", 0, 255), colorPart(asset, "color", 1, 128), colorPart(asset, "color", 2, 0), colorPart(asset, "color", 3, 255)]
  secondary = [colorPart(asset, "secondary", 0, 40), colorPart(asset, "secondary", 1, 40), colorPart(asset, "secondary", 2, 50), colorPart(asset, "secondary", 3, 255)]
  pixels = bytes(width * height * 4, 0)
  tileWidth = integerDivide(width, 4)
  tileHeight = integerDivide(height, 4)
  if tileWidth < 1 then tileWidth = 1 end if
  if tileHeight < 1 then tileHeight = 1 end if
  for y = 0 to height - 1
    for x = 0 to width - 1
      color = primary
      if kind == "blank" then
        color = [0, 0, 0, 0]
      else if kind == "player" then
        if x == 0 or x == width - 1 or y == 0 or y == height - 1 then
          color = [0, 0, 0, 0]
        else if y < integerDivide(height, 3) then
          color = [255, 232, 170, 255]
        else if x >= integerDivide(width, 2) then
          color = secondary
        end if
      else if kind == "tiles" then
        if (integerDivide(x, tileWidth) + integerDivide(y, tileHeight)) % 2 != 0 then color = secondary end if
      else
        if (integerDivide(x, 4) + integerDivide(y, 4)) % 2 != 0 then color = secondary end if
      end if
      offset = ((y * width) + x) * 4
      pixels[offset] = color[0]
      pixels[offset + 1] = color[1]
      pixels[offset + 2] = color[2]
      pixels[offset + 3] = color[3]
    end for
  end for
  return pixels
end function

/// Returns the MPX kind identifier for an asset type.
/// @param asset Manifest asset object.
function assetKind(asset)
  typ = stringField(asset, "type", "image")
  if typ == "audio" then return 2 end if
  if typ == "file" then return 3 end if
  if typ == "text" then return 4 end if
  if typ == "data" then return 5 end if
  return 1
end function

/// Converts a JSON string catalog into the deterministic MPT1 payload format.
/// @param path Source JSON file path.
function textCatalogPayload(path)
  source = try(fs.readAllText(path))
  if typeof(source) == "error" then return source end if
  root = try(json.parse(source))
  if typeof(root) == "error" then return root end if
  if root.kind != "object" then return error(9201, "text asset must contain a JSON object: " + path) end if
  total = 8
  if len(root.objectKeys) > 0 then
    for i = 0 to len(root.objectKeys) - 1
      value = root.objectValues[i]
      if value.kind != "string" then return error(9201, "text asset values must be strings: " + path) end if
      nameBytes = bytes(root.objectKeys[i])
      valueBytes = bytes(value.stringValue)
      if len(nameBytes) <= 0 or len(nameBytes) > 65535 then return error(9201, "invalid text key length: " + path) end if
      total = total + 6 + len(nameBytes) + len(valueBytes)
    end for
  end if
  output = bytes(total, 0)
  output[0] = 77
  output[1] = 80
  output[2] = 84
  output[3] = 49
  by.writeU32LE(output, 4, len(root.objectKeys))
  offset = 8
  if len(root.objectKeys) > 0 then
    for i = 0 to len(root.objectKeys) - 1
      nameBytes = bytes(root.objectKeys[i])
      valueBytes = bytes(root.objectValues[i].stringValue)
      by.writeU16LE(output, offset, len(nameBytes))
      by.writeU32LE(output, offset + 2, len(valueBytes))
      offset = offset + 6
      copyBytes(output, offset, nameBytes, 0, len(nameBytes))
      offset = offset + len(nameBytes)
      copyBytes(output, offset, valueBytes, 0, len(valueBytes))
      offset = offset + len(valueBytes)
    end for
  end if
  return output
end function

/// Loads or generates a payload for native MPX packaging.
/// @param asset Manifest asset object.
/// @param projectRoot Project directory.
function assetPayload(asset, projectRoot)
  typ = stringField(asset, "type", "image")
  if typ == "procedural" then
    return png.encodeRgba(assetWidth(asset), assetHeight(asset), renderProceduralPixels(asset))
  end if
  path = stringField(asset, "path", "")
  if path == "" then return error(9201, "asset '" + stringField(asset, "id", "asset") + "' requires a path") end if
  if typ == "text" then return textCatalogPayload(join(projectRoot, path)) end if
  return fs.readAllBytes(join(projectRoot, path))
end function

/// Encodes repeated byte runs and bounded literal spans into an MPR1 envelope.
/// @internal
function rlePayload(data)
  output = bytes((len(data) * 2) + 8, 0)
  output[0] = 77
  output[1] = 80
  output[2] = 82
  output[3] = 49
  by.writeU32LE(output, 4, len(data))
  source = 0
  target = 8
  while source < len(data)
    run = 1
    while source + run < len(data) and data[source + run] == data[source] and run < 130
      run = run + 1
    end while
    if run >= 3 then
      output[target] = 128 | (run - 3)
      output[target + 1] = data[source]
      target = target + 2
      source = source + run
    else
      literalStart = source
      source = source + run
      while source < len(data) and source - literalStart < 128
        nextRun = 1
        while source + nextRun < len(data) and data[source + nextRun] == data[source] and nextRun < 130
          nextRun = nextRun + 1
        end while
        if nextRun >= 3 then break end if
        remaining = 128 - (source - literalStart)
        if nextRun > remaining then nextRun = remaining end if
        source = source + nextRun
      end while
      literalSize = source - literalStart
      output[target] = literalSize - 1
      target = target + 1
      copyBytes(output, target, data, literalStart, literalSize)
      target = target + literalSize
    end if
  end while
  return slice(output, 0, target)
end function

/// Selects native RLE only when its complete envelope produces a useful saving.
/// @internal
function compactPayload(data, profile)
  if profile == "none" then return PackedPayload(0, data) end if
  if len(data) < 32 then return PackedPayload(0, data) end if
  encoded = rlePayload(data)
  minimumSaving = integerDivide(len(data), 100)
  if minimumSaving < 8 then minimumSaving = 8 end if
  if profile == "small" then minimumSaving = 1 end if
  if len(encoded) + minimumSaving <= len(data) then return PackedPayload(2, encoded) end if
  return PackedPayload(0, data)
end function

/// Writes a deterministic native MiniPixels asset pack.
/// @param root Parsed project root.
/// @param projectRoot Project directory.
/// @param path Output MPX path.
/// @param r Generation result receiving diagnostics.
function writeAssetPack(root, projectRoot, path, r)
  sourceAssets = sortedAssets(root)
  loading = objectField(root, "assetLoading")
  defaultCompression = "auto"
  if typeof(loading) != "void" then defaultCompression = stringField(loading, "compression", "auto") end if
  count = len(sourceAssets)
  ids = array(count)
  kinds = array(count, 0)
  codecs = array(count, 0)
  payloads = array(count)
  duplicateOf = array(count, -1)
  indexSize = 8
  payloadSize = 0
  if count > 0 then
    for index = 0 to count - 1
      asset = sourceAssets[index]
      id = stringField(asset, "id", "asset")
      logicalPayload = try(assetPayload(asset, projectRoot))
      if typeof(logicalPayload) == "error" then
        addError(r, logicalPayload.message)
        return false
      end if
      packed = compactPayload(logicalPayload, stringField(asset, "compression", defaultCompression))
      payload = packed.data
      encodedId = identifierBytes(id)
      ids[index] = encodedId
      kinds[index] = assetKind(asset)
      codecs[index] = packed.codec
      payloads[index] = payload
      indexSize = indexSize + 12 + len(encodedId)
      duplicate = -1
      if index > 0 then
        for previous = 0 to index - 1
          if codecs[previous] == packed.codec and fsu.bytesEqual(payloads[previous], payload) then
            duplicate = previous
            break
          end if
        end for
      end if
      duplicateOf[index] = duplicate
      if duplicate < 0 then payloadSize = payloadSize + len(payload) end if
    end for
  end if
  output = bytes(indexSize + payloadSize, 0)
  output[0] = 77
  output[1] = 80
  output[2] = 88
  output[3] = 49
  by.writeU32LE(output, 4, count)
  entryOffset = 8
  payloadOffset = indexSize
  payloadOffsets = array(count, 0)
  if count > 0 then
    for index = 0 to count - 1
      idBytes = ids[index]
      payload = payloads[index]
      by.writeU16LE(output, entryOffset, len(idBytes))
      copyBytes(output, entryOffset + 2, idBytes, 0, len(idBytes))
      entryOffset = entryOffset + 2 + len(idBytes)
      output[entryOffset] = kinds[index]
      output[entryOffset + 1] = codecs[index]
      storedOffset = payloadOffset
      if duplicateOf[index] >= 0 then storedOffset = payloadOffsets[duplicateOf[index]] end if
      payloadOffsets[index] = storedOffset
      by.writeU32LE(output, entryOffset + 2, storedOffset)
      by.writeU32LE(output, entryOffset + 6, len(payload))
      entryOffset = entryOffset + 10
      if duplicateOf[index] < 0 then
        if len(payload) > 0 then copyBytes(output, payloadOffset, payload, 0, len(payload)) end if
        payloadOffset = payloadOffset + len(payload)
      end if
    end for
  end if
  written = try(fsu.writeBytes(path, output))
  if typeof(written) == "error" or written == false then
    if typeof(written) != "error" then written = error(9201, "could not write asset pack: " + path) end if
    addError(r, written.message)
    return false
  end if
  return true
end function

/// Returns whether sheet is available.
/// @param asset asset value consumed by this operation.
function hasSheet(asset)
  return typeof(objectField(asset, "sheet")) != "void"
end function

/// Performs the sheetModule operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param id Stable identifier of the affected item.
function sheetModule(asset, id)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return "" end if
  fw = numberField(sheet, "frameWidth", assetWidth(asset))
  fh = numberField(sheet, "frameHeight", assetHeight(asset))
  spacing = numberField(sheet, "spacing", 0)
  margin = numberField(sheet, "margin", 0)
  code = sb.StringBuilder.withCapacity(256)
  code.appendLine("sheet_" + id + "_cache = void")
  code.appendLine("")
  code.appendLine("function sheet_" + id + "()")
  code.appendLine("  global sheet_" + id + "_cache")
  code.appendLine("  if sheet_" + id + "_cache == void then")
  code.appendLine("    spr = make_" + id + "()")
  code.appendLine("    sheet_" + id + "_cache = mp.spriteSheet(spr.image, " + fw + ", " + fh + ", " + spacing + ", " + margin + ")")
  code.appendLine("  end if")
  code.appendLine("  return sheet_" + id + "_cache")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the assetsHeader operation for the minipixels tools generator module.
/// @param root Parsed project root.
/// @param fallbackPackPath Project-relative fallback path to the generated pack.
function assetsHeader(root, fallbackPackPath)
  code = sb.StringBuilder.withCapacity(2048)
  loading = objectField(root, "assetLoading")
  mode = "lazy"
  batchBytes = 16777216
  if typeof(loading) != "void" then
    mode = stringField(loading, "mode", "lazy")
    batchBytes = numberField(loading, "batchBytes", 16777216)
  end if
  code.appendLine("package generated.assets")
  code.appendLine("")
  code.appendLine("import minipixels as mp")
  code.appendLine("import minipixels.assets.assets as assets")
  code.appendLine("")
  code.appendLine("assetPackCache = void")
  code.appendLine("")
  code.appendLine("function assetPack()")
  code.appendLine("  global assetPackCache")
  code.appendLine("  if assetPackCache == void then")
  code.appendLine("    opened = try(mp.openAssetPack(\"assets.mpx\"))")
  code.appendLine("    if typeof(opened) == \"error\" then opened = try(mp.openAssetPack(\"build/assets.mpx\")) end if")
  code.appendLine("    if typeof(opened) == \"error\" then opened = mp.openAssetPack(" + quotePath(fallbackPackPath) + ") end if")
  if mode == "resident" then
    code.appendLine("    resident = try(mp.preloadAssetPack(opened, " + batchBytes + "))")
    code.appendLine("    if typeof(resident) == \"error\" then")
    code.appendLine("      mp.closeAssetPack(opened)")
    code.appendLine("      return resident")
    code.appendLine("    end if")
  end if
  code.appendLine("    assetPackCache = opened")
  code.appendLine("  end if")
  code.appendLine("  return assetPackCache")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the assetModule operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param r r value consumed by this operation.
/// @param slot Stable pack slot generated for the asset.
function assetModule(asset, r, slot)
  id = stringField(asset, "id", "asset")
  code = sb.StringBuilder.withCapacity(512)
  code.appendLine("sprite_" + id + "_cache = void")
  code.appendLine("")
  code.appendLine("function make_" + id + "()")
  code.appendLine("  global sprite_" + id + "_cache")
  code.appendLine("  if sprite_" + id + "_cache == void then")
  code.appendLine("    img = mp.loadPngFromPackSlot(assetPack(), " + slot + ")")
  code.appendLine("    sprite_" + id + "_cache = mp.spriteFromImage(img, " + quote(id) + ")")
  code.appendLine("  end if")
  code.appendLine("  return sprite_" + id + "_cache")
  code.appendLine("end function")
  code.appendLine("")
  code.appendString(sheetModule(asset, id))
  return code.toString()
end function

/// Emits an audio or generic-file accessor backed by the generated pack.
/// @param asset Manifest asset object.
/// @param slot Stable pack slot generated for the asset.
function runtimeAssetModule(asset, slot)
  id = stringField(asset, "id", "asset")
  typ = stringField(asset, "type", "file")
  code = sb.StringBuilder.withCapacity(256)
  if typ == "audio" then
    code.appendLine("audio_" + id + "_cache = void")
    code.appendLine("")
    code.appendLine("function audio_" + id + "()")
    code.appendLine("  global audio_" + id + "_cache")
    code.appendLine("  if audio_" + id + "_cache == void then audio_" + id + "_cache = mp.audioClipFromBytes(mp.loadBytesFromPackSlot(assetPack(), " + slot + "), " + quote(id) + ") end if")
    code.appendLine("  return audio_" + id + "_cache")
    code.appendLine("end function")
  else if typ == "text" then
    locale = stringField(asset, "locale", id)
    code.appendLine("text_" + id + "_cache = void")
    code.appendLine("")
    code.appendLine("function text_" + id + "()")
    code.appendLine("  global text_" + id + "_cache")
    code.appendLine("  if text_" + id + "_cache == void then text_" + id + "_cache = mp.loadTextCatalogFromPackSlot(assetPack(), " + slot + ", " + quote(locale) + ") end if")
    code.appendLine("  return text_" + id + "_cache")
    code.appendLine("end function")
  else if typ == "data" then
    code.appendLine("data_" + id + "_cache = void")
    code.appendLine("data_" + id + "_loaded = false")
    code.appendLine("")
    code.appendLine("function data_" + id + "()")
    code.appendLine("  global data_" + id + "_cache")
    code.appendLine("  global data_" + id + "_loaded")
    code.appendLine("  if data_" + id + "_loaded then return data_" + id + "_cache end if")
    code.appendLine("  data_" + id + "_cache = decode(mp.loadBytesFromPackSlot(assetPack(), " + slot + "))")
    code.appendLine("  data_" + id + "_loaded = true")
    code.appendLine("  mp.releasePackedAssetBytesSlot(assetPack(), " + slot + ")")
    code.appendLine("  return data_" + id + "_cache")
    code.appendLine("end function")
  else
    code.appendLine("function file_" + id + "()")
    code.appendLine("  return mp.loadBytesFromPackSlot(assetPack(), " + slot + ")")
    code.appendLine("end function")
  end if
  code.appendLine("")
  return code.toString()
end function

/// Performs the assetsModule operation for the minipixels tools generator module.
/// @param root root value consumed by this operation.
/// @param fallbackPackPath Project-relative fallback pack path.
/// @param r r value consumed by this operation.
function assetsModule(root, fallbackPackPath, r)
  code = sb.StringBuilder.withCapacity(4096)
  code.appendString(assetsHeader(root, fallbackPackPath))
  assets = sortedAssets(root)
  loading = objectField(root, "assetLoading")
  batchBytes = 16777216
  if typeof(loading) != "void" then batchBytes = numberField(loading, "batchBytes", 16777216) end if
  embedded = []
  if len(assets) > 0 then
    for i = 0 to len(assets) - 1
      id = stringField(assets[i], "id", "asset")
      code.appendLine("slot_" + id + "_cache = -1")
      code.appendLine("")
      code.appendLine("function slot_" + id + "()")
      code.appendLine("  global slot_" + id + "_cache")
      code.appendLine("  if slot_" + id + "_cache < 0 then slot_" + id + "_cache = mp.assetSlotFromPack(assetPack(), " + quote(id) + ") end if")
      code.appendLine("  return slot_" + id + "_cache")
      code.appendLine("end function")
      code.appendLine("")
    end for
    for i = 0 to len(assets) - 1
      asset = assets[i]
      typ = stringField(asset, "type", "image")
      id = stringField(asset, "id", "asset")
      if typ == "image" or typ == "procedural" then
        code.appendString(assetModule(asset, r, "slot_" + id + "()"))
        embedded = arr.append(embedded, asset)
      else if typ != "constants" then
        code.appendString(runtimeAssetModule(asset, "slot_" + id + "()"))
      end if
    end for
  end if
  if len(assets) > 0 then
    code.appendLine("function preload()")
    code.appendLine("  opened = assetPack()")
    code.appendLine("  if typeof(opened) == \"error\" then return opened end if")
    code.appendLine("  loaded = try(mp.preloadAssetPack(opened, " + batchBytes + "))")
    code.appendLine("  if typeof(loaded) == \"error\" then return loaded end if")
    for i = 0 to len(assets) - 1
      asset = assets[i]
      typ = stringField(asset, "type", "image")
      id = stringField(asset, "id", "asset")
      if typ == "image" or typ == "procedural" then code.appendLine("  make_" + id + "()") end if
      if typ == "audio" then code.appendLine("  audio_" + id + "()") end if
      if typ == "text" then code.appendLine("  text_" + id + "()") end if
      if typ == "data" then code.appendLine("  data_" + id + "()") end if
      if typ == "file" then code.appendLine("  file_" + id + "()") end if
    end for
    code.appendLine("  return true")
    code.appendLine("end function")
    code.appendLine("")

    groups = []
    for i = 0 to len(assets) - 1
      preloadValue = json.get(assets[i], "preload")
      group = ""
      if typeof(preloadValue) != "void" and preloadValue.kind == "bool" and preloadValue.boolValue then group = "boot" end if
      if typeof(preloadValue) != "void" and preloadValue.kind == "string" then group = preloadValue.stringValue end if
      if group != "" and not arr.contains(groups, group) then groups = arr.append(groups, group) end if
    end for
    if len(groups) > 0 then
      sorting.sort(groups)
      code.appendLine("function preloadGroup(group)")
      for groupIndex = 0 to len(groups) - 1
        group = groups[groupIndex]
        slots = ""
        for i = 0 to len(assets) - 1
          preloadValue = json.get(assets[i], "preload")
          assetGroup = ""
          if typeof(preloadValue) != "void" and preloadValue.kind == "bool" and preloadValue.boolValue then assetGroup = "boot" end if
          if typeof(preloadValue) != "void" and preloadValue.kind == "string" then assetGroup = preloadValue.stringValue end if
          if assetGroup == group then
            if slots != "" then slots = slots + ", " end if
            slots = slots + "slot_" + stringField(assets[i], "id", "asset") + "()"
          end if
        end for
        code.appendLine("  if group == " + quote(group) + " then")
        code.appendLine("    opened = assetPack()")
        code.appendLine("    if typeof(opened) == \"error\" then return opened end if")
        code.appendLine("    loaded = try(mp.preloadAssetPackSlots(opened, [" + slots + "], " + batchBytes + "))")
        code.appendLine("    if typeof(loaded) == \"error\" then return loaded end if")
        for i = 0 to len(assets) - 1
          asset = assets[i]
          preloadValue = json.get(asset, "preload")
          assetGroup = ""
          if typeof(preloadValue) != "void" and preloadValue.kind == "bool" and preloadValue.boolValue then assetGroup = "boot" end if
          if typeof(preloadValue) != "void" and preloadValue.kind == "string" then assetGroup = preloadValue.stringValue end if
          if assetGroup == group then
            typ = stringField(asset, "type", "image")
            id = stringField(asset, "id", "asset")
            if typ == "image" or typ == "procedural" then code.appendLine("    make_" + id + "()") end if
            if typ == "audio" then code.appendLine("    audio_" + id + "()") end if
            if typ == "text" then code.appendLine("    text_" + id + "()") end if
            if typ == "data" then code.appendLine("    data_" + id + "()") end if
            if typ == "file" then code.appendLine("    file_" + id + "()") end if
          end if
        end for
        code.appendLine("    return true")
        code.appendLine("  end if")
      end for
      code.appendLine("  return false")
      code.appendLine("end function")
      code.appendLine("")
    end if
  end if
  code.appendLine("function registry()")
  code.appendLine("  reg = assets.create(64)")
  if len(embedded) > 0 then
    for i = 0 to len(embedded) - 1
      asset = embedded[i]
      id = stringField(asset, "id", "asset")
      code.appendLine("  reg.addLazy(" + quote(id) + ", make_" + id + ")")
    end for
  end if
  code.appendLine("  return reg")
  code.appendLine("end function")
  return code.toString()
end function

/// Performs the levelsStubModule operation for the minipixels tools generator module.
function levelsStubModule()
  return "package generated.levels\n\n" +
    "function count()\n" +
    "  return 0\n" +
    "end function\n\n" +
    "function width(level) return 0 end function\n" +
    "function height(level) return 0 end function\n" +
    "function spawnX(level) return 0 end function\n" +
    "function spawnY(level) return 0 end function\n" +
    "function exitX(level) return 0 end function\n" +
    "function exitY(level) return 0 end function\n" +
    "function tileData(level) return [] end function\n" +
    "function enemyCount(level) return 0 end function\n" +
    "function enemyX(level, index) return 0 end function\n" +
    "function enemyY(level, index) return 0 end function\n" +
    "function enemyMinX(level, index) return 0 end function\n" +
    "function enemyMaxX(level, index) return 0 end function\n" +
    "function enemyKind(level, index) return 0 end function\n" +
    "function coinCount(level) return 0 end function\n" +
    "function coinX(level, index) return 0 end function\n" +
    "function coinY(level, index) return 0 end function\n"
end function

/// Performs the levelField operation for the minipixels tools generator module.
/// @param level level value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function levelField(level, key, fallback)
  return numberField(level, key, fallback)
end function

/// Performs the pointField operation for the minipixels tools generator module.
/// @param level level value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param xFallback xFallback value consumed by this operation.
/// @param yFallback yFallback value consumed by this operation.
function pointField(level, key, xFallback, yFallback)
  p = objectField(level, key)
  if typeof(p) == "void" then return [xFallback, yFallback] end if
  return [numberField(p, "x", xFallback), numberField(p, "y", yFallback)]
end function

/// Performs the emitLevelScalar operation for the minipixels tools generator module.
/// @param levels levels value consumed by this operation.
/// @param fnName fnName value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param subkey subkey value consumed by this operation.
function emitLevelScalar(levels, fnName, key, subkey)
  code = sb.StringBuilder.withCapacity(256)
  code.appendLine("function " + fnName + "(level)")
  fallback = 0
  for i = 0 to len(levels) - 1
    level = levels[i]
    value = 0
    if subkey == "" then
      value = levelField(level, key, 0)
    else
      obj = objectField(level, key)
      value = numberField(obj, subkey, 0)
    end if
    fallback = value
    code.appendLine("  if level == " + i + " then return " + value + " end if")
  end for
  code.appendLine("  return " + fallback)
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the emitTileData operation for the minipixels tools generator module.
/// @param levels levels value consumed by this operation.
function emitTileData(levels)
  code = sb.StringBuilder.withCapacity(1024)
  code.appendLine("function tileData(level)")
  code.appendLine("  w = width(level)")
  code.appendLine("  h = height(level)")
  code.appendLine("  data = array(w * h, 0)")
  for i = 0 to len(levels) - 1
    level = levels[i]
    platforms = arrayField(level, "platforms")
    code.appendLine("  if level == " + i + " then")
    if len(platforms) > 0 then
      for j = 0 to len(platforms) - 1
        p = platforms[j]
        x = numberField(p, "x", 0)
        y = numberField(p, "y", 0)
        w = numberField(p, "w", 1)
        tile = numberField(p, "tile", 1)
        if json.has(p, "left") or json.has(p, "middle") or json.has(p, "alt") or json.has(p, "right") then
          left = numberField(p, "left", tile)
          middle = numberField(p, "middle", tile)
          alt = numberField(p, "alt", middle)
          right = numberField(p, "right", tile)
          code.appendLine("    fillPlatform(data, w, " + x + ", " + y + ", " + w + ", " + left + ", " + middle + ", " + alt + ", " + right + ")")
        else
          code.appendLine("    fill(data, w, " + x + ", " + y + ", " + w + ", " + tile + ")")
        end if
      end for
    end if
    code.appendLine("  end if")
  end for
  code.appendLine("  return data")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the emitCollectionCount operation for the minipixels tools generator module.
/// @param levels levels value consumed by this operation.
/// @param name Name of the affected item.
/// @param key key value consumed by this operation.
function emitCollectionCount(levels, name, key)
  code = sb.StringBuilder.withCapacity(256)
  code.appendLine("function " + name + "Count(level)")
  fallback = 0
  for i = 0 to len(levels) - 1
    items = arrayField(levels[i], key)
    fallback = len(items)
    code.appendLine("  if level == " + i + " then return " + len(items) + " end if")
  end for
  code.appendLine("  return " + fallback)
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the emitCollectionField operation for the minipixels tools generator module.
/// @param levels levels value consumed by this operation.
/// @param name Name of the affected item.
/// @param key key value consumed by this operation.
/// @param field field value consumed by this operation.
/// @param functionSuffix functionSuffix value consumed by this operation.
function emitCollectionField(levels, name, key, field, functionSuffix)
  code = sb.StringBuilder.withCapacity(512)
  code.appendLine("function " + name + functionSuffix + "(level, index)")
  for i = 0 to len(levels) - 1
    items = arrayField(levels[i], key)
    code.appendLine("  if level == " + i + " then")
    if len(items) > 0 then
      for j = 0 to len(items) - 1
        value = numberField(items[j], field, 0)
        code.appendLine("    if index == " + j + " then return " + value + " end if")
      end for
    end if
    code.appendLine("    return 0")
    code.appendLine("  end if")
  end for
  code.appendLine("  return 0")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Validates levels for the minipixels tools generator workflow.
/// @param r r value consumed by this operation.
/// @param levelsDoc levelsDoc value consumed by this operation.
/// @param source source value consumed by this operation.
function validateLevels(r, levelsDoc, source)
  levels = json.get(levelsDoc, "levels")
  if typeof(levels) == "void" or levels.kind != "array" or len(levels.arrayItems) <= 0 then
    addError(r, source + ": levels must contain at least one level")
    return []
  end if
  for i = 0 to len(levels.arrayItems) - 1
    level = levels.arrayItems[i]
    if typeof(level) != "struct" or level.kind != "object" then
      addError(r, source + ": level " + i + " must be an object")
    else
      if numberField(level, "width", 0) <= 0 then addError(r, source + ": level " + i + " width must be greater than zero") end if
      if numberField(level, "height", 0) <= 0 then addError(r, source + ": level " + i + " height must be greater than zero") end if
    end if
  end for
  return levels.arrayItems
end function

/// Returns a named Tiled property or a direct object field.
/// @param obj Tiled layer or object.
/// @param key Property name.
function tiledProperty(obj, key)
  properties = arrayField(obj, "properties")
  if len(properties) > 0 then
    for index = 0 to len(properties) - 1
      property = properties[index]
      if stringField(property, "name", "") == key then return json.get(property, "value") end if
    end for
  end if
  return json.get(obj, key)
end function

/// Returns whether a JSON value represents true.
/// @param value JSON value to inspect.
function jsonTrue(value)
  return typeof(value) != "void" and value.kind == "bool" and value.boolValue
end function

/// Returns whether a Tiled tile layer is explicitly marked as collision data.
/// @param layer Tiled layer object.
function tiledLayerIsSolid(layer)
  name = strings.toLowerAscii(stringField(layer, "name", ""))
  if name == "collision" or name == "collisions" or name == "solid" or name == "ground" then return true end if
  return jsonTrue(tiledProperty(layer, "collision")) or jsonTrue(tiledProperty(layer, "solid"))
end function

/// Returns a normalized Tiled object kind.
/// @param obj Tiled object.
function tiledObjectKind(obj)
  kind = stringField(obj, "type", "")
  if kind == "" then kind = stringField(obj, "name", "") end if
  if kind == "" then kind = json.asString(tiledProperty(obj, "kind"), "") end if
  if kind == "" then kind = json.asString(tiledProperty(obj, "type"), "") end if
  return strings.toLowerAscii(kind)
end function

/// Reads an integer-valued Tiled field or property.
/// @param obj Tiled object.
/// @param key Field or property name.
/// @param fallback Value used when absent.
function tiledNumber(obj, key, fallback)
  return json.asNumber(tiledProperty(obj, key), fallback)
end function

/// Creates a two-dimensional JSON point object.
/// @param x Point x coordinate.
/// @param y Point y coordinate.
function jsonPoint(x, y)
  return json.object(["x", "y"], [json.number(x), json.number(y)])
end function

/// Normalizes one finite CSV-encoded Tiled map into the MiniPixels level model.
/// @param document Parsed Tiled map.
/// @param r Generation result receiving diagnostics.
/// @param source Source path used in diagnostics.
function normalizeTiled(document, r, source)
  width = numberField(document, "width", 0)
  height = numberField(document, "height", 0)
  tileWidth = numberField(document, "tilewidth", 32)
  tileHeight = numberField(document, "tileheight", 32)
  if width <= 0 or height <= 0 then
    addError(r, source + ": Tiled map width and height must be greater than zero")
    return void
  end if
  layers = arrayField(document, "layers")
  explicitSolid = false
  if len(layers) > 0 then
    for index = 0 to len(layers) - 1
      layer = layers[index]
      if stringField(layer, "type", "") == "tilelayer" and tiledLayerIsSolid(layer) then explicitSolid = true end if
    end for
  end if
  platforms = []
  if len(layers) > 0 then
    for layerIndex = 0 to len(layers) - 1
      layer = layers[layerIndex]
      if stringField(layer, "type", "") == "tilelayer" and (explicitSolid == false or tiledLayerIsSolid(layer)) then
        layerWidth = numberField(layer, "width", width)
        layerHeight = numberField(layer, "height", height)
        if layerHeight > height then layerHeight = height end if
        data = arrayField(layer, "data")
        if len(data) == 0 then
          addError(r, source + ": Tiled CSV-encoded layer data is required")
          return void
        end if
        y = 0
        while y < layerHeight
          x = 0
          while x < layerWidth
            offset = y * layerWidth + x
            gid = 0
            if offset < len(data) then gid = json.asNumber(data[offset], 0) & 0x1FFFFFFF end if
            if gid <= 0 then
              x = x + 1
            else
              start = x
              while x < layerWidth
                scanOffset = y * layerWidth + x
                scan = 0
                if scanOffset < len(data) then scan = json.asNumber(data[scanOffset], 0) & 0x1FFFFFFF end if
                if scan != gid then break end if
                x = x + 1
              end while
              platforms = arr.append(platforms, json.object(
                ["x", "y", "w", "tile"],
                [json.number(start), json.number(y), json.number(x - start), json.number(gid)]
              ))
            end if
          end while
          y = y + 1
        end while
      end if
    end for
  end if
  spawnY = (height - 3) * tileHeight
  if spawnY < 0 then spawnY = 0 end if
  exitX = (width * tileWidth) - (3 * tileWidth)
  exitY = (height - 4) * tileHeight
  if exitX < 0 then exitX = 0 end if
  if exitY < 0 then exitY = 0 end if
  spawn = jsonPoint(48, spawnY)
  exitPoint = jsonPoint(exitX, exitY)
  enemies = []
  coins = []
  if len(layers) > 0 then
    for layerIndex = 0 to len(layers) - 1
      layer = layers[layerIndex]
      if stringField(layer, "type", "") == "objectgroup" then
        objects = arrayField(layer, "objects")
        if len(objects) > 0 then
          for objectIndex = 0 to len(objects) - 1
            obj = objects[objectIndex]
            kind = tiledObjectKind(obj)
            x = numberField(obj, "x", 0)
            y = numberField(obj, "y", 0)
            if kind == "spawn" or kind == "player" then
              spawn = jsonPoint(x, y)
            else if kind == "exit" or kind == "goal" then
              exitPoint = jsonPoint(x, y)
            else if kind == "coin" then
              coins = arr.append(coins, jsonPoint(x, y))
            else if kind == "enemy" then
              objectWidth = numberField(obj, "width", tileWidth * 4)
              enemies = arr.append(enemies, json.object(
                ["x", "y", "minX", "maxX", "kind"],
                [json.number(x), json.number(y), json.number(tiledNumber(obj, "minX", x)), json.number(tiledNumber(obj, "maxX", x + objectWidth)), json.number(tiledNumber(obj, "kind", 0))]
              ))
            end if
          end for
        end if
      end if
    end for
  end if
  level = json.object(
    ["width", "height", "spawn", "exit", "platforms", "enemies", "coins"],
    [json.number(width), json.number(height), spawn, exitPoint, json.array(platforms), json.array(enemies), json.array(coins)]
  )
  return json.object(["levels"], [json.array([level])])
end function

/// Performs the levelsModule operation for the minipixels tools generator module.
/// @param m m value consumed by this operation.
/// @param r r value consumed by this operation.
function levelsModule(m, r)
  path = join(m.root, m.levelPath)
  text = try(fs.readAllText(path))
  if typeof(text) == "error" then
    addError(r, "cannot read levels: " + text.message)
    return levelsStubModule()
  end if
  parsed = try(json.parse(text))
  if typeof(parsed) == "error" then
    addError(r, parsed.message)
    return levelsStubModule()
  end if
  if json.has(parsed, "levels") == false then
    if json.has(parsed, "layers") and json.has(parsed, "tilewidth") then
      parsed = normalizeTiled(parsed, r, path)
      if typeof(parsed) == "void" then return levelsStubModule() end if
    else
      addError(r, path + ": unsupported level JSON shape")
      return levelsStubModule()
    end if
  end if
  levels = validateLevels(r, parsed, path)
  if len(levels) <= 0 then return levelsStubModule() end if
  code = sb.StringBuilder.withCapacity(4096)
  code.appendLine("package generated.levels")
  code.appendLine("")
  code.appendLine("function count()")
  code.appendLine("  return " + len(levels))
  code.appendLine("end function")
  code.appendLine("")
  code.appendLine("function fill(data, width, x, y, w, value)")
  code.appendLine("  i = 0")
  code.appendLine("  while i < w")
  code.appendLine("    data[(y * width) + x + i] = value")
  code.appendLine("    i = i + 1")
  code.appendLine("  end while")
  code.appendLine("end function")
  code.appendLine("")
  code.appendLine("function fillPlatform(data, width, x, y, w, left, middle, alt, right)")
  code.appendLine("  if w <= 0 then return end if")
  code.appendLine("  if w == 1 then")
  code.appendLine("    data[(y * width) + x] = middle")
  code.appendLine("    return")
  code.appendLine("  end if")
  code.appendLine("  data[(y * width) + x] = left")
  code.appendLine("  i = 1")
  code.appendLine("  while i < w - 1")
  code.appendLine("    value = middle")
  code.appendLine("    if alt > 0 and i % 3 == 0 then value = alt end if")
  code.appendLine("    data[(y * width) + x + i] = value")
  code.appendLine("    i = i + 1")
  code.appendLine("  end while")
  code.appendLine("  data[(y * width) + x + w - 1] = right")
  code.appendLine("end function")
  code.appendLine("")
  code.appendString(emitLevelScalar(levels, "width", "width", ""))
  code.appendString(emitLevelScalar(levels, "height", "height", ""))
  code.appendString(emitLevelScalar(levels, "spawnX", "spawn", "x"))
  code.appendString(emitLevelScalar(levels, "spawnY", "spawn", "y"))
  code.appendString(emitLevelScalar(levels, "exitX", "exit", "x"))
  code.appendString(emitLevelScalar(levels, "exitY", "exit", "y"))
  code.appendString(emitTileData(levels))
  code.appendString(emitCollectionCount(levels, "enemy", "enemies"))
  code.appendString(emitCollectionField(levels, "enemy", "enemies", "x", "X"))
  code.appendString(emitCollectionField(levels, "enemy", "enemies", "y", "Y"))
  code.appendString(emitCollectionField(levels, "enemy", "enemies", "minX", "MinX"))
  code.appendString(emitCollectionField(levels, "enemy", "enemies", "maxX", "MaxX"))
  code.appendString(emitCollectionField(levels, "enemy", "enemies", "kind", "Kind"))
  code.appendString(emitCollectionCount(levels, "coin", "coins"))
  code.appendString(emitCollectionField(levels, "coin", "coins", "x", "X"))
  code.appendString(emitCollectionField(levels, "coin", "coins", "y", "Y"))
  return code.toString()
end function

/// Loads json for the minipixels tools generator module.
/// @param path Path of the file or directory used by the operation.
/// @param r r value consumed by this operation.
function loadJson(path, r)
  text = try(fs.readAllText(path))
  if typeof(text) == "error" then
    addError(r, "cannot read project: " + text.message)
    return void
  end if
  parsed = try(json.parse(text))
  if typeof(parsed) == "error" then
    addError(r, parsed.message)
    return void
  end if
  return parsed
end function

/// Generates generate for the minipixels tools generator workflow.
/// @param projectPath Path associated with project.
/// @param outDir outDir value consumed by this operation.
function generate(projectPath, outDir)
  target = outDir
  if target == "" then target = defaultOutDir(projectPath) end if
  r = result(target)
  m = manifest.load(projectPath)
  if manifest.isValid(m) == false then
    if len(m.errors) > 0 then
      for i = 0 to len(m.errors) - 1
        addError(r, m.errors[i])
      end for
    end if
    return r
  end if
  root = loadJson(projectPath, r)
  if r.ok == false then return r end if
  protection = objectField(root, "assetProtection")
  if typeof(protection) != "void" and json.asBool(json.get(protection, "enabled"), false) then
    addError(r, "protected MPX3 generation is a build operation; use tools/minipixels.py build or generate")
    return r
  end if
  projectAssets = arrayField(root, "assets")
  if len(projectAssets) > 0 then
    for index = 0 to len(projectAssets) - 1
      if stringField(projectAssets[index], "type", "image") == "constants" then
        addError(r, "compiled constants require the Python build driver")
        return r
      end if
    end for
  end if
  if fsu.ensureDir(target) == false then
    addError(r, "could not create output directory: " + target)
    return r
  end if
  packPath = fs.joinPath(fs.joinPath(m.root, "build"), "assets.mpx")
  if writeAssetPack(root, m.root, packPath, r) == false then return r end if
  wr = try(fsu.writeText(fs.joinPath(target, "assets.ml"), assetsModule(root, packPath, r)))
  if typeof(wr) == "error" then
    addError(r, wr.message)
    return r
  end if
  if m.levelPath != "" then
    wrLevels = try(fsu.writeText(fs.joinPath(target, "levels.ml"), levelsModule(m, r)))
    if typeof(wrLevels) == "error" then addError(r, wrLevels.message) end if
  end if
  return r
end function

/// Prints result for the minipixels tools generator workflow.
/// @param r r value consumed by this operation.
function printResult(r)
  if r is not GenerateResult then
    print "generate: invalid result"
    return
  end if
  print "Generated: " + r.outDir
  if len(r.warnings) > 0 then
    for i = 0 to len(r.warnings) - 1
      print "[WARN] " + r.warnings[i]
    end for
  end if
  if len(r.errors) > 0 then
    for i = 0 to len(r.errors) - 1
      print "[ERROR] " + r.errors[i]
    end for
  else
    print "[OK] generate complete"
  end if
end function
