# `src/minipixels/graphics/font.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels graphics font facilities for this project.

Package: [`minipixels.graphics.font`](Package-minipixels-graphics-font-76916397.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/canvas.ml` as `cv` → [src/minipixels/graphics/canvas.ml](File-src-minipixels-graphics-canvas-ml-370061960.md)

## Declarations

<a id="function-function-minipixels-graphics-font-drawglyph-function-drawglyph-canvas-ch-x-y-scale-color-src-minipixels-graphics-font-ml-725828193"></a>
### drawGlyph

```ml
function drawGlyph(canvas, ch, x, y, scale, color)
```

Draws glyph through the minipixels graphics font rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `ch` | `dynamic` | — | ch value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/font.ml#L73)

<a id="function-function-minipixels-graphics-font-drawtext-function-drawtext-canvas-text-x-y-scale-color-src-minipixels-graphics-font-ml-1630535549"></a>
### drawText

```ml
function drawText(canvas, text, x, y, scale, color)
```

Draws text through the minipixels graphics font rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/font.ml#L98)

<a id="function-function-minipixels-graphics-font-drawtextcentered-function-drawtextcentered-canvas-text-y-scale-color-src-minipixels-graphics-font-ml-1722252689"></a>
### drawTextCentered

```ml
function drawTextCentered(canvas, text, y, scale, color)
```

Draws text centered through the minipixels graphics font rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/font.ml#L113)

<a id="function-function-minipixels-graphics-font-glyphbits-function-glyphbits-ch-src-minipixels-graphics-font-ml-1627811811"></a>
### glyphBits

```ml
function glyphBits(ch)
```

Performs the glyphBits operation for the minipixels graphics font module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | ch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/font.ml#L11)

<a id="function-function-minipixels-graphics-font-textwidth-function-textwidth-text-scale-src-minipixels-graphics-font-ml-141266891"></a>
### textWidth

```ml
function textWidth(text, scale)
```

Performs the textWidth operation for the minipixels graphics font module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/font.ml#L60)
