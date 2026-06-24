package minipixels.tools.manifest

import minipixels.tools.json as json
import std.array as arr
import std.fs as fs
import std.string as str

struct Manifest
  path
  root
  name
  main
  title
  width
  height
  scale
  assetCount
  levelPath
  errors
  warnings
end struct

function newManifest(path, root)
  return Manifest(path, root, "", "", "", 0, 0, 1, 0, "", [], [])
end function

function addError(m, msg)
  m.errors = arr.append(m.errors, msg)
end function

function addWarning(m, msg)
  m.warnings = arr.append(m.warnings, msg)
end function

function isValid(m)
  return m is Manifest and len(m.errors) == 0
end function

function maxInt(a, b)
  if a > b then return a end if
  return b
end function

function dirname(path)
  lastSlash = str.lastIndexOf(path, "\\")
  lastForward = str.lastIndexOf(path, "/")
  last = maxInt(lastSlash, lastForward)
  if last < 0 then return "." end if
  if last == 0 then return str.substr(path, 0, 1) end if
  return str.substr(path, 0, last)
end function

function join(root, rel)
  return fs.joinPath(root, rel)
end function

function safeIdentifier(id)
  if typeof(id) != "string" then return false end if
  if len(id) == 0 then return false end if
  letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
  rest = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
  if str.contains(letters, id[0]) == false then return false end if
  for i = 1 to len(id) - 1
    if str.contains(rest, id[i]) == false then return false end if
  end for
  return true
end function

function containsString(items, value)
  if typeof(items) != "array" then return false end if
  if len(items) <= 0 then return false end if
  for i = 0 to len(items) - 1
    if items[i] == value then return true end if
  end for
  return false
end function

function requireField(m, obj, key)
  if json.has(obj, key) == false then
    addError(m, "missing required field '" + key + "'")
    return false
  end if
  return true
end function

function stringField(m, obj, key, required)
  v = json.get(obj, key)
  if typeof(v) == "void" then
    if required then addError(m, "missing required field '" + key + "'") end if
    return ""
  end if
  if v.kind != "string" then
    addError(m, "'" + key + "' must be a string")
    return ""
  end if
  return v.stringValue
end function

function numberField(m, obj, key, required, fallback)
  v = json.get(obj, key)
  if typeof(v) == "void" then
    if required then addError(m, "missing required field '" + key + "'") end if
    return fallback
  end if
  if v.kind != "number" then
    addError(m, "'" + key + "' must be a number")
    return fallback
  end if
  return v.numberValue
end function

function validateAsset(m, asset, seen)
  if typeof(asset) != "struct" or asset.kind != "object" then
    addError(m, "asset must be an object")
    return seen
  end if
  id = stringField(m, asset, "id", true)
  if id != "" then
    if safeIdentifier(id) == false then
      addError(m, "asset id '" + id + "' must be a MiniLang identifier")
    end if
    if containsString(seen, id) then
      addError(m, "duplicate asset id '" + id + "'")
    end if
    seen = arr.append(seen, id)
  end if
  typ = stringField(m, asset, "type", false)
  if typ == "" then typ = "image" end if
  if typ != "image" and typ != "audio" and typ != "file" then
    addError(m, "asset '" + id + "' type must be image, audio, or file")
  end if
  path = stringField(m, asset, "path", false)
  if path != "" and fs.exists(join(m.root, path)) == false then
    addError(m, "asset '" + id + "' path does not exist: " + path)
  end if
  sheet = json.get(asset, "sheet")
  if typeof(sheet) != "void" then
    if sheet.kind != "object" then
      addError(m, "asset '" + id + "' sheet must be an object")
    else
      fw = numberField(m, sheet, "frameWidth", true, 0)
      fh = numberField(m, sheet, "frameHeight", true, 0)
      spacing = numberField(m, sheet, "spacing", false, 0)
      margin = numberField(m, sheet, "margin", false, 0)
      if fw <= 0 or fh <= 0 then
        addError(m, "asset '" + id + "' sheet frame size must be greater than zero")
      end if
      if spacing < 0 or margin < 0 then
        addError(m, "asset '" + id + "' sheet spacing and margin must not be negative")
      end if
    end if
  end if
  return seen
end function

function validateAssets(m, root)
  assets = json.get(root, "assets")
  if typeof(assets) == "void" then return end if
  if assets.kind != "array" then
    addError(m, "'assets' must be an array")
    return
  end if
  m.assetCount = len(assets.arrayItems)
  if m.assetCount <= 0 then return end if
  seen = []
  for i = 0 to len(assets.arrayItems) - 1
    seen = validateAsset(m, assets.arrayItems[i], seen)
  end for
end function

function validateLevels(m, root)
  levels = json.get(root, "levels")
  if typeof(levels) == "void" then return end if
  if levels.kind != "object" then
    addError(m, "'levels' must be an object")
    return
  end if
  path = stringField(m, levels, "path", true)
  m.levelPath = path
  if path != "" and fs.exists(join(m.root, path)) == false then
    addError(m, "levels file does not exist: " + path)
  end if
end function

function validateRoot(m, root)
  if typeof(root) != "struct" or root.kind != "object" then
    addError(m, "manifest root must be an object")
    return m
  end if
  requireField(m, root, "name")
  requireField(m, root, "main")
  requireField(m, root, "window")

  m.name = stringField(m, root, "name", true)
  m.main = stringField(m, root, "main", true)
  if m.main != "" and fs.exists(join(m.root, m.main)) == false then
    addError(m, "main source not found: " + m.main)
  end if

  window = json.get(root, "window")
  if typeof(window) == "void" then
    return m
  end if
  if window.kind != "object" then
    addError(m, "'window' must be an object")
    return m
  end if
  m.title = stringField(m, window, "title", false)
  m.width = numberField(m, window, "width", true, 0)
  m.height = numberField(m, window, "height", true, 0)
  m.scale = numberField(m, window, "scale", false, 1)
  if m.width <= 0 then addError(m, "window.width must be greater than zero") end if
  if m.height <= 0 then addError(m, "window.height must be greater than zero") end if
  if m.scale <= 0 then addError(m, "window.scale must be greater than zero") end if

  validateAssets(m, root)
  validateLevels(m, root)
  return m
end function

function parseText(text, source, root)
  parsed = try(json.parse(text))
  m = newManifest(source, root)
  if typeof(parsed) == "error" then
    addError(m, parsed.message)
    return m
  end if
  return validateRoot(m, parsed)
end function

function load(path)
  root = dirname(path)
  text = try(fs.readAllText(path))
  if typeof(text) == "error" then
    m = newManifest(path, root)
    addError(m, "cannot read manifest: " + text.message)
    return m
  end if
  return parseText(text, path, root)
end function

function printReport(m)
  if m is not Manifest then
    print "manifest: invalid report"
    return
  end if
  print "Manifest: " + m.path
  print "Name: " + m.name
  print "Main: " + m.main
  print "Window: " + m.width + "x" + m.height + " scale " + m.scale
  print "Assets: " + m.assetCount
  if m.levelPath != "" then print "Levels: " + m.levelPath end if
  if len(m.warnings) > 0 then
    for i = 0 to len(m.warnings) - 1
      print "[WARN] " + m.warnings[i]
    end for
  end if
  if len(m.errors) > 0 then
    for i = 0 to len(m.errors) - 1
      print "[ERROR] " + m.errors[i]
    end for
  else
    print "[OK] manifest valid"
  end if
end function
