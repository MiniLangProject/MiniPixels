# `src/minipixels/platform/windows.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels platform windows facilities for this project.

Package: [`minipixels.platform.windows`](Package-minipixels-platform-windows-647622739.md)

Reachable from entry: **yes**

## Imports

- `minipixels/input/input.ml` as `inp` → [src/minipixels/input/input.ml](File-src-minipixels-input-input-ml-1476207415.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="global-global-minipixels-platform-windows-activeopenglcontext-activeopenglcontext-src-minipixels-platform-windows-ml-1709100368"></a>
### activeOpenGLContext

```ml
activeOpenGLContext
```

OpenGL context MiniPixels most recently made current on this thread.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L346)

<a id="function-function-minipixels-platform-windows-applytexturefilter-function-applytexturefilter-w-src-minipixels-platform-windows-ml-2147080741"></a>
### applyTextureFilter

```ml
function applyTextureFilter(w)
```

Performs the applyTextureFilter operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L878)

<a id="constant-constant-minipixels-platform-windows-bi-bitfields-const-bi-bitfields-3-src-minipixels-platform-windows-ml-1521755672"></a>
### BI_BITFIELDS

```ml
const BI_BITFIELDS = 3
```

Defines the bi bitfields constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L37)

<a id="constant-constant-minipixels-platform-windows-blackness-const-blackness-66-src-minipixels-platform-windows-ml-253594027"></a>
### BLACKNESS

```ml
const BLACKNESS = 66
```

Defines the blackness constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L79)

<a id="extern_function-extern-function-minipixels-platform-windows-choosepixelformat-extern-function-choosepixelformat-dc-as-ptr-pfd-as-bytes-from-gdi32-dll-returns-int-src-minipixels-platform-windows-ml-160230700"></a>
### ChoosePixelFormat

```ml
extern function ChoosePixelFormat(dc as ptr, pfd as bytes) from "gdi32.dll" returns int
```

Invokes the native ChoosePixelFormat entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `pfd` | `bytes` | — | pfd value consumed by this operation. |


**Returns:** Native int result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L239)

<a id="function-function-minipixels-platform-windows-clientheight-function-clientheight-w-src-minipixels-platform-windows-ml-1214474653"></a>
### clientHeight

```ml
function clientHeight(w)
```

Performs the clientHeight operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L777)

<a id="function-function-minipixels-platform-windows-clientwidth-function-clientwidth-w-src-minipixels-platform-windows-ml-638520075"></a>
### clientWidth

```ml
function clientWidth(w)
```

Returns the current client-area width.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L769)

<a id="function-function-minipixels-platform-windows-close-function-close-w-src-minipixels-platform-windows-ml-1000963621"></a>
### close

```ml
function close(w)
```

Closes close owned by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L613)

<a id="function-function-minipixels-platform-windows-consumemousewheel-function-consumemousewheel-src-minipixels-platform-windows-ml-273982854"></a>
### consumeMouseWheel

```ml
function consumeMouseWheel()
```

Consumes wheel steps accumulated by the window callback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L720)

<a id="function-function-minipixels-platform-windows-createbitmapinfo-function-createbitmapinfo-width-height-src-minipixels-platform-windows-ml-629354415"></a>
### createBitmapInfo

```ml
function createBitmapInfo(width, height)
```

Creates bitmap info for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L508)

<a id="function-function-minipixels-platform-windows-createpixelformatdescriptor-function-createpixelformatdescriptor-src-minipixels-platform-windows-ml-160177046"></a>
### createPixelFormatDescriptor

```ml
function createPixelFormatDescriptor()
```

Creates pixel format descriptor for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L524)

<a id="extern_function-extern-function-minipixels-platform-windows-createwindowexw-extern-function-createwindowexw-exstyle-as-int-classname-as-ptr-windowname-as-wstr-style-as-int-x-as-int-y-as-int-w-as-int-h-as-int-parent-as-ptr-menu-as-ptr-instance-as-ptr-param-as-ptr-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-978331506"></a>
### CreateWindowExW

```ml
extern function CreateWindowExW(exStyle as int, className as ptr, windowName as wstr, style as int, x as int, y as int, w as int, h as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" returns ptr
```

Invokes the native CreateWindowExW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exStyle` | `int` | — | exStyle value consumed by this operation. |
| `className` | `ptr` | — | className value consumed by this operation. |
| `windowName` | `wstr` | — | windowName value consumed by this operation. |
| `style` | `int` | — | style value consumed by this operation. |
| `x` | `int` | — | Horizontal coordinate used by the operation. |
| `y` | `int` | — | Vertical coordinate used by the operation. |
| `w` | `int` | — | w value consumed by this operation. |
| `h` | `int` | — | h value consumed by this operation. |
| `parent` | `ptr` | — | parent value consumed by this operation. |
| `menu` | `ptr` | — | menu value consumed by this operation. |
| `instance` | `ptr` | — | instance value consumed by this operation. |
| `param` | `ptr` | — | param value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L121)

<a id="constant-constant-minipixels-platform-windows-cs-owndc-const-cs-owndc-32-src-minipixels-platform-windows-ml-427250570"></a>
### CS_OWNDC

```ml
const CS_OWNDC = 32
```

Defines the cs owndc constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L23)

<a id="constant-constant-minipixels-platform-windows-cw-usedefault-const-cw-usedefault-2147483648-src-minipixels-platform-windows-ml-1363175088"></a>
### CW_USEDEFAULT

```ml
const CW_USEDEFAULT = 2147483648
```

Defines the cw usedefault constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L29)

<a id="extern_function-extern-function-minipixels-platform-windows-defwindowprocw-extern-function-defwindowprocw-hwnd-as-ptr-msg-as-u32-wparam-as-ptr-lparam-as-ptr-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-865229917"></a>
### DefWindowProcW

```ml
extern function DefWindowProcW(hwnd as ptr, msg as u32, wParam as ptr, lParam as ptr) from "user32.dll" returns ptr
```

Invokes the native DefWindowProcW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `msg` | `u32` | — | msg value consumed by this operation. |
| `wParam` | `ptr` | — | wParam value consumed by this operation. |
| `lParam` | `ptr` | — | lParam value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L128)

<a id="extern_function-extern-function-minipixels-platform-windows-destroywindow-extern-function-destroywindow-hwnd-as-ptr-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1006722765"></a>
### DestroyWindow

```ml
extern function DestroyWindow(hwnd as ptr) from "user32.dll" returns bool
```

Invokes the native DestroyWindow entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L132)

<a id="constant-constant-minipixels-platform-windows-dib-rgb-colors-const-dib-rgb-colors-0-src-minipixels-platform-windows-ml-1129623439"></a>
### DIB_RGB_COLORS

```ml
const DIB_RGB_COLORS = 0
```

Defines the dib rgb colors constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L35)

<a id="extern_function-extern-function-minipixels-platform-windows-dispatchmessagew-extern-function-dispatchmessagew-msg-as-bytes-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-1660803358"></a>
### DispatchMessageW

```ml
extern function DispatchMessageW(msg as bytes) from "user32.dll" returns ptr
```

Invokes the native DispatchMessageW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | msg value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L174)

<a id="function-function-minipixels-platform-windows-ensureopengltexture-function-ensureopengltexture-w-canvas-src-minipixels-platform-windows-ml-405927349"></a>
### ensureOpenGLTexture

```ml
function ensureOpenGLTexture(w, canvas)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `canvas` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L941)

