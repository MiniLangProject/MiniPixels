# `src/minipixels/audio/audio.ml`

[Home](README.md) · [Files](Files.md)

Provides legacy sound playback and a buffered multi-voice PCM mixer.

Package: [`minipixels.audio.audio`](Package-minipixels-audio-audio-2063109159.md)

Reachable from entry: **yes**

## Imports

- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)
- `std/bytes.ml` as `by` → `../MiniLangCompilerML/std/bytes.ml` — external dependency
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

- [minipixels.audio.audio.AudioChannel](Type-minipixels-audio-audio-audiochannel-2041318038.md) — struct
- [minipixels.audio.audio.AudioClip](Type-minipixels-audio-audio-audioclip-2035849473.md) — struct
- [minipixels.audio.audio.AudioMixer](Type-minipixels-audio-audio-audiomixer-583677548.md) — struct
- [minipixels.audio.audio.AudioState](Type-minipixels-audio-audio-audiostate-1754318248.md) — struct
<a id="function-function-minipixels-audio-audio-backendname-function-backendname-src-minipixels-audio-audio-ml-410717894"></a>
### backendName

```ml
function backendName()
```

Returns the primary advanced audio backend name.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L427)

<a id="function-function-minipixels-audio-audio-channel-function-channel-id-src-minipixels-audio-audio-ml-1513742897"></a>
### channel

```ml
function channel(id)
```

Creates an inactive mixer channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable channel identifier. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L390)

<a id="function-function-minipixels-audio-audio-choosechannel-function-choosechannel-value-src-minipixels-audio-audio-ml-132341089"></a>
### chooseChannel

```ml
function chooseChannel(value)
```

Chooses an idle channel or a deterministic round-robin replacement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer whose channels are inspected. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L691)

<a id="function-function-minipixels-audio-audio-chunkis-function-chunkis-data-offset-a-b-c-d-src-minipixels-audio-audio-ml-1791883403"></a>
### chunkIs

```ml
function chunkIs(data, offset, a, b, c, d)
```

Returns whether four bytes match an ASCII chunk identifier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | WAV byte buffer. |
| `offset` | `dynamic` | — | Starting byte offset. |
| `a` | `dynamic` | — | First identifier byte. |
| `b` | `dynamic` | — | Second identifier byte. |
| `c` | `dynamic` | — | Third identifier byte. |
| `d` | `dynamic` | — | Fourth identifier byte. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L605)

<a id="function-function-minipixels-audio-audio-clip-function-clip-path-name-src-minipixels-audio-audio-ml-1063573672"></a>
### clip

```ml
function clip(path, name)
```

Creates a file-backed audio clip.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |
| `name` | `dynamic` | — | Stable clip name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L364)

<a id="function-function-minipixels-audio-audio-clipfrombytes-function-clipfrombytes-data-name-src-minipixels-audio-audio-ml-1031187923"></a>
### clipFromBytes

```ml
function clipFromBytes(data, name)
```

Creates an in-memory WAV audio clip.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete WAV file bytes. |
| `name` | `dynamic` | — | Stable clip name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L373)

<a id="function-function-minipixels-audio-audio-close-function-close-audio-src-minipixels-audio-audio-ml-57250972"></a>
### close

```ml
function close(audio)
```

Closes an advanced mixer while accepting legacy audio state values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Audio state or mixer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L1020)

<a id="function-function-minipixels-audio-audio-closemixer-function-closemixer-value-src-minipixels-audio-audio-ml-1464048709"></a>
### closeMixer

```ml
function closeMixer(value)
```

Releases retained buffers and closes the native PCM output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to close. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L982)

<a id="function-function-minipixels-audio-audio-create-function-create-src-minipixels-audio-audio-ml-1139740796"></a>
### create

```ml
function create()
```

Creates legacy direct-playback state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L357)

<a id="function-function-minipixels-audio-audio-effectiveclipvolume-function-effectiveclipvolume-audio-channelvolume-clipvolume-src-minipixels-audio-audio-ml-76886695"></a>
### effectiveClipVolume

```ml
function effectiveClipVolume(audio, channelVolume, clipVolume)
```

Returns effective state/channel/clip volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Shared audio state. |
| `channelVolume` | `dynamic` | — | Bus or channel volume percentage. |
| `clipVolume` | `dynamic` | — | Clip volume percentage. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L422)

