# `src/minipixels/tools/json.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels tools json facilities for this project.

Package: [`minipixels.tools.json`](Package-minipixels-tools-json-1320765334.md)

Reachable from entry: **no**

## Imports

- `std/ds/list.ml` as `list` → `../MiniLangCompilerML/std/ds/list.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerML/std/string.ml` — external dependency
- `std/string_builder.ml` as `sb` → `../MiniLangCompilerML/std/string_builder.ml` — external dependency

## Declarations

<a id="function-function-minipixels-tools-json-advance-function-advance-p-src-minipixels-tools-json-ml-1670467414"></a>
### advance

```ml
function advance(p)
```

Performs the advance operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L105)

<a id="function-function-minipixels-tools-json-array-function-array-items-src-minipixels-tools-json-ml-864087716"></a>
### array

```ml
function array(items)
```

Performs the array operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `items` | `dynamic` | — | Items consumed or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L66)

<a id="function-function-minipixels-tools-json-asbool-function-asbool-v-fallback-src-minipixels-tools-json-ml-420557818"></a>
### asBool

```ml
function asBool(v, fallback)
```

Performs the asBool operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L426)

<a id="function-function-minipixels-tools-json-asnumber-function-asnumber-v-fallback-src-minipixels-tools-json-ml-273637246"></a>
### asNumber

```ml
function asNumber(v, fallback)
```

Performs the asNumber operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L418)

<a id="function-function-minipixels-tools-json-asstring-function-asstring-v-fallback-src-minipixels-tools-json-ml-764495218"></a>
### asString

```ml
function asString(v, fallback)
```

Performs the asString operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L410)

<a id="function-function-minipixels-tools-json-at-function-at-v-index-src-minipixels-tools-json-ml-1057288724"></a>
### at

```ml
function at(v, index)
```

Performs the at operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L400)

<a id="function-function-minipixels-tools-json-atend-function-atend-p-src-minipixels-tools-json-ml-1957540310"></a>
### atEnd

```ml
function atEnd(p)
```

Performs the atEnd operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L92)

<a id="function-function-minipixels-tools-json-bool-function-bool-v-src-minipixels-tools-json-ml-62668008"></a>
### bool

```ml
function bool(v)
```

Performs the bool operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L63)

<a id="function-function-minipixels-tools-json-expect-function-expect-p-ch-msg-src-minipixels-tools-json-ml-1964869574"></a>
### expect

```ml
function expect(p, ch, msg)
```

Performs the expect operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |
| `ch` | `dynamic` | — | ch value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L164)

<a id="function-function-minipixels-tools-json-get-function-get-obj-key-src-minipixels-tools-json-ml-1778388894"></a>
### get

```ml
function get(obj, key)
```

Returns get maintained by the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L380)

<a id="function-function-minipixels-tools-json-has-function-has-obj-key-src-minipixels-tools-json-ml-63109630"></a>
### has

```ml
function has(obj, key)
```

Returns whether has is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `obj` | `dynamic` | — | obj value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L393)

<a id="function-function-minipixels-tools-json-isdigit-function-isdigit-ch-src-minipixels-tools-json-ml-660247743"></a>
### isDigit

```ml
function isDigit(ch)
```

Returns whether digit satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | ch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L80)

<a id="function-function-minipixels-tools-json-ishex-function-ishex-ch-src-minipixels-tools-json-ml-982538439"></a>
### isHex

```ml
function isHex(ch)
```

Returns whether hex satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | ch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L86)

- [minipixels.tools.json.JsonValue](Type-minipixels-tools-json-jsonvalue-550249139.md) — struct
<a id="function-function-minipixels-tools-json-lenof-function-lenof-v-src-minipixels-tools-json-ml-2089388704"></a>
### lenOf

```ml
function lenOf(v)
```

Performs the lenOf operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | v value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L433)

<a id="function-function-minipixels-tools-json-linecol-function-linecol-text-pos-src-minipixels-tools-json-ml-2113257201"></a>
### lineCol

```ml
function lineCol(text, pos)
```

Performs the lineCol operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `pos` | `dynamic` | — | pos value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L138)

<a id="function-function-minipixels-tools-json-matchliteral-function-matchliteral-p-lit-src-minipixels-tools-json-ml-1415041955"></a>
### matchLiteral

```ml
function matchLiteral(p, lit)
```

