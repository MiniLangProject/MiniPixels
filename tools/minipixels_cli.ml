import std.fs as fs
import std.string as str
import std.string_builder as sb
import minipixels.tools.manifest as manifest
import minipixels.tools.generator as generator
import minipixels.tools.fsutil as fsu

const VERSION = "0.8.0"

function usage()
  print "MiniPixels native CLI " + VERSION
  print ""
  print "Usage:"
  print "  minipixels info [project]"
  print "  minipixels doctor"
  print "  minipixels validate [project]"
  print "  minipixels generate [project] [outDir]"
  print "  minipixels new <name> [basic|platformer|pixel-art]"
  print ""
  print "This MiniLang CLI covers project creation, diagnostics, validation, native asset packing, and generation."
  print "Build, run, and SDK packaging remain available through the Python project driver."
end function

function fail(msg)
  print msg
  return 1
end function

function writeText(path, text)
  r = try(fsu.writeText(path, text))
  if typeof(r) == "error" then
    print path + ": " + r.message
    return false
  end if
  return true
end function

function safeProjectName(name)
  if typeof(name) != "string" then return false end if
  if len(name) == 0 then return false end if
  allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"
  for i = 0 to len(name) - 1
    ch = name[i]
    if str.contains(allowed, ch) == false then return false end if
  end for
  return true
end function

function normalizeTemplate(tpl)
  t = str.toLowerAscii(tpl)
  if t == "platformer" then return "platformer" end if
  if t == "pixel-art" then return "pixel-art" end if
  if t == "pixel" then return "pixel-art" end if
  return "basic"
end function

function jsonFor(name, title, width, height, scale)
  text = sb.StringBuilder.withCapacity(192)
  text.appendLine("{")
  text.appendLine("  \"name\": \"" + name + "\",")
  text.appendLine("  \"main\": \"src/main.ml\",")
  text.appendLine("  \"window\": {")
  text.appendLine("    \"title\": \"" + title + "\",")
  text.appendLine("    \"width\": " + width + ",")
  text.appendLine("    \"height\": " + height + ",")
  text.appendLine("    \"scale\": " + scale)
  text.appendLine("  },")
  text.appendLine("  \"assets\": []")
  text.appendLine("}")
  return text.toString()
end function

function basicMain(title)
  text = sb.StringBuilder.withCapacity(768)
  text.appendLine("import minipixels as mp")
  text.appendLine("")
  text.appendLine("x = 40")
  text.appendLine("y = 40")
  text.appendLine("")
  text.appendLine("function update(game, dt)")
  text.appendLine("  global x, y")
  text.appendLine("  speed = 90 * dt")
  text.appendLine("  if game.input.left then x = x - speed end if")
  text.appendLine("  if game.input.right then x = x + speed end if")
  text.appendLine("  if game.input.up then y = y - speed end if")
  text.appendLine("  if game.input.down then y = y + speed end if")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function render(game, canvas)")
  text.appendLine("  canvas.clear(mp.rgb(18, 22, 34))")
  text.appendLine("  canvas.fillRect(x, y, 16, 16, mp.rgb(255, 205, 80))")
  text.appendLine("  mp.drawText(canvas, \"" + title + "\", 8, 8, 1, mp.rgb(255, 255, 255))")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function main(args)")
  text.appendLine("  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)")
  text.appendLine("  mp.useIntegerScale(cfg)")
  text.appendLine("  return mp.run(cfg, void, update, render, void)")
  text.appendLine("end function")
  return text.toString()
end function