<a id="function-function-minipixels-audio-audio-effectivevolume-function-effectivevolume-audio-channelvolume-src-minipixels-audio-audio-ml-4040267"></a>
### effectiveVolume

```ml
function effectiveVolume(audio, channelVolume)
```

Returns effective state/channel volume before clip-specific scaling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Shared audio state. |
| `channelVolume` | `dynamic` | — | Bus or channel volume percentage. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L413)

<a id="function-function-minipixels-audio-audio-ensurebackend-function-ensurebackend-value-src-minipixels-audio-audio-ml-1066765565"></a>
### ensureBackend

```ml
function ensureBackend(value)
```

Opens the platform PCM device and prepares retained output buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to open. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L780)

<a id="function-function-minipixels-audio-audio-getu32-function-getu32-buffer-offset-src-minipixels-audio-audio-ml-2062268999"></a>
### getU32

```ml
function getU32(buffer, offset)
```

Reads a little-endian unsigned 32-bit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Source byte buffer. |
| `offset` | `dynamic` | — | Starting byte offset. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L579)

<a id="function-function-minipixels-audio-audio-getu64-function-getu64-buffer-offset-src-minipixels-audio-audio-ml-876331771"></a>
### getU64

```ml
function getU64(buffer, offset)
```

Reads a little-endian unsigned 64-bit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Source byte buffer. |
| `offset` | `dynamic` | — | Starting byte offset. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L586)

<a id="function-function-minipixels-audio-audio-hasrange-function-hasrange-data-offset-size-src-minipixels-audio-audio-ml-308052286"></a>
### hasRange

```ml
function hasRange(data, offset, size)
```

Returns whether a byte range is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Byte buffer to inspect. |
| `offset` | `dynamic` | — | Starting byte offset. |
| `size` | `dynamic` | — | Required byte count. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L594)

<a id="function-function-minipixels-audio-audio-mixbuffer-function-mixbuffer-value-output-src-minipixels-audio-audio-ml-1839013514"></a>
### mixBuffer

```ml
function mixBuffer(value, output)
```

Mixes active voices into one interleaved stereo 16-bit output buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Source mixer. |
| `output` | `dynamic` | — | Destination interleaved PCM buffer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L738)

<a id="function-function-minipixels-audio-audio-mixer-function-mixer-maxchannels-src-minipixels-audio-audio-ml-1382070998"></a>
### mixer

```ml
function mixer(maxChannels)
```