<a id="extern_function-extern-function-minipixels-platform-windows-getasynckeystate-extern-function-getasynckeystate-key-as-int-from-user32-dll-returns-i32-src-minipixels-platform-windows-ml-2035415046"></a>
### GetAsyncKeyState

```ml
extern function GetAsyncKeyState(key as int) from "user32.dll" returns i32
```

Invokes the native GetAsyncKeyState entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `int` | — | key value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L178)

<a id="extern_function-extern-function-minipixels-platform-windows-getclientrect-extern-function-getclientrect-hwnd-as-ptr-rect-as-bytes-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1777362596"></a>
### GetClientRect

```ml
extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" returns bool
```

Invokes the native GetClientRect entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `rect` | `bytes` | — | rect value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L186)

<a id="extern_function-extern-function-minipixels-platform-windows-getconsolewindow-extern-function-getconsolewindow-from-kernel32-dll-returns-ptr-src-minipixels-platform-windows-ml-1473478058"></a>
### GetConsoleWindow

```ml
extern function GetConsoleWindow() from "kernel32.dll" returns ptr
```

Invokes the native GetConsoleWindow entry point used by the minipixels platform windows module.


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L87)

<a id="extern_function-extern-function-minipixels-platform-windows-getcursorpos-extern-function-getcursorpos-point-as-bytes-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1568182643"></a>
### GetCursorPos

```ml
extern function GetCursorPos(point as bytes) from "user32.dll" returns bool
```

Reads the current pointer position in screen coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `bytes` | — | Eight-byte POINT destination. |


**Returns:** Whether the pointer position was read.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L190)

<a id="extern_function-extern-function-minipixels-platform-windows-getdc-extern-function-getdc-hwnd-as-ptr-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-1274711817"></a>
### GetDC

```ml
extern function GetDC(hwnd as ptr) from "user32.dll" returns ptr
```

Invokes the native GetDC entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L199)

<a id="extern_function-extern-function-minipixels-platform-windows-getforegroundwindow-extern-function-getforegroundwindow-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-1743046030"></a>
### GetForegroundWindow

```ml
extern function GetForegroundWindow() from "user32.dll" returns ptr
```

Invokes the native GetForegroundWindow entry point used by the minipixels platform windows module.


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L181)

<a id="function-function-minipixels-platform-windows-geti32-function-geti32-buf-off-src-minipixels-platform-windows-ml-737074136"></a>
### getI32

```ml
function getI32(buf, off)
```

Returns a signed 32-bit integer stored in a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buffer containing the encoded integer. |
| `off` | `dynamic` | — | Byte offset of the encoded integer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L445)

<a id="extern_function-extern-function-minipixels-platform-windows-getmodulehandlew-extern-function-getmodulehandlew-name-as-ptr-from-kernel32-dll-returns-ptr-src-minipixels-platform-windows-ml-1691831917"></a>
### GetModuleHandleW

```ml
extern function GetModuleHandleW(name as ptr) from "kernel32.dll" returns ptr
```

Invokes the native GetModuleHandleW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `ptr` | — | Name of the affected item. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L84)

<a id="extern_function-extern-function-minipixels-platform-windows-gettickcount64-extern-function-gettickcount64-from-kernel32-dll-returns-u64-src-minipixels-platform-windows-ml-1585985961"></a>
### GetTickCount64

```ml
extern function GetTickCount64() from "kernel32.dll" returns u64
```

Invokes the native GetTickCount64 entry point used by the minipixels platform windows module.


**Returns:** Native u64 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L90)

<a id="function-function-minipixels-platform-windows-getu32-function-getu32-buf-off-src-minipixels-platform-windows-ml-1871320496"></a>
### getU32

```ml
function getU32(buf, off)
```

Returns u32 maintained by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | buf value consumed by this operation. |
| `off` | `dynamic` | — | off value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L438)

<a id="function-function-minipixels-platform-windows-getu64-function-getu64-buf-off-src-minipixels-platform-windows-ml-2042778668"></a>
### getU64

```ml
function getU64(buf, off)
```

Returns an unsigned 64-bit integer stored in a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buffer containing the encoded integer. |
| `off` | `dynamic` | — | Byte offset of the encoded integer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L454)

<a id="constant-constant-minipixels-platform-windows-gl-clamp-const-gl-clamp-10496-src-minipixels-platform-windows-ml-1902515937"></a>
### GL_CLAMP

```ml
const GL_CLAMP = 10496
```

Defines the gl clamp constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L67)

<a id="constant-constant-minipixels-platform-windows-gl-nearest-const-gl-nearest-9728-src-minipixels-platform-windows-ml-597353775"></a>
### GL_NEAREST

```ml
const GL_NEAREST = 9728
```

Defines the gl nearest constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L65)

<a id="constant-constant-minipixels-platform-windows-gl-quads-const-gl-quads-7-src-minipixels-platform-windows-ml-1339779096"></a>
### GL_QUADS

```ml
const GL_QUADS = 7
```

Defines the gl quads constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L77)

<a id="constant-constant-minipixels-platform-windows-gl-rgba-const-gl-rgba-6408-src-minipixels-platform-windows-ml-1126611333"></a>
### GL_RGBA

```ml
const GL_RGBA = 6408
```

Defines the gl rgba constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L53)

<a id="constant-constant-minipixels-platform-windows-gl-texture-2d-const-gl-texture-2d-3553-src-minipixels-platform-windows-ml-1671612943"></a>
### GL_TEXTURE_2D

```ml
const GL_TEXTURE_2D = 3553
```

Defines the gl texture 2 d constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L51)

