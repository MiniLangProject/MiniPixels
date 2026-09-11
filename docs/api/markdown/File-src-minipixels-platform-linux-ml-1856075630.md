# `src/minipixels/platform/linux.ml`

[Home](README.md) · [Files](Files.md)

Provides the native X11 platform backend for MiniPixels on Linux x64.

Package: [`minipixels.platform.linux`](Package-minipixels-platform-linux-1505480356.md)

Reachable from entry: **no**

## Imports

- `minipixels/input/input.ml` as `inp` → [src/minipixels/input/input.ml](File-src-minipixels-input-input-ml-1476207415.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)
- `std/time.ml` as `time` → `../MiniLangCompilerML/std/time.ml` — external dependency

## Declarations

<a id="constant-constant-minipixels-platform-linux-button-press-const-button-press-4-src-minipixels-platform-linux-ml-1195450015"></a>
### BUTTON_PRESS

```ml
const BUTTON_PRESS = 4
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L69)

<a id="constant-constant-minipixels-platform-linux-button-press-mask-const-button-press-mask-4-src-minipixels-platform-linux-ml-1534172021"></a>
### BUTTON_PRESS_MASK

```ml
const BUTTON_PRESS_MASK = 4
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L83)

<a id="constant-constant-minipixels-platform-linux-button-release-const-button-release-5-src-minipixels-platform-linux-ml-1988003638"></a>
### BUTTON_RELEASE

```ml
const BUTTON_RELEASE = 5
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L70)

<a id="constant-constant-minipixels-platform-linux-button-release-mask-const-button-release-mask-8-src-minipixels-platform-linux-ml-964860741"></a>
### BUTTON_RELEASE_MASK

```ml
const BUTTON_RELEASE_MASK = 8
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L84)

<a id="function-function-minipixels-platform-linux-clearkeystates-function-clearkeystates-w-src-minipixels-platform-linux-ml-1514843137"></a>
### clearKeyStates

```ml
function clearKeyStates(w)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L295)

<a id="constant-constant-minipixels-platform-linux-client-message-const-client-message-33-src-minipixels-platform-linux-ml-942536031"></a>
### CLIENT_MESSAGE

```ml
const CLIENT_MESSAGE = 33
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L79)

<a id="function-function-minipixels-platform-linux-clientheight-function-clientheight-w-src-minipixels-platform-linux-ml-139569905"></a>
### clientHeight

```ml
function clientHeight(w)
```

Returns the current native client height.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L384)

<a id="function-function-minipixels-platform-linux-clientwidth-function-clientwidth-w-src-minipixels-platform-linux-ml-1541008415"></a>
### clientWidth

```ml
function clientWidth(w)
```

Returns the current native client width.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L377)

<a id="function-function-minipixels-platform-linux-close-function-close-w-src-minipixels-platform-linux-ml-1037820029"></a>
### close

```ml
function close(w)
```

Releases one X11 window and its native resources.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to close. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L214)

<a id="constant-constant-minipixels-platform-linux-configure-notify-const-configure-notify-22-src-minipixels-platform-linux-ml-1996509491"></a>
### CONFIGURE_NOTIFY

```ml
const CONFIGURE_NOTIFY = 22
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L78)

<a id="function-function-minipixels-platform-linux-convertnativeregion-function-convertnativeregion-w-canvas-x0-y0-x1-y1-src-minipixels-platform-linux-ml-1909208729"></a>
### convertNativeRegion

```ml
function convertNativeRegion(w, canvas, x0, y0, x1, y1)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `canvas` | `dynamic` | — |  |
| `x0` | `dynamic` | — |  |
| `y0` | `dynamic` | — |  |
| `x1` | `dynamic` | — |  |
| `y1` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L487)

<a id="constant-constant-minipixels-platform-linux-destroy-notify-const-destroy-notify-17-src-minipixels-platform-linux-ml-369994039"></a>
### DESTROY_NOTIFY

```ml
const DESTROY_NOTIFY = 17
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L77)

<a id="function-function-minipixels-platform-linux-ensureimage-function-ensureimage-w-src-minipixels-platform-linux-ml-902793707"></a>
### ensureImage

```ml
function ensureImage(w)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L476)

<a id="constant-constant-minipixels-platform-linux-enter-notify-const-enter-notify-7-src-minipixels-platform-linux-ml-826901888"></a>
### ENTER_NOTIFY

