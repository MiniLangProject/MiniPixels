# `src/minipixels/assets/text.ml`

[Home](README.md) · [Files](Files.md)

UTF-8 localization catalogs stored inside MiniPixels asset packs.

Package: [`minipixels.assets.text`](Package-minipixels-assets-text-1852764955.md)

Reachable from entry: **yes**

## Imports

- `minipixels/assets/pack.ml` as `packs` → [src/minipixels/assets/pack.ml](File-src-minipixels-assets-pack-ml-1157891367.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerML/std/ds/hashmap.ml` — external dependency
- `std/string.ml` as `strings` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-text-create-function-create-defaultlocale-src-minipixels-assets-text-ml-1658187789"></a>
### create

```ml
function create(defaultLocale)
```

Create a localization service with a default locale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `defaultLocale` | `dynamic` | — | Locale used when the requested catalog or key is absent. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L154)

<a id="function-function-minipixels-assets-text-decodecatalog-function-decodecatalog-data-locale-src-minipixels-assets-text-ml-1583293442"></a>
### decodeCatalog

```ml
function decodeCatalog(data, locale)
```

Decode a deterministic MPT1 catalog payload.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Encoded MPT1 bytes. |
| `locale` | `dynamic` | — | Locale assigned to the resulting catalog. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L115)

<a id="function-function-minipixels-assets-text-hasrange-function-hasrange-data-offset-size-src-minipixels-assets-text-ml-1376923648"></a>
### hasRange

```ml
function hasRange(data, offset, size)
```

Return whether a byte range lies inside the supplied buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Byte buffer. |
| `offset` | `dynamic` | — | First byte offset. |
| `size` | `dynamic` | — | Number of bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L108)

<a id="function-function-minipixels-assets-text-load-function-load-pack-name-locale-src-minipixels-assets-text-ml-1156505802"></a>
### load

```ml
function load(pack, name, locale)
```

Load a text catalog directly from an asset pack entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `name` | `dynamic` | — | Packed text asset id. |
| `locale` | `dynamic` | — | Locale assigned to the resulting catalog. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L146)

- [minipixels.assets.text.Localization](Type-minipixels-assets-text-localization-191735638.md) — struct
<a id="constant-constant-minipixels-assets-text-text-err-const-text-err-9303-src-minipixels-assets-text-ml-134791708"></a>
### TEXT_ERR

```ml
const TEXT_ERR = 9303
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L12)

- [minipixels.assets.text.TextCatalog](Type-minipixels-assets-text-textcatalog-27174823.md) — struct
<a id="function-function-minipixels-assets-text-texterror-function-texterror-message-src-minipixels-assets-text-ml-1809914603"></a>
### textError

```ml
function textError(message)
```

Create a text-catalog decoding error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable error message. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L100)
