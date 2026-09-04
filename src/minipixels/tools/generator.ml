// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools generator facilities for this project.

package minipixels.tools.generator

import minipixels.tools.fsutil as fsu
import minipixels.tools.json as json
import minipixels.tools.manifest as manifest
import std.array as arr
import std.fs as fs
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

/// Joins join for the minipixels tools generator workflow.
/// @param root root value consumed by this operation.
/// @param rel rel value consumed by this operation.
function join(root, rel)
  return fs.joinPath(root, rel)
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
  code.appendLine("function sheet_" + id + "()")
  code.appendLine("  spr = make_" + id + "()")
  code.appendLine("  return mp.spriteSheet(spr.image, " + fw + ", " + fh + ", " + spacing + ", " + margin + ")")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the assetsHeader operation for the minipixels tools generator module.
function assetsHeader()
  code = sb.StringBuilder.withCapacity(2048)
  code.appendLine("package generated.assets")
  code.appendLine("")
  code.appendLine("import minipixels as mp")
  code.appendLine("import minipixels.assets.assets as assets")
  code.appendLine("")
  // The generated module keeps procedural drawing local so projects can compile without the Python asset processor.
  code.appendLine("function setPixel(pix, width, x, y, r, g, b, a)")
  code.appendLine("  i = ((y * width) + x) * 4")
  code.appendLine("  pix[i] = r")
  code.appendLine("  pix[i + 1] = g")
  code.appendLine("  pix[i + 2] = b")
  code.appendLine("  pix[i + 3] = a")
  code.appendLine("end function")
  code.appendLine("")
  code.appendLine("function proceduralPixels(width, height, kind, pr, pg, pb, pa, sr, sg, sb, sa)")
  code.appendLine("  pix = bytes(width * height * 4, 0)")
  code.appendLine("  tileW = width / 4")
  code.appendLine("  if tileW < 1 then tileW = 1 end if")
  code.appendLine("  tileH = height / 4")
  code.appendLine("  if tileH < 1 then tileH = 1 end if")
  code.appendLine("  for y = 0 to height - 1")
  code.appendLine("    for x = 0 to width - 1")
  code.appendLine("      r = pr")
  code.appendLine("      g = pg")
  code.appendLine("      b = pb")
  code.appendLine("      a = pa")
  code.appendLine("      if kind == \"blank\" then")
  code.appendLine("        r = 0")
  code.appendLine("        g = 0")
  code.appendLine("        b = 0")
  code.appendLine("        a = 0")
  code.appendLine("      else if kind == \"player\" then")
  code.appendLine("        if x == 0 or x == width - 1 or y == 0 or y == height - 1 then")
  code.appendLine("          r = 0")
  code.appendLine("          g = 0")
  code.appendLine("          b = 0")
  code.appendLine("          a = 0")
  code.appendLine("        else if y < height / 3 then")
  code.appendLine("          r = 255")
  code.appendLine("          g = 232")
  code.appendLine("          b = 170")
  code.appendLine("          a = 255")
  code.appendLine("        else if x >= width / 2 then")
  code.appendLine("          r = sr")
  code.appendLine("          g = sg")
  code.appendLine("          b = sb")
  code.appendLine("          a = sa")
  code.appendLine("        end if")
  code.appendLine("      else if kind == \"tiles\" then")
  code.appendLine("        if ((x / tileW) + (y / tileH)) % 2 != 0 then")
  code.appendLine("          r = sr")
  code.appendLine("          g = sg")
  code.appendLine("          b = sb")
  code.appendLine("          a = sa")
  code.appendLine("        end if")
  code.appendLine("      else")
  code.appendLine("        if ((x / 4) + (y / 4)) % 2 != 0 then")
  code.appendLine("          r = sr")
  code.appendLine("          g = sg")
  code.appendLine("          b = sb")
  code.appendLine("          a = sa")
  code.appendLine("        end if")
  code.appendLine("      end if")
  code.appendLine("      setPixel(pix, width, x, y, r, g, b, a)")
  code.appendLine("    end for")
  code.appendLine("  end for")
  code.appendLine("  return pix")
  code.appendLine("end function")
  code.appendLine("")
  return code.toString()
end function

/// Performs the assetModule operation for the minipixels tools generator module.
/// @param asset asset value consumed by this operation.
/// @param r r value consumed by this operation.
function assetModule(asset, r)
  id = stringField(asset, "id", "asset")
  typ = stringField(asset, "type", "image")
  w = assetWidth(asset)
  h = assetHeight(asset)
  kind = stringField(asset, "kind", "checker")
  pr = colorPart(asset, "color", 0, 255)
  pg = colorPart(asset, "color", 1, 128)
  pb = colorPart(asset, "color", 2, 0)
  pa = colorPart(asset, "color", 3, 255)
  sr = colorPart(asset, "secondary", 0, 40)
  sg = colorPart(asset, "secondary", 1, 40)
  sb = colorPart(asset, "secondary", 2, 50)
  sa = colorPart(asset, "secondary", 3, 255)
  if typ == "image" then
    addWarning(r, "image asset '" + id + "' uses native placeholder pixels; PNG embedding is still legacy")
    kind = "checker"
  end if
  code = sb.StringBuilder.withCapacity(512)
  code.appendLine("function make_" + id + "()")
  code.appendLine("  pix = proceduralPixels(" + w + ", " + h + ", " + quote(kind) + ", " + pr + ", " + pg + ", " + pb + ", " + pa + ", " + sr + ", " + sg + ", " + sb + ", " + sa + ")")
  code.appendLine("  img = mp.image(" + w + ", " + h + ", pix, " + quote(id) + ")")
  code.appendLine("  return mp.spriteFromImage(img, " + quote(id) + ")")
  code.appendLine("end function")
  code.appendLine("")
  code.appendString(sheetModule(asset, id))
  return code.toString()
end function

/// Performs the assetsModule operation for the minipixels tools generator module.
/// @param root root value consumed by this operation.
/// @param r r value consumed by this operation.
function assetsModule(root, r)
  code = sb.StringBuilder.withCapacity(4096)
  code.appendString(assetsHeader())
  assets = json.get(root, "assets")
  embedded = []
  if typeof(assets) != "void" and assets.kind == "array" and len(assets.arrayItems) > 0 then
    for i = 0 to len(assets.arrayItems) - 1
      asset = assets.arrayItems[i]
      typ = stringField(asset, "type", "image")
      id = stringField(asset, "id", "asset")
      if typ == "image" or typ == "procedural" then
        code.appendString(assetModule(asset, r))
        embedded = arr.append(embedded, asset)
      else
        addWarning(r, "runtime asset '" + id + "' is validated but not embedded by native generate yet")
      end if
    end for
  end if
  code.appendLine("function registry()")
  code.appendLine("  reg = assets.create(64)")
  if len(embedded) > 0 then
    for i = 0 to len(embedded) - 1
      asset = embedded[i]
      id = stringField(asset, "id", "asset")
      code.appendLine("  reg.add(" + quote(id) + ", make_" + id + "())")
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
    // Tiled/TMJ support still belongs to the Python pipeline until the native importer is ported.
    addWarning(r, "native Tiled/TMJ import is not implemented yet; wrote generated.levels stub")
    return levelsStubModule()
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
  if fsu.ensureDir(target) == false then
    addError(r, "could not create output directory: " + target)
    return r
  end if
  wr = try(fsu.writeText(fs.joinPath(target, "assets.ml"), assetsModule(root, r)))
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
