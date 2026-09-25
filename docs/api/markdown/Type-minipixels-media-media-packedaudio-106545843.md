# `minipixels.media.media.PackedAudio`

[Home](README.md) · [Source file](File-src-minipixels-media-media-ml-194127391.md)

<a id="struct-struct-minipixels-media-media-packedaudio-struct-packedaudio-src-minipixels-media-media-ml-1339375303"></a>
## PackedAudio

```ml
struct PackedAudio
```

Audio player whose encoded bytes remain inside its MPX file.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L84)

## Members

<a id="method-method-minipixels-media-media-packedaudio-close-function-close-src-minipixels-media-media-ml-1140121697"></a>
### close

```ml
function close()
```

Closes the player before releasing its MPX range source.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L122)

<a id="field-field-minipixels-media-media-packedaudio-closed-closed-src-minipixels-media-media-ml-17206723"></a>
### closed

```ml
closed
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L87)

<a id="method-method-minipixels-media-media-packedaudio-duration-function-duration-src-minipixels-media-media-ml-1326806933"></a>
### duration

```ml
function duration()
```

Returns the media duration.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L101)

<a id="method-method-minipixels-media-media-packedaudio-hasaudio-function-hasaudio-src-minipixels-media-media-ml-439836221"></a>
### hasAudio

```ml
function hasAudio()
```

Returns whether the media exposes an audio track.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L105)

<a id="method-method-minipixels-media-media-packedaudio-pause-function-pause-src-minipixels-media-media-ml-1605000957"></a>
### pause

```ml
function pause()
```

Pauses playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L92)

<a id="method-method-minipixels-media-media-packedaudio-play-function-play-src-minipixels-media-media-ml-443831549"></a>
### play

```ml
function play()
```

Starts or resumes playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L90)

<a id="field-field-minipixels-media-media-packedaudio-player-player-src-minipixels-media-media-ml-1410445717"></a>
### player

```ml
player
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L86)

<a id="method-method-minipixels-media-media-packedaudio-pollevent-function-pollevent-src-minipixels-media-media-ml-240631491"></a>
### pollEvent

```ml
function pollEvent()
```

Returns the next queued media event.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L119)

<a id="method-method-minipixels-media-media-packedaudio-position-function-position-src-minipixels-media-media-ml-1594558425"></a>
### position

```ml
function position()
```

Returns the current playback timestamp.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L99)

<a id="method-method-minipixels-media-media-packedaudio-seek-function-seek-milliseconds-src-minipixels-media-media-ml-1954995491"></a>
### seek

```ml
function seek(milliseconds)
```

Seeks to a media timestamp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `milliseconds` | `dynamic` | — | Target timestamp in milliseconds. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L97)

<a id="method-method-minipixels-media-media-packedaudio-setloop-function-setloop-enabled-src-minipixels-media-media-ml-97114894"></a>
### setLoop

```ml
function setLoop(enabled)
```

Enables or disables looping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | True to loop playback. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L117)

<a id="method-method-minipixels-media-media-packedaudio-setmuted-function-setmuted-muted-src-minipixels-media-media-ml-1176508216"></a>
### setMuted

```ml
function setMuted(muted)
```

Enables or disables muting.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `muted` | `dynamic` | — | True to mute playback. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L111)

<a id="method-method-minipixels-media-media-packedaudio-setplaybackrate-function-setplaybackrate-rate-src-minipixels-media-media-ml-1965883301"></a>
### setPlaybackRate

```ml
function setPlaybackRate(rate)
```

Sets the playback speed multiplier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rate` | `dynamic` | — | Playback speed accepted by `std.audio`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L114)

<a id="method-method-minipixels-media-media-packedaudio-setvolume-function-setvolume-volume-src-minipixels-media-media-ml-777929739"></a>
### setVolume

```ml
function setVolume(volume)
```

Sets playback volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume accepted by `std.audio`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L108)

<a id="field-field-minipixels-media-media-packedaudio-source-source-src-minipixels-media-media-ml-2104026313"></a>
### source

```ml
source
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L85)

<a id="method-method-minipixels-media-media-packedaudio-state-function-state-src-minipixels-media-media-ml-455829007"></a>
### state

```ml
function state()
```

Returns the current player state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L103)

<a id="method-method-minipixels-media-media-packedaudio-stop-function-stop-src-minipixels-media-media-ml-2037000945"></a>
### stop

```ml
function stop()
```

Stops playback and rewinds the player.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L94)
