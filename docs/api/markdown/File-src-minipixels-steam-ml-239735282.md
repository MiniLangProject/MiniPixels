# `src/minipixels/steam.ml`

[Home](README.md) · [Files](Files.md)

Optional Steam client integration. All calls and callbacks run on the game thread.

Package: [`minipixels.steam`](Package-minipixels-steam-281536945.md)

Reachable from entry: **yes**

## Imports

- `minipixels/tools/fsutil.ml` as `dirs` → [src/minipixels/tools/fsutil.ml](File-src-minipixels-tools-fsutil-ml-605704885.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/process.ml` as `process` → `../MiniLangCompilerML/std/process.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-minipixels-steam-achievement-function-achievement-s-name-src-minipixels-steam-ml-1426113977"></a>
### achievement

```ml
function achievement(s, name)
```

Returns 1 unlocked, 0 locked, -1 unavailable or unknown achievement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Active Steam session. |
| `name` | `dynamic` | — | Published achievement API name to query. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L172)

<a id="function-function-minipixels-steam-close-function-close-s-src-minipixels-steam-ml-1252254442"></a>
### close

```ml
function close(s)
```

Flush dirty stats best-effort and release the active Steam session once.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session to close; repeated calls are harmless. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L231)

<a id="function-function-minipixels-steam-config-function-config-appid-required-src-minipixels-steam-ml-398412972"></a>
### config

```ml
function config(appId, required)
```

Configure optional/required Steam startup. A running offline client is allowed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `appId` | `dynamic` | — | Positive uint32 Steam application identifier. |
| `required` | `dynamic` | — | Fail startup instead of falling back when Steam is unavailable. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L60)

<a id="function-function-minipixels-steam-defaults-function-defaults-src-minipixels-steam-ml-1525667215"></a>
### defaults

```ml
function defaults()
```

Build-generated settings; ordinary direct compiler builds have no Steam dependency.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L65)

<a id="function-function-minipixels-steam-flush-function-flush-s-src-minipixels-steam-ml-209506122"></a>
### flush

```ml
function flush(s)
```

Non-blocking store. Confirmation arrives via subsequent update calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session with pending local changes to persist. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L201)

<a id="function-function-minipixels-steam-invoke-function-invoke-s-op-text-value-src-minipixels-steam-ml-519366301"></a>
### invoke

```ml
function invoke(s, op, text, value)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — |  |
| `op` | `dynamic` | — |  |
| `text` | `dynamic` | — |  |
| `value` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L90)

<a id="function-function-minipixels-steam-nativebackend-function-nativebackend-op-text-value-output-src-minipixels-steam-ml-494936215"></a>
### nativeBackend

```ml
function nativeBackend(op, text, value, output)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `op` | `dynamic` | — |  |
| `text` | `dynamic` | — |  |
| `value` | `dynamic` | — |  |
| `output` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L74)

<a id="function-function-minipixels-steam-openoverlay-function-openoverlay-s-dialog-src-minipixels-steam-ml-139911566"></a>
### openOverlay

```ml
function openOverlay(s, dialog)
```

Request a Steam overlay dialog; false means the request was unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session with an overlay-capable presenter. |
| `dialog` | `dynamic` | — | Supported Steam dialog, such as friends or achievements. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L217)

<a id="function-function-minipixels-steam-readsave-function-readsave-s-name-src-minipixels-steam-ml-23713363"></a>
### readSave

```ml
function readSave(s, name)
```

Read a local account-specific save as bytes, or return a filesystem error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session selecting the application and user directory. |
| `name` | `dynamic` | — | Portable save basename previously used with writeSave. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L306)

<a id="function-function-minipixels-steam-readstring-function-readstring-s-op-src-minipixels-steam-ml-37752595"></a>
### readString

