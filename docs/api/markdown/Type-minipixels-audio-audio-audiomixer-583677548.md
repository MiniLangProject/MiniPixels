# `minipixels.audio.audio.AudioMixer`

[Home](README.md) · [Source file](File-src-minipixels-audio-audio-ml-660527635.md)

<a id="struct-struct-minipixels-audio-audio-audiomixer-struct-audiomixer-src-minipixels-audio-audio-ml-624563825"></a>
## AudioMixer

```ml
struct AudioMixer
```

Represents a software PCM mixer backed by WinMM waveOut or ALSA.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L291)

## Members

<a id="field-field-minipixels-audio-audio-audiomixer-audio-audio-src-minipixels-audio-audio-ml-71920972"></a>
### audio

```ml
audio
```

Shared bus volume and mute state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L293)

<a id="field-field-minipixels-audio-audio-audiomixer-buffercount-buffercount-src-minipixels-audio-audio-ml-1557663584"></a>
### bufferCount

```ml
bufferCount
```

Number of queued buffers.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L319)

<a id="field-field-minipixels-audio-audio-audiomixer-bufferframes-bufferframes-src-minipixels-audio-audio-ml-721824012"></a>
### bufferFrames

```ml
bufferFrames
```

Stereo sample frames per buffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L317)

<a id="field-field-minipixels-audio-audio-audiomixer-buffers-buffers-src-minipixels-audio-audio-ml-2016976192"></a>
### buffers

```ml
buffers
```

Retained output byte buffers.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L313)

<a id="field-field-minipixels-audio-audio-audiomixer-channelcount-channelcount-src-minipixels-audio-audio-ml-1974549612"></a>
### channelCount

```ml
channelCount
```

Number of sound-effect voices.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L297)

<a id="field-field-minipixels-audio-audio-audiomixer-channels-channels-src-minipixels-audio-audio-ml-351011016"></a>
### channels

```ml
channels
```

Sound-effect voices.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L295)

<a id="method-method-minipixels-audio-audio-audiomixer-close-function-close-src-minipixels-audio-audio-ml-1133851762"></a>
### close

```ml
function close()
```

Releases the native output device.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L388)

<a id="field-field-minipixels-audio-audio-audiomixer-format-format-src-minipixels-audio-audio-ml-1754452030"></a>
### format

```ml
format
```

Native PCM WAVEFORMATEX storage used on Windows.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L311)

<a id="field-field-minipixels-audio-audio-audiomixer-handle-handle-src-minipixels-audio-audio-ml-981249164"></a>
### handle

```ml
handle
```

Native waveOut or ALSA PCM handle.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L307)

<a id="field-field-minipixels-audio-audio-audiomixer-handlestorage-handlestorage-src-minipixels-audio-audio-ml-487586528"></a>
### handleStorage

```ml
handleStorage
```

Native handle output storage.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L309)

<a id="field-field-minipixels-audio-audio-audiomixer-headers-headers-src-minipixels-audio-audio-ml-1307128444"></a>
### headers

```ml
headers
```

Retained native WAVEHDR structures used on Windows.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L315)

<a id="field-field-minipixels-audio-audio-audiomixer-lasterror-lasterror-src-minipixels-audio-audio-ml-1444303204"></a>
### lastError

```ml
lastError
```

Last native audio error code.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L327)

<a id="field-field-minipixels-audio-audio-audiomixer-mixleft-mixleft-src-minipixels-audio-audio-ml-710958788"></a>
### mixLeft

```ml
mixLeft
```

Reusable left-channel mixing accumulator.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L321)

<a id="field-field-minipixels-audio-audio-audiomixer-mixright-mixright-src-minipixels-audio-audio-ml-1332356952"></a>
### mixRight

```ml
mixRight
```

Reusable right-channel mixing accumulator.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L323)

<a id="field-field-minipixels-audio-audio-audiomixer-music-music-src-minipixels-audio-audio-ml-611737000"></a>
### music

```ml
music
```

Active music clip retained for compatibility.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L301)

<a id="field-field-minipixels-audio-audio-audiomixer-musicchannel-musicchannel-src-minipixels-audio-audio-ml-522760268"></a>
### musicChannel

