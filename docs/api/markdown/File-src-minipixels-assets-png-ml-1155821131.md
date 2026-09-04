# `src/minipixels/assets/png.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels assets png facilities for this project.

Package: [`minipixels.assets.png`](Package-minipixels-assets-png-1408634139.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-png-decode-function-decode-data-name-src-minipixels-assets-png-ml-856797033"></a>
### decode

```ml
function decode(data, name)
```

Decodes decode for the minipixels assets png workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L77)

<a id="function-function-minipixels-assets-png-hasrange-function-hasrange-data-offset-size-src-minipixels-assets-png-ml-438379508"></a>
### hasRange

```ml
function hasRange(data, offset, size)
```

Returns whether range is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `size` | `dynamic` | — | Size in the units required by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L23)

<a id="function-function-minipixels-assets-png-inflatestored-function-inflatestored-z-src-minipixels-assets-png-ml-225226070"></a>
### inflateStored

```ml
function inflateStored(z)
```

Performs the inflateStored operation for the minipixels assets png module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L36)

<a id="function-function-minipixels-assets-png-ispng-function-ispng-data-src-minipixels-assets-png-ml-1327530400"></a>
### isPng

```ml
function isPng(data)
```

Returns whether png satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L29)

<a id="constant-constant-minipixels-assets-png-png-err-const-png-err-9301-src-minipixels-assets-png-ml-1680279242"></a>
### PNG_ERR

```ml
const PNG_ERR = 9301
```

Defines the png err constant used by the minipixels assets png module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L11)

<a id="function-function-minipixels-assets-png-pngerror-function-pngerror-message-src-minipixels-assets-png-ml-691109243"></a>
### pngError

```ml
function pngError(message)
```

Performs the pngError operation for the minipixels assets png module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L15)
