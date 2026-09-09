# `minipixels.graphics.canvas.Canvas`

[Home](README.md) · [Source file](File-src-minipixels-graphics-canvas-ml-370061960.md)

<a id="struct-struct-minipixels-graphics-canvas-canvas-struct-canvas-src-minipixels-graphics-canvas-ml-22051031"></a>
## Canvas

```ml
struct Canvas
```

Represents the canvas data used by the minipixels graphics canvas module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L12)

## Members

<a id="method-method-minipixels-graphics-canvas-canvas-begincamera-function-begincamera-camera-src-minipixels-graphics-canvas-ml-187269402"></a>
### beginCamera

```ml
function beginCamera(camera)
```

Performs the beginCamera operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L226)

<a id="method-method-minipixels-graphics-canvas-canvas-blit-function-blit-image-x-y-src-minipixels-graphics-canvas-ml-1673562235"></a>
### blit

```ml
function blit(image, x, y)
```

Performs the blit operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — | image value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L115)

<a id="method-method-minipixels-graphics-canvas-canvas-blitregion-function-blitregion-image-sx-sy-sw-sh-x-y-src-minipixels-graphics-canvas-ml-766058417"></a>
### blitRegion

```ml
function blitRegion(image, sx, sy, sw, sh, x, y)
```

Performs the blitRegion operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — | image value consumed by this operation. |
| `sx` | `dynamic` | — | sx value consumed by this operation. |
| `sy` | `dynamic` | — | sy value consumed by this operation. |
| `sw` | `dynamic` | — | sw value consumed by this operation. |
| `sh` | `dynamic` | — | sh value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L127)

<a id="field-field-minipixels-graphics-canvas-canvas-camerax-camerax-src-minipixels-graphics-canvas-ml-329695921"></a>
### cameraX

```ml
cameraX
```

Stores the camera x value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L20)

<a id="field-field-minipixels-graphics-canvas-canvas-cameray-cameray-src-minipixels-graphics-canvas-ml-993749729"></a>
### cameraY

```ml
cameraY
```

Stores the camera y value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L22)

<a id="method-method-minipixels-graphics-canvas-canvas-clear-function-clear-color-src-minipixels-graphics-canvas-ml-2046325442"></a>
### clear

```ml
function clear(color)
```

Clears clear maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L44)

<a id="field-field-minipixels-graphics-canvas-canvas-dirty-dirty-src-minipixels-graphics-canvas-ml-1085616549"></a>
### dirty

```ml
dirty
```

Whether the canvas contains pixels not yet uploaded by a presenter.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L32)

<a id="field-field-minipixels-graphics-canvas-canvas-dirtyx0-dirtyx0-src-minipixels-graphics-canvas-ml-776310517"></a>
### dirtyX0

```ml
dirtyX0
```

Inclusive minimum dirty x coordinate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L34)

<a id="field-field-minipixels-graphics-canvas-canvas-dirtyx1-dirtyx1-src-minipixels-graphics-canvas-ml-1022784613"></a>
### dirtyX1

```ml
dirtyX1
```

Exclusive maximum dirty x coordinate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L38)

<a id="field-field-minipixels-graphics-canvas-canvas-dirtyy0-dirtyy0-src-minipixels-graphics-canvas-ml-1693697965"></a>
### dirtyY0

```ml
dirtyY0
```

Inclusive minimum dirty y coordinate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L36)

<a id="field-field-minipixels-graphics-canvas-canvas-dirtyy1-dirtyy1-src-minipixels-graphics-canvas-ml-299262385"></a>
### dirtyY1

```ml
dirtyY1
```

Exclusive maximum dirty y coordinate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L40)

<a id="field-field-minipixels-graphics-canvas-canvas-drawcalls-drawcalls-as-int-src-minipixels-graphics-canvas-ml-296633080"></a>
### drawCalls

```ml
drawCalls as int
```

Stores the draw calls value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L28)

<a id="method-method-minipixels-graphics-canvas-canvas-drawcanvas-function-drawcanvas-source-x-y-src-minipixels-graphics-canvas-ml-1209826293"></a>
### drawCanvas

```ml
function drawCanvas(source, x, y)
```