Creates a lazily opened multi-voice PCM mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxChannels` | `dynamic` | — | Maximum simultaneous sound-effect voices. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L396)

<a id="constant-constant-minipixels-audio-audio-mixer-buffer-count-const-mixer-buffer-count-3-src-minipixels-audio-audio-ml-287319778"></a>
### MIXER_BUFFER_COUNT

```ml
const MIXER_BUFFER_COUNT = 3
```

Number of buffers retained in the output queue.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L115)

<a id="constant-constant-minipixels-audio-audio-mixer-buffer-frames-const-mixer-buffer-frames-1024-src-minipixels-audio-audio-ml-670309352"></a>
### MIXER_BUFFER_FRAMES

```ml
const MIXER_BUFFER_FRAMES = 1024
```

Number of stereo frames in one queued mixer buffer.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L113)

<a id="constant-constant-minipixels-audio-audio-mixer-sample-rate-const-mixer-sample-rate-44100-src-minipixels-audio-audio-ml-2123322046"></a>
### MIXER_SAMPLE_RATE

```ml
const MIXER_SAMPLE_RATE = 44100
```

Default mixer sample rate.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L111)

<a id="function-function-minipixels-audio-audio-mixerplaymusic-function-mixerplaymusic-value-source-src-minipixels-audio-audio-ml-23262282"></a>
### mixerPlayMusic

```ml
function mixerPlayMusic(value, source)
```

Starts or replaces the dedicated music voice.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Destination mixer. |
| `source` | `dynamic` | — | Prepared or lazy audio clip. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L858)

<a id="function-function-minipixels-audio-audio-mixerplaysfx-function-mixerplaysfx-value-source-src-minipixels-audio-audio-ml-2069513338"></a>
### mixerPlaySfx

```ml
function mixerPlaySfx(value, source)
```

Starts a sound-effect voice without interrupting other voices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Destination mixer. |
| `source` | `dynamic` | — | Prepared or lazy audio clip. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L835)

<a id="function-function-minipixels-audio-audio-mixerstopall-function-mixerstopall-value-src-minipixels-audio-audio-ml-320772273"></a>
### mixerStopAll

```ml
function mixerStopAll(value)
```

Stops every mixer voice and replaces queued output with silence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to stop. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L930)

<a id="function-function-minipixels-audio-audio-mixvoice-function-mixvoice-value-voice-busvolume-src-minipixels-audio-audio-ml-1921813683"></a>
### mixVoice

```ml
function mixVoice(value, voice, busVolume)
```

Accumulates one voice into reusable stereo mix arrays and returns its new state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Destination mixer. |
| `voice` | `dynamic` | — | Voice to advance. |
| `busVolume` | `dynamic` | — | Bus volume percentage. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L704)

<a id="constant-constant-minipixels-audio-audio-mmsyserr-noerror-const-mmsyserr-noerror-0-src-minipixels-audio-audio-ml-1668941983"></a>
### MMSYSERR_NOERROR

```ml
const MMSYSERR_NOERROR = 0
```

Successful multimedia-system result.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L97)

<a id="function-function-minipixels-audio-audio-musicclip-function-musicclip-path-name-src-minipixels-audio-audio-ml-2047326674"></a>
### musicClip

```ml
function musicClip(path, name)
```

Creates a looping file-backed music clip.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |
| `name` | `dynamic` | — | Stable clip name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L382)

<a id="function-function-minipixels-audio-audio-normalizepan-function-normalizepan-value-src-minipixels-audio-audio-ml-208173369"></a>
### normalizePan

```ml
function normalizePan(value)
```

Normalizes pan into the inclusive -100..100 range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Candidate pan. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L349)

<a id="function-function-minipixels-audio-audio-normalizevolume-function-normalizevolume-value-src-minipixels-audio-audio-ml-1136828683"></a>
### normalizeVolume

```ml
function normalizeVolume(value)
```

Normalizes a percentage volume into the inclusive 0..100 range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Candidate volume. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L340)

<a id="function-function-minipixels-audio-audio-playclip-function-playclip-audio-value-src-minipixels-audio-audio-ml-1317191505"></a>
### playClip

```ml
function playClip(audio, value)
```

Plays a clip through legacy state or the advanced mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Destination audio state or mixer. |
| `value` | `dynamic` | — | Audio clip to play. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L539)

<a id="function-function-minipixels-audio-audio-playmusic-function-playmusic-path-src-minipixels-audio-audio-ml-1533567019"></a>
### playMusic

```ml
function playMusic(path)
```

Plays looping legacy music from a path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L511)

<a id="function-function-minipixels-audio-audio-playmusicwithstate-function-playmusicwithstate-audio-path-src-minipixels-audio-audio-ml-1696997549"></a>
### playMusicWithState

```ml
function playMusicWithState(audio, path)
```

Plays looping music through legacy state or the advanced mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Destination audio state or mixer. |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L528)

<a id="function-function-minipixels-audio-audio-playsfx-function-playsfx-audio-path-src-minipixels-audio-audio-ml-696113711"></a>
### playSfx

```ml
function playSfx(audio, path)
```

Plays a path as either legacy state playback or mixer playback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Destination audio state or mixer. |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L518)

<a id="function-function-minipixels-audio-audio-playsound-function-playsound-path-src-minipixels-audio-audio-ml-222199423"></a>
### playSound

```ml
function playSound(path)
```

Plays one WAV file through the legacy operating-system helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L447)

<a id="function-function-minipixels-audio-audio-playsoundbytes-function-playsoundbytes-data-src-minipixels-audio-audio-ml-253944656"></a>
### playSoundBytes

```ml
function playSoundBytes(data)
```

Plays WAV file bytes through the legacy helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete WAV file bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L480)

<a id="function-function-minipixels-audio-audio-playsoundbytessync-function-playsoundbytessync-data-src-minipixels-audio-audio-ml-2100117544"></a>
### playSoundBytesSync

```ml
function playSoundBytesSync(data)
```

Plays WAV file bytes synchronously through the legacy helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Complete WAV file bytes. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L491)

<a id="function-function-minipixels-audio-audio-playsoundloop-function-playsoundloop-path-src-minipixels-audio-audio-ml-792422107"></a>
### playSoundLoop

```ml
function playSoundLoop(path)
```

Plays one looping WAV file through the legacy helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L469)

<a id="extern_function-extern-function-minipixels-audio-audio-playsoundmemory-extern-function-playsoundmemory-data-as-ptr-module-as-ptr-flags-as-int-from-winmm-dll-symbol-playsoundw-returns-bool-src-minipixels-audio-audio-ml-698928250"></a>
### PlaySoundMemory

```ml
extern function PlaySoundMemory(data as ptr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
```

Invokes the legacy PlaySoundW memory entry point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `ptr` | — | Pointer to complete WAV bytes. |
| `module` | `ptr` | — | Optional resource module handle. |
| `flags` | `int` | — | WinMM playback flags. |


**Returns:** Whether playback started.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L23)

<a id="function-function-minipixels-audio-audio-playsoundsync-function-playsoundsync-path-src-minipixels-audio-audio-ml-1212590181"></a>
### playSoundSync

```ml
function playSoundSync(path)
```

Plays one WAV file synchronously through the legacy helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | WAV file path. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L458)

<a id="extern_function-extern-function-minipixels-audio-audio-playsoundw-extern-function-playsoundw-path-as-wstr-module-as-ptr-flags-as-int-from-winmm-dll-symbol-playsoundw-returns-bool-src-minipixels-audio-audio-ml-1708401531"></a>
### PlaySoundW

```ml
extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
```

Invokes the legacy PlaySoundW file entry point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | UTF-16 WAV file path. |
| `module` | `ptr` | — | Optional resource module handle. |
| `flags` | `int` | — | WinMM playback flags. |


**Returns:** Whether playback started.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L17)

<a id="function-function-minipixels-audio-audio-prepareclip-function-prepareclip-value-src-minipixels-audio-audio-ml-1136745543"></a>
### prepareClip

```ml
function prepareClip(value)
```

Loads and parses a PCM WAV clip on first use.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Audio clip to prepare. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L612)

<a id="function-function-minipixels-audio-audio-preparemixerformat-function-preparemixerformat-value-src-minipixels-audio-audio-ml-1534543109"></a>
### prepareMixerFormat

```ml
function prepareMixerFormat(value)
```

Initializes and fills the native PCM format structure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to initialize. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L767)

<a id="function-function-minipixels-audio-audio-putu32-function-putu32-buffer-offset-value-src-minipixels-audio-audio-ml-1424367900"></a>
### putU32

```ml
function putU32(buffer, offset, value)
```

Writes a little-endian 32-bit value to a native structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Destination byte buffer. |
| `offset` | `dynamic` | — | Starting byte offset. |
| `value` | `dynamic` | — | Integer value to encode. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L559)

<a id="function-function-minipixels-audio-audio-putu64-function-putu64-buffer-offset-value-src-minipixels-audio-audio-ml-1896812244"></a>
### putU64

```ml
function putU64(buffer, offset, value)
```

Writes a little-endian 64-bit value to a native structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Destination byte buffer. |
| `offset` | `dynamic` | — | Starting byte offset. |
| `value` | `dynamic` | — | Integer value to encode. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L571)

<a id="function-function-minipixels-audio-audio-refreshmixer-function-refreshmixer-value-src-minipixels-audio-audio-ml-2084548497"></a>
### refreshMixer

```ml
function refreshMixer(value)
```

Applies a volume or mute change to subsequently mixed buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to refresh. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L924)

<a id="function-function-minipixels-audio-audio-sampleat-function-sampleat-value-frame-side-src-minipixels-audio-audio-ml-2062631707"></a>
### sampleAt

```ml
function sampleAt(value, frame, side)
```

Reads one source sample and converts it to signed 16-bit amplitude.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Prepared audio clip. |
| `frame` | `dynamic` | — | Zero-based sample frame. |
| `side` | `dynamic` | — | Source side, zero for left and one for right. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L666)

<a id="function-function-minipixels-audio-audio-setchannel-function-setchannel-value-id-volume-pan-src-minipixels-audio-audio-ml-713064651"></a>
### setChannel

```ml
function setChannel(value, id, volume, pan)
```

Sets one sound-effect channel's volume and pan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer owning the channel. |
| `id` | `dynamic` | — | Zero-based channel identifier. |
| `volume` | `dynamic` | — | Percentage from 0 through 100. |
| `pan` | `dynamic` | — | Pan from -100 through 100. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L971)

<a id="constant-constant-minipixels-audio-audio-snd-async-const-snd-async-1-src-minipixels-audio-audio-ml-1322667142"></a>
### SND_ASYNC

```ml
const SND_ASYNC = 1
```

Legacy asynchronous playback flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L81)

<a id="constant-constant-minipixels-audio-audio-snd-filename-const-snd-filename-131072-src-minipixels-audio-audio-ml-215512995"></a>
### SND_FILENAME

```ml
const SND_FILENAME = 131072
```

Legacy filename playback flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L91)

<a id="constant-constant-minipixels-audio-audio-snd-loop-const-snd-loop-8-src-minipixels-audio-audio-ml-420892747"></a>
### SND_LOOP

```ml
const SND_LOOP = 8
```

Legacy looping flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L87)

<a id="constant-constant-minipixels-audio-audio-snd-memory-const-snd-memory-4-src-minipixels-audio-audio-ml-28765133"></a>
### SND_MEMORY

```ml
const SND_MEMORY = 4
```

Legacy memory playback flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L85)

<a id="constant-constant-minipixels-audio-audio-snd-nodefault-const-snd-nodefault-2-src-minipixels-audio-audio-ml-1562408735"></a>
### SND_NODEFAULT

```ml
const SND_NODEFAULT = 2
```

Legacy no-default-sound flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L83)

<a id="constant-constant-minipixels-audio-audio-snd-pcm-access-rw-interleaved-const-snd-pcm-access-rw-interleaved-3-src-minipixels-audio-audio-ml-518988744"></a>
### SND_PCM_ACCESS_RW_INTERLEAVED

```ml
const SND_PCM_ACCESS_RW_INTERLEAVED = 3
```

ALSA read/write interleaved access mode.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L109)

<a id="constant-constant-minipixels-audio-audio-snd-pcm-format-s16-le-const-snd-pcm-format-s16-le-2-src-minipixels-audio-audio-ml-1309007647"></a>
### SND_PCM_FORMAT_S16_LE

```ml
const SND_PCM_FORMAT_S16_LE = 2
```

ALSA signed 16-bit little-endian sample format.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L107)

<a id="constant-constant-minipixels-audio-audio-snd-pcm-nonblock-const-snd-pcm-nonblock-1-src-minipixels-audio-audio-ml-947214574"></a>
### SND_PCM_NONBLOCK

```ml
const SND_PCM_NONBLOCK = 1
```

ALSA non-blocking open flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L105)

<a id="constant-constant-minipixels-audio-audio-snd-pcm-stream-playback-const-snd-pcm-stream-playback-0-src-minipixels-audio-audio-ml-90034637"></a>
### SND_PCM_STREAM_PLAYBACK

```ml
const SND_PCM_STREAM_PLAYBACK = 0
```

ALSA playback stream selector.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L103)

<a id="constant-constant-minipixels-audio-audio-snd-purge-const-snd-purge-64-src-minipixels-audio-audio-ml-1070278709"></a>
### SND_PURGE

```ml
const SND_PURGE = 64
```

Legacy purge flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L89)

<a id="constant-constant-minipixels-audio-audio-snd-sync-const-snd-sync-0-src-minipixels-audio-audio-ml-1889669705"></a>
### SND_SYNC

```ml
const SND_SYNC = 0
```

Legacy synchronous playback flag.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L79)

<a id="function-function-minipixels-audio-audio-stopchannel-function-stopchannel-value-id-src-minipixels-audio-audio-ml-887401248"></a>
### stopChannel

```ml
function stopChannel(value, id)
```

Stops one sound-effect channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer owning the channel. |
| `id` | `dynamic` | — | Zero-based channel identifier. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L957)

<a id="function-function-minipixels-audio-audio-stopsound-function-stopsound-src-minipixels-audio-audio-ml-2145337042"></a>
### stopSound

```ml
function stopSound()
```

Stops legacy direct playback.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L501)

<a id="function-function-minipixels-audio-audio-supportsmultiplesfx-function-supportsmultiplesfx-src-minipixels-audio-audio-ml-886731190"></a>
### supportsMultipleSfx

```ml
function supportsMultipleSfx()
```

Returns whether the mixer supports simultaneous sound effects.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L436)

<a id="function-function-minipixels-audio-audio-supportsvolumecontrol-function-supportsvolumecontrol-src-minipixels-audio-audio-ml-956723918"></a>
### supportsVolumeControl

```ml
function supportsVolumeControl()
```

Returns whether the mixer applies per-bus, per-channel, and per-clip volume.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L441)

<a id="function-function-minipixels-audio-audio-update-function-update-audio-src-minipixels-audio-audio-ml-563201104"></a>
### update

```ml
function update(audio)
```

Updates an advanced mixer while accepting legacy audio state values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | Audio state or mixer. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L1013)

<a id="function-function-minipixels-audio-audio-updatemixer-function-updatemixer-value-src-minipixels-audio-audio-ml-1939388709"></a>
### updateMixer

```ml
function updateMixer(value)
```

Refills completed Windows headers or an available ALSA period.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Mixer to update. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L882)

<a id="constant-constant-minipixels-audio-audio-wave-format-pcm-const-wave-format-pcm-1-src-minipixels-audio-audio-ml-853778922"></a>
### WAVE_FORMAT_PCM

```ml
const WAVE_FORMAT_PCM = 1
```

PCM waveform format identifier.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L95)

<a id="constant-constant-minipixels-audio-audio-wave-mapper-const-wave-mapper-4294967295-src-minipixels-audio-audio-ml-624364048"></a>
### WAVE_MAPPER

```ml
const WAVE_MAPPER = 4294967295
```

Default waveform output device selector.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L93)

<a id="constant-constant-minipixels-audio-audio-wavehdr-size-const-wavehdr-size-48-src-minipixels-audio-audio-ml-896746603"></a>
### WAVEHDR_SIZE

```ml
const WAVEHDR_SIZE = 48
```

Native WAVEHDR size on x64 Windows.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L101)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutclose-extern-function-waveoutclose-handle-as-ptr-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-1865723696"></a>
### waveOutClose

```ml
extern function waveOutClose(handle as ptr) from "winmm.dll" returns u32
```

Closes a waveform output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Open waveform output handle. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L58)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutopen-extern-function-waveoutopen-handle-as-bytes-device-as-u32-format-as-bytes-callback-as-ptr-instance-as-ptr-flags-as-u32-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-1368150372"></a>
### waveOutOpen

```ml
extern function waveOutOpen(handle as bytes, device as u32, format as bytes, callback as ptr, instance as ptr, flags as u32) from "winmm.dll" returns u32
```

Opens a waveform output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `bytes` | — | Destination for the opened device handle. |
| `device` | `u32` | — | Waveform device selector. |
| `format` | `bytes` | — | PCM WAVEFORMATEX bytes. |
| `callback` | `ptr` | — | Optional callback pointer. |
| `instance` | `ptr` | — | Optional callback instance. |
| `flags` | `u32` | — | Open flags. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L32)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutprepareheader-extern-function-waveoutprepareheader-handle-as-ptr-header-as-bytes-size-as-u32-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-1244580209"></a>
### waveOutPrepareHeader

```ml
extern function waveOutPrepareHeader(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
```

Prepares one waveform output header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Open waveform output handle. |
| `header` | `bytes` | — | WAVEHDR bytes. |
| `size` | `u32` | — | Native WAVEHDR size. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L38)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutreset-extern-function-waveoutreset-handle-as-ptr-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-82553482"></a>
### waveOutReset

```ml
extern function waveOutReset(handle as ptr) from "winmm.dll" returns u32
```

Stops playback and returns queued headers to the application.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Open waveform output handle. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L54)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutunprepareheader-extern-function-waveoutunprepareheader-handle-as-ptr-header-as-bytes-size-as-u32-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-1897396311"></a>
### waveOutUnprepareHeader

```ml
extern function waveOutUnprepareHeader(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
```

Unprepares one waveform output header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Open waveform output handle. |
| `header` | `bytes` | — | Completed WAVEHDR bytes. |
| `size` | `u32` | — | Native WAVEHDR size. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L50)

<a id="extern_function-extern-function-minipixels-audio-audio-waveoutwrite-extern-function-waveoutwrite-handle-as-ptr-header-as-bytes-size-as-u32-from-winmm-dll-returns-u32-src-minipixels-audio-audio-ml-1868486543"></a>
### waveOutWrite

```ml
extern function waveOutWrite(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
```

Queues one prepared waveform output header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Open waveform output handle. |
| `header` | `bytes` | — | Prepared WAVEHDR bytes. |
| `size` | `u32` | — | Native WAVEHDR size. |


**Returns:** Multimedia-system result code.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L44)

<a id="constant-constant-minipixels-audio-audio-whdr-done-const-whdr-done-1-src-minipixels-audio-audio-ml-2065175966"></a>
### WHDR_DONE

```ml
const WHDR_DONE = 1
```

Header flag set after an output buffer finishes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L99)