function pixelArtMain(title)
  text = sb.StringBuilder.withCapacity(1024)
  text.appendLine("import minipixels as mp")
  text.appendLine("")
  text.appendLine("frame = 0")
  text.appendLine("")
  text.appendLine("function update(game, dt)")
  text.appendLine("  global frame")
  text.appendLine("  frame = frame + 1")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function render(game, canvas)")
  text.appendLine("  canvas.clear(mp.rgb(12, 14, 24))")
  text.appendLine("  for y = 0 to canvas.height - 1")
  text.appendLine("    for x = 0 to canvas.width - 1")
  text.appendLine("      if ((x + frame) % 16) == 0 or ((y + frame) % 16) == 0 then")
  text.appendLine("        canvas.setPixel(x, y, mp.rgb(78, 205, 196))")
  text.appendLine("      end if")
  text.appendLine("    end for")
  text.appendLine("  end for")
  text.appendLine("  canvas.fillRect(138, 74, 44, 32, mp.rgb(255, 205, 80))")
  text.appendLine("  canvas.drawRect(138, 74, 44, 32, mp.rgb(255, 255, 255))")
  text.appendLine("  mp.drawTextCentered(canvas, \"" + title + "\", 20, 1, mp.rgb(255, 255, 255))")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function main(args)")
  text.appendLine("  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)")
  text.appendLine("  mp.useIntegerScale(cfg)")
  text.appendLine("  return mp.run(cfg, void, update, render, void)")
  text.appendLine("end function")
  return text.toString()
end function

function platformerMain(title)
  text = sb.StringBuilder.withCapacity(1024)
  text.appendLine("import minipixels as mp")
  text.appendLine("")
  text.appendLine("x = 48")
  text.appendLine("y = 120")
  text.appendLine("vy = 0")
  text.appendLine("grounded = false")
  text.appendLine("")
  text.appendLine("function update(game, dt)")
  text.appendLine("  global x, y, vy, grounded")
  text.appendLine("  if game.input.left then x = x - 90 * dt end if")
  text.appendLine("  if game.input.right then x = x + 90 * dt end if")
  text.appendLine("  if game.input.jump and grounded then")
  text.appendLine("    vy = -230")
  text.appendLine("    grounded = false")
  text.appendLine("  end if")
  text.appendLine("  vy = vy + 620 * dt")
  text.appendLine("  y = y + vy * dt")
  text.appendLine("  if y > 132 then")
  text.appendLine("    y = 132")
  text.appendLine("    vy = 0")
  text.appendLine("    grounded = true")
  text.appendLine("  end if")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function render(game, canvas)")
  text.appendLine("  canvas.clear(mp.rgb(88, 146, 190))")
  text.appendLine("  canvas.fillRect(0, 148, 320, 32, mp.rgb(64, 120, 68))")
  text.appendLine("  canvas.fillRect(0, 160, 320, 20, mp.rgb(52, 82, 62))")
  text.appendLine("  canvas.fillRect(x, y, 14, 16, mp.rgb(255, 205, 80))")
  text.appendLine("  canvas.drawRect(x, y, 14, 16, mp.rgb(20, 20, 30))")
  text.appendLine("  mp.drawText(canvas, \"" + title + "\", 8, 8, 1, mp.rgb(255, 255, 255))")
  text.appendLine("end function")
  text.appendLine("")
  text.appendLine("function main(args)")
  text.appendLine("  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)")
  text.appendLine("  mp.useIntegerScale(cfg)")
  text.appendLine("  return mp.run(cfg, void, update, render, void)")
  text.appendLine("end function")
  return text.toString()
end function

function mainForTemplate(tpl, title)
  if tpl == "platformer" then return platformerMain(title) end if
  if tpl == "pixel-art" then return pixelArtMain(title) end if
  return basicMain(title)
end function

function readmeFor(name, tpl)
  text = sb.StringBuilder.withCapacity(384)
  text.appendLine("# " + name)
  text.appendLine("")
  text.appendLine("Created with the native MiniPixels MiniLang CLI.")
  text.appendLine("")
  text.appendLine("Template: `" + tpl + "`")
  text.appendLine("")
  text.appendLine("Build with the MiniPixels project driver:")
  text.appendLine("")
  text.appendLine("```powershell")
  text.appendLine("..\\tools\\minipixels.py build minipixels.json --compiler ..\\..\\MiniLangCompilerPy\\mlc_win64.py")
  text.appendLine("```")
  return text.toString()
end function

function projectArg(args, defaultPath)
  if len(args) >= 2 then return args[1] end if
  return defaultPath
end function

