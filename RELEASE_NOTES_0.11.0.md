# MiniPixels 0.11.0

MiniPixels 0.11.0 adds compressed stereo audio and an experimental path for
rendering complete scenes on the GPU while retaining the portable CPU renderer.

## MP3 and stereo audio

WAV and MP3 clips can now be mono or stereo. Sound effects decode lazily and
MP3 music streams incrementally from files or packed MPX bytes instead of
expanding the complete track in memory. The mixer preserves left/right channels
through rate conversion, looping, master/bus/channel volume, and pan.

The Python build driver automatically builds and copies the small native decoder
bridge for Windows x64 or Linux x64. Its `dr_mp3` dependency is pinned and
checksum-verified before compilation. Capability queries let games detect MP3
decoding and stereo mixing explicitly.

## Experimental GPU scene canvas

Windows developers can opt into `minipixels.graphics.gpu`, a separate batched
OpenGL scene canvas that renders sprites and primitives directly into a logical
GPU framebuffer. It supports resizing, CPU-image texture caching and explicit
invalidation, readback, window presentation, per-frame upload/draw-call counters,
and optional shader-based point lights. The light shader is a capability rather
than a requirement, so ordinary GPU rendering still works when it is unavailable.

The native runtime validates its owning OpenGL context, safely rebuilds resized
framebuffers and changed texture formats, and preserves opaque scene alpha for a
cheaper blend path. A PowerShell build helper compiles the DLL with Visual Studio,
and the SDK now contains its source and build script. Linux imports compile to a
safe unsupported fallback without linking a Windows library.

This API remains experimental and explicit. It is not yet wired into `mp.run`,
and it does not currently implement rotated sprites, GPU-canvas texture sources,
or Linux GPU rendering. The existing CPU Canvas and OpenGL/GDI/XImage presenters
remain the stable default.

## Rendering optimizations

The CPU Canvas now specializes transparent sprite rows when the destination is
known opaque and retains that invariant after source-over fills. Windows avoids
redundant full-client clears when an opaque frame covers the complete viewport;
letterboxed resize and expose events continue to repaint their borders correctly.

## Verification

The full Windows test suite covers WAV/MP3 mono/stereo mixing and protected packed
audio. A native GPU smoke test covers drawing, resizing, readback, resolving, and
window swaps. The same test cross-compiles and runs its unsupported fallback on
Linux. The committed MiniDoc HTML and Markdown references are generated in strict
mode with zero warnings.