```ml
const ENTER_NOTIFY = 7
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L72)

<a id="constant-constant-minipixels-platform-linux-enter-window-mask-const-enter-window-mask-16-src-minipixels-platform-linux-ml-151175312"></a>
### ENTER_WINDOW_MASK

```ml
const ENTER_WINDOW_MASK = 16
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L85)

<a id="constant-constant-minipixels-platform-linux-expose-const-expose-12-src-minipixels-platform-linux-ml-97557590"></a>
### EXPOSE

```ml
const EXPOSE = 12
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L76)

<a id="constant-constant-minipixels-platform-linux-exposure-mask-const-exposure-mask-32768-src-minipixels-platform-linux-ml-7648341"></a>
### EXPOSURE_MASK

```ml
const EXPOSURE_MASK = 32768
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L90)

<a id="constant-constant-minipixels-platform-linux-focus-change-mask-const-focus-change-mask-2097152-src-minipixels-platform-linux-ml-1025755099"></a>
### FOCUS_CHANGE_MASK

```ml
const FOCUS_CHANGE_MASK = 2097152
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L89)

<a id="constant-constant-minipixels-platform-linux-focus-in-const-focus-in-9-src-minipixels-platform-linux-ml-1845542310"></a>
### FOCUS_IN

```ml
const FOCUS_IN = 9
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L74)

<a id="constant-constant-minipixels-platform-linux-focus-out-const-focus-out-10-src-minipixels-platform-linux-ml-983875378"></a>
### FOCUS_OUT

```ml
const FOCUS_OUT = 10
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L75)

<a id="function-function-minipixels-platform-linux-geti32-function-geti32-buffer-offset-src-minipixels-platform-linux-ml-1839484605"></a>
### getI32

```ml
function getI32(buffer, offset)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L132)

<a id="function-function-minipixels-platform-linux-getu32-function-getu32-buffer-offset-src-minipixels-platform-linux-ml-1087970109"></a>
### getU32

```ml
function getU32(buffer, offset)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L127)

<a id="function-function-minipixels-platform-linux-getu64-function-getu64-buffer-offset-src-minipixels-platform-linux-ml-1270060673"></a>
### getU64

```ml
function getU64(buffer, offset)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L139)

<a id="function-function-minipixels-platform-linux-hasfocus-function-hasfocus-w-src-minipixels-platform-linux-ml-32365145"></a>
### hasFocus

```ml
function hasFocus(w)
```

Returns whether the window currently owns keyboard focus.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L370)

<a id="function-function-minipixels-platform-linux-isgpurenderer-function-isgpurenderer-w-src-minipixels-platform-linux-ml-278633347"></a>
### isGpuRenderer

```ml
function isGpuRenderer(w)
```

Returns whether the active Linux presenter is GPU-accelerated.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L244)

<a id="constant-constant-minipixels-platform-linux-key-press-const-key-press-2-src-minipixels-platform-linux-ml-1202460127"></a>
### KEY_PRESS

```ml
const KEY_PRESS = 2
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L67)

<a id="constant-constant-minipixels-platform-linux-key-press-mask-const-key-press-mask-1-src-minipixels-platform-linux-ml-1549245534"></a>
### KEY_PRESS_MASK

```ml
const KEY_PRESS_MASK = 1
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L81)

<a id="constant-constant-minipixels-platform-linux-key-release-const-key-release-3-src-minipixels-platform-linux-ml-1613803594"></a>
### KEY_RELEASE

```ml
const KEY_RELEASE = 3
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L68)

<a id="constant-constant-minipixels-platform-linux-key-release-mask-const-key-release-mask-2-src-minipixels-platform-linux-ml-648896877"></a>
### KEY_RELEASE_MASK

```ml
const KEY_RELEASE_MASK = 2
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L82)

<a id="function-function-minipixels-platform-linux-keysymtovirtualkey-function-keysymtovirtualkey-sym-src-minipixels-platform-linux-ml-656400771"></a>
### keysymToVirtualKey

```ml
function keysymToVirtualKey(sym)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sym` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L265)

<a id="constant-constant-minipixels-platform-linux-leave-notify-const-leave-notify-8-src-minipixels-platform-linux-ml-2071650097"></a>
### LEAVE_NOTIFY

```ml
const LEAVE_NOTIFY = 8
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L73)

<a id="constant-constant-minipixels-platform-linux-leave-window-mask-const-leave-window-mask-32-src-minipixels-platform-linux-ml-1920579090"></a>
### LEAVE_WINDOW_MASK

```ml
const LEAVE_WINDOW_MASK = 32
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L86)

