# `minipixels.audio.audio.AudioClip`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audioclip-struct-audioclip-src-minipixels-audio-audio-ml-1607502727"></a>
## AudioClip

```ml
struct AudioClip
```

Represents a WAV or MP3 clip and its lazily prepared payload.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L215)

## Members

<a id="field-field-minipixels-audio-audio-audioclip-bitspersample-bitspersample-src-minipixels-audio-audio-ml-619087673"></a>
### bitsPerSample

```ml
bitsPerSample
```

Source bits per sample.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L237)

<a id="field-field-minipixels-audio-audio-audioclip-blockalign-blockalign-src-minipixels-audio-audio-ml-1937899229"></a>
### blockAlign

```ml
blockAlign
```

Source bytes per interleaved frame.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L239)

<a id="field-field-minipixels-audio-audio-audioclip-channels-channels-src-minipixels-audio-audio-ml-909289801"></a>
### channels

```ml
channels
```

Source channel count.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L233)

<a id="field-field-minipixels-audio-audio-audioclip-codec-codec-src-minipixels-audio-audio-ml-216781065"></a>
### codec

```ml
codec
```

Normalized source codec name (`wav` or `mp3`).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L245)

<a id="field-field-minipixels-audio-audio-audioclip-data-data-src-minipixels-audio-audio-ml-810038921"></a>
### data

```ml
data
```

Original WAV or MP3 file bytes, when loaded in memory.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L225)

<a id="field-field-minipixels-audio-audio-audioclip-formattag-formattag-src-minipixels-audio-audio-ml-40666461"></a>
### formatTag

```ml
formatTag
```

Source format identifier.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L231)

<a id="field-field-minipixels-audio-audio-audioclip-framecount-framecount-src-minipixels-audio-audio-ml-59754737"></a>
### frameCount

```ml
frameCount
```

Number of source sample frames.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L243)

<a id="field-field-minipixels-audio-audio-audioclip-looping-looping-src-minipixels-audio-audio-ml-1320651897"></a>
### looping

```ml
looping
```

Whether playback loops after the final frame.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L223)

<a id="field-field-minipixels-audio-audio-audioclip-name-name-src-minipixels-audio-audio-ml-793758243"></a>
### name

```ml
name
```

Stable clip name.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L219)

<a id="field-field-minipixels-audio-audio-audioclip-path-path-src-minipixels-audio-audio-ml-140685895"></a>
### path

```ml
path
```

Optional source path.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L217)

<a id="method-method-minipixels-audio-audio-audioclip-play-function-play-audio-src-minipixels-audio-audio-ml-1822210437"></a>
### play

```ml
function play(audio)
```

Plays this clip through an AudioState or AudioMixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Destination audio state or mixer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L261)

<a id="field-field-minipixels-audio-audio-audioclip-prepared-prepared-src-minipixels-audio-audio-ml-1124427359"></a>
### prepared

```ml
prepared
```

Whether format preparation has been attempted.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L227)

<a id="field-field-minipixels-audio-audio-audioclip-sampledata-sampledata-src-minipixels-audio-audio-ml-1356099641"></a>
### sampleData

```ml
sampleData
```

Detached PCM sample payload.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L241)

<a id="field-field-minipixels-audio-audio-audioclip-samplerate-samplerate-src-minipixels-audio-audio-ml-596789577"></a>
### sampleRate

```ml
sampleRate
```

Source sample rate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L235)

<a id="method-method-minipixels-audio-audio-audioclip-setlooping-function-setlooping-value-src-minipixels-audio-audio-ml-1044269888"></a>
### setLooping

```ml
function setLooping(value)
```

Sets looping behavior.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Whether playback should loop. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L256)

<a id="method-method-minipixels-audio-audio-audioclip-setvolume-function-setvolume-value-src-minipixels-audio-audio-ml-232371152"></a>
### setVolume

```ml
function setVolume(value)
```

Sets clip volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L251)

<a id="field-field-minipixels-audio-audio-audioclip-streaming-streaming-src-minipixels-audio-audio-ml-1080483625"></a>
### streaming

```ml
streaming
```

Whether an MP3 should be decoded incrementally while playing.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L247)

<a id="field-field-minipixels-audio-audio-audioclip-valid-valid-src-minipixels-audio-audio-ml-1965274953"></a>
### valid

```ml
valid
```

Whether the parsed format is supported.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L229)

<a id="field-field-minipixels-audio-audio-audioclip-volume-volume-src-minipixels-audio-audio-ml-143217357"></a>
### volume

```ml
volume
```

Clip volume percentage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L221)
