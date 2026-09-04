# `minipixels.audio.audio.AudioMixer`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audiomixer-struct-audiomixer-src-minipixels-audio-audio-ml-624563825"></a>
## AudioMixer

```ml
struct AudioMixer
```

Represents the audio mixer data used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L141)

## Members

<a id="field-field-minipixels-audio-audio-audiomixer-audio-audio-src-minipixels-audio-audio-ml-71920972"></a>
### audio

```ml
audio
```

Stores the audio value associated with audio mixer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L143)

<a id="field-field-minipixels-audio-audio-audiomixer-channelcount-channelcount-src-minipixels-audio-audio-ml-1974549612"></a>
### channelCount

```ml
channelCount
```

Stores the channel count value associated with audio mixer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L147)

<a id="field-field-minipixels-audio-audio-audiomixer-channels-channels-src-minipixels-audio-audio-ml-351011016"></a>
### channels

```ml
channels
```

Stores the channels value associated with audio mixer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L145)

<a id="field-field-minipixels-audio-audio-audiomixer-music-music-src-minipixels-audio-audio-ml-611737000"></a>
### music

```ml
music
```

Stores the music value associated with audio mixer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L151)

<a id="method-method-minipixels-audio-audio-audiomixer-mute-function-mute-src-minipixels-audio-audio-ml-587003342"></a>
### mute

```ml
function mute()
```

Performs the mute operation for the minipixels audio audio audio mixer module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L172)

<a id="field-field-minipixels-audio-audio-audiomixer-nextchannel-nextchannel-src-minipixels-audio-audio-ml-1240139108"></a>
### nextChannel

```ml
nextChannel
```

Stores the next channel value associated with audio mixer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L149)

<a id="method-method-minipixels-audio-audio-audiomixer-playmusic-function-playmusic-clip-src-minipixels-audio-audio-ml-1170273894"></a>
### playMusic

```ml
function playMusic(clip)
```

Performs the playMusic operation for the minipixels audio audio audio mixer module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clip` | `dynamic` | — | clip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L189)

<a id="method-method-minipixels-audio-audio-audiomixer-playsfx-function-playsfx-clip-src-minipixels-audio-audio-ml-869959498"></a>
### playSfx

```ml
function playSfx(clip)
```

Performs the playSfx operation for the minipixels audio audio audio mixer module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clip` | `dynamic` | — | clip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L183)

<a id="method-method-minipixels-audio-audio-audiomixer-setmastervolume-function-setmastervolume-value-src-minipixels-audio-audio-ml-195509011"></a>
### setMasterVolume

```ml
function setMasterVolume(value)
```

Updates master volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L155)

<a id="method-method-minipixels-audio-audio-audiomixer-setmusicvolume-function-setmusicvolume-value-src-minipixels-audio-audio-ml-987640579"></a>
### setMusicVolume

```ml
function setMusicVolume(value)
```

Updates music volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L167)

<a id="method-method-minipixels-audio-audio-audiomixer-setsfxvolume-function-setsfxvolume-value-src-minipixels-audio-audio-ml-1926371943"></a>
### setSfxVolume

```ml
function setSfxVolume(value)
```

Updates sfx volume maintained by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L161)

<a id="method-method-minipixels-audio-audio-audiomixer-stopall-function-stopall-src-minipixels-audio-audio-ml-2353796"></a>
### stopAll

```ml
function stopAll()
```

Stops all for the minipixels audio audio workflow.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L194)

<a id="method-method-minipixels-audio-audio-audiomixer-unmute-function-unmute-src-minipixels-audio-audio-ml-1780619714"></a>
### unmute

```ml
function unmute()
```

Performs the unmute operation for the minipixels audio audio audio mixer module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L177)
