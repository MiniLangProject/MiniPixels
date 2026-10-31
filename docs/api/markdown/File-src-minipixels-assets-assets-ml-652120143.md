# `src/minipixels/assets/assets.ml`

[Home](README.md) · [Files](Files.md)

Provides a growable, indexed, optionally lazy MiniPixels asset registry.

Package: [`minipixels.assets.assets`](Package-minipixels-assets-assets-1798617957.md)

Reachable from entry: **yes**

## Imports

- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerML/std/ds/hashmap.ml` — external dependency

## Declarations

<a id="function-function-minipixels-assets-assets-add-function-add-reg-name-value-src-minipixels-assets-assets-ml-403929218"></a>
### add

```ml
function add(reg, name, value)
```

Adds or replaces an eager asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to mutate. |
| `name` | `dynamic` | — | Stable asset name. |
| `value` | `dynamic` | — | Asset value to cache. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L126)

<a id="function-function-minipixels-assets-assets-addlazy-function-addlazy-reg-name-loader-src-minipixels-assets-assets-ml-229028220"></a>
### addLazy

```ml
function addLazy(reg, name, loader)
```

Adds or replaces a lazily created asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to mutate. |
| `name` | `dynamic` | — | Stable asset name. |
| `loader` | `dynamic` | — | Zero-argument factory returning the asset value. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L139)

- [minipixels.assets.assets.AssetRegistry](Type-minipixels-assets-assets-assetregistry-891835752.md) — struct
<a id="function-function-minipixels-assets-assets-create-function-create-capacity-src-minipixels-assets-assets-ml-352325578"></a>
### create

```ml
function create(capacity)
```

Creates a growable asset registry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `capacity` | `dynamic` | — | Initial registry capacity. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L67)

<a id="function-function-minipixels-assets-assets-ensurecapacity-function-ensurecapacity-reg-src-minipixels-assets-assets-ml-876214258"></a>
### ensureCapacity

```ml
function ensureCapacity(reg)
```

Grows registry storage when full.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to resize. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L77)

<a id="function-function-minipixels-assets-assets-ensureslot-function-ensureslot-reg-name-src-minipixels-assets-assets-ml-1514407379"></a>
### ensureSlot

```ml
function ensureSlot(reg, name)
```

Allocates a slot for a new name or returns its existing slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to mutate. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L108)

<a id="function-function-minipixels-assets-assets-get-function-get-reg-name-src-minipixels-assets-assets-ml-1319302883"></a>
### get

```ml
function get(reg, name)
```

Returns an asset and caches a successful lazy result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to inspect. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L159)

<a id="function-function-minipixels-assets-assets-has-function-has-reg-name-src-minipixels-assets-assets-ml-38453459"></a>
### has

```ml
function has(reg, name)
```

Returns whether an asset name is registered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to inspect. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L152)

<a id="function-function-minipixels-assets-assets-slotof-function-slotof-reg-name-src-minipixels-assets-assets-ml-1113594587"></a>
### slotOf

```ml
function slotOf(reg, name)
```

Returns a registered slot or -1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to inspect. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L98)

<a id="function-function-minipixels-assets-assets-unload-function-unload-reg-name-src-minipixels-assets-assets-ml-1253901111"></a>
### unload

```ml
function unload(reg, name)
```

Drops a cached lazy value while retaining its factory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to mutate. |
| `name` | `dynamic` | — | Stable asset name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L177)

<a id="function-function-minipixels-assets-assets-unloadall-function-unloadall-reg-src-minipixels-assets-assets-ml-117031674"></a>
### unloadAll

```ml
function unloadAll(reg)
```

Clears all cached lazy values while retaining registrations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reg` | `dynamic` | — | Registry to mutate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/assets/assets.ml#L187)
