// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools manifest facilities for this project.

package minipixels.tools.manifest

import minipixels.tools.json as json
import std.array as arr
import std.fs as fs
import std.string as str

/// Represents the manifest data used by the minipixels tools manifest module.
struct Manifest
  /// Stores the path value associated with manifest.
  path
  /// Stores the root value associated with manifest.
  root
  /// Stores the name value associated with manifest.
  name
  /// Stores the main value associated with manifest.
  main
  /// Stores the title value associated with manifest.
  title
  /// Stores the width value associated with manifest.
  width
  /// Stores the height value associated with manifest.
  height
  /// Stores the scale value associated with manifest.
  scale
  /// Stores the asset count value associated with manifest.
  assetCount
  /// Stores the level path value associated with manifest.
  levelPath
  /// Stores the errors value associated with manifest.
  errors
  /// Stores the warnings value associated with manifest.
  warnings
end struct

/// Creates manifest for the minipixels tools manifest module.
/// @param path Path of the file or directory used by the operation.
/// @param root root value consumed by this operation.
function newManifest(path, root)
  return Manifest(path, root, "", "", "", 0, 0, 1, 0, "", [], [])
end function

/// Adds error to the state managed by the minipixels tools manifest module.
/// @param m m value consumed by this operation.
/// @param msg msg value consumed by this operation.
function addError(m, msg)
  m.errors = arr.append(m.errors, msg)
end function

/// Adds warning to the state managed by the minipixels tools manifest module.
/// @param m m value consumed by this operation.
/// @param msg msg value consumed by this operation.
function addWarning(m, msg)
  m.warnings = arr.append(m.warnings, msg)
end function

/// Returns whether valid satisfies the required condition.
/// @param m m value consumed by this operation.
function isValid(m)
  return m is Manifest and len(m.errors) == 0
end function

/// Performs the maxInt operation for the minipixels tools manifest module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function maxInt(a, b)
  if a > b then return a end if
  return b
end function

/// Performs the dirname operation for the minipixels tools manifest module.
/// @param path Path of the file or directory used by the operation.
function dirname(path)
  lastSlash = str.lastIndexOf(path, "\\")
  lastForward = str.lastIndexOf(path, "/")
  last = maxInt(lastSlash, lastForward)
  if last < 0 then return "." end if
  if last == 0 then return str.substr(path, 0, 1) end if
  return str.substr(path, 0, last)
end function

/// Joins join for the minipixels tools manifest workflow.
/// @param root root value consumed by this operation.
/// @param rel rel value consumed by this operation.
function join(root, rel)
  return fs.joinPath(root, rel)
end function

/// Performs the safeIdentifier operation for the minipixels tools manifest module.
/// @param id Stable identifier of the affected item.
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

/// Returns whether the supplied data contains string.
/// @param items Items consumed or updated by the operation.
/// @param value Value consumed or transformed by the operation.
function containsString(items, value)
  if typeof(items) != "array" then return false end if
  if len(items) <= 0 then return false end if
  for i = 0 to len(items) - 1
    if items[i] == value then return true end if
  end for
  return false
end function

/// Performs the requireField operation for the minipixels tools manifest module.
/// @param m m value consumed by this operation.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
function requireField(m, obj, key)
  if json.has(obj, key) == false then
    addError(m, "missing required field '" + key + "'")
    return false
  end if
  return true
end function

/// Performs the stringField operation for the minipixels tools manifest module.
/// @param m m value consumed by this operation.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param required required value consumed by this operation.
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

/// Performs the numberField operation for the minipixels tools manifest module.
/// @param m m value consumed by this operation.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
/// @param required required value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
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

/// Returns whether a container compression profile is supported.
/// @internal
function validCompressionProfile(value)
  return value == "auto" or value == "none" or value == "fast" or value == "small"
end function

/// Validates asset for the minipixels tools manifest workflow.
/// @param m m value consumed by this operation.
/// @param asset asset value consumed by this operation.
/// @param seen seen value consumed by this operation.
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
  if typ != "image" and typ != "procedural" and typ != "audio" and typ != "file" and typ != "text" and typ != "data" and typ != "constants" then
    addError(m, "asset '" + id + "' type must be image, procedural, audio, file, text, data, or constants")
  end if
  compression = json.get(asset, "compression")
  if typeof(compression) != "void" then
    if compression.kind != "string" or not validCompressionProfile(compression.stringValue) then
      addError(m, "asset '" + id + "' compression must be auto, none, fast, or small")
    end if
  end if
  preload = json.get(asset, "preload")
  if typeof(preload) != "void" and preload.kind != "bool" and preload.kind != "string" then
    addError(m, "asset '" + id + "' preload must be a boolean or group name")
  end if
  if typeof(preload) != "void" and preload.kind == "string" and preload.stringValue == "" then
    addError(m, "asset '" + id + "' preload group must not be empty")
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

/// Validates assets for the minipixels tools manifest workflow.
/// @param m m value consumed by this operation.
/// @param root root value consumed by this operation.
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

/// Validates levels for the minipixels tools manifest workflow.
/// @param m m value consumed by this operation.
/// @param root root value consumed by this operation.
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

/// Validates root for the minipixels tools manifest workflow.
/// @param m m value consumed by this operation.
/// @param root root value consumed by this operation.
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

  loading = json.get(root, "assetLoading")
  if typeof(loading) != "void" then
    if loading.kind != "object" then
      addError(m, "'assetLoading' must be an object")
    else
      mode = stringField(m, loading, "mode", false)
      if mode != "" and mode != "lazy" and mode != "resident" then addError(m, "assetLoading.mode must be lazy or resident") end if
      compression = stringField(m, loading, "compression", false)
      if compression != "" and not validCompressionProfile(compression) then addError(m, "assetLoading.compression must be auto, none, fast, or small") end if
      batchBytes = numberField(m, loading, "batchBytes", false, 16777216)
      if batchBytes < 65536 or batchBytes > 536870912 then addError(m, "assetLoading.batchBytes must be between 65536 and 536870912") end if
    end if
  end if

  validateAssets(m, root)
  validateLevels(m, root)
  return m
end function

/// Parses text for the minipixels tools manifest workflow.
/// @param text Text consumed by the operation.
/// @param source source value consumed by this operation.
/// @param root root value consumed by this operation.
function parseText(text, source, root)
  parsed = try(json.parse(text))
  m = newManifest(source, root)
  if typeof(parsed) == "error" then
    addError(m, parsed.message)
    return m
  end if
  return validateRoot(m, parsed)
end function

/// Loads load for the minipixels tools manifest module.
/// @param path Path of the file or directory used by the operation.
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

/// Prints report for the minipixels tools manifest workflow.
/// @param m m value consumed by this operation.
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
