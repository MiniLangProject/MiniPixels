# MiniPixels 0.10.0

MiniPixels 0.10.0 removes the fixed-framebuffer limitation and improves the
presentation paths used by native Windows and Linux games.

## Flexible render resolution

Games can keep an arbitrary fixed framebuffer, render at the native window
client size, or follow a configurable fraction or multiple of that size:

```ml
cfg = mp.createConfig("Game", 320, 180, 4)
mp.useNativeRenderResolution(cfg)
# mp.useScaledRenderResolution(cfg, 0.75)
mp.setMaxRenderPixels(cfg, 2073600)
mp.setDesignResolution(cfg, 320, 180)
```

Native and scaled modes react to window resizing before input and game
callbacks run. The existing Canvas object is retained while its pixel storage
is replaced, avoiding stale game references. `game.renderWidth`,
`game.renderHeight`, `game.renderScaleX/Y`, and `game.resolutionChanged` expose
the active state. Explicit conversion helpers connect optional design
coordinates to framebuffer pixels.

Dynamic allocations preserve the client aspect ratio when the configured
pixel limit is reached. Minimized windows do not collapse and reallocate the
framebuffer to a temporary 1x1 surface.

## Renderer performance

The WGL presenter now reallocates its backing texture safely when render size
changes and retains power-of-two storage across nearby sizes. Windows and Linux
skip native presentation for unchanged frames until their window system asks
for repainting.

At native 1:1 size, the Linux XImage path converts and uploads only the Canvas
dirty rectangle instead of rebuilding the complete client image. GDI continues
to consume RGBA pixels through explicit channel masks without a conversion
copy.

The renderer benchmark now covers 320x180, 960x540, and 1920x1080 and reports
megapixel throughput. Developers can use fractional render resolution to trade
pixel workload for frame rate without changing the native window size.

## Verification

The release is covered by resolution-policy, Canvas identity/reallocation, and
coordinate-conversion tests. Window smoke tests exercise runtime framebuffer
resizing and the complete native-resolution game loop on OpenGL/WGL and X11.
The full test suites and all examples build for Windows x64 and Linux x64, and
the committed MiniDoc reference is generated with zero warnings.
