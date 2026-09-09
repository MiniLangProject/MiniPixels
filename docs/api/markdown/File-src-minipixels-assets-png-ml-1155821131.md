# `src/minipixels/assets/png.ml`

[Home](README.md) · [Files](Files.md)

Decodes common non-interlaced PNG images from memory or disk.

Package: [`minipixels.assets.png`](Package-minipixels-assets-png-1408634139.md)

Reachable from entry: **yes**

## Imports

- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerPy/std/bytes.ml` — external dependency
- `std/checksum/crc32.ml` as `crc` → `../MiniLangCompilerPy/std/checksum/crc32.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerPy/std/fs.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-png-adler32-function-adler32-data-src-minipixels-assets-png-ml-1397005228"></a>
### adler32

```ml
function adler32(data)
```

Computes an Adler-32 checksum over decoded zlib output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Uncompressed byte sequence. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L287)

<a id="function-function-minipixels-assets-png-alignbits-function-alignbits-reader-src-minipixels-assets-png-ml-1129393079"></a>
### alignBits

```ml
function alignBits(reader)
```

Aligns a Deflate reader to the next byte boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reader` | `dynamic` | — | Mutable bit reader. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L118)

- [minipixels.assets.png.BitReader](Type-minipixels-assets-png-bitreader-15679877.md) — struct
<a id="function-function-minipixels-assets-png-buildhuffman-function-buildhuffman-lengths-src-minipixels-assets-png-ml-1855213401"></a>
### buildHuffman

```ml
function buildHuffman(lengths)
```

Builds a canonical Huffman table from symbol bit lengths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lengths` | `dynamic` | — | Bit length for every symbol. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L125)

<a id="function-function-minipixels-assets-png-chunkis-function-chunkis-data-position-a-b-c-d-src-minipixels-assets-png-ml-1376687399"></a>
### chunkIs

```ml
function chunkIs(data, position, a, b, c, d)
```

Returns whether a PNG chunk type matches four ASCII bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | PNG byte buffer. |
| `position` | `dynamic` | — | Chunk length-field offset. |
| `a` | `dynamic` | — | First chunk-type byte. |
| `b` | `dynamic` | — | Second chunk-type byte. |
| `c` | `dynamic` | — | Third chunk-type byte. |
| `d` | `dynamic` | — | Fourth chunk-type byte. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L90)

<a id="function-function-minipixels-assets-png-decode-function-decode-data-name-src-minipixels-assets-png-ml-856797033"></a>
### decode

```ml
function decode(data, name)
```

Decodes a non-interlaced PNG byte sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete PNG file bytes. |
| `name` | `dynamic` | — | Name assigned to the decoded image. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L529)

<a id="function-function-minipixels-assets-png-decodesymbol-function-decodesymbol-reader-table-src-minipixels-assets-png-ml-675811497"></a>
### decodeSymbol

```ml
function decodeSymbol(reader, table)
```

Decodes one symbol from a canonical Deflate table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reader` | `dynamic` | — | Mutable bit reader. |
| `table` | `dynamic` | — | Canonical decoding table. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L157)

<a id="function-function-minipixels-assets-png-distancebase-function-distancebase-index-src-minipixels-assets-png-ml-501581944"></a>
### distanceBase

```ml
function distanceBase(index)
```

Returns the RFC 1951 base distance for a distance symbol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based distance-code index. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L273)

<a id="function-function-minipixels-assets-png-distanceextra-function-distanceextra-index-src-minipixels-assets-png-ml-300853202"></a>
### distanceExtra

```ml
function distanceExtra(index)
```

Returns the RFC 1951 extra-bit count for a distance symbol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based distance-code index. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L280)

<a id="function-function-minipixels-assets-png-dynamictables-function-dynamictables-reader-src-minipixels-assets-png-ml-1811664705"></a>
### dynamicTables

```ml
function dynamicTables(reader)
```

Reads dynamic Deflate Huffman tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reader` | `dynamic` | — | Mutable bit reader positioned after the block type. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L202)

<a id="function-function-minipixels-assets-png-encodechunk-function-encodechunk-chunktype-payload-src-minipixels-assets-png-ml-421197257"></a>
### encodeChunk

```ml
function encodeChunk(chunkType, payload)
```

Creates one PNG chunk including its CRC-32 checksum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `chunkType` | `dynamic` | — | Four chunk-type bytes. |
| `payload` | `dynamic` | — | Chunk payload bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L642)

<a id="function-function-minipixels-assets-png-encodergba-function-encodergba-width-height-pixels-src-minipixels-assets-png-ml-1336251350"></a>
### encodeRgba

```ml
function encodeRgba(width, height, pixels)
```