<a id="constant-constant-minipixels-platform-windows-gl-texture-mag-filter-const-gl-texture-mag-filter-10240-src-minipixels-platform-windows-ml-974572746"></a>
### GL_TEXTURE_MAG_FILTER

```ml
const GL_TEXTURE_MAG_FILTER = 10240
```

Defines the gl texture mag filter constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L57)

<a id="constant-constant-minipixels-platform-windows-gl-texture-min-filter-const-gl-texture-min-filter-10241-src-minipixels-platform-windows-ml-1611056671"></a>
### GL_TEXTURE_MIN_FILTER

```ml
const GL_TEXTURE_MIN_FILTER = 10241
```

Defines the gl texture min filter constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L59)

<a id="constant-constant-minipixels-platform-windows-gl-texture-wrap-s-const-gl-texture-wrap-s-10242-src-minipixels-platform-windows-ml-1061984656"></a>
### GL_TEXTURE_WRAP_S

```ml
const GL_TEXTURE_WRAP_S = 10242
```

Defines the gl texture wrap s constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L61)

<a id="constant-constant-minipixels-platform-windows-gl-texture-wrap-t-const-gl-texture-wrap-t-10243-src-minipixels-platform-windows-ml-1891919441"></a>
### GL_TEXTURE_WRAP_T

```ml
const GL_TEXTURE_WRAP_T = 10243
```

Defines the gl texture wrap t constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L63)

<a id="constant-constant-minipixels-platform-windows-gl-unpack-alignment-const-gl-unpack-alignment-3317-src-minipixels-platform-windows-ml-1355504569"></a>
### GL_UNPACK_ALIGNMENT

```ml
const GL_UNPACK_ALIGNMENT = 3317
```

Defines the gl unpack alignment constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L69)

<a id="constant-constant-minipixels-platform-windows-gl-unpack-row-length-const-gl-unpack-row-length-3314-src-minipixels-platform-windows-ml-405892548"></a>
### GL_UNPACK_ROW_LENGTH

```ml
const GL_UNPACK_ROW_LENGTH = 3314
```

Defines source row length for partial texture uploads.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L71)

<a id="constant-constant-minipixels-platform-windows-gl-unpack-skip-pixels-const-gl-unpack-skip-pixels-3316-src-minipixels-platform-windows-ml-1515704208"></a>
### GL_UNPACK_SKIP_PIXELS

```ml
const GL_UNPACK_SKIP_PIXELS = 3316
```

Defines source pixels skipped for partial texture uploads.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L75)

<a id="constant-constant-minipixels-platform-windows-gl-unpack-skip-rows-const-gl-unpack-skip-rows-3315-src-minipixels-platform-windows-ml-2111098359"></a>
### GL_UNPACK_SKIP_ROWS

```ml
const GL_UNPACK_SKIP_ROWS = 3315
```

Defines source rows skipped for partial texture uploads.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L73)

<a id="constant-constant-minipixels-platform-windows-gl-unsigned-byte-const-gl-unsigned-byte-5121-src-minipixels-platform-windows-ml-355224600"></a>
### GL_UNSIGNED_BYTE

```ml
const GL_UNSIGNED_BYTE = 5121
```

Defines the gl unsigned byte constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L55)

<a id="extern_function-extern-function-minipixels-platform-windows-glbegin-extern-function-glbegin-mode-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1332960826"></a>
### glBegin

```ml
extern function glBegin(mode as int) from "opengl32.dll" returns void
```

Invokes the native glBegin entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `int` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L321)

<a id="extern_function-extern-function-minipixels-platform-windows-glbindtexture-extern-function-glbindtexture-target-as-int-texture-as-u32-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-644172833"></a>
### glBindTexture

```ml
extern function glBindTexture(target as int, texture as u32) from "opengl32.dll" returns void
```

Invokes the native glBindTexture entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `int` | — | target value consumed by this operation. |
| `texture` | `u32` | — | texture value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L291)

<a id="extern_function-extern-function-minipixels-platform-windows-glcolor3ub-extern-function-glcolor3ub-r-as-int-g-as-int-b-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1147966672"></a>
### glColor3ub

```ml
extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" returns void
```

Invokes the native glColor3ub entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `int` | — | r value consumed by this operation. |
| `g` | `int` | — | g value consumed by this operation. |
| `b` | `int` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L279)

<a id="extern_function-extern-function-minipixels-platform-windows-gldisable-extern-function-gldisable-cap-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-287648249"></a>
### glDisable

```ml
extern function glDisable(cap as int) from "opengl32.dll" returns void
```

Invokes the native glDisable entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cap` | `int` | — | cap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L274)

<a id="extern_function-extern-function-minipixels-platform-windows-glenable-extern-function-glenable-cap-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-356259237"></a>
### glEnable

```ml
extern function glEnable(cap as int) from "opengl32.dll" returns void
```

Invokes the native glEnable entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cap` | `int` | — | cap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L271)

<a id="extern_function-extern-function-minipixels-platform-windows-glend-extern-function-glend-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1700915702"></a>
### glEnd

```ml
extern function glEnd() from "opengl32.dll" returns void
```

Invokes the native glEnd entry point used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L323)

<a id="extern_function-extern-function-minipixels-platform-windows-glgentextures-extern-function-glgentextures-count-as-int-textures-as-bytes-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1724473323"></a>
### glGenTextures

```ml
extern function glGenTextures(count as int, textures as bytes) from "opengl32.dll" returns void
```

Invokes the native glGenTextures entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `int` | — | Number of items or units to process. |
| `textures` | `bytes` | — | textures value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L287)

<a id="extern_function-extern-function-minipixels-platform-windows-glpixelstorei-extern-function-glpixelstorei-name-as-int-param-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-791000736"></a>
### glPixelStorei

```ml
extern function glPixelStorei(name as int, param as int) from "opengl32.dll" returns void
```

Invokes the native glPixelStorei entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `int` | — | Name of the affected item. |
| `param` | `int` | — | param value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L283)

<a id="extern_function-extern-function-minipixels-platform-windows-gltexcoord2d-extern-function-gltexcoord2d-s-as-double-t-as-double-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1301131339"></a>
### glTexCoord2d

```ml
extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" returns void
```

Invokes the native glTexCoord2d entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `double` | — | s value consumed by this operation. |
| `t` | `double` | — | t value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L327)

<a id="extern_function-extern-function-minipixels-platform-windows-glteximage2d-extern-function-glteximage2d-target-as-int-level-as-int-internalformat-as-int-width-as-int-height-as-int-border-as-int-format-as-int-typ-as-int-pixels-as-bytes-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1245282084"></a>
### glTexImage2D