<a id="constant-constant-minipixels-platform-linux-motion-notify-const-motion-notify-6-src-minipixels-platform-linux-ml-1007878915"></a>
### MOTION_NOTIFY

```ml
const MOTION_NOTIFY = 6
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L71)

<a id="extern_function-extern-function-minipixels-platform-linux-mppixelsrgbatobgra-extern-function-mppixelsrgbatobgra-destination-as-bytes-destinationoffset-as-u64-source-as-bytes-sourceoffset-as-u64-pixelcount-as-int-from-libminipixels-audio-so-returns-void-src-minipixels-platform-linux-ml-1957117957"></a>
### mpPixelsRgbaToBgra

```ml
extern function mpPixelsRgbaToBgra(destination as bytes, destinationOffset as u64, source as bytes, sourceOffset as u64, pixelCount as int) from "./libminipixels_audio.so" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `bytes` | — |  |
| `destinationOffset` | `u64` | — |  |
| `source` | `bytes` | — |  |
| `sourceOffset` | `u64` | — |  |
| `pixelCount` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L12)

<a id="extern_function-extern-function-minipixels-platform-linux-mppixelsscaleintegerbgra-extern-function-mppixelsscaleintegerbgra-destination-as-bytes-destinationwidth-as-int-destinationheight-as-int-source-as-bytes-sourcewidth-as-int-sourceheight-as-int-viewportx-as-int-viewporty-as-int-factor-as-int-from-libminipixels-audio-so-returns-i32-src-minipixels-platform-linux-ml-27949279"></a>
### mpPixelsScaleIntegerBgra

```ml
extern function mpPixelsScaleIntegerBgra(destination as bytes, destinationWidth as int, destinationHeight as int, source as bytes, sourceWidth as int, sourceHeight as int, viewportX as int, viewportY as int, factor as int) from "./libminipixels_audio.so" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `bytes` | — |  |
| `destinationWidth` | `int` | — |  |
| `destinationHeight` | `int` | — |  |
| `source` | `bytes` | — |  |
| `sourceWidth` | `int` | — |  |
| `sourceHeight` | `int` | — |  |
| `viewportX` | `int` | — |  |
| `viewportY` | `int` | — |  |
| `factor` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L14)

<a id="extern_function-extern-function-minipixels-platform-linux-mppixelsscalenearestbgra-extern-function-mppixelsscalenearestbgra-destination-as-bytes-destinationwidth-as-int-destinationheight-as-int-source-as-bytes-sourcewidth-as-int-sourceheight-as-int-viewportx-as-int-viewporty-as-int-viewportwidth-as-int-viewportheight-as-int-from-libminipixels-audio-so-returns-i32-src-minipixels-platform-linux-ml-390237396"></a>
### mpPixelsScaleNearestBgra

```ml
extern function mpPixelsScaleNearestBgra(destination as bytes, destinationWidth as int, destinationHeight as int, source as bytes, sourceWidth as int, sourceHeight as int, viewportX as int, viewportY as int, viewportWidth as int, viewportHeight as int) from "./libminipixels_audio.so" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `bytes` | — |  |
| `destinationWidth` | `int` | — |  |
| `destinationHeight` | `int` | — |  |
| `source` | `bytes` | — |  |
| `sourceWidth` | `int` | — |  |
| `sourceHeight` | `int` | — |  |
| `viewportX` | `int` | — |  |
| `viewportY` | `int` | — |  |
| `viewportWidth` | `int` | — |  |
| `viewportHeight` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L16)

<a id="function-function-minipixels-platform-linux-normalizescalemode-function-normalizescalemode-value-src-minipixels-platform-linux-ml-1970083533"></a>
### normalizeScaleMode

```ml
function normalizeScaleMode(value)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L151)

<a id="function-function-minipixels-platform-linux-open-function-open-title-width-height-scale-renderer-scalemode-smoothing-src-minipixels-platform-linux-ml-979195075"></a>
### open

```ml
function open(title, width, height, scale, renderer, scaleMode, smoothing)
```

Opens an X11 window. Linux currently uses the CPU XImage presenter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable window title. |
| `width` | `dynamic` | — | Logical framebuffer width. |
| `height` | `dynamic` | — | Logical framebuffer height. |
| `scale` | `dynamic` | — | Initial integer window scale. |
| `renderer` | `dynamic` | — | Requested renderer name. |
| `scaleMode` | `dynamic` | — | Stretch, fit, or integer presentation mode. |
| `smoothing` | `dynamic` | — | Smoothing preference retained for renderer compatibility. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L165)

<a id="constant-constant-minipixels-platform-linux-pointer-motion-mask-const-pointer-motion-mask-64-src-minipixels-platform-linux-ml-1959507439"></a>
### POINTER_MOTION_MASK

```ml
const POINTER_MOTION_MASK = 64
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L87)

