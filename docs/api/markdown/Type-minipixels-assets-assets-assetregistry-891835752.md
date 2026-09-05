# `minipixels.assets.assets.AssetRegistry`

[Home](README.md) · [Source file](File-src-minipixels-assets-assets-ml-652120143.md)

<a id="struct-struct-minipixels-assets-assets-assetregistry-struct-assetregistry-src-minipixels-assets-assets-ml-1112008987"></a>
## AssetRegistry

```ml
struct AssetRegistry
```

Represents an indexed asset registry with optional lazy factories.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L10)

## Members

<a id="method-method-minipixels-assets-assets-assetregistry-add-function-add-name-value-src-minipixels-assets-assets-ml-1411773792"></a>
### add

```ml
function add(name, value)
```

Adds or replaces an eagerly available asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable asset name. |
| `value` | `dynamic` | — | Asset value to cache. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L29)

<a id="method-method-minipixels-assets-assets-assetregistry-addlazy-function-addlazy-name-loader-src-minipixels-assets-assets-ml-1104767410"></a>
### addLazy

```ml
function addLazy(name, loader)
```

Adds or replaces an asset created on first access.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable asset name. |
| `loader` | `dynamic` | — | Zero-argument factory returning the asset value. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L36)

<a id="field-field-minipixels-assets-assets-assetregistry-capacity-capacity-src-minipixels-assets-assets-ml-572224572"></a>
### capacity

```ml
capacity
```

Allocated registry capacity.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L18)

<a id="field-field-minipixels-assets-assets-assetregistry-count-count-src-minipixels-assets-assets-ml-630697404"></a>
### count

```ml
count
```

Number of registered assets.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L16)

<a id="method-method-minipixels-assets-assets-assetregistry-get-function-get-name-src-minipixels-assets-assets-ml-125790597"></a>
### get

```ml
function get(name)
```

Returns an asset, invoking its lazy factory at most once after success.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L42)

<a id="method-method-minipixels-assets-assets-assetregistry-getsprite-function-getsprite-name-src-minipixels-assets-assets-ml-2145386611"></a>
### getSprite

```ml
function getSprite(name)
```

Returns a sprite asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable sprite name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L48)

<a id="method-method-minipixels-assets-assets-assetregistry-has-function-has-name-src-minipixels-assets-assets-ml-40485109"></a>
### has

```ml
function has(name)
```

Returns whether an asset name is registered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L54)

<a id="field-field-minipixels-assets-assets-assetregistry-index-index-src-minipixels-assets-assets-ml-50036460"></a>
### index

```ml
index
```

Hash index mapping names to slots.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L20)

<a id="field-field-minipixels-assets-assets-assetregistry-loaded-loaded-src-minipixels-assets-assets-ml-994532182"></a>
### loaded

```ml
loaded
```

Whether each slot currently contains a cached value.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L24)

<a id="field-field-minipixels-assets-assets-assetregistry-loaders-loaders-src-minipixels-assets-assets-ml-2084071068"></a>
### loaders

```ml
loaders
```

Optional zero-argument factory associated with each slot.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L22)

<a id="field-field-minipixels-assets-assets-assetregistry-names-names-src-minipixels-assets-assets-ml-435090192"></a>
### names

```ml
names
```

Registered names retained for deterministic iteration.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L12)

<a id="method-method-minipixels-assets-assets-assetregistry-unload-function-unload-name-src-minipixels-assets-assets-ml-886843033"></a>
### unload

```ml
function unload(name)
```

Drops a cached lazy value so the next access recreates it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L60)

<a id="field-field-minipixels-assets-assets-assetregistry-values-values-src-minipixels-assets-assets-ml-655171648"></a>
### values

```ml
values
```

Cached asset values.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L14)
