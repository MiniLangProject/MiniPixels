# Physical keys, fullscreen and synchronized music

These reusable additions support applications with configurable controls,
independent rendering resolutions and adaptive music. Game rules and scene
selection remain the caller's responsibility.

## Physical keyboard capture

Both desktop platform modules expose `keyDownForWindow(window,key)`. It reads
one virtual key only while the window owns focus; invalid windows or keys
outside 0–255 return false. The Windows implementation uses its existing
physical-key query. Linux translates X11 keysyms into the same key codes:

| Modifier | Left | Right | Aggregate |
| --- | ---: | ---: | ---: |
| Shift | 160 | 161 | 16 |
| Ctrl | 162 | 163 | 17 |
| Alt | 164 | 165 | 18 |

Linux preserves the aggregate key while either side remains held. Key-capture
interfaces should wait for the activating key to be released, ignore aggregate
modifier aliases when recording a physical side, detect edges, and cancel on
focus loss. Existing `InputState.bindKeys` consumes these codes normally.

## Borderless monitor fullscreen

`setFullscreen(window,enabled)` requests the mode and returns success;
`isFullscreen(window)` reports the backend's state. On Windows, entry selects
the current/nearest monitor, saves the window style and `WINDOWPLACEMENT`,
removes the normal frame and covers the monitor. Exit restores the previous
normal or maximized placement. Logical input coordinates and the application's
framebuffer resolution are independent of this transition.

On Linux, the backend sends the standard `_NET_WM_STATE_FULLSCREEN` EWMH client
message. `isFullscreen` reports the successfully submitted request, not a
synchronous acknowledgement from the window manager. Desktop policy determines
the eventual native geometry.

The Windows GDI presenter now derives bitmap dimensions and stride from the
actual submitted canvas, including canvases larger than the logical window.
Its smoothing option selects HALFTONE when scaling; OpenGL/WGL remains the
preferred automatic presentation path when available.

`tests/platform_display_tests.ml` verifies invalid-window guards and Linux
left/right modifier aggregation. Its Windows branch checks the high-resolution
bitmap layout. Interactive monitor transitions, focus and device behavior
must additionally be exercised on the target desktop.

## Additional music-bus voices

`AudioMixer.musicLayers` provides eight dedicated voices alongside the existing
base music voice. Queue a layer with
`queueMusicLayer(mixer,id,clip,volume=100,pan=0,cursor=0.0)`; IDs are 0–7 and
the cursor is expressed in source PCM frames. The operation validates and
prepares the clip before replacing a current voice. `stopMusicLayer(mixer,id)`
releases one voice; `stopAll` and `close` include every layer.

Layers use the music and master buses, not the effects bus, and effect-channel
stealing cannot replace them. Muted or zero-volume layers continue advancing,
preserving phase when faded back in. Use matching sample rates and loop lengths
and queue all layers at matching cursors before rendering the first block.
The application controls voice gains to change instrumentation; the mixer does
not infer gameplay state or synchronize incompatible compositions.

Queueing is a software operation suitable for offline PCM rendering. A live
client calls `ensureBackend` once after preparing the complete ensemble; all
voices feed the same output device and accumulator. Existing base music and
effect APIs retain their behavior.

`tests/audio_layers_tests.ml` verifies actual mixed PCM, music/effect bus
separation, pan, muted loop phase, effect-channel isolation, invalid replacement,
bounds and cleanup. The existing audio mixer tests remain relevant regression
coverage for the unchanged single-track path.