Encodes RGBA8888 pixels as a deterministic non-interlaced PNG.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Image width. |
| `height` | `dynamic` | — | Image height. |
| `pixels` | `dynamic` | — | Width-times-height RGBA byte buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L655)

<a id="function-function-minipixels-assets-png-encodestoredzlib-function-encodestoredzlib-raw-src-minipixels-assets-png-ml-1654783034"></a>
### encodeStoredZlib

```ml
function encodeStoredZlib(raw)
```

Wraps raw bytes in a zlib stream made from deterministic stored blocks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `raw` | `dynamic` | — | Uncompressed payload. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L616)

<a id="global-global-minipixels-assets-png-fixeddistancecache-fixeddistancecache-src-minipixels-assets-png-ml-2015354274"></a>
### fixedDistanceCache

```ml
fixedDistanceCache
```

Lazily initialized fixed Deflate distance table.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L21)

<a id="function-function-minipixels-assets-png-fixeddistancetable-function-fixeddistancetable-src-minipixels-assets-png-ml-1889289050"></a>
### fixedDistanceTable

```ml
function fixedDistanceTable()
```

Creates the fixed Deflate distance table.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L193)

<a id="global-global-minipixels-assets-png-fixedliteralcache-fixedliteralcache-src-minipixels-assets-png-ml-1525254432"></a>
### fixedLiteralCache

```ml
fixedLiteralCache
```

Lazily initialized fixed Deflate literal/length table.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L19)

<a id="function-function-minipixels-assets-png-fixedliteraltable-function-fixedliteraltable-src-minipixels-assets-png-ml-79156372"></a>
### fixedLiteralTable

```ml
function fixedLiteralTable()
```

Creates the fixed Deflate literal/length table.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L180)

<a id="function-function-minipixels-assets-png-hasrange-function-hasrange-data-offset-size-src-minipixels-assets-png-ml-438379508"></a>
### hasRange

```ml
function hasRange(data, offset, size)
```

Returns whether an exact byte range is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Byte buffer to inspect. |
| `offset` | `dynamic` | — | Starting byte offset. |
| `size` | `dynamic` | — | Required byte count. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L57)

- [minipixels.assets.png.Huffman](Type-minipixels-assets-png-huffman-1510650536.md) — struct
<a id="function-function-minipixels-assets-png-inflatestored-function-inflatestored-data-src-minipixels-assets-png-ml-1748811902"></a>
### inflateStored

```ml
function inflateStored(data)
```

Inflates a stored-block zlib stream for backward compatibility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete zlib stream using stored blocks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L375)

<a id="function-function-minipixels-assets-png-inflatezlib-function-inflatezlib-data-expectedsize-src-minipixels-assets-png-ml-1810611263"></a>
### inflateZlib

```ml
function inflateZlib(data, expectedSize)
```

Inflates a zlib-wrapped Deflate stream into an exact-sized output buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete zlib stream. |
| `expectedSize` | `dynamic` | — | Required uncompressed byte count. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L300)

<a id="function-function-minipixels-assets-png-integerceildivide-function-integerceildivide-value-divisor-src-minipixels-assets-png-ml-381045095"></a>
### integerCeilDivide

```ml
function integerCeilDivide(value, divisor)
```

Divides non-negative integers and rounds up while retaining an integer result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Dividend. |
| `divisor` | `dynamic` | — | Positive divisor. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L71)

<a id="function-function-minipixels-assets-png-integerdivide-function-integerdivide-value-divisor-src-minipixels-assets-png-ml-2000646097"></a>
### integerDivide

```ml
function integerDivide(value, divisor)
```

Divides non-negative integers while retaining an integer result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Dividend. |
| `divisor` | `dynamic` | — | Positive divisor. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L64)

<a id="function-function-minipixels-assets-png-ispng-function-ispng-data-src-minipixels-assets-png-ml-1327530400"></a>
### isPng

```ml
function isPng(data)
```

Returns whether bytes begin with the PNG signature.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete candidate byte buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L78)

<a id="function-function-minipixels-assets-png-lengthbase-function-lengthbase-index-src-minipixels-assets-png-ml-1325145232"></a>
### lengthBase

```ml
function lengthBase(index)
```

Returns the RFC 1951 base length for a length symbol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based length-code index. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L259)

<a id="function-function-minipixels-assets-png-lengthextra-function-lengthextra-index-src-minipixels-assets-png-ml-2103720004"></a>
### lengthExtra

```ml
function lengthExtra(index)
```

Returns the RFC 1951 extra-bit count for a length symbol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based length-code index. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L266)

<a id="function-function-minipixels-assets-png-load-function-load-path-src-minipixels-assets-png-ml-863741217"></a>
### load