```ml
extern function glTexImage2D(target as int, level as int, internalFormat as int, width as int, height as int, border as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
```

Invokes the native glTexImage2D entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `int` | — | target value consumed by this operation. |
| `level` | `int` | — | level value consumed by this operation. |
| `internalFormat` | `int` | — | internalFormat value consumed by this operation. |
| `width` | `int` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `int` | — | Height in the coordinate or storage units used by the caller. |
| `border` | `int` | — | border value consumed by this operation. |
| `format` | `int` | — | format value consumed by this operation. |
| `typ` | `int` | — | typ value consumed by this operation. |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L307)

<a id="extern_function-extern-function-minipixels-platform-windows-gltexparameteri-extern-function-gltexparameteri-target-as-int-name-as-int-param-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-263795146"></a>
### glTexParameteri

```ml
extern function glTexParameteri(target as int, name as int, param as int) from "opengl32.dll" returns void
```

Invokes the native glTexParameteri entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `int` | — | target value consumed by this operation. |
| `name` | `int` | — | Name of the affected item. |
| `param` | `int` | — | param value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L296)

<a id="extern_function-extern-function-minipixels-platform-windows-gltexsubimage2d-extern-function-gltexsubimage2d-target-as-int-level-as-int-xoffset-as-int-yoffset-as-int-width-as-int-height-as-int-format-as-int-typ-as-int-pixels-as-bytes-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1163950585"></a>
### glTexSubImage2D

```ml
extern function glTexSubImage2D(target as int, level as int, xoffset as int, yoffset as int, width as int, height as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
```

Invokes the native glTexSubImage2D entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `int` | — | target value consumed by this operation. |
| `level` | `int` | — | level value consumed by this operation. |
| `xoffset` | `int` | — | xoffset value consumed by this operation. |
| `yoffset` | `int` | — | yoffset value consumed by this operation. |
| `width` | `int` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `int` | — | Height in the coordinate or storage units used by the caller. |
| `format` | `int` | — | format value consumed by this operation. |
| `typ` | `int` | — | typ value consumed by this operation. |
| `pixels` | `bytes` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L318)

<a id="extern_function-extern-function-minipixels-platform-windows-glvertex2i-extern-function-glvertex2i-x-as-int-y-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1103500729"></a>
### glVertex2i

```ml
extern function glVertex2i(x as int, y as int) from "opengl32.dll" returns void
```

Invokes the native glVertex2i entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — | Horizontal coordinate used by the operation. |
| `y` | `int` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L331)

<a id="extern_function-extern-function-minipixels-platform-windows-glviewport-extern-function-glviewport-x-as-int-y-as-int-width-as-int-height-as-int-from-opengl32-dll-returns-void-src-minipixels-platform-windows-ml-1804859456"></a>
### glViewport

```ml
extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" returns void
```

Invokes the native glViewport entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — | Horizontal coordinate used by the operation. |
| `y` | `int` | — | Vertical coordinate used by the operation. |
| `width` | `int` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `int` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L268)

<a id="function-function-minipixels-platform-windows-hasfocus-function-hasfocus-w-src-minipixels-platform-windows-ml-23980893"></a>
### hasFocus

```ml
function hasFocus(w)
```

Returns whether focus is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L681)

<a id="constant-constant-minipixels-platform-windows-idc-arrow-const-idc-arrow-32512-src-minipixels-platform-windows-ml-1946490360"></a>
### IDC_ARROW

```ml
const IDC_ARROW = 32512
```

Defines the idc arrow constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L31)

<a id="function-function-minipixels-platform-windows-initopengl-function-initopengl-w-src-minipixels-platform-windows-ml-560913305"></a>
### initOpenGL

```ml
function initOpenGL(w)
```

Performs the initOpenGL operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L887)

<a id="function-function-minipixels-platform-windows-isgpurenderer-function-isgpurenderer-w-src-minipixels-platform-windows-ml-1839018755"></a>
### isGpuRenderer

```ml
function isGpuRenderer(w)
```

Returns whether gpu renderer satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L641)

<a id="function-function-minipixels-platform-windows-keydown-function-keydown-vk-src-minipixels-platform-windows-ml-531259703"></a>
### keyDown

```ml
function keyDown(vk)
```

Performs the keyDown operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vk` | `dynamic` | — | vk value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L675)

<a id="extern_function-extern-function-minipixels-platform-windows-loadcursorw-extern-function-loadcursorw-instance-as-ptr-cursorname-as-ptr-from-user32-dll-returns-ptr-src-minipixels-platform-windows-ml-1224271446"></a>
### LoadCursorW

```ml
extern function LoadCursorW(instance as ptr, cursorName as ptr) from "user32.dll" returns ptr
```

Invokes the native LoadCursorW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `instance` | `ptr` | — | instance value consumed by this operation. |
| `cursorName` | `ptr` | — | cursorName value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L140)

<a id="function-function-minipixels-platform-windows-maxint-function-maxint-a-b-src-minipixels-platform-windows-ml-1767531073"></a>
### maxInt

```ml
function maxInt(a, b)
```

Performs the maxInt operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L811)

<a id="function-function-minipixels-platform-windows-minint-function-minint-a-b-src-minipixels-platform-windows-ml-341836797"></a>
### minInt

```ml
function minInt(a, b)
```

Performs the minInt operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L803)

<a id="global-global-minipixels-platform-windows-mousewheelaccumulator-mousewheelaccumulator-src-minipixels-platform-windows-ml-230604820"></a>
### mouseWheelAccumulator

```ml
mouseWheelAccumulator
```

Stores wheel steps received by the window callback until input polling consumes them.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L338)

<a id="function-function-minipixels-platform-windows-nextpow2-function-nextpow2-n-src-minipixels-platform-windows-ml-546811990"></a>
### nextPow2

```ml
function nextPow2(n)
```

Performs the nextPow2 operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | n value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L540)

<a id="function-function-minipixels-platform-windows-normalizerenderer-function-normalizerenderer-renderer-src-minipixels-platform-windows-ml-1683476245"></a>
### normalizeRenderer

```ml
function normalizeRenderer(renderer)
```

Normalizes renderer for the minipixels platform windows workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L550)

<a id="function-function-minipixels-platform-windows-normalizescalemode-function-normalizescalemode-scalemode-src-minipixels-platform-windows-ml-943866925"></a>
### normalizeScaleMode

```ml
function normalizeScaleMode(scaleMode)
```

Normalizes scale mode for the minipixels platform windows workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scaleMode` | `dynamic` | — | scaleMode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L560)

