# `minipixels.assets.png.BitReader`

[Home](README.md) · [Source file](File-src-minipixels-assets-png-ml-1155821131.md)

<a id="struct-struct-minipixels-assets-png-bitreader-struct-bitreader-src-minipixels-assets-png-ml-325807825"></a>
## BitReader

```ml
struct BitReader
```

Mutable least-significant-bit-first Deflate reader.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L32)

## Members

<a id="field-field-minipixels-assets-png-bitreader-bitcount-bitcount-src-minipixels-assets-png-ml-221948525"></a>
### bitCount

```ml
bitCount
```

Number of buffered bits.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L40)

<a id="field-field-minipixels-assets-png-bitreader-bits-bits-src-minipixels-assets-png-ml-1378707017"></a>
### bits

```ml
bits
```

Buffered low-order bits.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L38)

<a id="field-field-minipixels-assets-png-bitreader-data-data-src-minipixels-assets-png-ml-588165265"></a>
### data

```ml
data
```

Compressed input bytes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L34)

<a id="field-field-minipixels-assets-png-bitreader-failed-failed-src-minipixels-assets-png-ml-2046640839"></a>
### failed

```ml
failed
```

Whether an invalid read occurred.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L42)

<a id="field-field-minipixels-assets-png-bitreader-position-position-src-minipixels-assets-png-ml-1821970623"></a>
### position

```ml
position
```

Next unread byte offset.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/png.ml#L36)
