# `src/minipixels/graphics/gpu.ml`

[Home](README.md) · [Files](Files.md)

Provides an experimental batched GPU scene canvas on Windows. CPU canvases remain valid texture sources; Linux reports the backend as unsupported.

Package: [`minipixels.graphics.gpu`](Package-minipixels-graphics-gpu-1856137742.md)

Reachable from entry: **no**

## Imports

- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)
- `minipixels/platform/windows.ml` as `win` → [src/minipixels/platform/windows.ml](File-src-minipixels-platform-windows-ml-1027159307.md)

## Declarations

<a id="global-global-minipixels-graphics-gpu-active-active-src-minipixels-graphics-gpu-ml-16527936"></a>
### active

```ml
active
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L56)

<a id="global-global-minipixels-graphics-gpu-activeheight-activeheight-src-minipixels-graphics-gpu-ml-2049333506"></a>
### activeHeight

```ml
activeHeight
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L59)

<a id="global-global-minipixels-graphics-gpu-activewidth-activewidth-src-minipixels-graphics-gpu-ml-1468791108"></a>
### activeWidth

```ml
activeWidth
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L58)

<a id="global-global-minipixels-graphics-gpu-activewindow-activewindow-src-minipixels-graphics-gpu-ml-810560864"></a>
### activeWindow

```ml
activeWindow
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L57)

<a id="function-function-minipixels-graphics-gpu-begin-function-begin-window-returns-bool-src-minipixels-graphics-gpu-ml-1898668671"></a>
### begin

```ml
function begin(window) returns bool
```

Starts one GPU scene frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | Window used to create the GPU canvas. |


**Returns:** True when the frame was started.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L260)

<a id="function-function-minipixels-graphics-gpu-create-function-create-window-width-height-vsync-src-minipixels-graphics-gpu-ml-504824184"></a>
### create

```ml
function create(window, width, height, vsync)
```

Creates the singleton GPU scene canvas for an OpenGL window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | Window opened with the opengl renderer. |
| `width` | `dynamic` | — | Logical scene width. |
| `height` | `dynamic` | — | Logical scene height. |
| `vsync` | `dynamic` | — | True to synchronize buffer swaps. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L241)

<a id="function-function-minipixels-graphics-gpu-drawcalls-function-drawcalls-returns-int-src-minipixels-graphics-gpu-ml-1474591396"></a>
### drawCalls

```ml
function drawCalls() returns int
```

Returns native draw calls recorded in the current frame.


**Returns:** Number of native batches submitted in the current frame.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L305)

<a id="function-function-minipixels-graphics-gpu-drawregion-function-drawregion-c-image-sx-sy-sw-sh-x-y-dw-dh-tint-src-minipixels-graphics-gpu-ml-1741238635"></a>
### drawRegion

```ml
function drawRegion(c, image, sx, sy, sw, sh, x, y, dw, dh, tint)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — |  |
| `image` | `dynamic` | — |  |
| `sx` | `dynamic` | — |  |
| `sy` | `dynamic` | — |  |
| `sw` | `dynamic` | — |  |
| `sh` | `dynamic` | — |  |
| `x` | `dynamic` | — |  |
| `y` | `dynamic` | — |  |
| `dw` | `dynamic` | — |  |
| `dh` | `dynamic` | — |  |
| `tint` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L102)

<a id="function-function-minipixels-graphics-gpu-finish-function-finish-window-returns-bool-src-minipixels-graphics-gpu-ml-532089685"></a>
### finish

```ml
function finish(window) returns bool
```

Resolves the GPU scene into the window backbuffer; call window present afterwards.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | Window used to create the GPU canvas. |


**Returns:** True when the scene was resolved.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L270)

- [minipixels.graphics.gpu.GpuCanvas](Type-minipixels-graphics-gpu-gpucanvas-1207336338.md) — struct
<a id="function-function-minipixels-graphics-gpu-invalidate-function-invalidate-image-src-minipixels-graphics-gpu-ml-1250890709"></a>
### invalidate

```ml
function invalidate(image)
```

Uploads changed pixels for an image that has already been drawn by the GPU canvas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — | Mutable CPU image whose backing storage is unchanged. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L97)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpubegin-extern-function-mpgpubegin-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-611389443"></a>
### mpGpuBegin

```ml
extern function mpGpuBegin() from "minipixels_gpu.dll" returns void
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L22)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpucircle-extern-function-mpgpucircle-x-as-int-y-as-int-r-as-int-color-as-u32-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-19402144"></a>
### mpGpuCircle