<a id="function-function-minipixels-platform-windows-open-function-open-title-width-height-scale-renderer-scalemode-smoothing-src-minipixels-platform-windows-ml-682059839"></a>
### open

```ml
function open(title, width, height, scale, renderer, scaleMode, smoothing)
```

Opens open for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |
| `scaleMode` | `dynamic` | — | scaleMode value consumed by this operation. |
| `smoothing` | `dynamic` | — | smoothing value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L575)

<a id="extern_function-extern-function-minipixels-platform-windows-patblt-extern-function-patblt-dc-as-ptr-x-as-int-y-as-int-width-as-int-height-as-int-rop-as-int-from-gdi32-dll-returns-bool-src-minipixels-platform-windows-ml-181015738"></a>
### PatBlt

```ml
extern function PatBlt(dc as ptr, x as int, y as int, width as int, height as int, rop as int) from "gdi32.dll" returns bool
```

Invokes the native PatBlt entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `x` | `int` | — | Horizontal coordinate used by the operation. |
| `y` | `int` | — | Vertical coordinate used by the operation. |
| `width` | `int` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `int` | — | Height in the coordinate or storage units used by the caller. |
| `rop` | `int` | — | rop value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L234)

<a id="extern_function-extern-function-minipixels-platform-windows-peekmessagew-extern-function-peekmessagew-msg-as-bytes-hwnd-as-ptr-minfilter-as-u32-maxfilter-as-u32-removemsg-as-u32-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1068985278"></a>
### PeekMessageW

```ml
extern function PeekMessageW(msg as bytes, hwnd as ptr, minFilter as u32, maxFilter as u32, removeMsg as u32) from "user32.dll" returns bool
```

Invokes the native PeekMessageW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | msg value consumed by this operation. |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `minFilter` | `u32` | — | minFilter value consumed by this operation. |
| `maxFilter` | `u32` | — | maxFilter value consumed by this operation. |
| `removeMsg` | `u32` | — | removeMsg value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L166)

<a id="global-global-minipixels-platform-windows-performancecounterbuffer-performancecounterbuffer-src-minipixels-platform-windows-ml-234859452"></a>
### performanceCounterBuffer

```ml
performanceCounterBuffer
```

Reusable buffer for high-resolution counter queries.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L342)

<a id="global-global-minipixels-platform-windows-performancefrequency-performancefrequency-src-minipixels-platform-windows-ml-445614708"></a>
### performanceFrequency

```ml
performanceFrequency
```

Cached high-resolution performance-counter frequency.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L344)

<a id="constant-constant-minipixels-platform-windows-pfd-doublebuffer-const-pfd-doublebuffer-1-src-minipixels-platform-windows-ml-193579286"></a>
### PFD_DOUBLEBUFFER

```ml
const PFD_DOUBLEBUFFER = 1
```

Defines the pfd doublebuffer constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L41)

<a id="constant-constant-minipixels-platform-windows-pfd-draw-to-window-const-pfd-draw-to-window-4-src-minipixels-platform-windows-ml-2015075179"></a>
### PFD_DRAW_TO_WINDOW

```ml
const PFD_DRAW_TO_WINDOW = 4
```

Defines the pfd draw to window constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L43)

<a id="constant-constant-minipixels-platform-windows-pfd-main-plane-const-pfd-main-plane-0-src-minipixels-platform-windows-ml-1290561001"></a>
### PFD_MAIN_PLANE

```ml
const PFD_MAIN_PLANE = 0
```

Defines the pfd main plane constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L49)

<a id="constant-constant-minipixels-platform-windows-pfd-support-opengl-const-pfd-support-opengl-32-src-minipixels-platform-windows-ml-869120678"></a>
### PFD_SUPPORT_OPENGL

```ml
const PFD_SUPPORT_OPENGL = 32
```

Defines the pfd support opengl constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L45)

<a id="constant-constant-minipixels-platform-windows-pfd-type-rgba-const-pfd-type-rgba-0-src-minipixels-platform-windows-ml-2101786561"></a>
### PFD_TYPE_RGBA

```ml
const PFD_TYPE_RGBA = 0
```

Defines the pfd type rgba constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L47)

<a id="constant-constant-minipixels-platform-windows-pm-remove-const-pm-remove-1-src-minipixels-platform-windows-ml-1621406016"></a>
### PM_REMOVE

```ml
const PM_REMOVE = 1
```

Defines the pm remove constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L21)

<a id="function-function-minipixels-platform-windows-pollevents-function-pollevents-w-src-minipixels-platform-windows-ml-932426681"></a>
### pollEvents

```ml
function pollEvents(w)
```

Performs the pollEvents operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L666)

<a id="extern_function-extern-function-minipixels-platform-windows-postquitmessage-extern-function-postquitmessage-exitcode-as-int-from-user32-dll-returns-void-src-minipixels-platform-windows-ml-177238112"></a>
### PostQuitMessage

```ml
extern function PostQuitMessage(exitCode as int) from "user32.dll" returns void
```

