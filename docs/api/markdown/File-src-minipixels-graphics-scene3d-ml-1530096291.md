# `src/minipixels/graphics/scene3d.ml`

[Home](README.md) · [Files](Files.md)

Optional retained 3D pass. Coordinates are world X/Y and upward elevation Z. begin/finish share the GPU canvas; draw ordinary 2D UI only after finish.

Package: [`minipixels.graphics.scene3d`](Package-minipixels-graphics-scene3d-353711103.md)

Reachable from entry: **no**

## Declarations

<a id="function-function-minipixels-graphics-scene3d-begin-function-begin-camerax-cameray-zoom-centerx-centery-returns-bool-src-minipixels-graphics-scene3d-ml-70495686"></a>
### begin

```ml
function begin(cameraX, cameraY, zoom, centerX, centerY) returns bool
```

Starts a depth-tested isometric pass on the active GPU canvas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cameraX` | `dynamic` | — | Camera horizontal offset in pixels. |
| `cameraY` | `dynamic` | — | Camera vertical offset in pixels. |
| `zoom` | `dynamic` | — | Positive scene zoom, at most 64. |
| `centerX` | `dynamic` | — | Screen origin X in pixels. |
| `centerY` | `dynamic` | — | Screen origin Y in pixels. |


**Returns:** True when the pass starts; false if unavailable or invalid.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L35)

<a id="function-function-minipixels-graphics-scene3d-beginprojected-function-beginprojected-x-y-width-height-halfextent-returns-bool-src-minipixels-graphics-scene3d-ml-1381206914"></a>
### beginProjected

```ml
function beginProjected(x, y, width, height, halfExtent) returns bool
```

Composes a live orthographic model into a screen viewport. Colour is kept, depth starts clean, and the model's own camera-space normals stay intact.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Viewport left in screen pixels. |
| `y` | `dynamic` | — | Viewport top in screen pixels. |
| `width` | `dynamic` | — | Viewport width in pixels, 1 through 4096. |
| `height` | `dynamic` | — | Viewport height in pixels, 1 through 4096. |
| `halfExtent` | `dynamic` | — | Positive half extent of the model camera. |


**Returns:** True when the projected pass starts; false if unavailable or invalid.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L48)

<a id="function-function-minipixels-graphics-scene3d-box-function-box-x-y-z-sx-sy-sz-color-returns-bool-src-minipixels-graphics-scene3d-ml-567024415"></a>
### box

```ml
function box(x, y, z, sx, sy, sz, color) returns bool
```

Appends a solid box, shaded per face; nonpositive extents invalidate the build.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | World tile X origin. |
| `y` | `dynamic` | — | World tile Y origin. |
| `z` | `dynamic` | — | Upward elevation. |
| `sx` | `dynamic` | — | Positive width along world X. |
| `sy` | `dynamic` | — | Positive width along world Y. |
| `sz` | `dynamic` | — | Positive height along world Z. |
| `color` | `dynamic` | — | Packed RGBA face colour. |


**Returns:** True when valid geometry is appended.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L63)

<a id="function-function-minipixels-graphics-scene3d-draw-function-draw-handle-returns-bool-src-minipixels-graphics-scene3d-ml-1643208343"></a>
### draw

```ml
function draw(handle) returns bool
```

Draws resident geometry without uploading vertex data again.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Live mesh handle returned by meshEnd. |


**Returns:** True when the live mesh is drawn.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L70)

<a id="function-function-minipixels-graphics-scene3d-drawat-function-drawat-handle-x-y-z-yaw-0-sx-1-sy-1-sz-1-returns-bool-src-minipixels-graphics-scene3d-ml-111743870"></a>
### drawAt

```ml
function drawAt(handle, x, y, z, yaw = 0, sx = 1, sy = 1, sz = 1) returns bool
```

Reuses a mesh with a world transform; yaw rotates around upward Z.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Live mesh handle returned by meshEnd. |
| `x` | `dynamic` | — | World tile X translation. |
| `y` | `dynamic` | — | World tile Y translation. |
| `z` | `dynamic` | — | Upward elevation. |
| `yaw` | `dynamic` | `0` | Rotation in degrees around world Z. |
| `sx` | `dynamic` | `1` | Positive world X scale. |
| `sy` | `dynamic` | `1` | Positive world Y scale. |
| `sz` | `dynamic` | `1` | Positive world Z scale. |


**Returns:** True when the transformed mesh is drawn.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L81)

<a id="function-function-minipixels-graphics-scene3d-finish-function-finish-src-minipixels-graphics-scene3d-ml-805697962"></a>
### finish

```ml
function finish()
```

Restores 2D canvas state, including matrices, shader, buffers and target.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L39)

<a id="function-function-minipixels-graphics-scene3d-meshbegin-function-meshbegin-returns-bool-src-minipixels-graphics-scene3d-ml-1195999557"></a>
### meshBegin

```ml
function meshBegin() returns bool
```

Starts construction of one immutable GPU mesh. Builders cannot nest.


**Returns:** True when a new builder starts.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L53)

<a id="function-function-minipixels-graphics-scene3d-meshend-function-meshend-returns-int-src-minipixels-graphics-scene3d-ml-2092566256"></a>
### meshEnd

```ml
function meshEnd() returns int
```

Uploads the mesh once. Zero means invalid or empty geometry.


**Returns:** A positive mesh handle, or zero for an invalid or unsupported upload.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L66)

<a id="function-function-minipixels-graphics-scene3d-metric-function-metric-field-src-minipixels-graphics-scene3d-ml-753839984"></a>
### metric

```ml
function metric(field)
```

Draw calls, triangles, resident mesh bytes, resident mesh count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `field` | `dynamic` | — | 0: pass draws; 1: pass triangles; 2: resident bytes; 3: resident meshes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L89)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dbegin-extern-function-mp3dbegin-camerax-as-double-cameray-as-double-zoom-as-double-centerx-as-double-centery-as-double-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-1911764236"></a>
### mp3dBegin

```ml
extern function mp3dBegin(cameraX as double, cameraY as double, zoom as double, centerX as double, centerY as double) from "minipixels_gpu.dll" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cameraX` | `double` | — |  |
| `cameraY` | `double` | — |  |
| `zoom` | `double` | — |  |
| `centerX` | `double` | — |  |
| `centerY` | `double` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L8)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dbeginprojected-extern-function-mp3dbeginprojected-x-as-double-y-as-double-width-as-int-height-as-int-halfextent-as-double-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-1552049476"></a>
### mp3dBeginProjected

```ml
extern function mp3dBeginProjected(x as double, y as double, width as int, height as int, halfExtent as double) from "minipixels_gpu.dll" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `double` | — |  |
| `y` | `double` | — |  |
| `width` | `int` | — |  |
| `height` | `int` | — |  |
| `halfExtent` | `double` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L12)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dbox-extern-function-mp3dbox-x-as-double-y-as-double-z-as-double-sx-as-double-sy-as-double-sz-as-double-color-as-u32-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-942455978"></a>
### mp3dBox

