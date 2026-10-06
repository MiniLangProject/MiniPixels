# `minipixels.media.media.PackedVideo`

[Home](README.md) · [Source file](File-src-minipixels-media-media-ml-194127391.md)

<a id="struct-struct-minipixels-media-media-packedvideo-struct-packedvideo-src-minipixels-media-media-ml-221952833"></a>
## PackedVideo

```ml
struct PackedVideo
```

Video player whose encoded bytes remain inside its MPX file.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L137)

## Members

<a id="method-method-minipixels-media-media-packedvideo-attach-function-attach-windowhandle-src-minipixels-media-media-ml-792850344"></a>
### attach

```ml
function attach(windowHandle)
```

Attaches video output to a native window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `windowHandle` | `dynamic` | — | Win32 HWND or X11 window id. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L144)

<a id="method-method-minipixels-media-media-packedvideo-close-function-close-src-minipixels-media-media-ml-1448024954"></a>
### close

```ml
function close()
```

Closes the player before releasing its MPX range source.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L184)

<a id="field-field-minipixels-media-media-packedvideo-closed-closed-src-minipixels-media-media-ml-1912254490"></a>
### closed

```ml
closed
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L140)

<a id="method-method-minipixels-media-media-packedvideo-duration-function-duration-src-minipixels-media-media-ml-237413034"></a>
### duration

```ml
function duration()
```

Returns the media duration.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L157)

<a id="method-method-minipixels-media-media-packedvideo-hasaudio-function-hasaudio-src-minipixels-media-media-ml-225646466"></a>
### hasAudio

```ml
function hasAudio()
```

Returns whether the media exposes an audio track.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L161)

<a id="method-method-minipixels-media-media-packedvideo-hasvideo-function-hasvideo-src-minipixels-media-media-ml-1878030482"></a>
### hasVideo

```ml
function hasVideo()
```

Returns whether the media exposes a video track.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L163)

<a id="method-method-minipixels-media-media-packedvideo-pause-function-pause-src-minipixels-media-media-ml-1516739230"></a>
### pause

```ml
function pause()
```

Pauses playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L148)

<a id="method-method-minipixels-media-media-packedvideo-play-function-play-src-minipixels-media-media-ml-326160994"></a>
### play

```ml
function play()
```

Starts or resumes playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L146)

<a id="field-field-minipixels-media-media-packedvideo-player-player-src-minipixels-media-media-ml-1108460048"></a>
### player

```ml
player
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L139)

<a id="method-method-minipixels-media-media-packedvideo-pollevent-function-pollevent-src-minipixels-media-media-ml-2055105472"></a>
### pollEvent

```ml
function pollEvent()
```

Returns the next queued media event.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L181)

<a id="method-method-minipixels-media-media-packedvideo-position-function-position-src-minipixels-media-media-ml-955998150"></a>
### position

```ml
function position()
```

Returns the current playback timestamp.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L155)

<a id="method-method-minipixels-media-media-packedvideo-seek-function-seek-milliseconds-src-minipixels-media-media-ml-792649568"></a>
### seek

```ml
function seek(milliseconds)
```

Seeks to a media timestamp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `milliseconds` | `dynamic` | — | Target timestamp in milliseconds. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L153)

<a id="method-method-minipixels-media-media-packedvideo-setloop-function-setloop-enabled-src-minipixels-media-media-ml-530716307"></a>
### setLoop

```ml
function setLoop(enabled)
```

Enables or disables looping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | True to loop playback. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L179)

<a id="method-method-minipixels-media-media-packedvideo-setmuted-function-setmuted-muted-src-minipixels-media-media-ml-931409493"></a>
### setMuted

```ml
function setMuted(muted)
```

Enables or disables muting.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `muted` | `dynamic` | — | True to mute playback. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L173)

<a id="method-method-minipixels-media-media-packedvideo-setplaybackrate-function-setplaybackrate-rate-src-minipixels-media-media-ml-563065634"></a>
### setPlaybackRate

```ml
function setPlaybackRate(rate)
```

Sets the playback speed multiplier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rate` | `dynamic` | — | Playback speed accepted by `std.video`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L176)

<a id="method-method-minipixels-media-media-packedvideo-setvolume-function-setvolume-volume-src-minipixels-media-media-ml-228705196"></a>
### setVolume

```ml
function setVolume(volume)
```

Sets playback volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume accepted by `std.video`. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L170)

<a id="field-field-minipixels-media-media-packedvideo-source-source-src-minipixels-media-media-ml-845850280"></a>
### source

```ml
source
```


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L138)

<a id="method-method-minipixels-media-media-packedvideo-state-function-state-src-minipixels-media-media-ml-158619428"></a>
### state

```ml
function state()
```

Returns the current player state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L159)

<a id="method-method-minipixels-media-media-packedvideo-stop-function-stop-src-minipixels-media-media-ml-1647671830"></a>
### stop

```ml
function stop()
```

Stops playback and rewinds the player.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L150)

<a id="method-method-minipixels-media-media-packedvideo-videoheight-function-videoheight-src-minipixels-media-media-ml-1716028242"></a>
### videoHeight

```ml
function videoHeight()
```

Returns the decoded video height.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L167)

<a id="method-method-minipixels-media-media-packedvideo-videowidth-function-videowidth-src-minipixels-media-media-ml-1338987938"></a>
### videoWidth

```ml
function videoWidth()
```

Returns the decoded video width.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/media/media.ml#L165)