Invokes the native PostQuitMessage entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exitCode` | `int` | — | exitCode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L135)

<a id="function-function-minipixels-platform-windows-present-function-present-w-canvas-src-minipixels-platform-windows-ml-2143358207"></a>
### present

```ml
function present(w, canvas)
```

Performs the present operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1044)

<a id="function-function-minipixels-platform-windows-presentgdi-function-presentgdi-w-canvas-src-minipixels-platform-windows-ml-1093617233"></a>
### presentGDI

```ml
function presentGDI(w, canvas)
```

Performs the presentGDI operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1022)

<a id="function-function-minipixels-platform-windows-presentopengl-function-presentopengl-w-canvas-src-minipixels-platform-windows-ml-1644844221"></a>
### presentOpenGL

```ml
function presentOpenGL(w, canvas)
```

Performs the presentOpenGL operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L961)

<a id="function-function-minipixels-platform-windows-puti32-function-puti32-buf-off-v-src-minipixels-platform-windows-ml-2002961072"></a>
### putI32

```ml
function putI32(buf, off, v)
```

Performs the putI32 operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | buf value consumed by this operation. |
| `off` | `dynamic` | — | off value consumed by this operation. |
| `v` | `dynamic` | — | v value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L421)

<a id="function-function-minipixels-platform-windows-putu32-function-putu32-buf-off-v-src-minipixels-platform-windows-ml-1021775528"></a>
### putU32

```ml
function putU32(buf, off, v)
```

Performs the putU32 operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | buf value consumed by this operation. |
| `off` | `dynamic` | — | off value consumed by this operation. |
| `v` | `dynamic` | — | v value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L409)

<a id="function-function-minipixels-platform-windows-putu64-function-putu64-buf-off-v-src-minipixels-platform-windows-ml-847442640"></a>
### putU64

```ml
function putU64(buf, off, v)
```

Performs the putU64 operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | buf value consumed by this operation. |
| `off` | `dynamic` | — | off value consumed by this operation. |
| `v` | `dynamic` | — | v value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L429)

<a id="extern_function-extern-function-minipixels-platform-windows-queryperformancecounter-extern-function-queryperformancecounter-value-as-bytes-from-kernel32-dll-returns-bool-src-minipixels-platform-windows-ml-1099920706"></a>
### QueryPerformanceCounter

```ml
extern function QueryPerformanceCounter(value as bytes) from "kernel32.dll" returns bool
```

Reads the high-resolution performance counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `bytes` | — | Eight-byte destination receiving the counter value. |


**Returns:** Whether the counter was available.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L94)

<a id="extern_function-extern-function-minipixels-platform-windows-queryperformancefrequency-extern-function-queryperformancefrequency-value-as-bytes-from-kernel32-dll-returns-bool-src-minipixels-platform-windows-ml-2115135426"></a>
### QueryPerformanceFrequency

```ml
extern function QueryPerformanceFrequency(value as bytes) from "kernel32.dll" returns bool
```

Reads the high-resolution performance-counter frequency.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `bytes` | — | Eight-byte destination receiving ticks per second. |


**Returns:** Whether the counter was available.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L98)

<a id="function-function-minipixels-platform-windows-refreshclientsize-function-refreshclientsize-w-src-minipixels-platform-windows-ml-1628478687"></a>
### refreshClientSize

```ml
function refreshClientSize(w)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L753)

<a id="extern_function-extern-function-minipixels-platform-windows-registerclassexw-extern-function-registerclassexw-wndclass-as-bytes-from-user32-dll-returns-u32-src-minipixels-platform-windows-ml-1362104956"></a>
### RegisterClassExW

```ml
extern function RegisterClassExW(wndClass as bytes) from "user32.dll" returns u32
```

Invokes the native RegisterClassExW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wndClass` | `bytes` | — | wndClass value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L106)

<a id="global-global-minipixels-platform-windows-registeredclassname-registeredclassname-src-minipixels-platform-windows-ml-1418228528"></a>
### registeredClassName

```ml
registeredClassName
```

Stores module-wide registered class name state for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L336)

<a id="function-function-minipixels-platform-windows-registerwindowclass-function-registerwindowclass-src-minipixels-platform-windows-ml-832642552"></a>
### registerWindowClass

```ml
function registerWindowClass()
```

Performs the registerWindowClass operation for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L488)

<a id="extern_function-extern-function-minipixels-platform-windows-releasedc-extern-function-releasedc-hwnd-as-ptr-dc-as-ptr-from-user32-dll-returns-int-src-minipixels-platform-windows-ml-29800223"></a>
### ReleaseDC

```ml
extern function ReleaseDC(hwnd as ptr, dc as ptr) from "user32.dll" returns int
```

Invokes the native ReleaseDC entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `dc` | `ptr` | — | dc value consumed by this operation. |


**Returns:** Native int result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L204)

<a id="function-function-minipixels-platform-windows-rendererfallbackreason-function-rendererfallbackreason-w-src-minipixels-platform-windows-ml-570595189"></a>
### rendererFallbackReason

```ml
function rendererFallbackReason(w)
```

Performs the rendererFallbackReason operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L648)

<a id="function-function-minipixels-platform-windows-renderername-function-renderername-w-src-minipixels-platform-windows-ml-969738357"></a>
### rendererName

```ml
function rendererName(w)
```

Performs the rendererName operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L634)

<a id="function-function-minipixels-platform-windows-running-function-running-src-minipixels-platform-windows-ml-1269548420"></a>
### running

```ml
function running()
```

Performs the running operation for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L606)

<a id="extern_function-extern-function-minipixels-platform-windows-screentoclient-extern-function-screentoclient-hwnd-as-ptr-point-as-bytes-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-263265762"></a>
### ScreenToClient

```ml
extern function ScreenToClient(hwnd as ptr, point as bytes) from "user32.dll" returns bool
```

Converts a POINT from screen coordinates to client coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | Window owning the client coordinate system. |
| `point` | `bytes` | — | Eight-byte POINT value to convert in place. |


**Returns:** Whether the conversion succeeded.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L195)

<a id="function-function-minipixels-platform-windows-seconds-function-seconds-src-minipixels-platform-windows-ml-1238233208"></a>
### seconds

```ml
function seconds()
```

Returns a high-resolution monotonic time value in seconds.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1071)

<a id="extern_function-extern-function-minipixels-platform-windows-setforegroundwindow-extern-function-setforegroundwindow-hwnd-as-ptr-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1099224625"></a>
### SetForegroundWindow

```ml
extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" returns bool
```

Invokes the native SetForegroundWindow entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L153)

<a id="extern_function-extern-function-minipixels-platform-windows-setpixelformat-extern-function-setpixelformat-dc-as-ptr-pixelformat-as-int-pfd-as-bytes-from-gdi32-dll-returns-bool-src-minipixels-platform-windows-ml-715536415"></a>
### SetPixelFormat

```ml
extern function SetPixelFormat(dc as ptr, pixelFormat as int, pfd as bytes) from "gdi32.dll" returns bool
```

Invokes the native SetPixelFormat entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `pixelFormat` | `int` | — | pixelFormat value consumed by this operation. |
| `pfd` | `bytes` | — | pfd value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L245)

<a id="function-function-minipixels-platform-windows-setrendersize-function-setrendersize-w-width-height-src-minipixels-platform-windows-ml-1700798220"></a>
### setRenderSize

```ml
function setRenderSize(w, width, height)
```

Updates the logical source size used by presentation and pointer mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window to update. |
| `width` | `dynamic` | — | New framebuffer width. |
| `height` | `dynamic` | — | New framebuffer height. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L787)

<a id="extern_function-extern-function-minipixels-platform-windows-setstretchbltmode-extern-function-setstretchbltmode-dc-as-ptr-mode-as-int-from-gdi32-dll-returns-int-src-minipixels-platform-windows-ml-1855644937"></a>
### SetStretchBltMode

```ml
extern function SetStretchBltMode(dc as ptr, mode as int) from "gdi32.dll" returns int
```

Invokes the native SetStretchBltMode entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `mode` | `int` | — | Mode selecting the requested behavior. |


**Returns:** Native int result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L225)

<a id="function-function-minipixels-platform-windows-settitle-function-settitle-w-title-src-minipixels-platform-windows-ml-650917391"></a>
### setTitle

```ml
function setTitle(w, title)
```

Updates title maintained by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L656)

<a id="extern_function-extern-function-minipixels-platform-windows-setwindowtextw-extern-function-setwindowtextw-hwnd-as-ptr-title-as-wstr-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-201005825"></a>
### SetWindowTextW

```ml
extern function SetWindowTextW(hwnd as ptr, title as wstr) from "user32.dll" returns bool
```

Invokes the native SetWindowTextW entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `title` | `wstr` | — | Human-readable title presented to the user. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L158)

<a id="extern_function-extern-function-minipixels-platform-windows-showwindow-extern-function-showwindow-hwnd-as-ptr-cmdshow-as-int-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1035614093"></a>
### ShowWindow

```ml
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" returns bool
```

Invokes the native ShowWindow entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |
| `cmdShow` | `int` | — | cmdShow value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L145)

<a id="extern_function-extern-function-minipixels-platform-windows-sleep-extern-function-sleep-ms-as-int-from-kernel32-dll-returns-void-src-minipixels-platform-windows-ml-302554407"></a>
### Sleep

```ml
extern function Sleep(ms as int) from "kernel32.dll" returns void
```

Invokes the native Sleep entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ms` | `int` | — | ms value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L101)

