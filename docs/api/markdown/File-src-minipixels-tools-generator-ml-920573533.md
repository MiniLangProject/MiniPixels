# `src/minipixels/tools/generator.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels tools generator facilities for this project.

Package: [`minipixels.tools.generator`](Package-minipixels-tools-generator-968290761.md)

Reachable from entry: **no**

## Imports

- `minipixels/tools/fsutil.ml` as `fsu` → [src/minipixels/tools/fsutil.ml](File-src-minipixels-tools-fsutil-ml-605704885.md)
- `minipixels/tools/json.ml` as `json` → [src/minipixels/tools/json.ml](File-src-minipixels-tools-json-ml-388493918.md)
- `minipixels/tools/manifest.ml` as `manifest` → [src/minipixels/tools/manifest.ml](File-src-minipixels-tools-manifest-ml-1067201239.md)
- `std/array.ml` as `arr` → `../MiniLangCompilerML/std/array.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string_builder.ml` as `sb` → `../MiniLangCompilerML/std/string_builder.ml` — external dependency

## Declarations

<a id="function-function-minipixels-tools-generator-adderror-function-adderror-r-msg-src-minipixels-tools-generator-ml-1026990381"></a>
### addError

```ml
function addError(r, msg)
```

Adds error to the state managed by the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L42)

<a id="function-function-minipixels-tools-generator-addwarning-function-addwarning-r-msg-src-minipixels-tools-generator-ml-1682824801"></a>
### addWarning

```ml
function addWarning(r, msg)
```

Adds warning to the state managed by the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L35)

<a id="function-function-minipixels-tools-generator-arrayfield-function-arrayfield-obj-key-src-minipixels-tools-generator-ml-223697808"></a>
### arrayField

```ml
function arrayField(obj, key)
```

Performs the arrayField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L86)

<a id="function-function-minipixels-tools-generator-assetheight-function-assetheight-asset-src-minipixels-tools-generator-ml-1926826956"></a>
### assetHeight

```ml
function assetHeight(asset)
```

Performs the assetHeight operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L140)

<a id="function-function-minipixels-tools-generator-assetmodule-function-assetmodule-asset-r-src-minipixels-tools-generator-ml-757226198"></a>
### assetModule

```ml
function assetModule(asset, r)
```

Performs the assetModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L247)

<a id="function-function-minipixels-tools-generator-assetsheader-function-assetsheader-src-minipixels-tools-generator-ml-2133713956"></a>
### assetsHeader

```ml
function assetsHeader()
```

Performs the assetsHeader operation for the minipixels tools generator module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L170)

<a id="function-function-minipixels-tools-generator-assetsmodule-function-assetsmodule-root-r-src-minipixels-tools-generator-ml-187524820"></a>
### assetsModule

```ml
function assetsModule(root, r)
```

Performs the assetsModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L279)

<a id="function-function-minipixels-tools-generator-assetwidth-function-assetwidth-asset-src-minipixels-tools-generator-ml-1180867762"></a>
### assetWidth

```ml
function assetWidth(asset)
```

Performs the assetWidth operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L134)

<a id="function-function-minipixels-tools-generator-colorpart-function-colorpart-asset-key-index-fallback-src-minipixels-tools-generator-ml-3280331"></a>
### colorPart

```ml
function colorPart(asset, key, index, fallback)
```

Performs the colorPart operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L106)

<a id="function-function-minipixels-tools-generator-defaultoutdir-function-defaultoutdir-projectpath-src-minipixels-tools-generator-ml-2064768812"></a>
### defaultOutDir

```ml
function defaultOutDir(projectPath)
```

Performs the defaultOutDir operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectPath` | `dynamic` | — | Path associated with project. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L49)

<a id="function-function-minipixels-tools-generator-emitcollectioncount-function-emitcollectioncount-levels-name-key-src-minipixels-tools-generator-ml-713427575"></a>
### emitCollectionCount

```ml
function emitCollectionCount(levels, name, key)
```

Performs the emitCollectionCount operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `levels` | `dynamic` | — | levels value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L423)

<a id="function-function-minipixels-tools-generator-emitcollectionfield-function-emitcollectionfield-levels-name-key-field-functionsuffix-src-minipixels-tools-generator-ml-1571531614"></a>
### emitCollectionField

```ml
function emitCollectionField(levels, name, key, field, functionSuffix)
```

Performs the emitCollectionField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `levels` | `dynamic` | — | levels value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `field` | `dynamic` | — | field value consumed by this operation. |
| `functionSuffix` | `dynamic` | — | functionSuffix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L444)

<a id="function-function-minipixels-tools-generator-emitlevelscalar-function-emitlevelscalar-levels-fnname-key-subkey-src-minipixels-tools-generator-ml-470272978"></a>
### emitLevelScalar

```ml
function emitLevelScalar(levels, fnName, key, subkey)
```

Performs the emitLevelScalar operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `levels` | `dynamic` | — | levels value consumed by this operation. |
| `fnName` | `dynamic` | — | fnName value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `subkey` | `dynamic` | — | subkey value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L359)

<a id="function-function-minipixels-tools-generator-emittiledata-function-emittiledata-levels-src-minipixels-tools-generator-ml-846711985"></a>
### emitTileData

```ml
function emitTileData(levels)
```

Performs the emitTileData operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `levels` | `dynamic` | — | levels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L383)

<a id="function-function-minipixels-tools-generator-generate-function-generate-projectpath-outdir-src-minipixels-tools-generator-ml-1953884477"></a>
### generate

```ml
function generate(projectPath, outDir)
```

Generates generate for the minipixels tools generator workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectPath` | `dynamic` | — | Path associated with project. |
| `outDir` | `dynamic` | — | outDir value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L580)

