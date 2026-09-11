# `minipixels.graphics.gpu.GpuCanvas`

[Home](README.md) · [Source file](File-src-minipixels-graphics-gpu-ml-159526452.md)

<a id="struct-struct-minipixels-graphics-gpu-gpucanvas-struct-gpucanvas-src-minipixels-graphics-gpu-ml-759501323"></a>
## GpuCanvas

```ml
struct GpuCanvas
```

Experimental batched render target backed by an OpenGL framebuffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L119)

## Members

<a id="method-method-minipixels-graphics-gpu-gpucanvas-blitregion-function-blitregion-image-sx-sy-sw-sh-x-y-src-minipixels-graphics-gpu-ml-661449327"></a>
### blitRegion

```ml
function blitRegion(image, sx, sy, sw, sh, x, y)
```

Draws a source image region without scaling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — | CPU image to upload and draw. |
| `sx` | `dynamic` | — | Source x coordinate. |
| `sy` | `dynamic` | — | Source y coordinate. |
| `sw` | `dynamic` | — | Source width. |
| `sh` | `dynamic` | — | Source height. |
| `x` | `dynamic` | — | Destination x coordinate. |
| `y` | `dynamic` | — | Destination y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L182)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-clear-function-clear-color-src-minipixels-graphics-gpu-ml-274484978"></a>
### clear

```ml
function clear(color)
```

Clears the complete scene target to an opaque color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | Packed RGBA clear color; the target remains opaque. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L126)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawcanvas-function-drawcanvas-source-x-y-src-minipixels-graphics-gpu-ml-808238395"></a>
### drawCanvas

```ml
function drawCanvas(source, x, y)
```

Draws a CPU canvas. GPU canvases are not valid sources.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | CPU canvas to upload and draw. |
| `x` | `dynamic` | — | Destination x coordinate. |
| `y` | `dynamic` | — | Destination y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L170)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawlight-function-drawlight-x-y-radiusx-radiusy-red-green-blue-returns-bool-src-minipixels-graphics-gpu-ml-1222912900"></a>
### drawLight

```ml
function drawLight(x, y, radiusX, radiusY, red, green, blue) returns bool
```

Applies an additive screen-blend point light when shader support is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Center x coordinate. |
| `y` | `dynamic` | — | Center y coordinate. |
| `radiusX` | `dynamic` | — | Horizontal radius. |
| `radiusY` | `dynamic` | — | Vertical radius. |
| `red` | `dynamic` | — | Red light strength from zero to 255. |
| `green` | `dynamic` | — | Green light strength from zero to 255. |
| `blue` | `dynamic` | — | Blue light strength from zero to 255. |


**Returns:** True when the optional light shader is available.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L237)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawline-function-drawline-x0-y0-x1-y1-color-src-minipixels-graphics-gpu-ml-331511308"></a>
### drawLine

```ml
function drawLine(x0, y0, x1, y1, color)
```

Draws a one-pixel line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x0` | `dynamic` | — | Start x coordinate. |
| `y0` | `dynamic` | — | Start y coordinate. |
| `x1` | `dynamic` | — | End x coordinate. |
| `y1` | `dynamic` | — | End y coordinate. |
| `color` | `dynamic` | — | Packed RGBA color. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L215)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawrect-function-drawrect-x-y-w-h-color-src-minipixels-graphics-gpu-ml-140781264"></a>
### drawRect

```ml
function drawRect(x, y, w, h, color)
```

Draws a one-pixel rectangle outline.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Left coordinate. |
| `y` | `dynamic` | — | Top coordinate. |
| `w` | `dynamic` | — | Rectangle width. |
| `h` | `dynamic` | — | Rectangle height. |
| `color` | `dynamic` | — | Packed RGBA color. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L202)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawsprite-function-drawsprite-spr-x-y-src-minipixels-graphics-gpu-ml-951683967"></a>
### drawSprite

```ml
function drawSprite(spr, x, y)
```

Draws a sprite at its natural size.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spr` | `dynamic` | — | Sprite and source region to draw. |
| `x` | `dynamic` | — | Destination pivot x coordinate. |
| `y` | `dynamic` | — | Destination pivot y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L152)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-drawspritescaled-function-drawspritescaled-spr-x-y-scale-tint-src-minipixels-graphics-gpu-ml-1627954726"></a>
### drawSpriteScaled

```ml
function drawSpriteScaled(spr, x, y, scale, tint)
```

Draws a tinted sprite at a uniform scale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spr` | `dynamic` | — | Sprite and source region to draw. |
| `x` | `dynamic` | — | Destination pivot x coordinate. |
| `y` | `dynamic` | — | Destination pivot y coordinate. |
| `scale` | `dynamic` | — | Positive uniform scale. |
| `tint` | `dynamic` | — | Packed RGBA color multiplier. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L162)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-fillcircle-function-fillcircle-x-y-r-color-src-minipixels-graphics-gpu-ml-118501783"></a>
### fillCircle

```ml
function fillCircle(x, y, r, color)
```

Draws a filled circle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Center x coordinate. |
| `y` | `dynamic` | — | Center y coordinate. |
| `r` | `dynamic` | — | Radius in pixels. |
| `color` | `dynamic` | — | Packed RGBA color. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L224)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-fillrect-function-fillrect-x-y-w-h-color-src-minipixels-graphics-gpu-ml-612314980"></a>
### fillRect

```ml
function fillRect(x, y, w, h, color)
```

Draws a filled rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Left coordinate. |
| `y` | `dynamic` | — | Top coordinate. |
| `w` | `dynamic` | — | Rectangle width. |
| `h` | `dynamic` | — | Rectangle height. |
| `color` | `dynamic` | — | Packed RGBA color. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L192)

<a id="field-field-minipixels-graphics-gpu-gpucanvas-height-height-src-minipixels-graphics-gpu-ml-845698813"></a>
### height

```ml
height
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L121)

<a id="field-field-minipixels-graphics-gpu-gpucanvas-imageview-imageview-src-minipixels-graphics-gpu-ml-1140649519"></a>
### imageView

```ml
imageView
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L122)

<a id="method-method-minipixels-graphics-gpu-gpucanvas-resize-function-resize-width-height-returns-bool-src-minipixels-graphics-gpu-ml-285495381"></a>
### resize

```ml
function resize(width, height) returns bool
```

Resizes and clears the GPU framebuffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | New logical width. |
| `height` | `dynamic` | — | New logical height. |


**Returns:** True when the framebuffer was resized or already has this size.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L134)

<a id="field-field-minipixels-graphics-gpu-gpucanvas-width-width-src-minipixels-graphics-gpu-ml-1578370063"></a>
### width

```ml
width
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/gpu.ml#L120)
