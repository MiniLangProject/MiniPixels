# `src/minipixels/tools/manifest.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels tools manifest facilities for this project.

Package: [`minipixels.tools.manifest`](Package-minipixels-tools-manifest-1949572481.md)

Reachable from entry: **no**

## Imports

- `minipixels/tools/json.ml` as `json` → [src/minipixels/tools/json.ml](File-src-minipixels-tools-json-ml-388493918.md)
- `std/array.ml` as `arr` → `../MiniLangCompilerML/std/array.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-minipixels-tools-manifest-adderror-function-adderror-m-msg-src-minipixels-tools-manifest-ml-841838020"></a>
### addError

```ml
function addError(m, msg)
```

Adds error to the state managed by the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L50)

<a id="function-function-minipixels-tools-manifest-addwarning-function-addwarning-m-msg-src-minipixels-tools-manifest-ml-1234262464"></a>
### addWarning

```ml
function addWarning(m, msg)
```

Adds warning to the state managed by the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L57)

<a id="function-function-minipixels-tools-manifest-containsstring-function-containsstring-items-value-src-minipixels-tools-manifest-ml-2031850845"></a>
### containsString

```ml
function containsString(items, value)
```

Returns whether the supplied data contains string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `items` | `dynamic` | — | Items consumed or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L110)

<a id="function-function-minipixels-tools-manifest-dirname-function-dirname-path-src-minipixels-tools-manifest-ml-264369667"></a>
### dirname

```ml
function dirname(path)
```

Performs the dirname operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L77)

<a id="function-function-minipixels-tools-manifest-isvalid-function-isvalid-m-src-minipixels-tools-manifest-ml-1577894917"></a>
### isValid

```ml
function isValid(m)
```

Returns whether valid satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L63)

<a id="function-function-minipixels-tools-manifest-join-function-join-root-rel-src-minipixels-tools-manifest-ml-2078359205"></a>
### join

```ml
function join(root, rel)
```

Joins join for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |
| `rel` | `dynamic` | — | rel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L89)

<a id="function-function-minipixels-tools-manifest-load-function-load-path-src-minipixels-tools-manifest-ml-1065554379"></a>
### load

```ml
function load(path)
```

Loads load for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L339)

- [minipixels.tools.manifest.Manifest](Type-minipixels-tools-manifest-manifest-62751308.md) — struct
<a id="function-function-minipixels-tools-manifest-maxint-function-maxint-a-b-src-minipixels-tools-manifest-ml-529438451"></a>
### maxInt

```ml
function maxInt(a, b)
```

Performs the maxInt operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L70)

<a id="function-function-minipixels-tools-manifest-newmanifest-function-newmanifest-path-root-src-minipixels-tools-manifest-ml-1555835233"></a>
### newManifest

```ml
function newManifest(path, root)
```

Creates manifest for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L43)

<a id="function-function-minipixels-tools-manifest-numberfield-function-numberfield-m-obj-key-required-fallback-src-minipixels-tools-manifest-ml-1096271560"></a>
### numberField

```ml
function numberField(m, obj, key, required, fallback)
```

Performs the numberField operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `required` | `dynamic` | — | required value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L155)

<a id="function-function-minipixels-tools-manifest-parsetext-function-parsetext-text-source-root-src-minipixels-tools-manifest-ml-1441810850"></a>
### parseText

```ml
function parseText(text, source, root)
```

Parses text for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L327)

<a id="function-function-minipixels-tools-manifest-printreport-function-printreport-m-src-minipixels-tools-manifest-ml-960629759"></a>
### printReport

```ml
function printReport(m)
```

Prints report for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L352)

<a id="function-function-minipixels-tools-manifest-requirefield-function-requirefield-m-obj-key-src-minipixels-tools-manifest-ml-138594909"></a>
### requireField

```ml
function requireField(m, obj, key)
```

Performs the requireField operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L123)

<a id="function-function-minipixels-tools-manifest-safeidentifier-function-safeidentifier-id-src-minipixels-tools-manifest-ml-2025223973"></a>
### safeIdentifier

```ml
function safeIdentifier(id)
```

Performs the safeIdentifier operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L95)

<a id="function-function-minipixels-tools-manifest-stringfield-function-stringfield-m-obj-key-required-src-minipixels-tools-manifest-ml-438859378"></a>
### stringField

```ml
function stringField(m, obj, key, required)
```

Performs the stringField operation for the minipixels tools manifest module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `required` | `dynamic` | — | required value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L136)

<a id="function-function-minipixels-tools-manifest-validateasset-function-validateasset-m-asset-seen-src-minipixels-tools-manifest-ml-1965574238"></a>
### validateAsset

```ml
function validateAsset(m, asset, seen)
```

Validates asset for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `seen` | `dynamic` | — | seen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L178)

<a id="function-function-minipixels-tools-manifest-validateassets-function-validateassets-m-root-src-minipixels-tools-manifest-ml-88321205"></a>
### validateAssets

```ml
function validateAssets(m, root)
```

Validates assets for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L238)

<a id="function-function-minipixels-tools-manifest-validatelevels-function-validatelevels-m-root-src-minipixels-tools-manifest-ml-1903826297"></a>
### validateLevels

```ml
function validateLevels(m, root)
```

Validates levels for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L256)

<a id="function-function-minipixels-tools-manifest-validateroot-function-validateroot-m-root-src-minipixels-tools-manifest-ml-1770268961"></a>
### validateRoot

```ml
function validateRoot(m, root)
```

Validates root for the minipixels tools manifest workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L273)

<a id="function-function-minipixels-tools-manifest-validcompressionprofile-function-validcompressionprofile-value-src-minipixels-tools-manifest-ml-1793777077"></a>
### validCompressionProfile

```ml
function validCompressionProfile(value)
```

Returns whether a container compression profile is supported.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/manifest.ml#L170)
