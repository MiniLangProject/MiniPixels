# MiniPixels 0.22.0

MiniPixels now includes an optional retained 3D layer on its Windows/OpenGL GPU
canvas. Existing 2D games continue to use their current rendering path.

- `minipixels.graphics.scene3d` provides immutable box meshes, transformed draws,
  isometric depth passes and projected orthographic model viewports.
- Meshes remain resident until released; shutdown frees their resources.
- Projected passes clear only the model rectangle's depth and preserve scene
  colour. Finishing a public pass restores the caller's 2D OpenGL state.
- The internal integration hook avoids redundant state snapshots/projections
  when the caller explicitly owns and restores its rendering state.
- Native builds now track changes to both the C++ source and 3D header.
- Tests cover depth order, cutouts, 2D restoration, texture units, invalid input,
  repeated resizing, resource lifetime, the MiniLang ABI and Linux fallbacks.

The layer is experimental and currently Windows/OpenGL only. Linux applications
still compile; these operations report unsupported there. It uses a fixed
isometric/orthographic camera and does not include a universal model importer,
game-specific skeletal formats, automatic shadows or a replacement for the
existing 2D renderer. Optional GPU tests explicitly report a capability skip
on hosted Windows runners without framebuffer support; real-GPU tests also run
locally without that allowance.

Rebuild `minipixels_gpu.dll` using `native/build-gpu.ps1` before using the new
module. No MPX-format change is required. See [the 3D guide](docs/scene3d.md) and
the generated MiniDoc API reference for details.
