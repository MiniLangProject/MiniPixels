# `minipixels.audio.audio.AudioState`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audiostate-struct-audiostate-src-minipixels-audio-audio-ml-1889735169"></a>
## AudioState

```ml
struct AudioState
```

Represents the audio state data used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L36)

## Members

<a id="field-field-minipixels-audio-audio-audiostate-mastervolume-mastervolume-src-minipixels-audio-audio-ml-1149832876"></a>
### masterVolume

```ml
masterVolume
```

Stores the master volume value associated with audio state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L38)

<a id="field-field-minipixels-audio-audio-audiostate-musicpath-musicpath-src-minipixels-audio-audio-ml-897396192"></a>
### musicPath

```ml
musicPath
```

Stores the music path value associated with audio state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L46)

<a id="field-field-minipixels-audio-audio-audiostate-musicvolume-musicvolume-src-minipixels-audio-audio-ml-980377204"></a>
### musicVolume

```ml
musicVolume
```

Stores the music volume value associated with audio state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L42)

<a id="method-method-minipixels-audio-audio-audiostate-mute-function-mute-src-minipixels-audio-audio-ml-1822477818"></a>
### mute

```ml
function mute()
```

Performs the mute operation for the minipixels audio audio audio state module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L67)

<a id="field-field-minipixels-audio-audio-audiostate-muted-muted-src-minipixels-audio-audio-ml-1930108828"></a>
### muted

```ml
muted
```

Stores the muted value associated with audio state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L44)

<a id="method-method-minipixels-audio-audio-audiostate-playmusic-function-playmusic-path-src-minipixels-audio-audio-ml-2020149201"></a>
### playMusic

```ml
function playMusic(path)
```

Performs the playMusic operation for the minipixels audio audio audio state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L85)

<a id="method-method-minipixels-audio-audio-audiostate-playsfx-function-playsfx-path-src-minipixels-audio-audio-ml-1714481429"></a>
### playSfx

```ml
function playSfx(path)
```

Performs the playSfx operation for the minipixels audio audio audio state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L79)

<a id="method-method-minipixels-audio-audio-audiostate-setmastervolume-function-setmastervolume-value-src-minipixels-audio-audio-ml-37365463"></a>
### setMasterVolume

```ml
function setMasterVolume(value)
```

Updates master volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L50)

<a id="method-method-minipixels-audio-audio-audiostate-setmusicvolume-function-setmusicvolume-value-src-minipixels-audio-audio-ml-331730887"></a>
### setMusicVolume

```ml
function setMusicVolume(value)
```

Updates music volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L62)

<a id="method-method-minipixels-audio-audio-audiostate-setsfxvolume-function-setsfxvolume-value-src-minipixels-audio-audio-ml-8602475"></a>
### setSfxVolume

```ml
function setSfxVolume(value)
```

Updates sfx volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L56)

<a id="field-field-minipixels-audio-audio-audiostate-sfxvolume-sfxvolume-src-minipixels-audio-audio-ml-1304137504"></a>
### sfxVolume

```ml
sfxVolume
```

Stores the sfx volume value associated with audio state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L40)

<a id="method-method-minipixels-audio-audio-audiostate-stop-function-stop-src-minipixels-audio-audio-ml-1667517674"></a>
### stop

```ml
function stop()
```

Stops stop for the minipixels audio audio workflow.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L90)

<a id="method-method-minipixels-audio-audio-audiostate-unmute-function-unmute-src-minipixels-audio-audio-ml-40986830"></a>
### unmute

```ml
function unmute()
```

Performs the unmute operation for the minipixels audio audio audio state module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L73)
