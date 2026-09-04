# `src/minipixels/graphics/canvas.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels graphics canvas facilities for this project.

Package: [`minipixels.graphics.canvas`](Package-minipixels-graphics-canvas-2037800108.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="function-function-minipixels-graphics-canvas-blendpixel-function-blendpixel-c-x-y-color-src-minipixels-graphics-canvas-ml-1273688265"></a>
### blendPixel

```ml
function blendPixel(c, x, y, color)
```

Performs the blendPixel operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L295)

<a id="function-function-minipixels-graphics-canvas-blendpixelraw-function-blendpixelraw-c-x-y-color-src-minipixels-graphics-canvas-ml-1904491027"></a>
### blendPixelRaw

```ml
function blendPixelRaw(c, x, y, color)
```

Performs the blendPixelRaw operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L266)

<a id="function-function-minipixels-graphics-canvas-blitimage-function-blitimage-c-img-x-y-src-minipixels-graphics-canvas-ml-991305047"></a>
### blitImage

```ml
function blitImage(c, img, x, y)
```

Performs the blitImage operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L482)

<a id="function-function-minipixels-graphics-canvas-blitregion-function-blitregion-c-img-sx-sy-sw-sh-x-y-src-minipixels-graphics-canvas-ml-165924677"></a>
### blitRegion

```ml
function blitRegion(c, img, sx, sy, sw, sh, x, y)
```

Performs the blitRegion operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `sx` | `dynamic` | — | sx value consumed by this operation. |
| `sy` | `dynamic` | — | sy value consumed by this operation. |
| `sw` | `dynamic` | — | sw value consumed by this operation. |
| `sh` | `dynamic` | — | sh value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L495)

- [minipixels.graphics.canvas.Canvas](Type-minipixels-graphics-canvas-canvas-2121003546.md) — struct
<a id="function-function-minipixels-graphics-canvas-clearcanvas-function-clearcanvas-c-color-src-minipixels-graphics-canvas-ml-2094788080"></a>
### clearCanvas

```ml
function clearCanvas(c, color)
```

Clears canvas maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L222)

<a id="function-function-minipixels-graphics-canvas-create-function-create-width-height-src-minipixels-graphics-canvas-ml-1074773335"></a>
### create

```ml
function create(width, height)
```

Creates create for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L199)

<a id="function-function-minipixels-graphics-canvas-drawcircle-function-drawcircle-c-cx-cy-r-color-src-minipixels-graphics-canvas-ml-2045286387"></a>
### drawCircle

```ml
function drawCircle(c, cx, cy, r, color)
```

Draws circle through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `cx` | `dynamic` | — | cx value consumed by this operation. |
| `cy` | `dynamic` | — | cy value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L432)

<a id="function-function-minipixels-graphics-canvas-drawline-function-drawline-c-x1-y1-x2-y2-color-src-minipixels-graphics-canvas-ml-379303362"></a>
### drawLine

```ml
function drawLine(c, x1, y1, x2, y2, color)
```