```ml
extern function mpGpuCircle(x as int, y as int, r as int, color as u32) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — |  |
| `y` | `int` | — |  |
| `r` | `int` | — |  |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L42)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuclear-extern-function-mpgpuclear-color-as-u32-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-170915038"></a>
### mpGpuClear

```ml
extern function mpGpuClear(color as u32) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L24)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpudrawcalls-extern-function-mpgpudrawcalls-from-minipixels-gpu-dll-returns-u64-src-minipixels-graphics-gpu-ml-1954379670"></a>
### mpGpuDrawCalls

```ml
extern function mpGpuDrawCalls() from "minipixels_gpu.dll" returns u64
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L52)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuend-extern-function-mpgpuend-cw-as-int-ch-as-int-x-as-int-y-as-int-w-as-int-h-as-int-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-1782294114"></a>
### mpGpuEnd

```ml
extern function mpGpuEnd(cw as int, ch as int, x as int, y as int, w as int, h as int) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cw` | `int` | — |  |
| `ch` | `int` | — |  |
| `x` | `int` | — |  |
| `y` | `int` | — |  |
| `w` | `int` | — |  |
| `h` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L26)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuinfo-extern-function-mpgpuinfo-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-1574839371"></a>
### mpGpuInfo

```ml
extern function mpGpuInfo() from "minipixels_gpu.dll" returns void
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L20)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuinit-extern-function-mpgpuinit-w-as-int-h-as-int-from-minipixels-gpu-dll-returns-i32-src-minipixels-graphics-gpu-ml-736305856"></a>
### mpGpuInit

```ml
extern function mpGpuInit(w as int, h as int) from "minipixels_gpu.dll" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `int` | — |  |
| `h` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L14)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpulight-extern-function-mpgpulight-cx-as-int-cy-as-int-rx-as-int-ry-as-int-r-as-int-g-as-int-b-as-int-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-541289793"></a>
### mpGpuLight

```ml
extern function mpGpuLight(cx as int, cy as int, rx as int, ry as int, r as int, g as int, b as int) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cx` | `int` | — |  |
| `cy` | `int` | — |  |
| `rx` | `int` | — |  |
| `ry` | `int` | — |  |
| `r` | `int` | — |  |
| `g` | `int` | — |  |
| `b` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L46)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpulightready-extern-function-mpgpulightready-from-minipixels-gpu-dll-returns-i32-src-minipixels-graphics-gpu-ml-1008026323"></a>
### mpGpuLightReady

```ml
extern function mpGpuLightReady() from "minipixels_gpu.dll" returns i32
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L44)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuline-extern-function-mpgpuline-x0-as-int-y0-as-int-x1-as-int-y1-as-int-color-as-u32-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-1653694152"></a>
### mpGpuLine

```ml
extern function mpGpuLine(x0 as int, y0 as int, x1 as int, y1 as int, color as u32) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x0` | `int` | — |  |
| `y0` | `int` | — |  |
| `x1` | `int` | — |  |
| `y1` | `int` | — |  |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L40)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuread-extern-function-mpgpuread-pixels-as-bytes-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-1504816721"></a>
### mpGpuRead

```ml
extern function mpGpuRead(pixels as bytes) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `bytes` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L48)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpurect-extern-function-mpgpurect-x-as-int-y-as-int-w-as-int-h-as-int-color-as-u32-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-107871136"></a>
### mpGpuRect

```ml
extern function mpGpuRect(x as int, y as int, w as int, h as int, color as u32) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — |  |
| `y` | `int` | — |  |
| `w` | `int` | — |  |
| `h` | `int` | — |  |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L38)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuresettextures-extern-function-mpgpuresettextures-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-635899591"></a>
### mpGpuResetTextures

```ml
extern function mpGpuResetTextures() from "minipixels_gpu.dll" returns void
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L32)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuresize-extern-function-mpgpuresize-w-as-int-h-as-int-from-minipixels-gpu-dll-returns-i32-src-minipixels-graphics-gpu-ml-285297196"></a>
### mpGpuResize

```ml
extern function mpGpuResize(w as int, h as int) from "minipixels_gpu.dll" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `int` | — |  |
| `h` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L16)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpushutdown-extern-function-mpgpushutdown-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-566401403"></a>
### mpGpuShutdown

