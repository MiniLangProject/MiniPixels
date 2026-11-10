# `src/minipixels/assets/packed_image.ml`

[Home](README.md) · [Files](Files.md)

Prepares and loads MRI1 RGBA8888 images stored inside MPX packs.

Package: [`minipixels.assets.packed_image`](Package-minipixels-assets-packed-image-782195334.md)

Reachable from entry: **yes**

## Imports

- `minipixels/assets/png.ml` as `png` → [src/minipixels/assets/png.ml](File-src-minipixels-assets-png-ml-1155821131.md)
- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerPy/std/bytes.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-packed-image-decode-function-decode-data-name-src-minipixels-assets-packed-image-ml-661209231"></a>
### decode

```ml
function decode(data, name)
```

Loads prepared MRI1 pixels or an ordinary PNG payload from a pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete decompressed asset bytes. |
| `name` | `dynamic` | — | Image name retained by the engine. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/packed_image.ml#L38)

<a id="function-function-minipixels-assets-packed-image-encode-function-encode-width-height-pixels-src-minipixels-assets-packed-image-ml-1585596428"></a>
### encode

```ml
function encode(width, height, pixels)
```

Encodes build-prepared pixels without PNG filtering or color conversion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Pixel width. |
| `height` | `dynamic` | — | Pixel height. |
| `pixels` | `dynamic` | — | Exactly width * height * 4 RGBA8888 bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/packed_image.ml#L24)

<a id="constant-constant-minipixels-assets-packed-image-header-size-const-header-size-12-src-minipixels-assets-packed-image-ml-534005774"></a>
### HEADER_SIZE

```ml
const HEADER_SIZE = 12
```

MRI1 consists of a four-byte magic, little-endian width/height, then RGBA pixels.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/packed_image.ml#L12)

<a id="function-function-minipixels-assets-packed-image-validdimensions-function-validdimensions-width-height-src-minipixels-assets-packed-image-ml-423285873"></a>
### validDimensions

```ml
function validDimensions(width, height)
```

Validates dimensions before multiplication or pixel allocation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — |  |
| `height` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/packed_image.ml#L16)
