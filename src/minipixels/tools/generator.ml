package minipixels.tools.generator

import minipixels.tools.fsutil as fsu
import minipixels.tools.json as json
import minipixels.tools.manifest as manifest
import std.array as arr
import std.fs as fs

struct GenerateResult
  ok
  outDir
  warnings
  errors
end struct

function result(outDir)
  return GenerateResult(true, outDir, [], [])
end function

function addWarning(r, msg)
  r.warnings = arr.append(r.warnings, msg)
end function

function addError(r, msg)
  r.ok = false
  r.errors = arr.append(r.errors, msg)
end function

function defaultOutDir(projectPath)
  root = manifest.dirname(projectPath)
  return fs.joinPath(fs.joinPath(fs.joinPath(root, "build"), "generated"), "generated")
end function

function line(text)
  return text + "\n"
end function

function quote(text)
  return "\"" + text + "\""
end function

function join(root, rel)
  return fs.joinPath(root, rel)
end function

function numberField(obj, key, fallback)
  return json.asNumber(json.get(obj, key), fallback)
end function

function stringField(obj, key, fallback)
  return json.asString(json.get(obj, key), fallback)
end function

function arrayField(obj, key)
  v = json.get(obj, key)
  if typeof(v) == "void" or v.kind != "array" then return [] end if
  return v.arrayItems
end function

function objectField(obj, key)
  v = json.get(obj, key)
  if typeof(v) == "void" or v.kind != "object" then return void end if
  return v
end function

function colorPart(asset, key, index, fallback)
  color = json.get(asset, key)
  if typeof(color) == "void" or color.kind != "array" then return fallback end if
  if len(color.arrayItems) <= index then return fallback end if
  item = color.arrayItems[index]
  return json.asNumber(item, fallback)
end function

function sheetWidth(asset, fallback)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return fallback end if
  return numberField(sheet, "frameWidth", fallback)
end function

function sheetHeight(asset, fallback)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return fallback end if
  return numberField(sheet, "frameHeight", fallback)
end function

function assetWidth(asset)
  return numberField(asset, "width", sheetWidth(asset, 16))
end function

function assetHeight(asset)
  return numberField(asset, "height", sheetHeight(asset, 16))
end function

function hasSheet(asset)
  return typeof(objectField(asset, "sheet")) != "void"
end function

function sheetModule(asset, id)
  sheet = objectField(asset, "sheet")
  if typeof(sheet) == "void" then return "" end if
  fw = numberField(sheet, "frameWidth", assetWidth(asset))
  fh = numberField(sheet, "frameHeight", assetHeight(asset))
  spacing = numberField(sheet, "spacing", 0)
  margin = numberField(sheet, "margin", 0)
  code = ""
  code = code + line("function sheet_" + id + "()")
  code = code + line("  spr = make_" + id + "()")
  code = code + line("  return mp.spriteSheet(spr.image, " + fw + ", " + fh + ", " + spacing + ", " + margin + ")")
  code = code + line("end function")
  code = code + line("")
  return code
end function

