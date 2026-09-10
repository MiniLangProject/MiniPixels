# `src/minipixels/tools/generator.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels tools generator facilities for this project.

Package: [`minipixels.tools.generator`](Package-minipixels-tools-generator-968290761.md)

Reachable from entry: **no**

## Imports

- `minipixels/assets/png.ml` as `png` → [src/minipixels/assets/png.ml](File-src-minipixels-assets-png-ml-1155821131.md)
- `minipixels/tools/fsutil.ml` as `fsu` → [src/minipixels/tools/fsutil.ml](File-src-minipixels-tools-fsutil-ml-605704885.md)
- `minipixels/tools/json.ml` as `json` → [src/minipixels/tools/json.ml](File-src-minipixels-tools-json-ml-388493918.md)
- `minipixels/tools/manifest.ml` as `manifest` → [src/minipixels/tools/manifest.ml](File-src-minipixels-tools-manifest-ml-1067201239.md)
- `std/array.ml` as `arr` → `../MiniLangCompilerML/std/array.ml` — external dependency
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/sort.ml` as `sorting` → `../MiniLangCompilerML/std/sort.ml` — external dependency
- `std/string.ml` as `strings` → `../MiniLangCompilerML/std/string.ml` — external dependency
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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L52)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L45)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L165)

<a id="function-function-minipixels-tools-generator-assetheight-function-assetheight-asset-src-minipixels-tools-generator-ml-1926826956"></a>
### assetHeight

```ml
function assetHeight(asset)
```

Performs the assetHeight operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L219)

<a id="function-function-minipixels-tools-generator-assetkind-function-assetkind-asset-src-minipixels-tools-generator-ml-918138226"></a>
### assetKind

```ml
function assetKind(asset)
```

Returns the MPX kind identifier for an asset type.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | Manifest asset object. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L266)

<a id="function-function-minipixels-tools-generator-assetless-function-assetless-left-right-src-minipixels-tools-generator-ml-1903155175"></a>
### assetLess

```ml
function assetLess(left, right)
```

Orders manifest assets by stable id for reproducible output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `dynamic` | — | First asset object. |
| `right` | `dynamic` | — | Second asset object. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L118)

<a id="function-function-minipixels-tools-generator-assetmodule-function-assetmodule-asset-r-slot-src-minipixels-tools-generator-ml-2002425790"></a>
### assetModule

```ml
function assetModule(asset, r, slot)
```

Performs the assetModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `slot` | `dynamic` | — | Stable pack slot generated for the asset. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L529)

<a id="function-function-minipixels-tools-generator-assetpayload-function-assetpayload-asset-projectroot-src-minipixels-tools-generator-ml-731560131"></a>
### assetPayload

```ml
function assetPayload(asset, projectRoot)
```

Loads or generates a payload for native MPX packaging.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | Manifest asset object. |
| `projectRoot` | `dynamic` | — | Project directory. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L320)

<a id="function-function-minipixels-tools-generator-assetsheader-function-assetsheader-fallbackpackpath-src-minipixels-tools-generator-ml-423584780"></a>
### assetsHeader

```ml
function assetsHeader(fallbackPackPath)
```

Performs the assetsHeader operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fallbackPackPath` | `dynamic` | — | Project-relative fallback path to the generated pack. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L503)

<a id="function-function-minipixels-tools-generator-assetsmodule-function-assetsmodule-root-fallbackpackpath-r-src-minipixels-tools-generator-ml-222974424"></a>
### assetsModule

```ml
function assetsModule(root, fallbackPackPath, r)
```

Performs the assetsModule operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |
| `fallbackPackPath` | `dynamic` | — | Project-relative fallback pack path. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L597)

<a id="function-function-minipixels-tools-generator-assetwidth-function-assetwidth-asset-src-minipixels-tools-generator-ml-1180867762"></a>
### assetWidth

```ml
function assetWidth(asset)
```

Performs the assetWidth operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L213)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L185)

<a id="function-function-minipixels-tools-generator-compactpayload-function-compactpayload-data-src-minipixels-tools-generator-ml-293715672"></a>
### compactPayload

```ml
function compactPayload(data)
```