<a id="function-function-minipixels-platform-linux-pollevents-function-pollevents-w-src-minipixels-platform-linux-ml-1310229189"></a>
### pollEvents

```ml
function pollEvents(w)
```

Drains pending X11 events into retained window state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window whose event queue is polled. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L360)

<a id="function-function-minipixels-platform-linux-present-function-present-w-canvas-src-minipixels-platform-linux-ml-200856739"></a>
### present

```ml
function present(w, canvas)
```

Scales and presents an RGBA canvas through an X11 XImage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Destination window. |
| `canvas` | `dynamic` | — | Source logical framebuffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L511)

<a id="function-function-minipixels-platform-linux-processevent-function-processevent-w-src-minipixels-platform-linux-ml-1603153957"></a>
### processEvent

```ml
function processEvent(w)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L302)

<a id="function-function-minipixels-platform-linux-putu64-function-putu64-buffer-offset-value-src-minipixels-platform-linux-ml-1316549622"></a>
### putU64

```ml
function putU64(buffer, offset, value)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |
| `value` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L144)

<a id="function-function-minipixels-platform-linux-rendererfallbackreason-function-rendererfallbackreason-w-src-minipixels-platform-linux-ml-373066441"></a>
### rendererFallbackReason

```ml
function rendererFallbackReason(w)
```

Returns the renderer fallback reason, if any.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L250)

<a id="function-function-minipixels-platform-linux-renderername-function-renderername-w-src-minipixels-platform-linux-ml-430412433"></a>
### rendererName

```ml
function rendererName(w)
```

Returns the active native renderer name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L237)

<a id="function-function-minipixels-platform-linux-running-function-running-src-minipixels-platform-linux-ml-2002804818"></a>
### running

```ml
function running()
```

Returns whether the active Linux window remains open.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L207)

<a id="function-function-minipixels-platform-linux-scalegeneric-function-scalegeneric-w-canvas-vx-vy-vw-vh-src-minipixels-platform-linux-ml-1368856059"></a>
### scaleGeneric

```ml
function scaleGeneric(w, canvas, vx, vy, vw, vh)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `canvas` | `dynamic` | — |  |
| `vx` | `dynamic` | — |  |
| `vy` | `dynamic` | — |  |
| `vw` | `dynamic` | — |  |
| `vh` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L504)

<a id="function-function-minipixels-platform-linux-scaleinteger-function-scaleinteger-w-canvas-vx-vy-factor-src-minipixels-platform-linux-ml-2141798853"></a>
### scaleInteger

```ml
function scaleInteger(w, canvas, vx, vy, factor)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `canvas` | `dynamic` | — |  |
| `vx` | `dynamic` | — |  |
| `vy` | `dynamic` | — |  |
| `factor` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L496)

<a id="function-function-minipixels-platform-linux-seconds-function-seconds-src-minipixels-platform-linux-ml-1074978038"></a>
### seconds

```ml
function seconds()
```

Returns monotonic time in fractional seconds.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L562)

<a id="function-function-minipixels-platform-linux-setkeystate-function-setkeystate-w-virtualkey-down-src-minipixels-platform-linux-ml-65846199"></a>
### setKeyState

```ml
function setKeyState(w, virtualKey, down)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `virtualKey` | `dynamic` | — |  |
| `down` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L290)

<a id="function-function-minipixels-platform-linux-setrendersize-function-setrendersize-w-width-height-src-minipixels-platform-linux-ml-1030483646"></a>
### setRenderSize

```ml
function setRenderSize(w, width, height)
```

Updates the logical source size used by presentation and pointer mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to update. |
| `width` | `dynamic` | — | New framebuffer width. |
| `height` | `dynamic` | — | New framebuffer height. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L393)

<a id="function-function-minipixels-platform-linux-settitle-function-settitle-w-title-src-minipixels-platform-linux-ml-1668393081"></a>
### setTitle

```ml
function setTitle(w, title)
```

Updates the native window title.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to update. |
| `title` | `dynamic` | — | New human-readable title. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L258)

<a id="function-function-minipixels-platform-linux-sleepms-function-sleepms-ms-src-minipixels-platform-linux-ml-209195542"></a>
### sleepMs

```ml
function sleepMs(ms)
```

Sleeps for a number of milliseconds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ms` | `dynamic` | — | Milliseconds to sleep. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L579)