function assetsHeader()
  code = ""
  code = code + line("package generated.assets")
  code = code + line("")
  code = code + line("import minipixels as mp")
  code = code + line("import minipixels.assets.assets as assets")
  code = code + line("")
  // The generated module keeps procedural drawing local so projects can compile without the Python asset processor.
  code = code + line("function setPixel(pix, width, x, y, r, g, b, a)")
  code = code + line("  i = ((y * width) + x) * 4")
  code = code + line("  pix[i] = r")
  code = code + line("  pix[i + 1] = g")
  code = code + line("  pix[i + 2] = b")
  code = code + line("  pix[i + 3] = a")
  code = code + line("end function")
  code = code + line("")
  code = code + line("function proceduralPixels(width, height, kind, pr, pg, pb, pa, sr, sg, sb, sa)")
  code = code + line("  pix = bytes(width * height * 4, 0)")
  code = code + line("  tileW = width / 4")
  code = code + line("  if tileW < 1 then tileW = 1 end if")
  code = code + line("  tileH = height / 4")
  code = code + line("  if tileH < 1 then tileH = 1 end if")
  code = code + line("  for y = 0 to height - 1")
  code = code + line("    for x = 0 to width - 1")
  code = code + line("      r = pr")
  code = code + line("      g = pg")
  code = code + line("      b = pb")
  code = code + line("      a = pa")
  code = code + line("      if kind == \"blank\" then")
  code = code + line("        r = 0")
  code = code + line("        g = 0")
  code = code + line("        b = 0")
  code = code + line("        a = 0")
  code = code + line("      else if kind == \"player\" then")
  code = code + line("        if x == 0 or x == width - 1 or y == 0 or y == height - 1 then")
  code = code + line("          r = 0")
  code = code + line("          g = 0")
  code = code + line("          b = 0")
  code = code + line("          a = 0")
  code = code + line("        else if y < height / 3 then")
  code = code + line("          r = 255")
  code = code + line("          g = 232")
  code = code + line("          b = 170")
  code = code + line("          a = 255")
  code = code + line("        else if x >= width / 2 then")
  code = code + line("          r = sr")
  code = code + line("          g = sg")
  code = code + line("          b = sb")
  code = code + line("          a = sa")
  code = code + line("        end if")
  code = code + line("      else if kind == \"tiles\" then")
  code = code + line("        if ((x / tileW) + (y / tileH)) % 2 != 0 then")
  code = code + line("          r = sr")
  code = code + line("          g = sg")
  code = code + line("          b = sb")
  code = code + line("          a = sa")
  code = code + line("        end if")
  code = code + line("      else")
  code = code + line("        if ((x / 4) + (y / 4)) % 2 != 0 then")
  code = code + line("          r = sr")
  code = code + line("          g = sg")
  code = code + line("          b = sb")
  code = code + line("          a = sa")
  code = code + line("        end if")
  code = code + line("      end if")
  code = code + line("      setPixel(pix, width, x, y, r, g, b, a)")
  code = code + line("    end for")
  code = code + line("  end for")
  code = code + line("  return pix")
  code = code + line("end function")
  code = code + line("")
  return code
end function

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
  code = ""
  code = code + line("function make_" + id + "()")
  code = code + line("  pix = proceduralPixels(" + w + ", " + h + ", " + quote(kind) + ", " + pr + ", " + pg + ", " + pb + ", " + pa + ", " + sr + ", " + sg + ", " + sb + ", " + sa + ")")
  code = code + line("  img = mp.image(" + w + ", " + h + ", pix, " + quote(id) + ")")
  code = code + line("  return mp.spriteFromImage(img, " + quote(id) + ")")
  code = code + line("end function")
  code = code + line("")
  code = code + sheetModule(asset, id)
  return code
end function

function assetsModule(root, r)
  code = assetsHeader()
  assets = json.get(root, "assets")
  embedded = []
  if typeof(assets) != "void" and assets.kind == "array" and len(assets.arrayItems) > 0 then
    for i = 0 to len(assets.arrayItems) - 1
      asset = assets.arrayItems[i]
      typ = stringField(asset, "type", "image")
      id = stringField(asset, "id", "asset")
      if typ == "image" or typ == "procedural" then
        code = code + assetModule(asset, r)
        embedded = arr.append(embedded, asset)
      else
        addWarning(r, "runtime asset '" + id + "' is validated but not embedded by native generate yet")
      end if
    end for
  end if
  code = code + line("function registry()")
  code = code + line("  reg = assets.create(64)")
  if len(embedded) > 0 then
    for i = 0 to len(embedded) - 1
      asset = embedded[i]
      id = stringField(asset, "id", "asset")
      code = code + line("  reg.add(" + quote(id) + ", make_" + id + "())")
    end for
  end if
  code = code + line("  return reg")
  code = code + line("end function")
  return code
end function

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

function levelField(level, key, fallback)
  return numberField(level, key, fallback)
end function

function pointField(level, key, xFallback, yFallback)
  p = objectField(level, key)
  if typeof(p) == "void" then return [xFallback, yFallback] end if
  return [numberField(p, "x", xFallback), numberField(p, "y", yFallback)]
end function

function emitLevelScalar(levels, fnName, key, subkey)
  code = line("function " + fnName + "(level)")
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
    code = code + line("  if level == " + i + " then return " + value + " end if")
  end for
  code = code + line("  return " + fallback)
  code = code + line("end function")
  code = code + line("")
  return code
end function