```ml
extern function mpGpuShutdown() from "minipixels_gpu.dll" returns void
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L34)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpusprite-extern-function-mpgpusprite-id-as-int-iw-as-int-ih-as-int-sx-as-int-sy-as-int-sw-as-int-sh-as-int-x-as-int-y-as-int-dw-as-int-dh-as-int-color-as-u32-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-371122403"></a>
### mpGpuSprite

```ml
extern function mpGpuSprite(id as int, iw as int, ih as int, sx as int, sy as int, sw as int, sh as int, x as int, y as int, dw as int, dh as int, color as u32) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `int` | — |  |
| `iw` | `int` | — |  |
| `ih` | `int` | — |  |
| `sx` | `int` | — |  |
| `sy` | `int` | — |  |
| `sw` | `int` | — |  |
| `sh` | `int` | — |  |
| `x` | `int` | — |  |
| `y` | `int` | — |  |
| `dw` | `int` | — |  |
| `dh` | `int` | — |  |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L36)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuswap-extern-function-mpgpuswap-interval-as-int-from-minipixels-gpu-dll-returns-i32-src-minipixels-graphics-gpu-ml-341009863"></a>
### mpGpuSwap

```ml
extern function mpGpuSwap(interval as int) from "minipixels_gpu.dll" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interval` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L18)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgputexture-extern-function-mpgputexture-pixels-as-bytes-w-as-int-h-as-int-opaque-as-bool-from-minipixels-gpu-dll-returns-i32-src-minipixels-graphics-gpu-ml-1700070317"></a>
### mpGpuTexture

```ml
extern function mpGpuTexture(pixels as bytes, w as int, h as int, opaque as bool) from "minipixels_gpu.dll" returns i32
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `bytes` | — |  |
| `w` | `int` | — |  |
| `h` | `int` | — |  |
| `opaque` | `bool` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L28)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuupdate-extern-function-mpgpuupdate-pixels-as-bytes-w-as-int-h-as-int-opaque-as-bool-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-gpu-ml-285461273"></a>
### mpGpuUpdate

```ml
extern function mpGpuUpdate(pixels as bytes, w as int, h as int, opaque as bool) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `bytes` | — |  |
| `w` | `int` | — |  |
| `h` | `int` | — |  |
| `opaque` | `bool` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L30)

<a id="extern_function-extern-function-minipixels-graphics-gpu-mpgpuuploads-extern-function-mpgpuuploads-from-minipixels-gpu-dll-returns-u64-src-minipixels-graphics-gpu-ml-916231648"></a>
### mpGpuUploads

```ml
extern function mpGpuUploads() from "minipixels_gpu.dll" returns u64
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L50)

<a id="function-function-minipixels-graphics-gpu-printinfo-function-printinfo-src-minipixels-graphics-gpu-ml-664747454"></a>
### printInfo

```ml
function printInfo()
```

Prints the current OpenGL device information to standard output.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L292)

<a id="function-function-minipixels-graphics-gpu-readback-function-readback-destination-returns-bool-src-minipixels-graphics-gpu-ml-1042282877"></a>
### readback

```ml
function readback(destination) returns bool
```

Copies the scene into an equally sized CPU canvas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | CPU canvas that receives straight RGBA pixels. |


**Returns:** True when the dimensions match and the pixels were copied.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L279)

<a id="function-function-minipixels-graphics-gpu-resettextures-function-resettextures-src-minipixels-graphics-gpu-ml-2066754726"></a>
### resetTextures

```ml
function resetTextures()
```

Releases every cached GPU texture while keeping the scene canvas active.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L68)

<a id="global-global-minipixels-graphics-gpu-retained-retained-src-minipixels-graphics-gpu-ml-1547520812"></a>
### retained

```ml
retained
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L54)

<a id="global-global-minipixels-graphics-gpu-retainedcount-retainedcount-src-minipixels-graphics-gpu-ml-1714485196"></a>
### retainedCount

```ml
retainedCount
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L55)

<a id="function-function-minipixels-graphics-gpu-shutdown-function-shutdown-src-minipixels-graphics-gpu-ml-959613120"></a>
### shutdown

```ml
function shutdown()
```

Releases the GPU scene canvas and its cached textures.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L311)

<a id="function-function-minipixels-graphics-gpu-supported-function-supported-returns-bool-src-minipixels-graphics-gpu-ml-2140388001"></a>
### supported

```ml
function supported() returns bool
```

Reports whether this target supports the optional GPU scene runtime.


**Returns:** True on Windows; the DLL and sufficient OpenGL support are still required.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L63)

<a id="function-function-minipixels-graphics-gpu-texture-function-texture-image-src-minipixels-graphics-gpu-ml-1711808915"></a>
### texture

```ml
function texture(image)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L77)

<a id="function-function-minipixels-graphics-gpu-uploadbytes-function-uploadbytes-returns-int-src-minipixels-graphics-gpu-ml-348491374"></a>
### uploadBytes

```ml
function uploadBytes() returns int
```

Returns texture upload bytes recorded in the current frame.


**Returns:** Number of source bytes uploaded in the current frame.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L298)