Draws another canvas as a CPU render target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | Source canvas. |
| `x` | `dynamic` | — | Destination x coordinate. |
| `y` | `dynamic` | — | Destination y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L176)

<a id="method-method-minipixels-graphics-canvas-canvas-drawcircle-function-drawcircle-cx-cy-r-color-src-minipixels-graphics-canvas-ml-1526448457"></a>
### drawCircle

```ml
function drawCircle(cx, cy, r, color)
```

Draws circle through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cx` | `dynamic` | — | cx value consumed by this operation. |
| `cy` | `dynamic` | — | cy value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L98)

<a id="method-method-minipixels-graphics-canvas-canvas-drawline-function-drawline-x1-y1-x2-y2-color-src-minipixels-graphics-canvas-ml-758004720"></a>
### drawLine

```ml
function drawLine(x1, y1, x2, y2, color)
```

Draws line through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | x1 value consumed by this operation. |
| `y1` | `dynamic` | — | y1 value consumed by this operation. |
| `x2` | `dynamic` | — | x2 value consumed by this operation. |
| `y2` | `dynamic` | — | y2 value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L69)

<a id="method-method-minipixels-graphics-canvas-canvas-drawrect-function-drawrect-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1442125648"></a>
### drawRect

```ml
function drawRect(x, y, w, h, color)
```

Draws rect through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L79)

<a id="method-method-minipixels-graphics-canvas-canvas-drawrectworld-function-drawrectworld-camera-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1989667083"></a>
### drawRectWorld

```ml
function drawRectWorld(camera, x, y, w, h, color)
```

Draws rect world through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L198)

<a id="method-method-minipixels-graphics-canvas-canvas-drawsprite-function-drawsprite-sprite-x-y-src-minipixels-graphics-canvas-ml-606726197"></a>
### drawSprite

```ml
function drawSprite(sprite, x, y)
```

Draws sprite through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L135)

<a id="method-method-minipixels-graphics-canvas-canvas-drawspriteex-function-drawspriteex-sprite-x-y-flipx-flipy-scale-tint-src-minipixels-graphics-canvas-ml-1922682251"></a>
### drawSpriteEx

```ml
function drawSpriteEx(sprite, x, y, flipX, flipY, scale, tint)
```

Draws sprite ex through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `flipX` | `dynamic` | — | flipX value consumed by this operation. |
| `flipY` | `dynamic` | — | flipY value consumed by this operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `tint` | `dynamic` | — | tint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L147)

<a id="method-method-minipixels-graphics-canvas-canvas-drawspriterotated-function-drawspriterotated-sprite-x-y-radians-scale-tint-src-minipixels-graphics-canvas-ml-1377866026"></a>
### drawSpriteRotated

```ml
function drawSpriteRotated(sprite, x, y, radians, scale, tint)
```

Draws a sprite rotated around its configured pivot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprite` | `dynamic` | — | Sprite to draw. |
| `x` | `dynamic` | — | Pivot x coordinate. |
| `y` | `dynamic` | — | Pivot y coordinate. |
| `radians` | `dynamic` | — | Clockwise rotation in radians. |
| `scale` | `dynamic` | — | Positive integer scale. |
| `tint` | `dynamic` | — | Multiplicative RGBA tint. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L168)

<a id="method-method-minipixels-graphics-canvas-canvas-drawspritescaled-function-drawspritescaled-sprite-x-y-scale-tint-src-minipixels-graphics-canvas-ml-2138352210"></a>
### drawSpriteScaled

```ml
function drawSpriteScaled(sprite, x, y, scale, tint)
```

