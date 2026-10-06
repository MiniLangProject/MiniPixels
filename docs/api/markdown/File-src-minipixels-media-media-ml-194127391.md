# `src/minipixels/media/media.ml`

[Home](README.md) · [Files](Files.md)

Streams file-backed MPX audio and video through std.audio/std.video.

Package: [`minipixels.media.media`](Package-minipixels-media-media-1865358103.md)

Reachable from entry: **no**

## Imports

- `minipixels/assets/pack.ml` as `packs` → [src/minipixels/assets/pack.ml](File-src-minipixels-assets-pack-ml-1157891367.md)
- `std/audio.ml` as `nativeAudio` → `../MiniLangCompilerML/std/audio.ml` — external dependency
- `std/video.ml` as `nativeVideo` → `../MiniLangCompilerML/std/video.ml` — external dependency

## Declarations

<a id="function-function-minipixels-media-media-error-function-error-message-src-minipixels-media-media-ml-725740719"></a>
### _error

```ml
function _error(message)
```

Creates a media-module error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable error text. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L66)

<a id="function-function-minipixels-media-media-opensource-function-opensource-info-mime-suffix-src-minipixels-media-media-ml-1721162251"></a>
### _openSource

```ml
function _openSource(info, mime, suffix)
```

Opens the local range source for one already-validated pack entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | File-backed stream metadata returned by the pack module. |
| `mime` | `dynamic` | — | HTTP content type advertised to the media backend. |
| `suffix` | `dynamic` | — | Filename suffix used for decoder selection. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L199)

<a id="extern_function-extern-function-minipixels-media-media-streamclose-extern-function-streamclose-handle-as-ptr-from-minipixels-audio-dll-symbol-mpmediastreamclose-returns-void-src-minipixels-media-media-ml-395662664"></a>
### _streamClose

```ml
extern function _streamClose(handle as ptr) from "minipixels_audio.dll" symbol "mpMediaStreamClose" returns void
```

Closes a native loopback media source.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native source handle. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L36)

<a id="extern_function-extern-function-minipixels-media-media-streamopen-extern-function-streamopen-path-as-cstr-offset-as-u64-storedsize-as-u64-logicalsize-as-u64-codec-as-int-key-as-bytes-keysize-as-u64-nonce-as-bytes-noncesize-as-u64-hashes-as-bytes-hashessize-as-u64-mime-as-cstr-suffix-as-cstr-urloutput-as-bytes-urlcapacity-as-int-from-minipixels-audio-dll-symbol-mpmediastreamopenv6-returns-ptr-src-minipixels-media-media-ml-14201583"></a>
### _streamOpen

```ml
extern function _streamOpen(path as cstr, offset as u64, storedSize as u64, logicalSize as u64, codec as int, key as bytes, keySize as u64, nonce as bytes, nonceSize as u64, hashes as bytes, hashesSize as u64, mime as cstr, suffix as cstr, urlOutput as bytes, urlCapacity as int) from "minipixels_audio.dll" symbol "mpMediaStreamOpenV6" returns ptr
```

Opens a native loopback source for one MPX media range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `cstr` | — | MPX file path. |
| `offset` | `u64` | — | Stored payload offset. |
| `storedSize` | `u64` | — | Stored payload size. |
| `logicalSize` | `u64` | — | Plain media size. |
| `codec` | `int` | — | MPX payload codec. |
| `key` | `bytes` | — | AES key for protected media. |
| `keySize` | `u64` | — | AES key size. |
| `nonce` | `bytes` | — | Base nonce for protected media. |
| `nonceSize` | `u64` | — | Base nonce size. |
| `hashes` | `bytes` | — | Ciphertext SHA-256 digests from the verified signed index. |
| `hashesSize` | `u64` | — | Size of the digest table in bytes. |
| `mime` | `cstr` | — | HTTP response content type. |
| `suffix` | `cstr` | — | Decoder filename suffix. |
| `urlOutput` | `bytes` | — | Destination buffer for the loopback URL. |
| `urlCapacity` | `int` | — | Destination buffer capacity. |


**Returns:** Opaque native source handle, or zero on failure.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L32)

<a id="constant-constant-minipixels-media-media-media-err-const-media-err-9310-src-minipixels-media-media-ml-341136306"></a>
### MEDIA_ERR

```ml
const MEDIA_ERR = 9310
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L11)

<a id="function-function-minipixels-media-media-openaudio-function-openaudio-pack-name-mime-audio-mpeg-suffix-mp3-options-void-src-minipixels-media-media-ml-1460667144"></a>
### openAudio

```ml
function openAudio(pack, name, mime = "audio/mpeg", suffix = ".mp3", options = void)
```

Opens streamed audio by stable MPX asset name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `name` | `dynamic` | — | Stable audio asset name. |
| `mime` | `dynamic` | `"audio/mpeg"` | HTTP content type advertised to the audio backend. |
| `suffix` | `dynamic` | `".mp3"` | Filename suffix used for decoder selection. |
| `options` | `dynamic` | `void` | Optional `std.audio.PlayerOptions`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L255)

<a id="function-function-minipixels-media-media-openaudioat-function-openaudioat-pack-slot-mime-audio-mpeg-suffix-mp3-options-void-src-minipixels-media-media-ml-360541171"></a>
### openAudioAt

```ml
function openAudioAt(pack, slot, mime = "audio/mpeg", suffix = ".mp3", options = void)
```

Opens streamed audio by pre-resolved MPX slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `slot` | `dynamic` | — | Pre-resolved audio entry slot. |
| `mime` | `dynamic` | `"audio/mpeg"` | HTTP content type advertised to the audio backend. |
| `suffix` | `dynamic` | `".mp3"` | Filename suffix used for decoder selection. |
| `options` | `dynamic` | `void` | Optional `std.audio.PlayerOptions`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L235)

<a id="function-function-minipixels-media-media-openvideo-function-openvideo-pack-name-mime-video-mp4-suffix-mp4-options-void-src-minipixels-media-media-ml-1401851240"></a>
### openVideo

```ml
function openVideo(pack, name, mime = "video/mp4", suffix = ".mp4", options = void)
```

Opens streamed video by stable MPX asset name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `name` | `dynamic` | — | Stable video asset name. |
| `mime` | `dynamic` | `"video/mp4"` | HTTP content type advertised to the video backend. |
| `suffix` | `dynamic` | `".mp4"` | Filename suffix used for decoder selection. |
| `options` | `dynamic` | `void` | Optional `std.video.PlayerOptions`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L287)

<a id="function-function-minipixels-media-media-openvideoat-function-openvideoat-pack-slot-mime-video-mp4-suffix-mp4-options-void-src-minipixels-media-media-ml-424155165"></a>
### openVideoAt

```ml
function openVideoAt(pack, slot, mime = "video/mp4", suffix = ".mp4", options = void)
```

Opens streamed video by pre-resolved MPX slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | Open asset pack. |
| `slot` | `dynamic` | — | Pre-resolved video entry slot. |
| `mime` | `dynamic` | `"video/mp4"` | HTTP content type advertised to the video backend. |
| `suffix` | `dynamic` | `".mp4"` | Filename suffix used for decoder selection. |
| `options` | `dynamic` | `void` | Optional `std.video.PlayerOptions`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L267)

- [minipixels.media.media.PackedAudio](Type-minipixels-media-media-packedaudio-106545843.md) — struct
- [minipixels.media.media.PackedMediaSource](Type-minipixels-media-media-packedmediasource-266006340.md) — struct
- [minipixels.media.media.PackedVideo](Type-minipixels-media-media-packedvideo-1505809434.md) — struct