<a id="constant-constant-minipixels-platform-linux-structure-notify-mask-const-structure-notify-mask-131072-src-minipixels-platform-linux-ml-1485325941"></a>
### STRUCTURE_NOTIFY_MASK

```ml
const STRUCTURE_NOTIFY_MASK = 131072
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L88)

<a id="function-function-minipixels-platform-linux-ticks-function-ticks-src-minipixels-platform-linux-ml-506196644"></a>
### ticks

```ml
function ticks()
```

Returns monotonic milliseconds since system start.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L557)

<a id="function-function-minipixels-platform-linux-updateinput-function-updateinput-input-src-minipixels-platform-linux-ml-1889085674"></a>
### updateInput

```ml
function updateInput(input)
```

Clears platform input for callers without an active window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | Destination input state. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L442)

<a id="function-function-minipixels-platform-linux-updateinputforwindow-function-updateinputforwindow-w-input-src-minipixels-platform-linux-ml-310592467"></a>
### updateInputForWindow

```ml
function updateInputForWindow(w, input)
```

Publishes retained X11 keyboard and pointer state to an input frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Source window. |
| `input` | `dynamic` | — | Destination input state. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L407)

<a id="function-function-minipixels-platform-linux-viewport-function-viewport-w-logicalwidth-logicalheight-src-minipixels-platform-linux-ml-1080072856"></a>
### viewport

```ml
function viewport(w, logicalWidth, logicalHeight)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `logicalWidth` | `dynamic` | — |  |
| `logicalHeight` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L448)

<a id="function-function-minipixels-platform-linux-waituntil-function-waituntil-deadline-src-minipixels-platform-linux-ml-1619829530"></a>
### waitUntil

```ml
function waitUntil(deadline)
```

Waits until an absolute monotonic deadline.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `deadline` | `dynamic` | — | Absolute value previously returned by seconds(). |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L568)

- [minipixels.platform.linux.Window](Type-minipixels-platform-linux-window-788017826.md) — struct
<a id="global-global-minipixels-platform-linux-windowrunning-windowrunning-src-minipixels-platform-linux-ml-1764017184"></a>
### windowRunning

```ml
windowRunning
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L93)

<a id="extern_function-extern-function-minipixels-platform-linux-xblackpixel-extern-function-xblackpixel-display-as-ptr-screen-as-int-from-libx11-so-6-returns-u64-src-minipixels-platform-linux-ml-1041730539"></a>
### XBlackPixel

```ml
extern function XBlackPixel(display as ptr, screen as int) from "libX11.so.6" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `screen` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L25)

<a id="extern_function-extern-function-minipixels-platform-linux-xclosedisplay-extern-function-xclosedisplay-display-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-35061822"></a>
### XCloseDisplay

```ml
extern function XCloseDisplay(display as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L53)

<a id="extern_function-extern-function-minipixels-platform-linux-xcreategc-extern-function-xcreategc-display-as-ptr-drawable-as-u64-valuemask-as-u64-values-as-ptr-from-libx11-so-6-returns-ptr-src-minipixels-platform-linux-ml-117495002"></a>
### XCreateGC

```ml
extern function XCreateGC(display as ptr, drawable as u64, valueMask as u64, values as ptr) from "libX11.so.6" returns ptr
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `drawable` | `u64` | — |  |
| `valueMask` | `u64` | — |  |
| `values` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L47)

<a id="extern_function-extern-function-minipixels-platform-linux-xcreateimage-extern-function-xcreateimage-display-as-ptr-visual-as-ptr-depth-as-u32-format-as-int-offset-as-int-data-as-ptr-width-as-u32-height-as-u32-bitmappad-as-int-bytesperline-as-int-from-libx11-so-6-returns-ptr-src-minipixels-platform-linux-ml-1518647051"></a>
### XCreateImage

