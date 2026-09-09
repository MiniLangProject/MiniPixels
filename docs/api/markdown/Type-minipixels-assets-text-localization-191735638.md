# `minipixels.assets.text.Localization`

[Home](README.md) · [Source file](File-src-minipixels-assets-text-ml-1300721413.md)

<a id="struct-struct-minipixels-assets-text-localization-struct-localization-src-minipixels-assets-text-ml-379147711"></a>
## Localization

```ml
struct Localization
```

Selects catalogs with regional and default-locale fallback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L33)

## Members

<a id="method-method-minipixels-assets-text-localization-add-function-add-catalog-src-minipixels-assets-text-ml-743921747"></a>
### add

```ml
function add(catalog)
```

Register or replace a locale catalog.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `catalog` | `dynamic` | — | TextCatalog to register. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L40)

<a id="field-field-minipixels-assets-text-localization-catalogs-catalogs-src-minipixels-assets-text-ml-1763442872"></a>
### catalogs

```ml
catalogs
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L34)

<a id="field-field-minipixels-assets-text-localization-defaultlocale-defaultlocale-src-minipixels-assets-text-ml-1785067692"></a>
### defaultLocale

```ml
defaultLocale
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L35)

<a id="method-method-minipixels-assets-text-localization-format-function-format-name-values-src-minipixels-assets-text-ml-422193853"></a>
### format

```ml
function format(name, values)
```

Replace numbered placeholders in translated text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Translation key. |
| `values` | `dynamic` | — | Array used for placeholders {0}, {1}, and so on. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L87)

<a id="field-field-minipixels-assets-text-localization-locale-locale-src-minipixels-assets-text-ml-802246388"></a>
### locale

```ml
locale
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L36)

<a id="method-method-minipixels-assets-text-localization-resolvecatalog-function-resolvecatalog-locale-src-minipixels-assets-text-ml-874824956"></a>
### resolveCatalog

```ml
function resolveCatalog(locale)
```

Resolve an exact, base-language, or default catalog.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `locale` | `dynamic` | — | Requested locale. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L56)

<a id="method-method-minipixels-assets-text-localization-setlocale-function-setlocale-locale-src-minipixels-assets-text-ml-784888576"></a>
### setLocale

```ml
function setLocale(locale)
```

Select the locale used by text and format lookups.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `locale` | `dynamic` | — | Locale name such as de or de-DE. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L48)

<a id="method-method-minipixels-assets-text-localization-text-function-text-name-src-minipixels-assets-text-ml-286121067"></a>
### text

```ml
function text(name)
```

Return translated text, falling back to the key when it is absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Translation key. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/text.ml#L70)