- [minipixels.tools.generator.GenerateResult](Type-minipixels-tools-generator-generateresult-1764755755.md) — struct
<a id="function-function-minipixels-tools-generator-hassheet-function-hassheet-asset-src-minipixels-tools-generator-ml-823313442"></a>
### hasSheet

```ml
function hasSheet(asset)
```

Returns whether sheet is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L146)

<a id="function-function-minipixels-tools-generator-join-function-join-root-rel-src-minipixels-tools-generator-ml-709731783"></a>
### join

```ml
function join(root, rel)
```

Joins join for the minipixels tools generator workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |
| `rel` | `dynamic` | — | rel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L63)

<a id="function-function-minipixels-tools-generator-levelfield-function-levelfield-level-key-fallback-src-minipixels-tools-generator-ml-2126640141"></a>
### levelField

```ml
function levelField(level, key, fallback)
```

Performs the levelField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `level` | `dynamic` | — | level value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L339)

<a id="function-function-minipixels-tools-generator-levelsmodule-function-levelsmodule-m-r-src-minipixels-tools-generator-ml-2022266397"></a>
### levelsModule

```ml
function levelsModule(m, r)
```

Performs the levelsModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L490)

<a id="function-function-minipixels-tools-generator-levelsstubmodule-function-levelsstubmodule-src-minipixels-tools-generator-ml-164104188"></a>
### levelsStubModule

```ml
function levelsStubModule()
```

Performs the levelsStubModule operation for the minipixels tools generator module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L312)

<a id="function-function-minipixels-tools-generator-loadjson-function-loadjson-path-r-src-minipixels-tools-generator-ml-1466955895"></a>
### loadJson

```ml
function loadJson(path, r)
```

Loads json for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L563)

<a id="function-function-minipixels-tools-generator-numberfield-function-numberfield-obj-key-fallback-src-minipixels-tools-generator-ml-1771873920"></a>
### numberField

```ml
function numberField(obj, key, fallback)
```

Performs the numberField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L71)

<a id="function-function-minipixels-tools-generator-objectfield-function-objectfield-obj-key-src-minipixels-tools-generator-ml-1804342438"></a>
### objectField

```ml
function objectField(obj, key)
```

Performs the objectField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L95)

<a id="function-function-minipixels-tools-generator-pointfield-function-pointfield-level-key-xfallback-yfallback-src-minipixels-tools-generator-ml-1095341450"></a>
### pointField

```ml
function pointField(level, key, xFallback, yFallback)
```

Performs the pointField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `level` | `dynamic` | — | level value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `xFallback` | `dynamic` | — | xFallback value consumed by this operation. |
| `yFallback` | `dynamic` | — | yFallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L348)

<a id="function-function-minipixels-tools-generator-printresult-function-printresult-r-src-minipixels-tools-generator-ml-1897932440"></a>
### printResult

```ml
function printResult(r)
```

Prints result for the minipixels tools generator workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L613)

<a id="function-function-minipixels-tools-generator-quote-function-quote-text-src-minipixels-tools-generator-ml-156979913"></a>
### quote

```ml
function quote(text)
```

Performs the quote operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L56)

<a id="function-function-minipixels-tools-generator-result-function-result-outdir-src-minipixels-tools-generator-ml-1337540733"></a>
### result

```ml
function result(outDir)
```

Performs the result operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `outDir` | `dynamic` | — | outDir value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L28)

<a id="function-function-minipixels-tools-generator-sheetheight-function-sheetheight-asset-fallback-src-minipixels-tools-generator-ml-1862805064"></a>
### sheetHeight

```ml
function sheetHeight(asset, fallback)
```

Performs the sheetHeight operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L126)

<a id="function-function-minipixels-tools-generator-sheetmodule-function-sheetmodule-asset-id-src-minipixels-tools-generator-ml-1662660675"></a>
### sheetModule

```ml
function sheetModule(asset, id)
```

Performs the sheetModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `id` | `dynamic` | — | Stable identifier of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L153)

<a id="function-function-minipixels-tools-generator-sheetwidth-function-sheetwidth-asset-fallback-src-minipixels-tools-generator-ml-998700800"></a>
### sheetWidth

```ml
function sheetWidth(asset, fallback)
```

Performs the sheetWidth operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L117)

<a id="function-function-minipixels-tools-generator-stringfield-function-stringfield-obj-key-fallback-src-minipixels-tools-generator-ml-1788441524"></a>
### stringField

```ml
function stringField(obj, key, fallback)
```

Performs the stringField operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L79)

<a id="function-function-minipixels-tools-generator-validatelevels-function-validatelevels-r-levelsdoc-source-src-minipixels-tools-generator-ml-1441010220"></a>
### validateLevels

```ml
function validateLevels(r, levelsDoc, source)
```

Validates levels for the minipixels tools generator workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `levelsDoc` | `dynamic` | — | levelsDoc value consumed by this operation. |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L469)
