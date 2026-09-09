# `minipixels.assets.text.TextCatalog`

[Home](README.md) · [Source file](File-src-minipixels-assets-text-ml-1300721413.md)

<a id="struct-struct-minipixels-assets-text-textcatalog-struct-textcatalog-src-minipixels-assets-text-ml-1621439097"></a>
## TextCatalog

```ml
struct TextCatalog
```

Immutable lookup table decoded from one localized MPT1 pack entry.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L15)

## Members

<a id="method-method-minipixels-assets-text-textcatalog-get-function-get-name-src-minipixels-assets-text-ml-257041394"></a>
### get

```ml
function get(name)
```

Return the localized value for a key, or void when it is absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Translation key. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L21)

<a id="method-method-minipixels-assets-text-textcatalog-has-function-has-name-src-minipixels-assets-text-ml-1919479322"></a>
### has

```ml
function has(name)
```

Return whether the catalog contains a translation key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Translation key. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L27)

<a id="field-field-minipixels-assets-text-textcatalog-locale-locale-src-minipixels-assets-text-ml-906079269"></a>
### locale

```ml
locale
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L16)

<a id="field-field-minipixels-assets-text-textcatalog-values-values-src-minipixels-assets-text-ml-231519685"></a>
### values

```ml
values
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L17)