```ml
extern function XCreateImage(display as ptr, visual as ptr, depth as u32, format as int, offset as int, data as ptr, width as u32, height as u32, bitmapPad as int, bytesPerLine as int) from "libX11.so.6" returns ptr
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `visual` | `ptr` | — |  |
| `depth` | `u32` | — |  |
| `format` | `int` | — |  |
| `offset` | `int` | — |  |
| `data` | `ptr` | — |  |
| `width` | `u32` | — |  |
| `height` | `u32` | — |  |
| `bitmapPad` | `int` | — |  |
| `bytesPerLine` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L59)

<a id="extern_function-extern-function-minipixels-platform-linux-xcreatesimplewindow-extern-function-xcreatesimplewindow-display-as-ptr-parent-as-u64-x-as-int-y-as-int-width-as-u32-height-as-u32-borderwidth-as-u32-border-as-u64-background-as-u64-from-libx11-so-6-returns-u64-src-minipixels-platform-linux-ml-14236029"></a>
### XCreateSimpleWindow

```ml
extern function XCreateSimpleWindow(display as ptr, parent as u64, x as int, y as int, width as u32, height as u32, borderWidth as u32, border as u64, background as u64) from "libX11.so.6" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `parent` | `u64` | — |  |
| `x` | `int` | — |  |
| `y` | `int` | — |  |
| `width` | `u32` | — |  |
| `height` | `u32` | — |  |
| `borderWidth` | `u32` | — |  |
| `border` | `u64` | — |  |
| `background` | `u64` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L31)

<a id="extern_function-extern-function-minipixels-platform-linux-xdefaultdepth-extern-function-xdefaultdepth-display-as-ptr-screen-as-int-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-706125995"></a>
### XDefaultDepth

```ml
extern function XDefaultDepth(display as ptr, screen as int) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `screen` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L29)

<a id="extern_function-extern-function-minipixels-platform-linux-xdefaultscreen-extern-function-xdefaultscreen-display-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-1061433872"></a>
### XDefaultScreen

```ml
extern function XDefaultScreen(display as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L21)

<a id="extern_function-extern-function-minipixels-platform-linux-xdefaultvisual-extern-function-xdefaultvisual-display-as-ptr-screen-as-int-from-libx11-so-6-returns-ptr-src-minipixels-platform-linux-ml-1046546956"></a>
### XDefaultVisual

```ml
extern function XDefaultVisual(display as ptr, screen as int) from "libX11.so.6" returns ptr
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `screen` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L27)

<a id="extern_function-extern-function-minipixels-platform-linux-xdestroywindow-extern-function-xdestroywindow-display-as-ptr-window-as-u64-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-654367571"></a>
### XDestroyWindow

```ml
extern function XDestroyWindow(display as ptr, window as u64) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `window` | `u64` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L51)

<a id="extern_function-extern-function-minipixels-platform-linux-xflush-extern-function-xflush-display-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-1900050106"></a>
### XFlush

```ml
extern function XFlush(display as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L39)

<a id="extern_function-extern-function-minipixels-platform-linux-xfree-extern-function-xfree-value-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-1871282601"></a>
### XFree

```ml
extern function XFree(value as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L63)

<a id="extern_function-extern-function-minipixels-platform-linux-xfreegc-extern-function-xfreegc-display-as-ptr-gc-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-69301160"></a>
### XFreeGC

```ml
extern function XFreeGC(display as ptr, gc as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `gc` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L49)

<a id="extern_function-extern-function-minipixels-platform-linux-xinternatom-extern-function-xinternatom-display-as-ptr-name-as-cstr-onlyifexists-as-bool-from-libx11-so-6-returns-u64-src-minipixels-platform-linux-ml-1920564912"></a>
### XInternAtom

```ml
extern function XInternAtom(display as ptr, name as cstr, onlyIfExists as bool) from "libX11.so.6" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `name` | `cstr` | — |  |
| `onlyIfExists` | `bool` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L55)

<a id="extern_function-extern-function-minipixels-platform-linux-xkbsetdetectableautorepeat-extern-function-xkbsetdetectableautorepeat-display-as-ptr-detectable-as-bool-supported-as-bytes-from-libx11-so-6-returns-bool-src-minipixels-platform-linux-ml-903723159"></a>
### XkbSetDetectableAutoRepeat

