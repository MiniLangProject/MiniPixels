# `src/minipixels/graphics/sprite.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels graphics sprite facilities for this project.

Package: [`minipixels.graphics.sprite`](Package-minipixels-graphics-sprite-484808201.md)

Reachable from entry: **yes**

## Imports

- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="function-function-minipixels-graphics-sprite-cacheframes-function-cacheframes-sheet-src-minipixels-graphics-sprite-ml-1688415125"></a>
### cacheFrames

```ml
function cacheFrames(sheet)
```

Populates every frame descriptor cache ahead of a hot rendering loop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sheet` | `dynamic` | — | Sprite sheet to prewarm. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L230)

- [minipixels.graphics.sprite.Image](Type-minipixels-graphics-sprite-image-712579706.md) — struct
<a id="function-function-minipixels-graphics-sprite-imagegetpixel-function-imagegetpixel-img-x-y-src-minipixels-graphics-sprite-ml-595135794"></a>
### imageGetPixel

```ml
function imageGetPixel(img, x, y)
```

Performs the imageGetPixel operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L147)

<a id="function-function-minipixels-graphics-sprite-imageindex-inline-function-imageindex-img-x-y-src-minipixels-graphics-sprite-ml-1559316635"></a>
### imageIndex

```ml
inline function imageIndex(img, x, y)
```

Performs the imageIndex operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L123)

<a id="function-function-minipixels-graphics-sprite-imagesetpixel-function-imagesetpixel-img-x-y-color-src-minipixels-graphics-sprite-ml-1730185989"></a>
### imageSetPixel

```ml
function imageSetPixel(img, x, y, color)
```

Performs the imageSetPixel operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L132)

<a id="function-function-minipixels-graphics-sprite-newimage-function-newimage-width-height-pixels-name-src-minipixels-graphics-sprite-ml-1608740487"></a>
### newImage

```ml
function newImage(width, height, pixels, name)
```

Creates image for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L81)

<a id="function-function-minipixels-graphics-sprite-pixelsareopaque-function-pixelsareopaque-pixels-as-bytes-pixelcount-as-int-returns-bool-src-minipixels-graphics-sprite-ml-296598099"></a>
### pixelsAreOpaque

```ml
function pixelsAreOpaque(pixels as bytes, pixelCount as int) returns bool
```

Performs the pixelsAreOpaque operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |
| `pixelCount` | `int` | — | Number of pixel to process. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L92)

<a id="function-function-minipixels-graphics-sprite-solidimage-function-solidimage-width-height-color-name-src-minipixels-graphics-sprite-ml-413648029"></a>
### solidImage

```ml
function solidImage(width, height, color, name)
```

Performs the solidImage operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L108)

- [minipixels.graphics.sprite.Sprite](Type-minipixels-graphics-sprite-sprite-363793820.md) — struct
<a id="function-function-minipixels-graphics-sprite-spritefromimage-function-spritefromimage-img-name-src-minipixels-graphics-sprite-ml-2049691192"></a>
### spriteFromImage

```ml
function spriteFromImage(img, name)
```

Performs the spriteFromImage operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L163)

<a id="function-function-minipixels-graphics-sprite-spriteregion-function-spriteregion-img-sx-sy-w-h-name-src-minipixels-graphics-sprite-ml-1585338268"></a>
### spriteRegion

```ml
function spriteRegion(img, sx, sy, w, h, name)
```

Performs the spriteRegion operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `sx` | `dynamic` | — | sx value consumed by this operation. |
| `sy` | `dynamic` | — | sy value consumed by this operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L174)

<a id="function-function-minipixels-graphics-sprite-spritesheet-function-spritesheet-img-framewidth-frameheight-spacing-margin-src-minipixels-graphics-sprite-ml-1575399887"></a>
### spriteSheet

```ml
function spriteSheet(img, frameWidth, frameHeight, spacing, margin)
```

Performs the spriteSheet operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `frameWidth` | `dynamic` | — | frameWidth value consumed by this operation. |
| `frameHeight` | `dynamic` | — | frameHeight value consumed by this operation. |
| `spacing` | `dynamic` | — | spacing value consumed by this operation. |
| `margin` | `dynamic` | — | margin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L184)

- [minipixels.graphics.sprite.SpriteSheet](Type-minipixels-graphics-sprite-spritesheet-395190639.md) — struct
<a id="function-function-minipixels-graphics-sprite-spritesheetframe-function-spritesheetframe-sheet-index-src-minipixels-graphics-sprite-ml-199818173"></a>
### spriteSheetFrame

```ml
function spriteSheetFrame(sheet, index)
```

Performs the spriteSheetFrame operation for the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sheet` | `dynamic` | — | sheet value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L208)
