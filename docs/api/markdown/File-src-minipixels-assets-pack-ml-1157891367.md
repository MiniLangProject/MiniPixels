# `src/minipixels/assets/pack.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels assets pack facilities for this project.

Package: [`minipixels.assets.pack`](Package-minipixels-assets-pack-54195661.md)

Reachable from entry: **yes**

## Imports

- `minipixels/assets/png.ml` as `png` → [src/minipixels/assets/png.ml](File-src-minipixels-assets-png-ml-1155821131.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/crypto.ml` as `crypto` → `../MiniLangCompilerML/std/crypto.ml` — external dependency
- `std/crypto/aes_gcm.ml` as `aes` → `../MiniLangCompilerML/std/crypto/aes_gcm.ml` — external dependency
- `std/crypto/ecdsa_p256.ml` as `ecdsa` → `../MiniLangCompilerML/std/crypto/ecdsa_p256.ml` — external dependency
- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerML/std/ds/hashmap.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-pack-opendata-function-opendata-path-data-src-minipixels-assets-pack-ml-1181079965"></a>
### _openData

```ml
function _openData(path, data)
```

Opens open for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `data` | `dynamic` | — | Complete MPX1 byte buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L66)

<a id="function-function-minipixels-assets-pack-readu64le-function-readu64le-data-offset-src-minipixels-assets-pack-ml-400441839"></a>
### _readU64LE

```ml
function _readU64LE(data, offset)
```

Reads one unsigned little-endian 64-bit size from an MPX2 header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L120)

- [minipixels.assets.pack.AssetPack](Type-minipixels-assets-pack-assetpack-1256806610.md) — struct
<a id="function-function-minipixels-assets-pack-clearcache-function-clearcache-pack-src-minipixels-assets-pack-ml-1435924141"></a>
### clearCache

```ml
function clearCache(pack)
```

Clears every derived payload and image cache while retaining the pack index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack whose caches are cleared. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L244)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L189)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L200)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L213)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L52)

<a id="function-function-minipixels-assets-pack-ispack-function-ispack-data-src-minipixels-assets-pack-ml-36756322"></a>
### isPack

```ml
function isPack(data)
```

Returns whether pack satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L58)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L222)

<a id="function-function-minipixels-assets-pack-open-function-open-path-src-minipixels-assets-pack-ml-569822995"></a>
### open

```ml
function open(path)
```

Opens an ordinary MPX1 asset pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path to the asset pack. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L112)

<a id="function-function-minipixels-assets-pack-openprotected-function-openprotected-path-key-publickey-expectedkeyid-src-minipixels-assets-pack-ml-449955844"></a>
### openProtected

```ml
function openProtected(path, key, publicKey, expectedKeyId)
```

Opens an authenticated and encrypted MPX2 pack. The ECDSA signature is checked before any decryption, and caller-owned AES key bytes are wiped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path to the protected pack. |
| `key` | `dynamic` | — | Obfuscated build key reconstructed by generated game code. |
| `publicKey` | `dynamic` | — | Embedded 64-byte P-256 public key. |
| `expectedKeyId` | `dynamic` | — | Embedded 8-byte public-key fingerprint prefix. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L133)

<a id="constant-constant-minipixels-assets-pack-pack-err-const-pack-err-9302-src-minipixels-assets-pack-ml-666599551"></a>
### PACK_ERR

```ml
const PACK_ERR = 9302
```

Defines the pack err constant used by the minipixels assets pack module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L16)

<a id="function-function-minipixels-assets-pack-packerror-function-packerror-message-src-minipixels-assets-pack-ml-16473987"></a>
### packError

```ml
function packError(message)
```

Performs the packError operation for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L44)

<a id="function-function-minipixels-assets-pack-unload-function-unload-pack-name-src-minipixels-assets-pack-ml-1325636868"></a>
### unload

```ml
function unload(pack, name)
```

Removes cached payload and decoded image data for one entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack whose caches are updated. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L235)