function commandInfo(args)
  if len(args) >= 2 then
    m = manifest.load(projectArg(args, "minipixels.json"))
    manifest.printReport(m)
    if manifest.isValid(m) then return 0 end if
    return 1
  end if
  print "MiniPixels native CLI " + VERSION
  print "Engine templates: basic, platformer, pixel-art"
  print "Native status: validation, asset packing, and code generation are implemented in MiniLang."
  print "Python driver: build, run, and SDK packaging."
  return 0
end function

function commandValidate(args)
  m = manifest.load(projectArg(args, "minipixels.json"))
  manifest.printReport(m)
  if manifest.isValid(m) then return 0 end if
  return 1
end function

function commandGenerate(args)
  project = projectArg(args, "minipixels.json")
  outDir = ""
  if len(args) >= 3 then outDir = args[2] end if
  r = generator.generate(project, outDir)
  generator.printResult(r)
  if r.ok then return 0 end if
  return 1
end function

function commandDoctor()
  print "MiniPixels native CLI doctor"
  ok = true
  if fs.exists("src\\minipixels.ml") then
    print "[OK] engine source found: src\\minipixels.ml"
  else
    print "[WARN] engine source not found in current directory"
    ok = false
  end if
  if fs.exists("tools\\minipixels_cli.ml") then
    print "[OK] native CLI source found"
  else
    print "[WARN] native CLI source not found"
  end if
  if fs.exists("..\\MiniLangCompilerPy\\mlc_win64.py") then
    print "[OK] bootstrap compiler found: ..\\MiniLangCompilerPy\\mlc_win64.py"
  else
    print "[WARN] bootstrap compiler not found next to this repo"
    ok = false
  end if
  if fs.exists("minipixels.json") then
    m = manifest.load("minipixels.json")
    if manifest.isValid(m) then
      print "[OK] local minipixels.json valid"
    else
      print "[WARN] local minipixels.json has errors"
      for i = 0 to len(m.errors) - 1
        print "  " + m.errors[i]
      end for
      ok = false
    end if
  end if
  if ok then return 0 end if
  return 1
end function

function commandNew(args)
  if len(args) < 2 then
    return fail("new: missing project name")
  end if
  name = args[1]
  if safeProjectName(name) == false then
    return fail("new: project name may only contain letters, digits, '-' and '_'")
  end if
  tpl = "basic"
  if len(args) >= 3 then tpl = normalizeTemplate(args[2]) end if
  if fs.exists(name) then
    return fail("new: target already exists: " + name)
  end if
  if fsu.mkdir(name) == false then return fail("new: could not create directory: " + name) end if
  srcDir = fs.joinPath(name, "src")
  assetsDir = fs.joinPath(name, "assets")
  if fsu.mkdir(srcDir) == false then return fail("new: could not create directory: " + srcDir) end if
  if fsu.mkdir(assetsDir) == false then return fail("new: could not create directory: " + assetsDir) end if

  title = name
  manifestPath = fs.joinPath(name, "minipixels.json")
  mainPath = fs.joinPath(srcDir, "main.ml")
  readmePath = fs.joinPath(name, "README.md")
  if writeText(manifestPath, jsonFor(name, title, 320, 180, 4)) == false then return 1 end if
  if writeText(mainPath, mainForTemplate(tpl, title)) == false then return 1 end if
  if writeText(readmePath, readmeFor(name, tpl)) == false then return 1 end if

  print "Created MiniPixels project: " + name
  print "Template: " + tpl
  print "Next:"
  print "  cd " + name
  print "  ..\\tools\\minipixels.py build minipixels.json --compiler ..\\..\\MiniLangCompilerPy\\mlc_win64.py"
  return 0
end function

function main(args)
  if len(args) == 0 then
    usage()
    return 0
  end if
  cmd = str.toLowerAscii(args[0])
  if cmd == "help" or cmd == "--help" or cmd == "-h" then
    usage()
    return 0
  end if
  if cmd == "info" then return commandInfo(args) end if
  if cmd == "doctor" then return commandDoctor() end if
  if cmd == "validate" then return commandValidate(args) end if
  if cmd == "generate" then return commandGenerate(args) end if
  if cmd == "new" then return commandNew(args) end if
  usage()
  return 1
end function
