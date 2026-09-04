# `src/minipixels/assets/pack.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels assets pack facilities for this project.

Package: [`minipixels.assets.pack`](Package-minipixels-assets-pack-54195661.md)

Reachable from entry: **yes**

## Imports

- `minipixels/assets/png.ml` as `png` → [src/minipixels/assets/png.ml](File-src-minipixels-assets-png-ml-1155821131.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

- [minipixels.assets.pack.AssetPack](Type-minipixels-assets-pack-assetpack-1256806610.md) — struct
<a id="function-function-minipixels-assets-pack-find-function-find-pack-name-src-minipixels-assets-pack-ml-234838308"></a>
### find

```ml
function find(pack, name)
```

Finds find used by the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L94)

<a id="function-function-minipixels-assets-pack-getbytes-function-getbytes-pack-name-src-minipixels-assets-pack-ml-1640220432"></a>
### getBytes

```ml
function getBytes(pack, name)
```

Returns bytes maintained by the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L107)

<a id="function-function-minipixels-assets-pack-getkind-function-getkind-pack-name-src-minipixels-assets-pack-ml-1649210420"></a>
### getKind

```ml
function getKind(pack, name)
```

Returns kind maintained by the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L116)

<a id="function-function-minipixels-assets-pack-hasrange-function-hasrange-data-offset-size-src-minipixels-assets-pack-ml-769445656"></a>
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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L42)

<a id="function-function-minipixels-assets-pack-ispack-function-ispack-data-src-minipixels-assets-pack-ml-36756322"></a>
### isPack

```ml
function isPack(data)
```

Returns whether pack satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L48)

<a id="function-function-minipixels-assets-pack-loadpng-function-loadpng-pack-name-src-minipixels-assets-pack-ml-1158601410"></a>
### loadPng

```ml
function loadPng(pack, name)
```

Loads png for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L125)

<a id="function-function-minipixels-assets-pack-open-function-open-path-src-minipixels-assets-pack-ml-569822995"></a>
### open

```ml
function open(path)
```

Opens open for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L55)

<a id="constant-constant-minipixels-assets-pack-pack-err-const-pack-err-9302-src-minipixels-assets-pack-ml-666599551"></a>
### PACK_ERR

```ml
const PACK_ERR = 9302
```

Defines the pack err constant used by the minipixels assets pack module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L12)

<a id="function-function-minipixels-assets-pack-packerror-function-packerror-message-src-minipixels-assets-pack-ml-16473987"></a>
### packError

```ml
function packError(message)
```

Performs the packError operation for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L34)
