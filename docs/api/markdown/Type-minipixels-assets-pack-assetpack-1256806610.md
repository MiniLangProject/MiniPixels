# `minipixels.assets.pack.AssetPack`

[Home](README.md) · [Source file](File-src-minipixels-assets-pack-ml-1157891367.md)

<a id="struct-struct-minipixels-assets-pack-assetpack-struct-assetpack-src-minipixels-assets-pack-ml-775817831"></a>
## AssetPack

```ml
struct AssetPack
```

Represents the asset pack data used by the minipixels assets pack module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L31)

## Members

<a id="field-field-minipixels-assets-pack-assetpack-bulkreads-bulkreads-src-minipixels-assets-pack-ml-728096526"></a>
### bulkReads

```ml
bulkReads
```

Number of contiguous reads issued by bulk preloading.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L89)

<a id="field-field-minipixels-assets-pack-assetpack-cachedpayloadbytes-cachedpayloadbytes-src-minipixels-assets-pack-ml-1289388372"></a>
### cachedPayloadBytes

```ml
cachedPayloadBytes
```

Bytes currently retained by the payload cache.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L83)

<a id="field-field-minipixels-assets-pack-assetpack-codecs-codecs-src-minipixels-assets-pack-ml-867224620"></a>
### codecs

```ml
codecs
```

Per-entry container compression codec.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L49)

<a id="field-field-minipixels-assets-pack-assetpack-count-count-src-minipixels-assets-pack-ml-1711272198"></a>
### count

```ml
count
```

Stores the count value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L63)

<a id="field-field-minipixels-assets-pack-assetpack-data-data-src-minipixels-assets-pack-ml-37947814"></a>
### data

```ml
data
```

Stores the data value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L35)

<a id="field-field-minipixels-assets-pack-assetpack-decodedbytes-decodedbytes-src-minipixels-assets-pack-ml-1983905400"></a>
### decodedBytes

```ml
decodedBytes
```

Logical payload bytes materialized by cache misses.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L87)

<a id="field-field-minipixels-assets-pack-assetpack-file-file-src-minipixels-assets-pack-ml-865025314"></a>
### file

```ml
file
```

Open random-access file handle used by MPX3 packs.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L37)

<a id="field-field-minipixels-assets-pack-assetpack-filebacked-filebacked-src-minipixels-assets-pack-ml-1456381014"></a>
### fileBacked

```ml
fileBacked
```

Whether payload bytes remain in the source file until first access.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L39)

<a id="field-field-minipixels-assets-pack-assetpack-imagecache-imagecache-src-minipixels-assets-pack-ml-1457634964"></a>
### imageCache

```ml
imageCache
```

Cache of decoded image objects.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L71)

<a id="field-field-minipixels-assets-pack-assetpack-imagehits-imagehits-src-minipixels-assets-pack-ml-1142138722"></a>
### imageHits

```ml
imageHits
```

Number of decoded-image cache hits.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L79)

<a id="field-field-minipixels-assets-pack-assetpack-imageloaded-imageloaded-src-minipixels-assets-pack-ml-2035815170"></a>
### imageLoaded

```ml
imageLoaded
```

Whether each image slot currently contains a decoded image.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L73)

<a id="field-field-minipixels-assets-pack-assetpack-imagemisses-imagemisses-src-minipixels-assets-pack-ml-490197346"></a>
### imageMisses

```ml
imageMisses
```

Number of image decodes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L81)

<a id="field-field-minipixels-assets-pack-assetpack-index-index-src-minipixels-assets-pack-ml-1521197782"></a>
### index

```ml
index
```

Hash index mapping names to entry slots.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L65)

<a id="field-field-minipixels-assets-pack-assetpack-key-key-src-minipixels-assets-pack-ml-1495975894"></a>
### key

```ml
key
```

AES key retained only while a lazy MPX3 pack is open.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L43)

<a id="field-field-minipixels-assets-pack-assetpack-kinds-kinds-src-minipixels-assets-pack-ml-1471208638"></a>
### kinds

```ml
kinds
```

Stores the kinds value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L47)

<a id="field-field-minipixels-assets-pack-assetpack-names-names-src-minipixels-assets-pack-ml-979745314"></a>
### names

```ml
names
```

Stores the names value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L45)

<a id="field-field-minipixels-assets-pack-assetpack-nonces-nonces-src-minipixels-assets-pack-ml-600697530"></a>
### nonces

```ml
nonces
```

Per-entry AES-GCM nonces for MPX3 payload blocks.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L57)

<a id="field-field-minipixels-assets-pack-assetpack-offsets-offsets-src-minipixels-assets-pack-ml-2049450334"></a>
### offsets

```ml
offsets
```

Stores the offsets value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L51)

<a id="field-field-minipixels-assets-pack-assetpack-owners-owners-src-minipixels-assets-pack-ml-257164018"></a>
### owners

```ml
owners
```

Canonical slot for entries that share one identical stored block.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L61)

<a id="field-field-minipixels-assets-pack-assetpack-path-path-src-minipixels-assets-pack-ml-2058340300"></a>
### path

```ml
path
```

Stores the path value associated with asset pack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L33)

<a id="field-field-minipixels-assets-pack-assetpack-payloadcache-payloadcache-src-minipixels-assets-pack-ml-724104538"></a>
### payloadCache

```ml
payloadCache
```

Cache of sliced payload byte buffers.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L67)

<a id="field-field-minipixels-assets-pack-assetpack-payloadhits-payloadhits-src-minipixels-assets-pack-ml-1809310778"></a>
### payloadHits

```ml
payloadHits
```

Number of payload-cache hits.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L75)

<a id="field-field-minipixels-assets-pack-assetpack-payloadloaded-payloadloaded-src-minipixels-assets-pack-ml-2045872526"></a>
### payloadLoaded

```ml
payloadLoaded
```

Whether each payload slot currently contains cached bytes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L69)

<a id="field-field-minipixels-assets-pack-assetpack-payloadmisses-payloadmisses-src-minipixels-assets-pack-ml-832515282"></a>
### payloadMisses

```ml
payloadMisses
```

Number of payload reads or slices.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L77)

<a id="field-field-minipixels-assets-pack-assetpack-protected-protected-src-minipixels-assets-pack-ml-106347898"></a>
### protected

```ml
protected
```

Whether payloads are independently encrypted MPX3 blocks.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L41)

<a id="field-field-minipixels-assets-pack-assetpack-sizes-sizes-src-minipixels-assets-pack-ml-2075833842"></a>
### sizes

```ml
sizes
```

Logical payload sizes where available.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L53)

<a id="field-field-minipixels-assets-pack-assetpack-storedbytesread-storedbytesread-src-minipixels-assets-pack-ml-1212362522"></a>
### storedBytesRead

```ml
storedBytesRead
```

Stored payload bytes read from the backing file.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L85)

<a id="field-field-minipixels-assets-pack-assetpack-storedsizes-storedsizes-src-minipixels-assets-pack-ml-1202092842"></a>
### storedSizes

```ml
storedSizes
```

Number of bytes stored in the backing file for each entry.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L55)

<a id="field-field-minipixels-assets-pack-assetpack-tags-tags-src-minipixels-assets-pack-ml-1553807592"></a>
### tags

```ml
tags
```

Per-entry AES-GCM authentication tags for MPX3 payload blocks.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/pack.ml#L59)
