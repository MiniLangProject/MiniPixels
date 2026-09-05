# `minipixels.audio.audio.AudioState`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audiostate-struct-audiostate-src-minipixels-audio-audio-ml-1889735169"></a>
## AudioState

```ml
struct AudioState
```

Represents legacy state used by direct PlaySound-compatible helpers.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L118)

## Members

<a id="field-field-minipixels-audio-audio-audiostate-mastervolume-mastervolume-src-minipixels-audio-audio-ml-1149832876"></a>
### masterVolume

```ml
masterVolume
```

Master volume percentage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L120)

<a id="field-field-minipixels-audio-audio-audiostate-musicpath-musicpath-src-minipixels-audio-audio-ml-897396192"></a>
### musicPath

```ml
musicPath
```

Last legacy music path.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L128)

<a id="field-field-minipixels-audio-audio-audiostate-musicvolume-musicvolume-src-minipixels-audio-audio-ml-980377204"></a>
### musicVolume

```ml
musicVolume
```

Music bus volume percentage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L124)

<a id="method-method-minipixels-audio-audio-audiostate-mute-function-mute-src-minipixels-audio-audio-ml-1822477818"></a>
### mute

```ml
function mute()
```

Mutes legacy playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L146)

<a id="field-field-minipixels-audio-audio-audiostate-muted-muted-src-minipixels-audio-audio-ml-1930108828"></a>
### muted

```ml
muted
```

Whether playback is muted.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L126)

<a id="method-method-minipixels-audio-audio-audiostate-playmusic-function-playmusic-path-src-minipixels-audio-audio-ml-2020149201"></a>
### playMusic

```ml
function playMusic(path)
```

Plays looping legacy music from a file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L161)

<a id="method-method-minipixels-audio-audio-audiostate-playsfx-function-playsfx-path-src-minipixels-audio-audio-ml-1714481429"></a>
### playSfx

```ml
function playSfx(path)
```

Plays a legacy sound effect from a file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L156)

<a id="method-method-minipixels-audio-audio-audiostate-setmastervolume-function-setmastervolume-value-src-minipixels-audio-audio-ml-37365463"></a>
### setMasterVolume

```ml
function setMasterVolume(value)
```

Sets master volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L132)

<a id="method-method-minipixels-audio-audio-audiostate-setmusicvolume-function-setmusicvolume-value-src-minipixels-audio-audio-ml-331730887"></a>
### setMusicVolume

```ml
function setMusicVolume(value)
```

Sets music volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L142)

<a id="method-method-minipixels-audio-audio-audiostate-setsfxvolume-function-setsfxvolume-value-src-minipixels-audio-audio-ml-8602475"></a>
### setSfxVolume

```ml
function setSfxVolume(value)
```

Sets sound-effect volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L137)

<a id="field-field-minipixels-audio-audio-audiostate-sfxvolume-sfxvolume-src-minipixels-audio-audio-ml-1304137504"></a>
### sfxVolume

```ml
sfxVolume
```

Sound-effect bus volume percentage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L122)

<a id="method-method-minipixels-audio-audio-audiostate-stop-function-stop-src-minipixels-audio-audio-ml-1667517674"></a>
### stop

```ml
function stop()
```

Stops legacy playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L165)

<a id="method-method-minipixels-audio-audio-audiostate-unmute-function-unmute-src-minipixels-audio-audio-ml-40986830"></a>
### unmute

```ml
function unmute()
```

Unmutes legacy playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L151)