```ml
extern function XkbSetDetectableAutoRepeat(display as ptr, detectable as bool, supported as bytes) from "libX11.so.6" returns bool
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `detectable` | `bool` | — |  |
| `supported` | `bytes` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L65)

<a id="extern_function-extern-function-minipixels-platform-linux-xlookupkeysym-extern-function-xlookupkeysym-event-as-bytes-index-as-int-from-libx11-so-6-returns-u64-src-minipixels-platform-linux-ml-1974637692"></a>
### XLookupKeysym

```ml
extern function XLookupKeysym(event as bytes, index as int) from "libX11.so.6" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `bytes` | — |  |
| `index` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L45)

<a id="extern_function-extern-function-minipixels-platform-linux-xmapwindow-extern-function-xmapwindow-display-as-ptr-window-as-u64-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-819059179"></a>
### XMapWindow

```ml
extern function XMapWindow(display as ptr, window as u64) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `window` | `u64` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L37)

<a id="extern_function-extern-function-minipixels-platform-linux-xnextevent-extern-function-xnextevent-display-as-ptr-event-as-bytes-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-836074105"></a>
### XNextEvent

```ml
extern function XNextEvent(display as ptr, event as bytes) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `event` | `bytes` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L43)

<a id="extern_function-extern-function-minipixels-platform-linux-xopendisplay-extern-function-xopendisplay-name-as-ptr-from-libx11-so-6-returns-ptr-src-minipixels-platform-linux-ml-48009832"></a>
### XOpenDisplay

```ml
extern function XOpenDisplay(name as ptr) from "libX11.so.6" returns ptr
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L19)

<a id="extern_function-extern-function-minipixels-platform-linux-xpending-extern-function-xpending-display-as-ptr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-568001812"></a>
### XPending

```ml
extern function XPending(display as ptr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L41)

<a id="extern_function-extern-function-minipixels-platform-linux-xputimage-extern-function-xputimage-display-as-ptr-drawable-as-u64-gc-as-ptr-image-as-ptr-srcx-as-int-srcy-as-int-destx-as-int-desty-as-int-width-as-u32-height-as-u32-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-1876968185"></a>
### XPutImage

```ml
extern function XPutImage(display as ptr, drawable as u64, gc as ptr, image as ptr, srcX as int, srcY as int, destX as int, destY as int, width as u32, height as u32) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `drawable` | `u64` | — |  |
| `gc` | `ptr` | — |  |
| `image` | `ptr` | — |  |
| `srcX` | `int` | — |  |
| `srcY` | `int` | — |  |
| `destX` | `int` | — |  |
| `destY` | `int` | — |  |
| `width` | `u32` | — |  |
| `height` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L61)

<a id="extern_function-extern-function-minipixels-platform-linux-xrootwindow-extern-function-xrootwindow-display-as-ptr-screen-as-int-from-libx11-so-6-returns-u64-src-minipixels-platform-linux-ml-546410095"></a>
### XRootWindow

```ml
extern function XRootWindow(display as ptr, screen as int) from "libX11.so.6" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `screen` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L23)

<a id="extern_function-extern-function-minipixels-platform-linux-xselectinput-extern-function-xselectinput-display-as-ptr-window-as-u64-eventmask-as-i64-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-1896181988"></a>
### XSelectInput

```ml
extern function XSelectInput(display as ptr, window as u64, eventMask as i64) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `window` | `u64` | — |  |
| `eventMask` | `i64` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L35)

<a id="extern_function-extern-function-minipixels-platform-linux-xsetwmprotocols-extern-function-xsetwmprotocols-display-as-ptr-window-as-u64-protocols-as-bytes-count-as-int-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-603644667"></a>
### XSetWMProtocols

```ml
extern function XSetWMProtocols(display as ptr, window as u64, protocols as bytes, count as int) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `window` | `u64` | — |  |
| `protocols` | `bytes` | — |  |
| `count` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L57)

<a id="extern_function-extern-function-minipixels-platform-linux-xstorename-extern-function-xstorename-display-as-ptr-window-as-u64-title-as-cstr-from-libx11-so-6-returns-int-src-minipixels-platform-linux-ml-848429769"></a>
### XStoreName

```ml
extern function XStoreName(display as ptr, window as u64, title as cstr) from "libX11.so.6" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `display` | `ptr` | — |  |
| `window` | `u64` | — |  |
| `title` | `cstr` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L33)

<a id="constant-constant-minipixels-platform-linux-zpixmap-const-zpixmap-2-src-minipixels-platform-linux-ml-2110541303"></a>
### ZPIXMAP

```ml
const ZPIXMAP = 2
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/linux.ml#L91)