```ml
musicChannel
```

Dedicated music voice.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L303)

<a id="method-method-minipixels-audio-audio-audiomixer-mute-function-mute-src-minipixels-audio-audio-ml-587003342"></a>
### mute

```ml
function mute()
```

Mutes all buses for subsequently mixed samples.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L348)

<a id="field-field-minipixels-audio-audio-audiomixer-nextchannel-nextchannel-src-minipixels-audio-audio-ml-1240139108"></a>
### nextChannel

```ml
nextChannel
```

Round-robin replacement cursor.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L299)

<a id="method-method-minipixels-audio-audio-audiomixer-playmusic-function-playmusic-clip-src-minipixels-audio-audio-ml-1170273894"></a>
### playMusic

```ml
function playMusic(clip)
```

Starts or replaces the dedicated music voice.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clip` | `dynamic` | — | WAV or MP3 clip. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L364)

<a id="method-method-minipixels-audio-audio-audiomixer-playsfx-function-playsfx-clip-src-minipixels-audio-audio-ml-869959498"></a>
### playSfx

```ml
function playSfx(clip)
```

Starts a sound-effect voice.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clip` | `dynamic` | — | WAV or MP3 clip. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L359)

<a id="field-field-minipixels-audio-audio-audiomixer-ready-ready-src-minipixels-audio-audio-ml-530294568"></a>
### ready

```ml
ready
```

Whether the native PCM backend is open.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L325)

<a id="field-field-minipixels-audio-audio-audiomixer-samplerate-samplerate-src-minipixels-audio-audio-ml-1540088640"></a>
### sampleRate

```ml
sampleRate
```

Output sample rate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L305)

<a id="method-method-minipixels-audio-audio-audiomixer-setchannel-function-setchannel-id-volume-pan-src-minipixels-audio-audio-ml-654725674"></a>
### setChannel

```ml
function setChannel(id, volume, pan)
```

Sets volume and pan for one sound-effect channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Zero-based channel identifier. |
| `volume` | `dynamic` | — | Percentage from 0 through 100. |
| `pan` | `dynamic` | — | Pan from -100 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L384)

<a id="method-method-minipixels-audio-audio-audiomixer-setmastervolume-function-setmastervolume-value-src-minipixels-audio-audio-ml-195509011"></a>
### setMasterVolume

```ml
function setMasterVolume(value)
```

Sets master volume for subsequently mixed samples.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L331)

<a id="method-method-minipixels-audio-audio-audiomixer-setmusicvolume-function-setmusicvolume-value-src-minipixels-audio-audio-ml-987640579"></a>
### setMusicVolume

```ml
function setMusicVolume(value)
```

Sets music bus volume for subsequently mixed samples.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L343)

<a id="method-method-minipixels-audio-audio-audiomixer-setsfxvolume-function-setsfxvolume-value-src-minipixels-audio-audio-ml-1926371943"></a>
### setSfxVolume

```ml
function setSfxVolume(value)
```

Sets sound-effect bus volume for subsequently mixed samples.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Percentage from 0 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L337)

<a id="method-method-minipixels-audio-audio-audiomixer-stopall-function-stopall-src-minipixels-audio-audio-ml-2353796"></a>
### stopAll

```ml
function stopAll()
```

Stops every active voice.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L372)

<a id="method-method-minipixels-audio-audio-audiomixer-stopchannel-function-stopchannel-id-src-minipixels-audio-audio-ml-549842483"></a>
### stopChannel

```ml
function stopChannel(id)
```

Stops one sound-effect channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Zero-based channel identifier. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L377)

<a id="method-method-minipixels-audio-audio-audiomixer-unmute-function-unmute-src-minipixels-audio-audio-ml-1780619714"></a>
### unmute

```ml
function unmute()
```

Unmutes all buses for subsequently mixed samples.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L353)

<a id="method-method-minipixels-audio-audio-audiomixer-update-function-update-src-minipixels-audio-audio-ml-701288054"></a>
### update

```ml
function update()
```

Refills completed output buffers.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L368)
