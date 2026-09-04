# `minipixels.graphics.canvas.Canvas`

[Home](README.md) · [Source file](File-src-minipixels-graphics-canvas-ml-370061960.md)

<a id="struct-struct-minipixels-graphics-canvas-canvas-struct-canvas-src-minipixels-graphics-canvas-ml-22051031"></a>
## Canvas

```ml
struct Canvas
```

Represents the canvas data used by the minipixels graphics canvas module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L11)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L184)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L102)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L114)

<a id="field-field-minipixels-graphics-canvas-canvas-camerax-camerax-src-minipixels-graphics-canvas-ml-329695921"></a>
### cameraX

```ml
cameraX
```

Stores the camera x value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L19)

<a id="field-field-minipixels-graphics-canvas-canvas-cameray-cameray-src-minipixels-graphics-canvas-ml-993749729"></a>
### cameraY

```ml
cameraY
```

Stores the camera y value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L21)

<a id="method-method-minipixels-graphics-canvas-canvas-clear-function-clear-color-src-minipixels-graphics-canvas-ml-2046325442"></a>
### clear

```ml
function clear(color)
```

Clears clear maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L31)

<a id="field-field-minipixels-graphics-canvas-canvas-drawcalls-drawcalls-as-int-src-minipixels-graphics-canvas-ml-296633080"></a>
### drawCalls

```ml
drawCalls as int
```

Stores the draw calls value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L27)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L85)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L56)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L66)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L156)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L122)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L134)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L165)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L178)

<a id="method-method-minipixels-graphics-canvas-canvas-endcamera-function-endcamera-src-minipixels-graphics-canvas-ml-1852350255"></a>
### endCamera

```ml
function endCamera()
```

Performs the endCamera operation for the minipixels graphics canvas canvas module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L190)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L94)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L76)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L145)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L46)

<a id="field-field-minipixels-graphics-canvas-canvas-height-height-as-int-src-minipixels-graphics-canvas-ml-804771362"></a>
### height

```ml
height as int
```

Stores the height value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L15)

<a id="field-field-minipixels-graphics-canvas-canvas-pixels-pixels-as-bytes-src-minipixels-graphics-canvas-ml-1601917324"></a>
### pixels

```ml
pixels as bytes
```

Stores the pixels value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L17)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L39)

<a id="field-field-minipixels-graphics-canvas-canvas-spritecount-spritecount-as-int-src-minipixels-graphics-canvas-ml-269112960"></a>
### spriteCount

```ml
spriteCount as int
```

Stores the sprite count value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L23)

<a id="field-field-minipixels-graphics-canvas-canvas-tilecount-tilecount-as-int-src-minipixels-graphics-canvas-ml-1566719344"></a>
### tileCount

```ml
tileCount as int
```

Stores the tile count value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L25)

<a id="field-field-minipixels-graphics-canvas-canvas-width-width-as-int-src-minipixels-graphics-canvas-ml-1676292864"></a>
### width

```ml
width as int
```

Stores the width value associated with canvas.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L13)