<a id="function-function-minipixels-platform-windows-sleepms-function-sleepms-ms-src-minipixels-platform-windows-ml-470961608"></a>
### sleepMs

```ml
function sleepMs(ms)
```

Performs the sleepMs operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ms` | `dynamic` | — | ms value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1101)

<a id="constant-constant-minipixels-platform-windows-srccopy-const-srccopy-13369376-src-minipixels-platform-windows-ml-1695044999"></a>
### SRCCOPY

```ml
const SRCCOPY = 13369376
```

Defines the srccopy constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L39)

<a id="extern_function-extern-function-minipixels-platform-windows-stretchdibits-extern-function-stretchdibits-dc-as-ptr-xdest-as-int-ydest-as-int-destw-as-int-desth-as-int-xsrc-as-int-ysrc-as-int-srcw-as-int-srch-as-int-bits-as-bytes-bmi-as-bytes-usage-as-int-rop-as-int-from-gdi32-dll-returns-int-src-minipixels-platform-windows-ml-2071537303"></a>
### StretchDIBits

```ml
extern function StretchDIBits(dc as ptr, xDest as int, yDest as int, destW as int, destH as int, xSrc as int, ySrc as int, srcW as int, srcH as int, bits as bytes, bmi as bytes, usage as int, rop as int) from "gdi32.dll" returns int
```

Invokes the native StretchDIBits entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `xDest` | `int` | — | xDest value consumed by this operation. |
| `yDest` | `int` | — | yDest value consumed by this operation. |
| `destW` | `int` | — | destW value consumed by this operation. |
| `destH` | `int` | — | destH value consumed by this operation. |
| `xSrc` | `int` | — | xSrc value consumed by this operation. |
| `ySrc` | `int` | — | ySrc value consumed by this operation. |
| `srcW` | `int` | — | srcW value consumed by this operation. |
| `srcH` | `int` | — | srcH value consumed by this operation. |
| `bits` | `bytes` | — | bits value consumed by this operation. |
| `bmi` | `bytes` | — | bmi value consumed by this operation. |
| `usage` | `int` | — | usage value consumed by this operation. |
| `rop` | `int` | — | rop value consumed by this operation. |


**Returns:** Native int result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L220)

<a id="constant-constant-minipixels-platform-windows-sw-hide-const-sw-hide-0-src-minipixels-platform-windows-ml-1694933181"></a>
### SW_HIDE

```ml
const SW_HIDE = 0
```

Defines the sw hide constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L33)

<a id="extern_function-extern-function-minipixels-platform-windows-swapbuffers-extern-function-swapbuffers-dc-as-ptr-from-gdi32-dll-returns-bool-src-minipixels-platform-windows-ml-1282786148"></a>
### SwapBuffers

```ml
extern function SwapBuffers(dc as ptr) from "gdi32.dll" returns bool
```

Invokes the native SwapBuffers entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L249)

<a id="function-function-minipixels-platform-windows-ticks-function-ticks-src-minipixels-platform-windows-ml-373459234"></a>
### ticks

```ml
function ticks()
```

Performs the ticks operation for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1066)

<a id="extern_function-extern-function-minipixels-platform-windows-translatemessage-extern-function-translatemessage-msg-as-bytes-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-34241778"></a>
### TranslateMessage

```ml
extern function TranslateMessage(msg as bytes) from "user32.dll" returns bool
```

Invokes the native TranslateMessage entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | msg value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L170)

<a id="function-function-minipixels-platform-windows-updateinput-function-updateinput-input-src-minipixels-platform-windows-ml-273120734"></a>
### updateInput

```ml
function updateInput(input)
```

Updates input for the minipixels platform windows workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L714)

<a id="function-function-minipixels-platform-windows-updateinputforwindow-function-updateinputforwindow-w-input-src-minipixels-platform-windows-ml-991970669"></a>
### updateInputForWindow

```ml
function updateInputForWindow(w, input)
```

Updates input for window for the minipixels platform windows workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L689)

<a id="function-function-minipixels-platform-windows-updatepointerforwindow-function-updatepointerforwindow-w-input-src-minipixels-platform-windows-ml-1648106125"></a>
### updatePointerForWindow

```ml
function updatePointerForWindow(w, input)
```

Updates the logical pointer position for a window and its active viewport.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | Window whose client area is sampled. |
| `input` | `dynamic` | — | Input state receiving logical coordinates. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L730)

<a id="function-function-minipixels-platform-windows-updateviewport-function-updateviewport-w-src-minipixels-platform-windows-ml-840770177"></a>
### updateViewport

```ml
function updateViewport(w)
```

Updates viewport for the minipixels platform windows workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L818)

<a id="function-function-minipixels-platform-windows-updateviewportforsize-function-updateviewportforsize-w-cw-ch-src-minipixels-platform-windows-ml-827462462"></a>
### updateViewportForSize

```ml
function updateViewportForSize(w, cw, ch)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — |  |
| `cw` | `dynamic` | — |  |
| `ch` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L826)

