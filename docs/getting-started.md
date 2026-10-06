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

Cross-target tests execute Linux binaries and the native media regressions inside WSL. Install Python 3 and `cryptography` there (Ubuntu: `sudo apt-get install python3-cryptography`), plus the GStreamer and OpenSSL packages listed in the README. Native Linux CI installs these runtime/build dependencies before running the same suite.

There is also a native MiniLang CLI for the pieces that have already moved out of Python:

```powershell
python ..\MiniLangCompilerPy\mlc_win64.py tools\minipixels_cli.ml build\tools\minipixels.exe -I src -I ..\MiniLangCompilerPy
build\tools\minipixels.exe info
build\tools\minipixels.exe validate examples\jump-and-run\minipixels.json
build\tools\minipixels.exe generate examples\jump-and-run\minipixels.json examples\jump-and-run\build\generated\generated
```

Native `generate` writes unprotected image/procedural/audio/video/file/text/data packs and MiniPixels or Tiled/TMJ level modules. Audio marked with `"stream": true` and every video asset are exposed as closeable, file-backed players instead of being copied completely into memory. The Python CLI remains the recommended end-to-end driver: it also builds, emits reports, compiles constants, and creates signed/encrypted packs.

To keep ordinary game development unchanged while protecting release assets, initialize protection once and continue using the normal `build`, `run`, and `package` commands:

```powershell
python tools\minipixels.py security init path\to\minipixels.json
python tools\minipixels.py build path\to\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

Keep the generated private signing key outside version control. The public verification key and an obfuscated AES-key reconstruction are generated into the game automatically; no key files are needed beside the finished executable and `assets.mpx`.

Generated asset helpers first select `assets.mpx` beside the executable, independently of the launch working directory. Only when that file is absent do development paths apply (`assets.mpx`, then `build/assets.mpx` in the working directory). An invalid installed pack is an error, not a reason to silently use another pack. Native-generator development code also retains its configured project-path fallback.

Distribute the native libraries beside the executable as produced by the build command. Linux uses executable-relative `$ORIGIN` imports for MiniPixels libraries, so launching from a desktop shortcut, Steam, or another directory works without copying `.so` files into the working directory. Custom build outputs no longer delete existing `assets/audio` directories; remove obsolete loose assets manually after checking that they are not source files.

Protected packs now use MPX3 version 6. When upgrading, rebuild the game and its pack together; keep the existing private signing key. See the [asset protection reference](manifest-reference.md#protected-asset-builds) for the integrity model and format change.

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

The ALSA refill drains available capacity with a bounded number of writes per update and retains unwritten PCM after partial writes or temporary backpressure. It is not limited to one 1024-frame buffer per game frame, so a steady 30 FPS loop can sustain 44.1-kHz stereo. Long main-thread stalls can still underrun; this is not a dedicated audio-thread design.

## Implemented now

Canvas, render targets, rotated sprites, deterministic PNG screenshots, cached signed/encrypted `.mpx` asset packs, localized text, generated constants/data, general non-interlaced PNG loading, native asset/Tiled generation, sprite sheets, scene stacks, animation, camera, tilemaps, parallax, swept collision, bitmap text, buffered configurable input, a real multi-voice PCM mixer, headless/visual regression tests, Win32 GDI/OpenGL and Linux X11/XImage presentation, an experimental batched Windows GPU scene canvas, CLI, cross-platform CI, SDK packaging, and examples are present.

## Not yet in the engine

Wayland and GPU-accelerated Linux presentation, additional compressed audio codecs, Adam7/16-bit PNG decoding, background asset I/O, fully integrated cross-platform GPU-native render targets, a complete ECS/physics layer, and an editor remain extension points.