Selects native RLE only when its complete envelope produces a useful saving.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L377)

<a id="function-function-minipixels-tools-generator-defaultoutdir-function-defaultoutdir-projectpath-src-minipixels-tools-generator-ml-2064768812"></a>
### defaultOutDir

```ml
function defaultOutDir(projectPath)
```

Performs the defaultOutDir operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectPath` | `dynamic` | — | Path associated with project. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L59)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L768)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L789)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L704)

<a id="function-function-minipixels-tools-generator-emittiledata-function-emittiledata-levels-src-minipixels-tools-generator-ml-846711985"></a>
### emitTileData

```ml
function emitTileData(levels)
```

Performs the emitTileData operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `levels` | `dynamic` | — | levels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L728)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L1091)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L472)

<a id="function-function-minipixels-tools-generator-identifierbytes-function-identifierbytes-text-src-minipixels-tools-generator-ml-60354221"></a>
### identifierBytes

```ml
function identifierBytes(text)
```

Encodes the manifest's ASCII-safe identifiers as bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Validated MiniLang identifier. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L93)

<a id="function-function-minipixels-tools-generator-identifiercode-function-identifiercode-ch-src-minipixels-tools-generator-ml-5394993"></a>
### identifierCode

```ml
function identifierCode(ch)
```

Returns the ASCII code of one validated identifier character.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | One-character string. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L78)

<a id="function-function-minipixels-tools-generator-integerdivide-function-integerdivide-value-divisor-src-minipixels-tools-generator-ml-530124181"></a>
### integerDivide

```ml
function integerDivide(value, divisor)
```

Divides non-negative integers while retaining an integer result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Dividend. |
| `divisor` | `dynamic` | — | Positive divisor. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L111)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L104)

<a id="function-function-minipixels-tools-generator-jsonpoint-function-jsonpoint-x-y-src-minipixels-tools-generator-ml-893405233"></a>
### jsonPoint

```ml
function jsonPoint(x, y)
```

Creates a two-dimensional JSON point object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Point x coordinate. |
| `y` | `dynamic` | — | Point y coordinate. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L881)

<a id="function-function-minipixels-tools-generator-jsontrue-function-jsontrue-value-src-minipixels-tools-generator-ml-1528192013"></a>
### jsonTrue

```ml
function jsonTrue(value)
```

Returns whether a JSON value represents true.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | JSON value to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L848)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L684)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L997)

<a id="function-function-minipixels-tools-generator-levelsstubmodule-function-levelsstubmodule-src-minipixels-tools-generator-ml-164104188"></a>
### levelsStubModule

```ml
function levelsStubModule()
```

Performs the levelsStubModule operation for the minipixels tools generator module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L657)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L1074)

<a id="function-function-minipixels-tools-generator-normalizetiled-function-normalizetiled-document-r-source-src-minipixels-tools-generator-ml-462824314"></a>
### normalizeTiled

```ml
function normalizeTiled(document, r, source)
```

Normalizes one finite CSV-encoded Tiled map into the MiniPixels level model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `document` | `dynamic` | — | Parsed Tiled map. |
| `r` | `dynamic` | — | Generation result receiving diagnostics. |
| `source` | `dynamic` | — | Source path used in diagnostics. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L889)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L150)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L174)

- [minipixels.tools.generator.PackedPayload](Type-minipixels-tools-generator-packedpayload-439377361.md) — struct
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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L693)

<a id="function-function-minipixels-tools-generator-printresult-function-printresult-r-src-minipixels-tools-generator-ml-1897932440"></a>
### printResult

```ml
function printResult(r)
```

Prints result for the minipixels tools generator workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L1140)

<a id="function-function-minipixels-tools-generator-quote-function-quote-text-src-minipixels-tools-generator-ml-156979913"></a>
### quote

```ml
function quote(text)
```

Performs the quote operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L66)

<a id="function-function-minipixels-tools-generator-quotepath-function-quotepath-text-src-minipixels-tools-generator-ml-1974716931"></a>
### quotePath

```ml
function quotePath(text)
```

Quotes a generated source path after normalizing directory separators.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Path text. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L72)

<a id="function-function-minipixels-tools-generator-renderproceduralpixels-function-renderproceduralpixels-asset-src-minipixels-tools-generator-ml-337733938"></a>
### renderProceduralPixels

```ml
function renderProceduralPixels(asset)
```

Renders one procedural manifest asset into RGBA8888 pixels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | Procedural asset object. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L225)

<a id="function-function-minipixels-tools-generator-result-function-result-outdir-src-minipixels-tools-generator-ml-1337540733"></a>
### result

```ml
function result(outDir)
```

Performs the result operation for the minipixels tools generator module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `outDir` | `dynamic` | — | outDir value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L38)

<a id="function-function-minipixels-tools-generator-rlepayload-function-rlepayload-data-src-minipixels-tools-generator-ml-2005714208"></a>
### rlePayload

```ml
function rlePayload(data)
```

Encodes repeated byte runs and bounded literal spans into an MPR1 envelope.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L333)

<a id="function-function-minipixels-tools-generator-runtimeassetmodule-function-runtimeassetmodule-asset-slot-src-minipixels-tools-generator-ml-326770682"></a>
### runtimeAssetModule

```ml
function runtimeAssetModule(asset, slot)
```

Emits an audio or generic-file accessor backed by the generated pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | Manifest asset object. |
| `slot` | `dynamic` | — | Stable pack slot generated for the asset. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L550)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L205)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L479)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L196)

<a id="function-function-minipixels-tools-generator-sortedassets-function-sortedassets-root-src-minipixels-tools-generator-ml-445878164"></a>
### sortedAssets

```ml
function sortedAssets(root)
```

Returns a sorted copy of a JSON asset array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | Parsed project root. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L134)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L158)

<a id="function-function-minipixels-tools-generator-textcatalogpayload-function-textcatalogpayload-path-src-minipixels-tools-generator-ml-539791437"></a>
### textCatalogPayload

```ml
function textCatalogPayload(path)
```

Converts a JSON string catalog into the deterministic MPT1 payload format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Source JSON file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L277)

<a id="function-function-minipixels-tools-generator-tiledlayerissolid-function-tiledlayerissolid-layer-src-minipixels-tools-generator-ml-175429249"></a>
### tiledLayerIsSolid

```ml
function tiledLayerIsSolid(layer)
```

Returns whether a Tiled tile layer is explicitly marked as collision data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layer` | `dynamic` | — | Tiled layer object. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L854)

