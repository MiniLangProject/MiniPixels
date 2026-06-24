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

function assetsModule()
  return "package generated.assets\n\n" +
    "import minipixels as mp\n" +
    "import minipixels.assets.assets as assets\n\n" +
    "function registry()\n" +
    "  reg = assets.create(64)\n" +
    "  return reg\n" +
    "end function\n"
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
    "function coinCount(level) return 0 end function\n" +
    "function coinX(level, index) return 0 end function\n" +
    "function coinY(level, index) return 0 end function\n"
end function

function warnUnsupportedAssets(r, projectPath)
  text = try(fs.readAllText(projectPath))
  if typeof(text) == "error" then return end if
  parsed = try(json.parse(text))
  if typeof(parsed) == "error" then return end if
  assets = json.get(parsed, "assets")
  if typeof(assets) == "void" or assets.kind != "array" then return end if
  if len(assets.arrayItems) <= 0 then return end if
  for i = 0 to len(assets.arrayItems) - 1
    asset = assets.arrayItems[i]
    if typeof(asset) == "struct" and asset.kind == "object" then
      id = json.asString(json.get(asset, "id"), "asset")
      typ = json.asString(json.get(asset, "type"), "image")
      if typ == "image" then
        addWarning(r, "image asset '" + id + "' still needs legacy PNG embedding")
      else
        addWarning(r, "runtime asset '" + id + "' is validated but not copied by native generate yet")
      end if
    end if
  end for
end function

function generate(projectPath, outDir)
  target = outDir
  if target == "" then target = defaultOutDir(projectPath) end if
  r = result(target)
  m = manifest.load(projectPath)
  if manifest.isValid(m) == false then
    for i = 0 to len(m.errors) - 1
      addError(r, m.errors[i])
    end for
    return r
  end if
  if fsu.ensureDir(target) == false then
    addError(r, "could not create output directory: " + target)
    return r
  end if
  wr = try(fsu.writeText(fs.joinPath(target, "assets.ml"), assetsModule()))
  if typeof(wr) == "error" then
    addError(r, wr.message)
    return r
  end if
  if m.levelPath != "" then
    addWarning(r, "native level import is not implemented yet; wrote generated.levels stub")
    wrLevels = try(fsu.writeText(fs.joinPath(target, "levels.ml"), levelsStubModule()))
    if typeof(wrLevels) == "error" then addError(r, wrLevels.message) end if
  end if
  warnUnsupportedAssets(r, projectPath)
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
