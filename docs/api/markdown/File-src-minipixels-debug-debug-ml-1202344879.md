# `src/minipixels/debug/debug.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels debug debug facilities for this project.

Package: [`minipixels.debug.debug`](Package-minipixels-debug-debug-706893891.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/canvas.ml` as `cv` → [src/minipixels/graphics/canvas.ml](File-src-minipixels-graphics-canvas-ml-370061960.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="function-function-minipixels-debug-debug-capturehash-function-capturehash-canvas-src-minipixels-debug-debug-ml-119582296"></a>
### captureHash

```ml
function captureHash(canvas)
```

Performs the captureHash operation for the minipixels debug debug module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/debug/debug.ml#L73)

<a id="global-global-minipixels-debug-debug-digitpatterns-digitpatterns-src-minipixels-debug-debug-ml-190276508"></a>
### digitPatterns

```ml
digitPatterns
```

Stores module-wide digit patterns state for the minipixels debug debug module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/debug/debug.ml#L11)

<a id="function-function-minipixels-debug-debug-drawdigit-function-drawdigit-canvas-n-x-y-color-src-minipixels-debug-debug-ml-324349602"></a>
### drawDigit

```ml
function drawDigit(canvas, n, x, y, color)
```

Draws digit through the minipixels debug debug rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `n` | `dynamic` | — | n value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/debug/debug.ml#L22)

<a id="function-function-minipixels-debug-debug-drawnumber-function-drawnumber-canvas-value-x-y-color-src-minipixels-debug-debug-ml-769181347"></a>
### drawNumber

```ml
function drawNumber(canvas, value, x, y, color)
```

Draws number through the minipixels debug debug rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/debug/debug.ml#L41)

<a id="function-function-minipixels-debug-debug-drawstats-function-drawstats-game-canvas-src-minipixels-debug-debug-ml-1449824244"></a>
### drawStats

```ml
function drawStats(game, canvas)
```

Draws stats through the minipixels debug debug rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `game` | `dynamic` | — | game value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/debug/debug.ml#L58)