function emitTileData(levels)
  code = ""
  code = code + line("function tileData(level)")
  code = code + line("  w = width(level)")
  code = code + line("  h = height(level)")
  code = code + line("  data = array(w * h, 0)")
  for i = 0 to len(levels) - 1
    level = levels[i]
    platforms = arrayField(level, "platforms")
    code = code + line("  if level == " + i + " then")
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
          code = code + line("    fillPlatform(data, w, " + x + ", " + y + ", " + w + ", " + left + ", " + middle + ", " + alt + ", " + right + ")")
        else
          code = code + line("    fill(data, w, " + x + ", " + y + ", " + w + ", " + tile + ")")
        end if
      end for
    end if
    code = code + line("  end if")
  end for
  code = code + line("  return data")
  code = code + line("end function")
  code = code + line("")
  return code
end function

function emitCollectionCount(levels, name, key)
  code = line("function " + name + "Count(level)")
  fallback = 0
  for i = 0 to len(levels) - 1
    items = arrayField(levels[i], key)
    fallback = len(items)
    code = code + line("  if level == " + i + " then return " + len(items) + " end if")
  end for
  code = code + line("  return " + fallback)
  code = code + line("end function")
  code = code + line("")
  return code
end function

function emitCollectionField(levels, name, key, field, functionSuffix)
  code = line("function " + name + functionSuffix + "(level, index)")
  for i = 0 to len(levels) - 1
    items = arrayField(levels[i], key)
    code = code + line("  if level == " + i + " then")
    if len(items) > 0 then
      for j = 0 to len(items) - 1
        value = numberField(items[j], field, 0)
        code = code + line("    if index == " + j + " then return " + value + " end if")
      end for
    end if
    code = code + line("    return 0")
    code = code + line("  end if")
  end for
  code = code + line("  return 0")
  code = code + line("end function")
  code = code + line("")
  return code
end function

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
  code = ""
  code = code + line("package generated.levels")
  code = code + line("")
  code = code + line("function count()")
  code = code + line("  return " + len(levels))
  code = code + line("end function")
  code = code + line("")
  code = code + line("function fill(data, width, x, y, w, value)")
  code = code + line("  i = 0")
  code = code + line("  while i < w")
  code = code + line("    data[(y * width) + x + i] = value")
  code = code + line("    i = i + 1")
  code = code + line("  end while")
  code = code + line("end function")
  code = code + line("")
  code = code + line("function fillPlatform(data, width, x, y, w, left, middle, alt, right)")
  code = code + line("  if w <= 0 then return end if")
  code = code + line("  if w == 1 then")
  code = code + line("    data[(y * width) + x] = middle")
  code = code + line("    return")
  code = code + line("  end if")
  code = code + line("  data[(y * width) + x] = left")
  code = code + line("  i = 1")
  code = code + line("  while i < w - 1")
  code = code + line("    value = middle")
  code = code + line("    if alt > 0 and i % 3 == 0 then value = alt end if")
  code = code + line("    data[(y * width) + x + i] = value")
  code = code + line("    i = i + 1")
  code = code + line("  end while")
  code = code + line("  data[(y * width) + x + w - 1] = right")
  code = code + line("end function")
  code = code + line("")
  code = code + emitLevelScalar(levels, "width", "width", "")
  code = code + emitLevelScalar(levels, "height", "height", "")
  code = code + emitLevelScalar(levels, "spawnX", "spawn", "x")
  code = code + emitLevelScalar(levels, "spawnY", "spawn", "y")
  code = code + emitLevelScalar(levels, "exitX", "exit", "x")
  code = code + emitLevelScalar(levels, "exitY", "exit", "y")
  code = code + emitTileData(levels)
  code = code + emitCollectionCount(levels, "enemy", "enemies")
  code = code + emitCollectionField(levels, "enemy", "enemies", "x", "X")
  code = code + emitCollectionField(levels, "enemy", "enemies", "y", "Y")
  code = code + emitCollectionField(levels, "enemy", "enemies", "minX", "MinX")
  code = code + emitCollectionField(levels, "enemy", "enemies", "maxX", "MaxX")
  code = code + emitCollectionField(levels, "enemy", "enemies", "kind", "Kind")
  code = code + emitCollectionCount(levels, "coin", "coins")
  code = code + emitCollectionField(levels, "coin", "coins", "x", "X")
  code = code + emitCollectionField(levels, "coin", "coins", "y", "Y")
  return code
end function

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
