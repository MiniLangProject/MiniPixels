# `src/minipixels/assets/pack.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels assets pack facilities for this project.

Package: [`minipixels.assets.pack`](Package-minipixels-assets-pack-54195661.md)

Reachable from entry: **yes**

## Imports

- `minipixels/assets/png.ml` as `png` → [src/minipixels/assets/png.ml](File-src-minipixels-assets-png-ml-1155821131.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/compress/lz4.ml` as `lz4` → `../MiniLangCompilerML/std/compress/lz4.ml` — external dependency
- `std/crypto.ml` as `crypto` → `../MiniLangCompilerML/std/crypto.ml` — external dependency
- `std/crypto/aes_gcm.ml` as `aes` → `../MiniLangCompilerML/std/crypto/aes_gcm.ml` — external dependency
- `std/crypto/ecdsa_p256.ml` as `ecdsa` → `../MiniLangCompilerML/std/crypto/ecdsa_p256.ml` — external dependency
- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerML/std/ds/hashmap.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/io/file.ml` as `fileio` → `../MiniLangCompilerML/std/io/file.ml` — external dependency
- `std/path.ml` as `paths` → `../MiniLangCompilerML/std/path.ml` — external dependency
- `std/process.ml` as `process` → `../MiniLangCompilerML/std/process.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-pack-decodepayload-function-decodepayload-codec-payload-expectedsize-src-minipixels-assets-pack-ml-207727389"></a>
### _decodePayload

```ml
function _decodePayload(codec, payload, expectedSize)
```

Expands one authenticated/read payload according to its index codec.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `codec` | `dynamic` | — |  |
| `payload` | `dynamic` | — |  |
| `expectedSize` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L228)

<a id="function-function-minipixels-assets-pack-decodepayloadrange-function-decodepayloadrange-codec-payload-offset-storedsize-expectedsize-src-minipixels-assets-pack-ml-1474227622"></a>
### _decodePayloadRange

```ml
function _decodePayloadRange(codec, payload, offset, storedSize, expectedSize)
```

Expands a stored payload range according to its index codec. Deflate reads directly from the supplied range into the final logical buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `codec` | `dynamic` | — |  |
| `payload` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |
| `storedSize` | `dynamic` | — |  |
| `expectedSize` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L171)

<a id="function-function-minipixels-assets-pack-decodestreampayload-function-decodestreampayload-payload-key-basenonce-expectedsize-signedhashes-src-minipixels-assets-pack-ml-1760078058"></a>
### _decodeStreamPayload

```ml
function _decodeStreamPayload(payload, key, baseNonce, expectedSize, signedHashes)
```

Decrypts a complete MPS1 payload for callers that explicitly request bytes. Normal media playback uses AssetStreamInfo and never takes this path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — |  |
| `key` | `dynamic` | — |  |
| `baseNonce` | `dynamic` | — |  |
| `expectedSize` | `dynamic` | — |  |
| `signedHashes` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L244)

<a id="function-function-minipixels-assets-pack-openfile1-function-openfile1-path-file-header-src-minipixels-assets-pack-ml-407372790"></a>
### _openFile1

```ml
function _openFile1(path, file, header)
```

Opens an MPX1 index while leaving its payloads file-backed and lazy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — |  |
| `file` | `dynamic` | — |  |
| `header` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L290)

<a id="function-function-minipixels-assets-pack-openprotected3-function-openprotected3-path-file-header-key-publickey-expectedkeyid-src-minipixels-assets-pack-ml-1178717239"></a>
### _openProtected3

```ml
function _openProtected3(path, file, header, key, publicKey, expectedKeyId)
```

Opens an MPX3 pack by authenticating and decrypting only its compact index. Payload blocks remain encrypted on disk until first access.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — |  |
| `file` | `dynamic` | — |  |
| `header` | `dynamic` | — |  |
| `key` | `dynamic` | — |  |
| `publicKey` | `dynamic` | — |  |
| `expectedKeyId` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L436)

<a id="function-function-minipixels-assets-pack-readpreloadrange-function-readpreloadrange-pack-offset-size-maxbatchbytes-src-minipixels-assets-pack-ml-1330989338"></a>
### _readPreloadRange

```ml
function _readPreloadRange(pack, offset, size, maxBatchBytes)
```

Reads directly into the final region using bounded physical reads. Large individual assets still require their full storage/decode buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |
| `size` | `dynamic` | — |  |
| `maxBatchBytes` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L713)

<a id="function-function-minipixels-assets-pack-readrange-function-readrange-file-offset-size-src-minipixels-assets-pack-ml-949562066"></a>
### _readRange

```ml
function _readRange(file, offset, size)
```

Reads an exact byte range from an open random-access file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `file` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |
| `size` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L425)

<a id="function-function-minipixels-assets-pack-readu64le-function-readu64le-data-offset-src-minipixels-assets-pack-ml-400441839"></a>
### _readU64LE

```ml
function _readU64LE(data, offset)
```

Reads one unsigned little-endian 64-bit size from an MPX3 header or index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — |  |
| `offset` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L234)

<a id="function-function-minipixels-assets-pack-sortslotsbyoffset-function-sortslotsbyoffset-pack-slots-count-src-minipixels-assets-pack-ml-1134853033"></a>
### _sortSlotsByOffset

```ml
function _sortSlotsByOffset(pack, slots, count)
```

Stable bottom-up mergesort; bounded O(n log n) even for reversed requests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — |  |
| `slots` | `dynamic` | — |  |
| `count` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L730)

- [minipixels.assets.pack.AssetPack](Type-minipixels-assets-pack-assetpack-1256806610.md) — struct
- [minipixels.assets.pack.AssetPackStats](Type-minipixels-assets-pack-assetpackstats-1911604225.md) — struct
- [minipixels.assets.pack.AssetStreamInfo](Type-minipixels-assets-pack-assetstreaminfo-1535683411.md) — struct
<a id="function-function-minipixels-assets-pack-clearcache-function-clearcache-pack-src-minipixels-assets-pack-ml-1435924141"></a>
### clearCache

```ml
function clearCache(pack)
```

Clears every derived payload and image cache while retaining the pack index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack whose caches are cleared. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L1000)

<a id="function-function-minipixels-assets-pack-close-function-close-pack-src-minipixels-assets-pack-ml-1838684689"></a>
### close

```ml
function close(pack)
```

Closes a lazy pack and wipes its retained AES key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack to close. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L1022)

<a id="constant-constant-minipixels-assets-pack-codec-deflate-const-codec-deflate-1-src-minipixels-assets-pack-ml-32061680"></a>
### CODEC_DEFLATE

```ml
const CODEC_DEFLATE = 1
```

MPC1-wrapped zlib/Deflate payload compression.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L26)

<a id="constant-constant-minipixels-assets-pack-codec-lz4-const-codec-lz4-3-src-minipixels-assets-pack-ml-706826662"></a>
### CODEC_LZ4

```ml
const CODEC_LZ4 = 3
```

MPL1-wrapped LZ4 block compression for latency-sensitive assets.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L30)

<a id="constant-constant-minipixels-assets-pack-codec-none-const-codec-none-0-src-minipixels-assets-pack-ml-1584000011"></a>
### CODEC_NONE

```ml
const CODEC_NONE = 0
```

No container-level payload compression.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L24)

<a id="constant-constant-minipixels-assets-pack-codec-rle-const-codec-rle-2-src-minipixels-assets-pack-ml-1407839533"></a>
### CODEC_RLE

```ml
const CODEC_RLE = 2
```

MPR1 byte-run compression used by the native MiniLang packer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L28)

<a id="constant-constant-minipixels-assets-pack-codec-stream-const-codec-stream-4-src-minipixels-assets-pack-ml-2044050799"></a>
### CODEC_STREAM

```ml
const CODEC_STREAM = 4
```

MPS1 chunked AES-GCM payload used for seekable protected media.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L32)

<a id="constant-constant-minipixels-assets-pack-default-preload-batch-bytes-const-default-preload-batch-bytes-16777216-src-minipixels-assets-pack-ml-446836290"></a>
### DEFAULT_PRELOAD_BATCH_BYTES

```ml
const DEFAULT_PRELOAD_BATCH_BYTES = 16777216
```

Default upper bound for one physical preload read and coalesced batch.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L40)

<a id="function-function-minipixels-assets-pack-defaultpath-function-defaultpath-src-minipixels-assets-pack-ml-1574140946"></a>
### defaultPath

```ml
function defaultPath()
```

Selects an executable-relative installed pack before development CWD paths. An existing but invalid installed pack is never replaced by a fallback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L138)

<a id="function-function-minipixels-assets-pack-droppayloadat-function-droppayloadat-pack-index-src-minipixels-assets-pack-ml-776792881"></a>
### dropPayloadAt

```ml
function dropPayloadAt(pack, index)
```

Releases only cached raw bytes for one pre-resolved slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack whose payload cache is updated. |
| `index` | `dynamic` | — | Pre-resolved entry slot. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L978)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L652)

<a id="function-function-minipixels-assets-pack-getbytes-function-getbytes-pack-name-src-minipixels-assets-pack-ml-1640220432"></a>
### getBytes

```ml
function getBytes(pack, name)
```

Returns bytes for a named entry while retaining the compatible string API.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack to read. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L888)

<a id="function-function-minipixels-assets-pack-getbytesat-function-getbytesat-pack-index-src-minipixels-assets-pack-ml-2026220673"></a>
### getBytesAt

```ml
function getBytesAt(pack, index)
```

Returns bytes maintained by the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `index` | `dynamic` | — | Pre-resolved entry slot. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L663)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L897)

<a id="function-function-minipixels-assets-pack-getkindat-function-getkindat-pack-index-src-minipixels-assets-pack-ml-1226468023"></a>
### getKindAt

```ml
function getKindAt(pack, index)
```

Returns the type code of a pre-resolved asset slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack to inspect. |
| `index` | `dynamic` | — | Pre-resolved entry slot. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L906)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L151)

<a id="function-function-minipixels-assets-pack-integerdivide-function-integerdivide-value-divisor-src-minipixels-assets-pack-ml-1632794547"></a>
### integerDivide

```ml
function integerDivide(value, divisor)
```

Divides non-negative integers while retaining an integer result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — |  |
| `divisor` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L157)

<a id="function-function-minipixels-assets-pack-ispack-function-ispack-data-src-minipixels-assets-pack-ml-36756322"></a>
### isPack

```ml
function isPack(data)
```

Returns whether pack satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L163)

<a id="function-function-minipixels-assets-pack-loadpng-function-loadpng-pack-name-src-minipixels-assets-pack-ml-1158601410"></a>
### loadPng

```ml
function loadPng(pack, name)
```

Loads and caches a named PNG image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack to read. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L969)

<a id="function-function-minipixels-assets-pack-loadpngat-function-loadpngat-pack-index-src-minipixels-assets-pack-ml-1529602909"></a>
### loadPngAt

```ml
function loadPngAt(pack, index)
```

Loads png for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `index` | `dynamic` | — | Pre-resolved entry slot. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L948)

<a id="constant-constant-minipixels-assets-pack-max-decompressed-asset-size-const-max-decompressed-asset-size-536870912-src-minipixels-assets-pack-ml-301720972"></a>
### MAX_DECOMPRESSED_ASSET_SIZE

```ml
const MAX_DECOMPRESSED_ASSET_SIZE = 536870912
```

Maximum logical size of one decompressed asset.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L38)

<a id="constant-constant-minipixels-assets-pack-max-index-size-const-max-index-size-67108864-src-minipixels-assets-pack-ml-1174233929"></a>
### MAX_INDEX_SIZE

```ml
const MAX_INDEX_SIZE = 67108864
```

Maximum encrypted index accepted before signature verification.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L22)

<a id="function-function-minipixels-assets-pack-open-function-open-path-src-minipixels-assets-pack-ml-569822995"></a>
### open

```ml
function open(path)
```

Opens an ordinary MPX1 asset pack with lazy random-access payload reads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path to the asset pack. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L412)

<a id="function-function-minipixels-assets-pack-openprotected-function-openprotected-path-key-publickey-expectedkeyid-src-minipixels-assets-pack-ml-449955844"></a>
### openProtected

```ml
function openProtected(path, key, publicKey, expectedKeyId)
```

Opens an authenticated MPX3 version-6 pack. Only its index is verified and decrypted up front; caller-owned AES key bytes are always wiped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path to the protected pack. |
| `key` | `dynamic` | — | Obfuscated build key reconstructed by generated game code. |
| `publicKey` | `dynamic` | — | Embedded 64-byte P-256 public key. |
| `expectedKeyId` | `dynamic` | — | Embedded 8-byte public-key fingerprint prefix. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L620)

<a id="constant-constant-minipixels-assets-pack-pack-err-const-pack-err-9302-src-minipixels-assets-pack-ml-666599551"></a>
### PACK_ERR

```ml
const PACK_ERR = 9302
```

Defines the pack err constant used by the minipixels assets pack module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L20)

<a id="function-function-minipixels-assets-pack-packerror-function-packerror-message-src-minipixels-assets-pack-ml-16473987"></a>
### packError

```ml
function packError(message)
```

Performs the packError operation for the minipixels assets pack module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L132)

<a id="function-function-minipixels-assets-pack-preloadall-function-preloadall-pack-maxbatchbytes-src-minipixels-assets-pack-ml-1162912906"></a>
### preloadAll

```ml
function preloadAll(pack, maxBatchBytes)
```

Preloads every payload in an asset pack through bounded contiguous reads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `maxBatchBytes` | `dynamic` | — | Maximum physical read/coalescing size, not an asset memory limit; non-positive uses the default. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L874)

<a id="function-function-minipixels-assets-pack-preloadslots-function-preloadslots-pack-slots-maxbatchbytes-src-minipixels-assets-pack-ml-820413723"></a>
### preloadSlots

```ml
function preloadSlots(pack, slots, maxBatchBytes)
```

Preloads selected asset slots with contiguous, bounded file reads. Already cached slots are skipped. File-order sorting turns a long sequence of small random reads into sequential reads without spanning unrequested gaps. Large single assets are filled directly through bounded reads but still need their storage/decode buffers; raw single-entry regions become the final cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `slots` | `dynamic` | — | Array of pre-resolved entry slots. |
| `maxBatchBytes` | `dynamic` | — | Maximum physical read/coalescing size, not an asset memory limit; non-positive uses the default. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L774)

<a id="function-function-minipixels-assets-pack-stats-function-stats-pack-src-minipixels-assets-pack-ml-122627519"></a>
### stats

```ml
function stats(pack)
```

Returns current cache hit/miss and resident-byte counters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Asset pack to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L1015)

<a id="constant-constant-minipixels-assets-pack-stream-chunk-size-const-stream-chunk-size-262144-src-minipixels-assets-pack-ml-1358590772"></a>
### STREAM_CHUNK_SIZE

```ml
const STREAM_CHUNK_SIZE = 262144
```

Fixed authenticated streaming chunk size in MPX3 version 6.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L36)

<a id="constant-constant-minipixels-assets-pack-stream-header-size-const-stream-header-size-24-src-minipixels-assets-pack-ml-384965321"></a>
### STREAM_HEADER_SIZE

```ml
const STREAM_HEADER_SIZE = 24
```

Fixed header size of one MPS1 chunked media envelope.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L34)

<a id="function-function-minipixels-assets-pack-streaminfo-function-streaminfo-pack-name-src-minipixels-assets-pack-ml-1018612080"></a>
### streamInfo

```ml
function streamInfo(pack, name)
```

Resolves a named file-backed audio/video stream.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L939)

<a id="function-function-minipixels-assets-pack-streaminfoat-function-streaminfoat-pack-index-src-minipixels-assets-pack-ml-862290221"></a>
### streamInfoAt

```ml
function streamInfoAt(pack, index)
```

Returns the file-backed range needed for native audio/video streaming. The returned key is consumed immediately by the native stream server and is never used as a complete decrypted media buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `index` | `dynamic` | — | Pre-resolved audio or video slot. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L916)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L989)
