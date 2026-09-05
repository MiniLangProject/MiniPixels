# `src/minipixels/tools/fsutil.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels tools fsutil facilities for this project.

Package: [`minipixels.tools.fsutil`](Package-minipixels-tools-fsutil-368541163.md)

Reachable from entry: **no**

## Imports

- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-minipixels-tools-fsutil-bytesequal-function-bytesequal-first-second-src-minipixels-tools-fsutil-ml-1514726528"></a>
### bytesEqual

```ml
function bytesEqual(first, second)
```

Returns whether two byte buffers have identical contents.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | First byte buffer. |
| `second` | `dynamic` | — | Second byte buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L57)

<a id="extern_function-extern-function-minipixels-tools-fsutil-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-returns-bool-src-minipixels-tools-fsutil-ml-1089767167"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
```

Invokes the native CreateDirectoryW entry point used by the minipixels tools fsutil module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `security` | `ptr` | — | security value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L14)

<a id="function-function-minipixels-tools-fsutil-dirname-function-dirname-path-src-minipixels-tools-fsutil-ml-896912947"></a>
### dirname

```ml
function dirname(path)
```

Performs the dirname operation for the minipixels tools fsutil module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L33)

<a id="function-function-minipixels-tools-fsutil-ensuredir-function-ensuredir-path-src-minipixels-tools-fsutil-ml-1756570909"></a>
### ensureDir

```ml
function ensureDir(path)
```

Ensures dir is available to the minipixels tools fsutil workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L44)

<a id="function-function-minipixels-tools-fsutil-maxint-function-maxint-a-b-src-minipixels-tools-fsutil-ml-545445319"></a>
### maxInt

```ml
function maxInt(a, b)
```

Performs the maxInt operation for the minipixels tools fsutil module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L26)

<a id="function-function-minipixels-tools-fsutil-mkdir-function-mkdir-path-src-minipixels-tools-fsutil-ml-1993442249"></a>
### mkdir

```ml
function mkdir(path)
```

Performs the mkdir operation for the minipixels tools fsutil module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L18)

<a id="function-function-minipixels-tools-fsutil-writebytes-function-writebytes-path-data-src-minipixels-tools-fsutil-ml-1097382007"></a>
### writeBytes

```ml
function writeBytes(path, data)
```

Writes bytes only when their contents differ from the existing file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file used by the operation. |
| `data` | `dynamic` | — | Byte payload to persist. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L70)

<a id="function-function-minipixels-tools-fsutil-writetext-function-writetext-path-text-src-minipixels-tools-fsutil-ml-719235936"></a>
### writeText

```ml
function writeText(path, text)
```

Writes text only when its contents differ from the existing file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/tools/fsutil.ml#L86)
