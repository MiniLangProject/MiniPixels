# `minipixels.audio.audio.AudioChannel`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audiochannel-struct-audiochannel-src-minipixels-audio-audio-ml-746235869"></a>
## AudioChannel

```ml
struct AudioChannel
```

Represents one independently mixed sound-effect voice.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L267)

## Members

<a id="field-field-minipixels-audio-audio-audiochannel-clip-clip-src-minipixels-audio-audio-ml-63275286"></a>
### clip

```ml
clip
```

Active clip.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L271)

<a id="field-field-minipixels-audio-audio-audiochannel-cursor-cursor-src-minipixels-audio-audio-ml-1692099430"></a>
### cursor

```ml
cursor
```

Fractional source-frame cursor.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L279)

<a id="field-field-minipixels-audio-audio-audiochannel-decoder-decoder-src-minipixels-audio-audio-ml-1800012338"></a>
### decoder

```ml
decoder
```

Native MP3 decoder handle, or zero for memory PCM.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L281)

<a id="field-field-minipixels-audio-audio-audiochannel-id-id-src-minipixels-audio-audio-ml-764030132"></a>
### id

```ml
id
```

Stable channel identifier.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L269)

<a id="field-field-minipixels-audio-audio-audiochannel-pan-pan-src-minipixels-audio-audio-ml-1658644898"></a>
### pan

```ml
pan
```

Channel pan from -100 (left) to 100 (right).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L277)

<a id="field-field-minipixels-audio-audio-audiochannel-playing-playing-src-minipixels-audio-audio-ml-1494561126"></a>
### playing

```ml
playing
```

Whether this voice is active.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L273)

<a id="field-field-minipixels-audio-audio-audiochannel-streamdata-streamdata-src-minipixels-audio-audio-ml-1831917410"></a>
### streamData

```ml
streamData
```

Reusable interleaved signed-16 streaming buffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L283)

<a id="field-field-minipixels-audio-audio-audiochannel-streamframes-streamframes-src-minipixels-audio-audio-ml-979519398"></a>
### streamFrames

```ml
streamFrames
```

Number of valid source frames in the streaming buffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L287)

<a id="field-field-minipixels-audio-audio-audiochannel-streamstart-streamstart-src-minipixels-audio-audio-ml-1140112638"></a>
### streamStart

```ml
streamStart
```

Absolute source frame represented by the first buffered frame.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L285)

<a id="field-field-minipixels-audio-audio-audiochannel-volume-volume-src-minipixels-audio-audio-ml-1481483718"></a>
### volume

```ml
volume
```

Channel volume percentage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L275)
