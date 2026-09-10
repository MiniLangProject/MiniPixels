# MiniPixels Getting Started

MiniPixels lives in this folder and uses the existing Python compiler:

```powershell
python -m pip install -r requirements.txt
```

The additional package is used by protected asset builds for key generation, encryption, and signing. The generated game runtime itself uses only MiniLang's native platform cryptography.

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py <main.ml> <game.exe> -I src
```

For Linux x64, select the ELF target and omit the `.exe` suffix:

```bash
python3 ../MiniLangCompilerPy/mlc_win64.py <main.ml> <game> -I src --target linux-x64
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

On Linux the build and test drivers choose `linux-x64` automatically. From Windows, use `--target linux-x64` to cross-compile an ELF executable:

```powershell
python tools\minipixels.py build examples\moving-sprite\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py --target linux-x64
python tests\run_tests.py --target linux-x64
```

There is also a native MiniLang CLI for the pieces that have already moved out of Python:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py tools\minipixels_cli.ml build\tools\minipixels.exe -I src -I ..\MiniLangCompilerPy
build\tools\minipixels.exe info
build\tools\minipixels.exe validate examples\jump-and-run\minipixels.json
build\tools\minipixels.exe generate examples\jump-and-run\minipixels.json examples\jump-and-run\build\generated\generated
```

Native `generate` writes unprotected image/procedural/audio/file/text/data packs and MiniPixels or Tiled/TMJ level modules. The Python CLI remains the recommended end-to-end driver: it also builds, emits reports, compiles constants, and creates signed/encrypted packs.

To keep ordinary game development unchanged while protecting release assets, initialize protection once and continue using the normal `build`, `run`, and `package` commands:

```powershell
python tools\minipixels.py security init path\to\minipixels.json
python tools\minipixels.py build path\to\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Keep the generated private signing key outside version control. The public verification key and an obfuscated AES-key reconstruction are generated into the game automatically; no key files are needed beside the finished executable and `assets.mpx`.

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

Game logic, input polling, PCM mixing, MP3 stream decoding, rendering, and native presentation run on the main thread. Windows waveOut consumes retained mixer buffers asynchronously; Linux refills a non-blocking ALSA stream from the frame loop. Public MiniPixels objects should be created and used on the main thread in this version.

## Implemented now

Canvas, render targets, rotated sprites, deterministic PNG screenshots, cached signed/encrypted `.mpx` asset packs, localized text, generated constants/data, general non-interlaced PNG loading, native asset/Tiled generation, sprite sheets, scene stacks, animation, camera, tilemaps, parallax, swept collision, bitmap text, buffered configurable input, a real multi-voice PCM mixer, headless/visual regression tests, Win32 GDI/OpenGL and Linux X11/XImage presentation, an experimental batched Windows GPU scene canvas, CLI, cross-platform CI, SDK packaging, and examples are present.

## Not yet in the engine

Wayland and GPU-accelerated Linux presentation, additional compressed audio codecs, Adam7/16-bit PNG decoding, background asset I/O, fully integrated cross-platform GPU-native render targets, a complete ECS/physics layer, and an editor remain extension points.