```ml
function load(path)
```

Loads and decodes a PNG directly from disk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | PNG file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L608)

<a id="constant-constant-minipixels-assets-png-max-bits-const-max-bits-15-src-minipixels-assets-png-ml-770777689"></a>
### MAX_BITS

```ml
const MAX_BITS = 15
```

Maximum canonical Deflate Huffman code length.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L15)

<a id="constant-constant-minipixels-assets-png-max-image-pixels-const-max-image-pixels-67108864-src-minipixels-assets-png-ml-268515669"></a>
### MAX_IMAGE_PIXELS

```ml
const MAX_IMAGE_PIXELS = 67108864
```

Maximum decoded pixel count accepted from untrusted PNG metadata.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L17)

<a id="function-function-minipixels-assets-png-paeth-function-paeth-a-b-c-src-minipixels-assets-png-ml-2136968420"></a>
### paeth

```ml
function paeth(a, b, c)
```

Returns the PNG Paeth predictor for three neighboring bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | Left byte. |
| `b` | `dynamic` | — | Byte above. |
| `c` | `dynamic` | — | Upper-left byte. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L401)

<a id="function-function-minipixels-assets-png-paletteindex-function-paletteindex-scanlines-rowstart-x-bitdepth-src-minipixels-assets-png-ml-364938678"></a>
### paletteIndex

```ml
function paletteIndex(scanlines, rowStart, x, bitDepth)
```

Returns an indexed-color palette entry for bit depths 1, 2, 4, or 8.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scanlines` | `dynamic` | — | Reconstructed packed scanlines. |
| `rowStart` | `dynamic` | — | Starting byte offset of the row. |
| `x` | `dynamic` | — | Pixel x coordinate. |
| `bitDepth` | `dynamic` | — | Indexed sample bit depth. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L450)

<a id="constant-constant-minipixels-assets-png-png-err-const-png-err-9301-src-minipixels-assets-png-ml-1680279242"></a>
### PNG_ERR

```ml
const PNG_ERR = 9301
```

PNG decoding error code.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L13)

<a id="function-function-minipixels-assets-png-pngerror-function-pngerror-message-src-minipixels-assets-png-ml-691109243"></a>
### pngError

```ml
function pngError(message)
```

Creates a consistent PNG error value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable decoding failure. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L49)

<a id="function-function-minipixels-assets-png-readbits-function-readbits-reader-count-src-minipixels-assets-png-ml-1894129290"></a>
### readBits

```ml
function readBits(reader, count)
```

Reads bits from a Deflate stream.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reader` | `dynamic` | — | Mutable bit reader. |
| `count` | `dynamic` | — | Number of low-order bits to consume. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L98)

<a id="function-function-minipixels-assets-png-savergba-function-savergba-path-width-height-pixels-src-minipixels-assets-png-ml-905033295"></a>
### saveRgba

```ml
function saveRgba(path, width, height, pixels)
```

Saves RGBA8888 pixels to a PNG file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Destination path. |
| `width` | `dynamic` | — | Image width. |
| `height` | `dynamic` | — | Image height. |
| `pixels` | `dynamic` | — | Width-times-height RGBA byte buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L701)

<a id="function-function-minipixels-assets-png-torgba-function-torgba-scanlines-width-height-colortype-bitdepth-palette-transparency-src-minipixels-assets-png-ml-1963512957"></a>
### toRgba

```ml
function toRgba(scanlines, width, height, colorType, bitDepth, palette, transparency)
```

Converts reconstructed PNG samples into RGBA8888 pixels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scanlines` | `dynamic` | — | Reconstructed sample data. |
| `width` | `dynamic` | — | Image width. |
| `height` | `dynamic` | — | Image height. |
| `colorType` | `dynamic` | — | PNG color-type identifier. |
| `bitDepth` | `dynamic` | — | PNG sample bit depth. |
| `palette` | `dynamic` | — | Optional PLTE payload. |
| `transparency` | `dynamic` | — | Optional tRNS payload. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L466)

<a id="function-function-minipixels-assets-png-unfilter-function-unfilter-raw-widthbytes-height-bytesperpixel-src-minipixels-assets-png-ml-1290320574"></a>
### unfilter

```ml
function unfilter(raw, widthBytes, height, bytesPerPixel)
```

Reconstructs PNG scanlines for filter types 0 through 4.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `raw` | `dynamic` | — | Inflated filter bytes and row payloads. |
| `widthBytes` | `dynamic` | — | Bytes in one reconstructed row. |
| `height` | `dynamic` | — | Number of rows. |
| `bytesPerPixel` | `dynamic` | — | Filter predictor byte stride. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L419)