Draws line through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x1` | `dynamic` | — | x1 value consumed by this operation. |
| `y1` | `dynamic` | — | y1 value consumed by this operation. |
| `x2` | `dynamic` | — | x2 value consumed by this operation. |
| `y2` | `dynamic` | — | y2 value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L398)

<a id="function-function-minipixels-graphics-canvas-drawpixelfast-function-drawpixelfast-c-x-y-color-src-minipixels-graphics-canvas-ml-1181598113"></a>
### drawPixelFast

```ml
function drawPixelFast(c, x, y, color)
```

Draws pixel fast through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L308)

<a id="function-function-minipixels-graphics-canvas-drawrect-function-drawrect-c-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1392056414"></a>
### drawRect

```ml
function drawRect(c, x, y, w, h, color)
```

Draws rect through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L384)

<a id="function-function-minipixels-graphics-canvas-drawrectworld-function-drawrectworld-c-camera-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1655626413"></a>
### drawRectWorld

```ml
function drawRectWorld(c, camera, x, y, w, h, color)
```

Draws rect world through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L673)

<a id="function-function-minipixels-graphics-canvas-drawsprite-function-drawsprite-c-spr-x-y-src-minipixels-graphics-canvas-ml-1771831875"></a>
### drawSprite

```ml
function drawSprite(c, spr, x, y)
```

Draws sprite through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `spr` | `dynamic` | — | spr value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L505)

<a id="function-function-minipixels-graphics-canvas-drawspriteex-function-drawspriteex-c-spr-x-y-flipx-flipy-scale-tint-src-minipixels-graphics-canvas-ml-1977777057"></a>
### drawSpriteEx

```ml
function drawSpriteEx(c, spr, x, y, flipX, flipY, scale, tint)
```

Draws sprite ex through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `spr` | `dynamic` | — | spr value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `flipX` | `dynamic` | — | flipX value consumed by this operation. |
| `flipY` | `dynamic` | — | flipY value consumed by this operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `tint` | `dynamic` | — | tint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L603)

<a id="function-function-minipixels-graphics-canvas-drawspritefast1x-function-drawspritefast1x-c-spr-x-y-src-minipixels-graphics-canvas-ml-1613156323"></a>
### drawSpriteFast1x

```ml
function drawSpriteFast1x(c, spr, x, y)
```

Draws sprite fast1x through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `spr` | `dynamic` | — | spr value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L550)

<a id="function-function-minipixels-graphics-canvas-drawspriteworld-function-drawspriteworld-c-camera-spr-x-y-src-minipixels-graphics-canvas-ml-758119470"></a>
### drawSpriteWorld

```ml
function drawSpriteWorld(c, camera, spr, x, y)
```

Draws sprite world through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `spr` | `dynamic` | — | spr value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L683)

<a id="function-function-minipixels-graphics-canvas-drawspriteworldex-function-drawspriteworldex-c-camera-spr-x-y-flipx-flipy-scale-tint-src-minipixels-graphics-canvas-ml-273018892"></a>
### drawSpriteWorldEx

```ml
function drawSpriteWorldEx(c, camera, spr, x, y, flipX, flipY, scale, tint)
```

Draws sprite world ex through the minipixels graphics canvas rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `spr` | `dynamic` | — | spr value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `flipX` | `dynamic` | — | flipX value consumed by this operation. |
| `flipY` | `dynamic` | — | flipY value consumed by this operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `tint` | `dynamic` | — | tint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L697)

<a id="function-function-minipixels-graphics-canvas-fillcircle-function-fillcircle-c-cx-cy-r-color-src-minipixels-graphics-canvas-ml-108867707"></a>
### fillCircle

```ml
function fillCircle(c, cx, cy, r, color)
```

Performs the fillCircle operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `cx` | `dynamic` | — | cx value consumed by this operation. |
| `cy` | `dynamic` | — | cy value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L462)

<a id="function-function-minipixels-graphics-canvas-fillrect-function-fillrect-c-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1196303130"></a>
### fillRect

```ml
function fillRect(c, x, y, w, h, color)
```

Performs the fillRect operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L330)

<a id="function-function-minipixels-graphics-canvas-fillrectworld-function-fillrectworld-c-camera-x-y-w-h-color-src-minipixels-graphics-canvas-ml-1749998495"></a>
### fillRectWorld

```ml
function fillRectWorld(c, camera, x, y, w, h, color)
```

Performs the fillRectWorld operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L661)

<a id="function-function-minipixels-graphics-canvas-fillscaledpixel-function-fillscaledpixel-c-x-y-scale-color-src-minipixels-graphics-canvas-ml-1949563361"></a>
### fillScaledPixel

```ml
function fillScaledPixel(c, x, y, scale, color)
```

Performs the fillScaledPixel operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L515)

<a id="function-function-minipixels-graphics-canvas-getpixel-function-getpixel-c-x-y-src-minipixels-graphics-canvas-ml-113781492"></a>
### getPixel

```ml
function getPixel(c, x, y)
```

Returns pixel maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L282)

<a id="function-function-minipixels-graphics-canvas-hash-function-hash-c-src-minipixels-graphics-canvas-ml-1715757429"></a>
### hash

```ml
function hash(c)
```

Performs the hash operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L703)

<a id="function-function-minipixels-graphics-canvas-index-inline-function-index-c-x-y-src-minipixels-graphics-canvas-ml-859928981"></a>
### index

```ml
inline function index(c, x, y)
```

Performs the index operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L215)

<a id="function-function-minipixels-graphics-canvas-resetstats-function-resetstats-c-src-minipixels-graphics-canvas-ml-1731332189"></a>
### resetStats

```ml
function resetStats(c)
```

Performs the resetStats operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L205)

<a id="function-function-minipixels-graphics-canvas-screenx-function-screenx-camera-x-src-minipixels-graphics-canvas-ml-1707190397"></a>
### screenX

```ml
function screenX(camera, x)
```

Performs the screenX operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L642)

<a id="function-function-minipixels-graphics-canvas-screeny-function-screeny-camera-y-src-minipixels-graphics-canvas-ml-963577846"></a>
### screenY

```ml
function screenY(camera, y)
```

Performs the screenY operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L649)

<a id="function-function-minipixels-graphics-canvas-setpixel-function-setpixel-c-x-y-color-src-minipixels-graphics-canvas-ml-1444983993"></a>
### setPixel

```ml
function setPixel(c, x, y, color)
```

Updates pixel maintained by the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L249)