Draws a sprite with an arbitrary positive nearest-neighbour scale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprite` | `dynamic` | — | Sprite to draw. |
| `x` | `dynamic` | — | Destination x coordinate. |
| `y` | `dynamic` | — | Destination y coordinate. |
| `scale` | `dynamic` | — | Positive fractional or integral scale. |
| `tint` | `dynamic` | — | Multiplicative RGBA tint. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L157)

<a id="method-method-minipixels-graphics-canvas-canvas-drawspriteworld-function-drawspriteworld-camera-sprite-x-y-src-minipixels-graphics-canvas-ml-2088929754"></a>
### drawSpriteWorld

```ml
function drawSpriteWorld(camera, sprite, x, y)
```

Draws sprite world through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L207)

<a id="method-method-minipixels-graphics-canvas-canvas-drawspriteworldex-function-drawspriteworldex-camera-sprite-x-y-flipx-flipy-scale-tint-src-minipixels-graphics-canvas-ml-1097149584"></a>
### drawSpriteWorldEx

```ml
function drawSpriteWorldEx(camera, sprite, x, y, flipX, flipY, scale, tint)
```

Draws sprite world ex through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `flipX` | `dynamic` | — | flipX value consumed by this operation. |
| `flipY` | `dynamic` | — | flipY value consumed by this operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `tint` | `dynamic` | — | tint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L220)

<a id="method-method-minipixels-graphics-canvas-canvas-endcamera-function-endcamera-src-minipixels-graphics-canvas-ml-1852350255"></a>
### endCamera

```ml
function endCamera()
```

Performs the endCamera operation for the minipixels graphics canvas canvas module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L232)

<a id="method-method-minipixels-graphics-canvas-canvas-fillcircle-function-fillcircle-cx-cy-r-color-src-minipixels-graphics-canvas-ml-1150265425"></a>
### fillCircle

```ml
function fillCircle(cx, cy, r, color)
```

Performs the fillCircle operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cx` | `dynamic` | — | cx value consumed by this operation. |
| `cy` | `dynamic` | — | cy value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L107)

<a id="method-method-minipixels-graphics-canvas-canvas-fillrect-function-fillrect-x-y-w-h-color-src-minipixels-graphics-canvas-ml-2145824812"></a>
### fillRect

```ml
function fillRect(x, y, w, h, color)
```

Performs the fillRect operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L89)

<a id="method-method-minipixels-graphics-canvas-canvas-fillrectworld-function-fillrectworld-camera-x-y-w-h-color-src-minipixels-graphics-canvas-ml-919901805"></a>
### fillRectWorld

```ml
function fillRectWorld(camera, x, y, w, h, color)
```

Performs the fillRectWorld operation for the minipixels graphics canvas canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L187)

<a id="method-method-minipixels-graphics-canvas-canvas-getpixel-function-getpixel-x-y-src-minipixels-graphics-canvas-ml-219773286"></a>
### getPixel

```ml
function getPixel(x, y)
```

Returns pixel maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L59)

<a id="field-field-minipixels-graphics-canvas-canvas-height-height-as-int-src-minipixels-graphics-canvas-ml-804771362"></a>
### height

```ml
height as int
```

Stores the height value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L16)

<a id="field-field-minipixels-graphics-canvas-canvas-imageview-imageview-src-minipixels-graphics-canvas-ml-321933405"></a>
### imageView

```ml
imageView
```

Image view sharing this canvas's pixel storage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L30)

<a id="field-field-minipixels-graphics-canvas-canvas-pixels-pixels-as-bytes-src-minipixels-graphics-canvas-ml-1601917324"></a>
### pixels

```ml
pixels as bytes
```

Stores the pixels value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L18)

<a id="method-method-minipixels-graphics-canvas-canvas-resize-function-resize-width-height-src-minipixels-graphics-canvas-ml-320755980"></a>
### resize

```ml
function resize(width, height)
```

Reallocates this framebuffer and discards its previous pixels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | New pixel width. |
| `height` | `dynamic` | — | New pixel height. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L240)

<a id="method-method-minipixels-graphics-canvas-canvas-setpixel-function-setpixel-x-y-color-src-minipixels-graphics-canvas-ml-1492748631"></a>
### setPixel

```ml
function setPixel(x, y, color)
```

Updates pixel maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L52)

<a id="field-field-minipixels-graphics-canvas-canvas-spritecount-spritecount-as-int-src-minipixels-graphics-canvas-ml-269112960"></a>
### spriteCount

```ml
spriteCount as int
```

Stores the sprite count value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L24)

<a id="field-field-minipixels-graphics-canvas-canvas-tilecount-tilecount-as-int-src-minipixels-graphics-canvas-ml-1566719344"></a>
### tileCount

```ml
tileCount as int
```

Stores the tile count value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L26)

<a id="field-field-minipixels-graphics-canvas-canvas-width-width-as-int-src-minipixels-graphics-canvas-ml-1676292864"></a>
### width

```ml
width as int
```

Stores the width value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L14)
