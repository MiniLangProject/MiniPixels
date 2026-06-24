import std.fs as fs
import std.string as str

extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

const VERSION = "0.4.0"

function usage()
  print "MiniPixels native CLI " + VERSION
  print ""
  print "Usage:"
  print "  minipixels info"
  print "  minipixels doctor"
  print "  minipixels new <name> [basic|platformer|pixel-art]"
  print ""
  print "This MiniLang CLI currently covers project creation and diagnostics."
  print "Build/generate/package are still handled by the legacy Python tool until"
  print "JSON, PNG and compiler process launching are moved into MiniLang."
end function

function mkdir(path)
  if fs.exists(path) then
    return fs.isDir(path)
  end if
  return CreateDirectoryW(path, 0)
end function

function fail(msg)
  print msg
  return 1
end function

function writeText(path, text)
  r = try(fs.writeAllText(path, text))
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
  return "{\n" +
    "  \"name\": \"" + name + "\",\n" +
    "  \"main\": \"src/main.ml\",\n" +
    "  \"window\": {\n" +
    "    \"title\": \"" + title + "\",\n" +
    "    \"width\": " + width + ",\n" +
    "    \"height\": " + height + ",\n" +
    "    \"scale\": " + scale + "\n" +
    "  },\n" +
    "  \"assets\": []\n" +
    "}\n"
end function

function basicMain(title)
  return "import minipixels as mp\n\n" +
    "x = 40\n" +
    "y = 40\n\n" +
    "function update(game, dt)\n" +
    "  global x, y\n" +
    "  speed = 90 * dt\n" +
    "  if game.input.left then x = x - speed end if\n" +
    "  if game.input.right then x = x + speed end if\n" +
    "  if game.input.up then y = y - speed end if\n" +
    "  if game.input.down then y = y + speed end if\n" +
    "end function\n\n" +
    "function render(game, canvas)\n" +
    "  canvas.clear(mp.rgb(18, 22, 34))\n" +
    "  canvas.fillRect(x, y, 16, 16, mp.rgb(255, 205, 80))\n" +
    "  mp.drawText(canvas, \"" + title + "\", 8, 8, 1, mp.rgb(255, 255, 255))\n" +
    "end function\n\n" +
    "function main(args)\n" +
    "  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)\n" +
    "  mp.useIntegerScale(cfg)\n" +
    "  return mp.run(cfg, void, update, render, void)\n" +
    "end function\n"
end function

function pixelArtMain(title)
  return "import minipixels as mp\n\n" +
    "frame = 0\n\n" +
    "function update(game, dt)\n" +
    "  global frame\n" +
    "  frame = frame + 1\n" +
    "end function\n\n" +
    "function render(game, canvas)\n" +
    "  canvas.clear(mp.rgb(12, 14, 24))\n" +
    "  for y = 0 to canvas.height - 1\n" +
    "    for x = 0 to canvas.width - 1\n" +
    "      if ((x + frame) % 16) == 0 or ((y + frame) % 16) == 0 then\n" +
    "        canvas.setPixel(x, y, mp.rgb(78, 205, 196))\n" +
    "      end if\n" +
    "    end for\n" +
    "  end for\n" +
    "  canvas.fillRect(138, 74, 44, 32, mp.rgb(255, 205, 80))\n" +
    "  canvas.drawRect(138, 74, 44, 32, mp.rgb(255, 255, 255))\n" +
    "  mp.drawTextCentered(canvas, \"" + title + "\", 20, 1, mp.rgb(255, 255, 255))\n" +
    "end function\n\n" +
    "function main(args)\n" +
    "  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)\n" +
    "  mp.useIntegerScale(cfg)\n" +
    "  return mp.run(cfg, void, update, render, void)\n" +
    "end function\n"
end function

function platformerMain(title)
  return "import minipixels as mp\n\n" +
    "x = 48\n" +
    "y = 120\n" +
    "vy = 0\n" +
    "grounded = false\n\n" +
    "function update(game, dt)\n" +
    "  global x, y, vy, grounded\n" +
    "  if game.input.left then x = x - 90 * dt end if\n" +
    "  if game.input.right then x = x + 90 * dt end if\n" +
    "  if game.input.jump and grounded then\n" +
    "    vy = -230\n" +
    "    grounded = false\n" +
    "  end if\n" +
    "  vy = vy + 620 * dt\n" +
    "  y = y + vy * dt\n" +
    "  if y > 132 then\n" +
    "    y = 132\n" +
    "    vy = 0\n" +
    "    grounded = true\n" +
    "  end if\n" +
    "end function\n\n" +
    "function render(game, canvas)\n" +
    "  canvas.clear(mp.rgb(88, 146, 190))\n" +
    "  canvas.fillRect(0, 148, 320, 32, mp.rgb(64, 120, 68))\n" +
    "  canvas.fillRect(0, 160, 320, 20, mp.rgb(52, 82, 62))\n" +
    "  canvas.fillRect(x, y, 14, 16, mp.rgb(255, 205, 80))\n" +
    "  canvas.drawRect(x, y, 14, 16, mp.rgb(20, 20, 30))\n" +
    "  mp.drawText(canvas, \"" + title + "\", 8, 8, 1, mp.rgb(255, 255, 255))\n" +
    "end function\n\n" +
    "function main(args)\n" +
    "  cfg = mp.createConfig(\"" + title + "\", 320, 180, 4)\n" +
    "  mp.useIntegerScale(cfg)\n" +
    "  return mp.run(cfg, void, update, render, void)\n" +
    "end function\n"
end function

function mainForTemplate(tpl, title)
  if tpl == "platformer" then return platformerMain(title) end if
  if tpl == "pixel-art" then return pixelArtMain(title) end if
  return basicMain(title)
end function

function readmeFor(name, tpl)
  return "# " + name + "\n\n" +
    "Created with the native MiniPixels MiniLang CLI.\n\n" +
    "Template: `" + tpl + "`\n\n" +
    "Build with the legacy processor while the remaining pipeline is moved to MiniLang:\n\n" +
    "```powershell\n" +
    "..\\tools\\minipixels.py build minipixels.json --compiler ..\\..\\MiniLangCompilerPy\\mlc_win64.py\n" +
    "```\n"
end function

function commandInfo()
  print "MiniPixels native CLI " + VERSION
  print "Engine templates: basic, platformer, pixel-art"
  print "Python status: compiler bootstrap only; legacy build pipeline still exists."
  return 0
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
  if mkdir(name) == false then return fail("new: could not create directory: " + name) end if
  srcDir = fs.joinPath(name, "src")
  assetsDir = fs.joinPath(name, "assets")
  if mkdir(srcDir) == false then return fail("new: could not create directory: " + srcDir) end if
  if mkdir(assetsDir) == false then return fail("new: could not create directory: " + assetsDir) end if

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
  if cmd == "info" then return commandInfo() end if
  if cmd == "doctor" then return commandDoctor() end if
  if cmd == "new" then return commandNew(args) end if
  usage()
  return 1
end function