<a id="function-function-minipixels-tools-generator-tilednumber-function-tilednumber-obj-key-fallback-src-minipixels-tools-generator-ml-1865193444"></a>
### tiledNumber

```ml
function tiledNumber(obj, key, fallback)
```

Reads an integer-valued Tiled field or property.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | Tiled object. |
| `key` | `dynamic` | — | Field or property name. |
| `fallback` | `dynamic` | — | Value used when absent. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L874)

<a id="function-function-minipixels-tools-generator-tiledobjectkind-function-tiledobjectkind-obj-src-minipixels-tools-generator-ml-266644527"></a>
### tiledObjectKind

```ml
function tiledObjectKind(obj)
```

Returns a normalized Tiled object kind.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | Tiled object. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L862)

<a id="function-function-minipixels-tools-generator-tiledproperty-function-tiledproperty-obj-key-src-minipixels-tools-generator-ml-428731166"></a>
### tiledProperty

```ml
function tiledProperty(obj, key)
```

Returns a named Tiled property or a direct object field.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | Tiled layer or object. |
| `key` | `dynamic` | — | Property name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L835)

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


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L814)

<a id="function-function-minipixels-tools-generator-writeassetpack-function-writeassetpack-root-projectroot-path-r-src-minipixels-tools-generator-ml-209076684"></a>
### writeAssetPack

```ml
function writeAssetPack(root, projectRoot, path, r)
```

Writes a deterministic native MiniPixels asset pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | Parsed project root. |
| `projectRoot` | `dynamic` | — | Project directory. |
| `path` | `dynamic` | — | Output MPX path. |
| `r` | `dynamic` | — | Generation result receiving diagnostics. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/generator.ml#L391)
