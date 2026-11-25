# Pure MiniLang runtime profile

Compile with `-DMINIPIXELS_PURE=true` to use MiniPixels without its custom C/C++ runtime libraries. Platform libraries such as Win32, X11, WinMM and ALSA remain permitted dependencies. The option is a typed Boolean and defaults to `false`; existing projects retain the normal codec and GPU feature profile.

This profile is useful for projects whose runtime must be implemented in MiniLang. It removes the optional native imports at compilation time. That distinction matters on Windows, where the pinned compiler puts declared externs into the PE import table even when a particular application never calls them.

## Supported paths and explicit limits

| Feature | Pure profile behavior |
| --- | --- |
| CPU canvas, sprites, animation, cameras and tilemaps | Existing MiniLang implementation |
| Windows CPU canvas presentation | System GDI/OpenGL libraries |
| Linux CPU canvas presentation | System X11 library; MiniLang RGBA-to-BGR0 conversion and integer/nearest scaling |
| PNG decode and zlib/Deflate | Existing portable MiniLang decoder; no native inflate call |
| MRI1 prepared images | Existing MiniLang decoder |
| MPX payloads with none, RLE or Deflate compression | Supported |
| MPX payloads with LZ4 compression | Explicit error naming `MINIPIXELS_PURE` |
| PCM WAV parsing and mixing | Existing MiniLang parser/mixer and system audio APIs |
| MP3 decoding or MP3 voices | Explicit error naming `MINIPIXELS_PURE`; use PCM WAV |
| Batched GPU scene canvas | Capability is false; creation returns an explicit unsupported error |
| Optional retained 3D pass | Existing unsupported capability results |
| MPX audio/video streaming | Explicit unsupported errors; `std.audio` and `std.video` are not imported |
| Steam native bridge | Defining both `MINIPIXELS_PURE=true` and `MINIPIXELS_STEAM` is a compile error |

The profile does not replace unsupported operations with fabricated data or successful no-ops. Existing capability queries and unsupported return values remain the way to detect optional GPU/3D support. System audio-device availability is still a runtime condition.

## Build without a custom bridge

The existing general-purpose `minipixels.py build` command unconditionally prepares the native codec runtime. For this profile, generate the project assets and invoke the MiniLang compiler directly instead:

```sh
python /path/to/MiniPixels/tools/minipixels.py generate /path/to/game/minipixels.json
python /path/to/MiniLangCompilerPy/mlc_win64.py \
  /path/to/game/src/main.ml /path/to/game/build/game \
  --target linux-x64 -DMINIPIXELS_PURE=true \
  -I /path/to/game/src -I /path/to/MiniPixels/src \
  -I /path/to/MiniLangCompilerPy -I /path/to/game/build/generated
```

For Windows, use `--target windows-x64`, an `.exe` output and `--subsystem windows` when appropriate. Keep the generated `assets.mpx` beside the executable. `generate` writes it to `game/build/assets.mpx` by default and writes generated modules under `game/build/generated/generated/`.

For predictable loading, configure `assetLoading.compression` as `none`. The generator prepares PNG assets as MRI1 RGBA pixels. Keep WAV assets untranscoded with `"transcode": false`; MP3 is outside this profile. Application wrappers should also inspect the actual PE imports and reject unexpected custom runtime libraries.

## Verification

Run the profile checks without any native bridge build or asset download:

```sh
python tests/pure_profile_tests.py --compiler ../MiniLangCompilerPy/mlc_win64.py
python ../MiniLangCompilerPy/mlc_win64.py tests/linux_presentation_tests.ml \
  build/linux_presentation_tests --target linux-x64 -DMINIPIXELS_PURE=true \
  -I src -I ../MiniLangCompilerPy
./build/linux_presentation_tests
```

The profile runner generates all binary fixtures in a temporary directory. It checks stored, fixed-Huffman and dynamic-Huffman Deflate streams against independent Python zlib output, rejects changed checksums, verifies PNG pixels, MRI1 and uncompressed MPX payloads, parses PCM WAV, and checks explicit rejection of unsupported features. It compiles both native Linux and Windows targets, executes the host target, inspects Windows PE imports, and checks Linux loader diagnostics for custom runtime loads. Cross-compilation is not Windows runtime verification.

The Linux presentation suite checks 7,212 scaling cases against a destination-pixel oracle, including upscaling, downscaling, integer replication, offscreen clipping and letterboxing. Separate checks cover dirty rectangles and rejected row-buffer ranges. Its timing output measures pixel conversion/scaling only, without X11 presentation or a display server. On the development Linux host, 200 conversions measured 138 ms for 320×200 to 960×600 integer scaling and 623 ms for nearest scaling to an 891×543 viewport in a 913×557 buffer. These measurements are workload evidence, not an end-to-end game frame-rate guarantee.
