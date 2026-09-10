# `src/minipixels/graphics/canvas.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels graphics canvas facilities for this project.

Package: [`minipixels.graphics.canvas`](Package-minipixels-graphics-canvas-2037800108.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)
- `std/math.ml` as `math` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-minipixels-graphics-canvas-blendopaquespriterow-function-blendopaquespriterow-destination-as-bytes-source-as-bytes-di-as-int-si-as-int-count-as-int-returns-bool-src-minipixels-graphics-canvas-ml-1753098185"></a>
### blendOpaqueSpriteRow

```ml
function blendOpaqueSpriteRow(destination as bytes, source as bytes, di as int, si as int, count as int) returns bool
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `bytes` | — |  |
| `source` | `bytes` | — |  |
| `di` | `int` | — |  |
| `si` | `int` | — |  |
| `count` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L671)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L410)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L381)

<a id="function-function-minipixels-graphics-canvas-blendtransparentspriterow-function-blendtransparentspriterow-destination-as-bytes-source-as-bytes-di-as-int-si-as-int-count-as-int-returns-bool-src-minipixels-graphics-canvas-ml-1352210493"></a>
### blendTransparentSpriteRow

```ml
function blendTransparentSpriteRow(destination as bytes, source as bytes, di as int, si as int, count as int) returns bool
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `bytes` | — |  |
| `source` | `bytes` | — |  |
| `di` | `int` | — |  |
| `si` | `int` | — |  |
| `count` | `int` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L696)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L607)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L620)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L333)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L248)

<a id="function-function-minipixels-graphics-canvas-drawcanvas-function-drawcanvas-destination-source-x-y-src-minipixels-graphics-canvas-ml-1518492604"></a>
### drawCanvas

```ml
function drawCanvas(destination, source, x, y)
```

Draws a source canvas as a reusable CPU render target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | Destination canvas. |
| `source` | `dynamic` | — | Source canvas. |
| `x` | `dynamic` | — | Destination x coordinate. |
| `y` | `dynamic` | — | Destination y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L911)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L548)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L514)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L423)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L500)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L949)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L630)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L765)

<a id="function-function-minipixels-graphics-canvas-drawspritefast1x-function-drawspritefast1x-c-spr-x-y-src-minipixels-graphics-canvas-ml-1613156323"></a>
### drawSpriteFast1x

```ml
function drawSpriteFast1x(c, spr, x, y)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — |  |
| `spr` | `dynamic` | — |  |
| `x` | `dynamic` | — |  |
| `y` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L726)

<a id="function-function-minipixels-graphics-canvas-drawspriterotated-function-drawspriterotated-c-spr-x-y-radians-scale-tint-src-minipixels-graphics-canvas-ml-840764200"></a>
### drawSpriteRotated

```ml
function drawSpriteRotated(c, spr, x, y, radians, scale, tint)
```

Draws a sprite rotated around its configured pivot using inverse sampling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | Destination canvas. |
| `spr` | `dynamic` | — | Sprite to draw. |
| `x` | `dynamic` | — | Pivot x coordinate. |
| `y` | `dynamic` | — | Pivot y coordinate. |
| `radians` | `dynamic` | — | Clockwise rotation in radians. |
| `scale` | `dynamic` | — | Positive integer scale. |
| `tint` | `dynamic` | — | Multiplicative RGBA tint. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L852)

<a id="function-function-minipixels-graphics-canvas-drawspritescaled-function-drawspritescaled-c-spr-x-y-scale-tint-src-minipixels-graphics-canvas-ml-841362936"></a>
### drawSpriteScaled

```ml
function drawSpriteScaled(c, spr, x, y, scale, tint)
```

Draws a sprite at an arbitrary nearest-neighbour scale. Unlike drawSpriteEx, this path intentionally accepts fractional scaling for smooth camera zoom.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | Target canvas. |
| `spr` | `dynamic` | — | Sprite to draw. |
| `x` | `dynamic` | — | Horizontal pivot position. |
| `y` | `dynamic` | — | Vertical pivot position. |
| `scale` | `dynamic` | — | Positive scale factor. |
| `tint` | `dynamic` | — | Multiplicative RGBA tint. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L810)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L959)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L973)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L578)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L445)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L937)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L640)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L397)

<a id="function-function-minipixels-graphics-canvas-hash-function-hash-c-src-minipixels-graphics-canvas-ml-1715757429"></a>
### hash

```ml
function hash(c)
```

Performs the hash operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L979)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L326)

<a id="function-function-minipixels-graphics-canvas-markdirty-function-markdirty-c-x-y-w-h-src-minipixels-graphics-canvas-ml-540302783"></a>
### markDirty

```ml
function markDirty(c, x, y, w, h)
```

Expands the pending upload region to include a rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | Canvas to mark. |
| `x` | `dynamic` | — | Rectangle x coordinate in canvas space. |
| `y` | `dynamic` | — | Rectangle y coordinate in canvas space. |
| `w` | `dynamic` | — | Rectangle width. |
| `h` | `dynamic` | — | Rectangle height. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L284)

<a id="function-function-minipixels-graphics-canvas-resetdirty-function-resetdirty-c-src-minipixels-graphics-canvas-ml-2031001549"></a>
### resetDirty

```ml
function resetDirty(c)
```

Clears the pending upload region after presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | Canvas whose dirty state is consumed. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L306)

<a id="function-function-minipixels-graphics-canvas-resetstats-function-resetstats-c-src-minipixels-graphics-canvas-ml-1731332189"></a>
### resetStats

```ml
function resetStats(c)
```

Performs the resetStats operation for the minipixels graphics canvas module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L316)

<a id="function-function-minipixels-graphics-canvas-resize-function-resize-c-width-height-src-minipixels-graphics-canvas-ml-1088691982"></a>
### resize

```ml
function resize(c, width, height)
```

Reallocate a canvas while preserving the Canvas object itself. Existing pixel contents are discarded and the new surface starts transparent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | Canvas to resize. |
| `width` | `dynamic` | — | New pixel width. |
| `height` | `dynamic` | — | New pixel height. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L259)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L918)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L925)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/canvas.ml#L362)