Performs the matchLiteral operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |
| `lit` | `dynamic` | — | lit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L221)

<a id="function-function-minipixels-tools-json-null-function-null-src-minipixels-tools-json-ml-102252854"></a>
### null

```ml
function null()
```

Performs the null operation for the minipixels tools json module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L54)

<a id="function-function-minipixels-tools-json-number-function-number-n-src-minipixels-tools-json-ml-228470172"></a>
### number

```ml
function number(n)
```

Performs the number operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | n value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L60)

<a id="function-function-minipixels-tools-json-object-function-object-keys-vals-src-minipixels-tools-json-ml-1249805806"></a>
### object

```ml
function object(keys, vals)
```

Performs the object operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `keys` | `dynamic` | — | keys value consumed by this operation. |
| `vals` | `dynamic` | — | vals value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L70)

<a id="function-function-minipixels-tools-json-parse-function-parse-text-src-minipixels-tools-json-ml-1119372103"></a>
### parse

```ml
function parse(text)
```

Parses parse for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L364)

<a id="function-function-minipixels-tools-json-parsearrayvalue-function-parsearrayvalue-p-src-minipixels-tools-json-ml-1850119020"></a>
### parseArrayValue

```ml
function parseArrayValue(p)
```

Parses array value for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L281)

<a id="function-function-minipixels-tools-json-parseerror-function-parseerror-p-src-minipixels-tools-json-ml-1327177078"></a>
### parseError

```ml
function parseError(p)
```

Parses error for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L156)

<a id="function-function-minipixels-tools-json-parsenumbervalue-function-parsenumbervalue-p-src-minipixels-tools-json-ml-32467182"></a>
### parseNumberValue

```ml
function parseNumberValue(p)
```

Parses number value for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L231)

<a id="function-function-minipixels-tools-json-parseobjectvalue-function-parseobjectvalue-p-src-minipixels-tools-json-ml-1178363278"></a>
### parseObjectValue

```ml
function parseObjectValue(p)
```

Parses object value for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L311)

<a id="function-function-minipixels-tools-json-parser-function-parser-text-src-minipixels-tools-json-ml-1842575709"></a>
### parser

```ml
function parser(text)
```

Performs the parser operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L74)

- [minipixels.tools.json.Parser](Type-minipixels-tools-json-parser-402899087.md) — struct
<a id="function-function-minipixels-tools-json-parsestringvalue-function-parsestringvalue-p-src-minipixels-tools-json-ml-781035314"></a>
### parseStringValue

```ml
function parseStringValue(p)
```

Parses string value for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L175)

<a id="function-function-minipixels-tools-json-parsevalue-function-parsevalue-p-src-minipixels-tools-json-ml-1531716422"></a>
### parseValue

```ml
function parseValue(p)
```

Parses value for the minipixels tools json workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L348)

<a id="function-function-minipixels-tools-json-peek-function-peek-p-src-minipixels-tools-json-ml-1391123098"></a>
### peek

```ml
function peek(p)
```

Performs the peek operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L98)

<a id="function-function-minipixels-tools-json-seterror-function-seterror-p-msg-src-minipixels-tools-json-ml-1359425151"></a>
### setError

```ml
function setError(p, msg)
```

Updates error maintained by the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L114)

<a id="function-function-minipixels-tools-json-skipwhitespace-function-skipwhitespace-p-src-minipixels-tools-json-ml-2046801998"></a>
### skipWhitespace

```ml
function skipWhitespace(p)
```

Performs the skipWhitespace operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | p value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L124)

<a id="function-function-minipixels-tools-json-string-function-string-s-src-minipixels-tools-json-ml-1943282315"></a>
### string

```ml
function string(s)
```

Performs the string operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | s value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L57)

<a id="function-function-minipixels-tools-json-value-function-value-kind-s-n-b-items-keys-vals-src-minipixels-tools-json-ml-951974765"></a>
### value

```ml
function value(kind, s, n, b, items, keys, vals)
```

Performs the value operation for the minipixels tools json module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `s` | `dynamic` | — | s value consumed by this operation. |
| `n` | `dynamic` | — | n value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |
| `items` | `dynamic` | — | Items consumed or updated by the operation. |
| `keys` | `dynamic` | — | keys value consumed by this operation. |
| `vals` | `dynamic` | — | vals value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/json.ml#L49)