<a id="extern_function-extern-function-minipixels-platform-windows-updatewindow-extern-function-updatewindow-hwnd-as-ptr-from-user32-dll-returns-bool-src-minipixels-platform-windows-ml-1654108303"></a>
### UpdateWindow

```ml
extern function UpdateWindow(hwnd as ptr) from "user32.dll" returns bool
```

Invokes the native UpdateWindow entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | hwnd value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L149)

<a id="function-function-minipixels-platform-windows-viewporth-function-viewporth-w-src-minipixels-platform-windows-ml-642079037"></a>
### viewportH

```ml
function viewportH(w)
```

Performs the viewportH operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L874)

<a id="function-function-minipixels-platform-windows-viewportw-function-viewportw-w-src-minipixels-platform-windows-ml-1163597675"></a>
### viewportW

```ml
function viewportW(w)
```

Performs the viewportW operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L871)

<a id="function-function-minipixels-platform-windows-viewportx-function-viewportx-w-src-minipixels-platform-windows-ml-547076125"></a>
### viewportX

```ml
function viewportX(w)
```

Performs the viewportX operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L865)

<a id="function-function-minipixels-platform-windows-viewporty-function-viewporty-w-src-minipixels-platform-windows-ml-1491031159"></a>
### viewportY

```ml
function viewportY(w)
```

Performs the viewportY operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | w value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L868)

<a id="function-function-minipixels-platform-windows-waituntil-function-waituntil-deadline-src-minipixels-platform-windows-ml-1646201760"></a>
### waitUntil

```ml
function waitUntil(deadline)
```

Waits until a high-resolution deadline while leaving time for other threads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `deadline` | `dynamic` | — | Absolute value previously obtained from seconds(). |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L1086)

<a id="extern_function-extern-function-minipixels-platform-windows-wglcreatecontext-extern-function-wglcreatecontext-dc-as-ptr-from-opengl32-dll-returns-ptr-src-minipixels-platform-windows-ml-1832064209"></a>
### wglCreateContext

```ml
extern function wglCreateContext(dc as ptr) from "opengl32.dll" returns ptr
```

Invokes the native wglCreateContext entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L253)

<a id="extern_function-extern-function-minipixels-platform-windows-wgldeletecontext-extern-function-wgldeletecontext-rc-as-ptr-from-opengl32-dll-returns-bool-src-minipixels-platform-windows-ml-1635549941"></a>
### wglDeleteContext

```ml
extern function wglDeleteContext(rc as ptr) from "opengl32.dll" returns bool
```

Invokes the native wglDeleteContext entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rc` | `ptr` | — | rc value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L262)

<a id="extern_function-extern-function-minipixels-platform-windows-wglmakecurrent-extern-function-wglmakecurrent-dc-as-ptr-rc-as-ptr-from-opengl32-dll-returns-bool-src-minipixels-platform-windows-ml-492060886"></a>
### wglMakeCurrent

```ml
extern function wglMakeCurrent(dc as ptr, rc as ptr) from "opengl32.dll" returns bool
```

Invokes the native wglMakeCurrent entry point used by the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dc` | `ptr` | — | dc value consumed by this operation. |
| `rc` | `ptr` | — | rc value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L258)

- [minipixels.platform.windows.Window](Type-minipixels-platform-windows-window-369528407.md) — struct
<a id="global-global-minipixels-platform-windows-windowneedspresent-windowneedspresent-src-minipixels-platform-windows-ml-1276197992"></a>
### windowNeedsPresent

```ml
windowNeedsPresent
```

Whether Win32 requested repainting of the retained framebuffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L340)

<a id="global-global-minipixels-platform-windows-windowrunning-windowrunning-src-minipixels-platform-windows-ml-1709194432"></a>
### windowRunning

```ml
windowRunning
```

Stores module-wide window running state for the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L334)

<a id="constant-constant-minipixels-platform-windows-wm-close-const-wm-close-16-src-minipixels-platform-windows-ml-244862842"></a>
### WM_CLOSE

```ml
const WM_CLOSE = 16
```

Defines the wm close constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L17)

<a id="constant-constant-minipixels-platform-windows-wm-destroy-const-wm-destroy-2-src-minipixels-platform-windows-ml-427733907"></a>
### WM_DESTROY

```ml
const WM_DESTROY = 2
```

Defines the wm destroy constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L11)

<a id="constant-constant-minipixels-platform-windows-wm-mousewheel-const-wm-mousewheel-522-src-minipixels-platform-windows-ml-781801104"></a>
### WM_MOUSEWHEEL

```ml
const WM_MOUSEWHEEL = 522
```

Defines the mouse-wheel message consumed by the input provider.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L19)

<a id="constant-constant-minipixels-platform-windows-wm-paint-const-wm-paint-15-src-minipixels-platform-windows-ml-174768813"></a>
### WM_PAINT

```ml
const WM_PAINT = 15
```

Defines the wm paint constant used to invalidate retained presentation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L15)

<a id="constant-constant-minipixels-platform-windows-wm-size-const-wm-size-5-src-minipixels-platform-windows-ml-1314556956"></a>
### WM_SIZE

```ml
const WM_SIZE = 5
```

Defines the wm size constant used to invalidate retained presentation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L13)

<a id="function-function-minipixels-platform-windows-wndproc-function-wndproc-hwnd-msg-wparam-lparam-src-minipixels-platform-windows-ml-10300301"></a>
### wndProc

```ml
function wndProc(hwnd, msg, wParam, lParam)
```

Performs the wndProc operation for the minipixels platform windows module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `dynamic` | — | hwnd value consumed by this operation. |
| `msg` | `dynamic` | — | msg value consumed by this operation. |
| `wParam` | `dynamic` | — | wParam value consumed by this operation. |
| `lParam` | `dynamic` | — | lParam value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L463)

<a id="constant-constant-minipixels-platform-windows-ws-overlappedwindow-const-ws-overlappedwindow-13565952-src-minipixels-platform-windows-ml-165080941"></a>
### WS_OVERLAPPEDWINDOW

```ml
const WS_OVERLAPPEDWINDOW = 13565952
```

Defines the ws overlappedwindow constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L25)

<a id="constant-constant-minipixels-platform-windows-ws-visible-const-ws-visible-268435456-src-minipixels-platform-windows-ml-233941244"></a>
### WS_VISIBLE

```ml
const WS_VISIBLE = 268435456
```

Defines the ws visible constant used by the minipixels platform windows module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/platform/windows.ml#L27)