```ml
function readString(s, op)
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — |  |
| `op` | `dynamic` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L95)

<a id="extern_function-extern-function-minipixels-steam-replacesave-extern-function-replacesave-source-as-wstr-destination-as-wstr-flags-as-u32-from-kernel32-dll-symbol-movefileexw-returns-bool-src-minipixels-steam-ml-1348001192"></a>
### replaceSave

```ml
extern function replaceSave(source as wstr, destination as wstr, flags as u32) from "kernel32.dll" symbol "MoveFileExW" returns bool
```

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `wstr` | — |  |
| `destination` | `wstr` | — |  |
| `flags` | `u32` | — |  |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L22)

<a id="function-function-minipixels-steam-safesavename-function-safesavename-name-src-minipixels-steam-ml-544877142"></a>
### safeSaveName

```ml
function safeSaveName(name)
```

Reject path traversal and non-portable save filenames before filesystem access.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Local save basename, without directories. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L246)

<a id="function-function-minipixels-steam-savepath-function-savepath-s-name-src-minipixels-steam-ml-1433334495"></a>
### savePath

```ml
function savePath(s, name)
```

User-separated Auto-Cloud path. Local fallback saves are not migrated to Steam users.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session providing AppID and optional decimal Steam user identity. |
| `name` | `dynamic` | — | Portable save basename; the save- prefix is added automatically. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L262)

<a id="function-function-minipixels-steam-session-function-session-cfg-backend-src-minipixels-steam-ml-1355190765"></a>
### session

```ml
function session(cfg, backend)
```

Injectable backend is intended for deterministic tests, never exported game builds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Steam startup configuration. |
| `backend` | `dynamic` | — | Game-thread callback accepting opcode, text, integer and output bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L85)

<a id="function-function-minipixels-steam-setrenderer-function-setrenderer-s-renderer-src-minipixels-steam-ml-688696697"></a>
### setRenderer

```ml
function setRenderer(s, renderer)
```

Record presenter capability; software GDI/XImage presentation cannot host the overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session associated with the game window. |
| `renderer` | `dynamic` | — | Actual platform renderer name, not the originally requested mode. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L225)

<a id="function-function-minipixels-steam-setstat-function-setstat-s-name-value-src-minipixels-steam-ml-2113296166"></a>
### setStat

```ml
function setStat(s, name, value)
```

Set an integer Steam stat. Float/average-rate stats are not part of this API.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Active Steam session. |
| `name` | `dynamic` | — | Published integer stat API name. |
| `value` | `dynamic` | — | Signed 32-bit integer value; out-of-range values are rejected. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L181)

<a id="function-function-minipixels-steam-start-function-start-s-headless-src-minipixels-steam-ml-954520131"></a>
### start

```ml
function start(s, headless)
```

Must run before graphics-device/window creation. Headless mode never contacts Steam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session whose identity is initialized once. |
| `headless` | `dynamic` | — | Skip all backend calls when true. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L104)

<a id="function-function-minipixels-steam-stat-function-stat-s-name-src-minipixels-steam-ml-1056332767"></a>
### stat

```ml
function stat(s, name)
```

Read a cached signed integer Steam stat, or return an error when unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Active Steam session. |
| `name` | `dynamic` | — | Published integer stat API name to query. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L192)

- [minipixels.steam.SteamConfig](Type-minipixels-steam-steamconfig-726539401.md) — struct
- [minipixels.steam.SteamSession](Type-minipixels-steam-steamsession-1270188261.md) — struct
<a id="function-function-minipixels-steam-unlockachievement-function-unlockachievement-s-name-src-minipixels-steam-ml-1266703741"></a>
### unlockAchievement

```ml
function unlockAchievement(s, name)
```

Returns acceptance, not remote persistence. Inspect storeStatus after flush.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Active Steam session. |
| `name` | `dynamic` | — | Published Steamworks achievement API name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L162)

<a id="function-function-minipixels-steam-update-function-update-s-dt-src-minipixels-steam-ml-933891002"></a>
### update

```ml
function update(s, dt)
```

Pump once per outer frame, including paused frames; never once per physics tick.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Active Steam session. |
| `dt` | `dynamic` | — | Elapsed real frame time in seconds, before simulation pause is applied. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L129)

<a id="function-function-minipixels-steam-writesave-function-writesave-s-name-data-src-minipixels-steam-ml-3985147"></a>
### writeSave

```ml
function writeSave(s, name, data)
```

Atomic local replacement, suitable for Steam Auto-Cloud. Call from the game thread.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Session selecting the application and user directory. |
| `name` | `dynamic` | — | Portable save basename, such as slot1.json. |
| `data` | `dynamic` | — | Complete serialized save contents as bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/steam.ml#L287)
