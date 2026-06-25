# MiniPixels Getting Started

MiniPixels lives in this folder and uses the existing Python compiler:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py <main.ml> <game.exe> -I src
```

The recommended full build/run workflow is the Python CLI:

```powershell
python tools\minipixels.py --version
python tools\minipixels.py validate examples\moving-sprite\minipixels.json
python tools\minipixels.py generate examples\moving-sprite\minipixels.json
python tools\minipixels.py build examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
python tools\minipixels.py run examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
python tools\build_examples.py
python tools\package_sdk.py
```

There is also a native MiniLang CLI for the pieces that have already moved out of Python:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py tools\minipixels_cli.ml build\tools\minipixels.exe -I src -I ..\MiniLangCompilerPy
build\tools\minipixels.exe info
build\tools\minipixels.exe validate examples\jump-and-run\minipixels.json
build\tools\minipixels.exe generate examples\jump-and-run\minipixels.json examples\jump-and-run\build\generated\generated
```

Native `generate` supports procedural sprites, sheet helpers, and MiniPixels `levels.json`. The Python CLI still owns MiniPixels asset-pack generation for images/audio/files, Tiled/TMJ import, build/run, packaging, and compiler launching.

## Minimal game

```ml
import minipixels as mp

x = 40
y = 40

function update(game, dt)
  global x, y
  if game.input.left then x = x - 1 end if
  if game.input.right then x = x + 1 end if
end function

function render(game, canvas)
  canvas.clear(mp.rgb(20, 20, 30))
  canvas.fillRect(x, y, 16, 16, mp.rgb(255, 128, 0))
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Demo", 320, 180, 4)
  return mp.run(cfg, void, update, render, void)
end function
```

## Color format

Colors are packed as `0xRRGGBBAA`. Canvas pixels are stored as RGBA bytes. Alpha is straight alpha. Drawing functions clip safely; writes outside the framebuffer do nothing.

## Thread model

Game logic, input polling, rendering, and Win32 presentation run on the main thread. The audio wrapper delegates to WinMM and may use system-managed audio threads internally. Public MiniPixels objects should be created and used on the main thread in this version.

## Implemented now

Canvas, sprites, MiniPixels `.mpx` asset packs, runtime PNG decoding for packed RGBA images, native procedural asset generation, runtime audio/file asset packing, sprite sheets, generated level data, animation helpers, camera, tilemaps, parallax, collision helpers, bitmap text, input/action snapshots, AudioMixer API, headless tests, framehash regression tests, Win32 GDI and OpenGL/WGL presentation, CLI, CI workflow, SDK packaging, and examples are present.

## Not yet in the engine

Native asset-pack generation, native Tiled/TMJ import, general PNG hot-loading outside `.mpx`, advanced audio mixing, async asset loading, arbitrary rotation, GPU render targets, a complete ECS, and visual golden-image management are documented extension points rather than current engine features.