```ml
extern function mp3dBox(x as double, y as double, z as double, sx as double, sy as double, sz as double, color as u32) from "minipixels_gpu.dll" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `double` | — |  |
| `y` | `double` | — |  |
| `z` | `double` | — |  |
| `sx` | `double` | — |  |
| `sy` | `double` | — |  |
| `sz` | `double` | — |  |
| `color` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L16)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dend-extern-function-mp3dend-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-scene3d-ml-322749221"></a>
### mp3dEnd

```ml
extern function mp3dEnd() from "minipixels_gpu.dll" returns void
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L10)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmeshbegin-extern-function-mp3dmeshbegin-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-152461430"></a>
### mp3dMeshBegin

```ml
extern function mp3dMeshBegin() from "minipixels_gpu.dll" returns int
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L14)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmeshdelete-extern-function-mp3dmeshdelete-handle-as-int-from-minipixels-gpu-dll-returns-void-src-minipixels-graphics-scene3d-ml-2069904168"></a>
### mp3dMeshDelete

```ml
extern function mp3dMeshDelete(handle as int) from "minipixels_gpu.dll" returns void
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L22)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmeshdraw-extern-function-mp3dmeshdraw-handle-as-int-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-874570519"></a>
### mp3dMeshDraw

```ml
extern function mp3dMeshDraw(handle as int) from "minipixels_gpu.dll" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L20)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmeshdrawat-extern-function-mp3dmeshdrawat-handle-as-int-x-as-double-y-as-double-z-as-double-yaw-as-double-sx-as-double-sy-as-double-sz-as-double-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-1740738720"></a>
### mp3dMeshDrawAt

```ml
extern function mp3dMeshDrawAt(handle as int, x as double, y as double, z as double, yaw as double, sx as double, sy as double, sz as double) from "minipixels_gpu.dll" returns int
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `int` | — |  |
| `x` | `double` | — |  |
| `y` | `double` | — |  |
| `z` | `double` | — |  |
| `yaw` | `double` | — |  |
| `sx` | `double` | — |  |
| `sy` | `double` | — |  |
| `sz` | `double` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L24)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmeshend-extern-function-mp3dmeshend-from-minipixels-gpu-dll-returns-int-src-minipixels-graphics-scene3d-ml-822456662"></a>
### mp3dMeshEnd

```ml
extern function mp3dMeshEnd() from "minipixels_gpu.dll" returns int
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L18)

<a id="extern_function-extern-function-minipixels-graphics-scene3d-mp3dmetric-extern-function-mp3dmetric-field-as-int-from-minipixels-gpu-dll-returns-u64-src-minipixels-graphics-scene3d-ml-1358237559"></a>
### mp3dMetric

```ml
extern function mp3dMetric(field as int) from "minipixels_gpu.dll" returns u64
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `field` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L26)

<a id="function-function-minipixels-graphics-scene3d-release-function-release-handle-src-minipixels-graphics-scene3d-ml-426897158"></a>
### release

```ml
function release(handle)
```

Releases an owned mesh; stale handles are harmless and never recycled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Owned mesh handle to release; stale handles are ignored. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/scene3d.ml#L86)
