# `src/minipixels/audio/audio.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels audio audio facilities for this project.

Package: [`minipixels.audio.audio`](Package-minipixels-audio-audio-2063109159.md)

Reachable from entry: **yes**

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

Performs the backendName operation for the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L277)

<a id="function-function-minipixels-audio-audio-channel-function-channel-id-src-minipixels-audio-audio-ml-1513742897"></a>
### channel

```ml
function channel(id)
```

Performs the channel operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Stable identifier of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L243)

<a id="function-function-minipixels-audio-audio-choosechannel-function-choosechannel-m-src-minipixels-audio-audio-ml-983803407"></a>
### chooseChannel

```ml
function chooseChannel(m)
```

Performs the chooseChannel operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L375)

<a id="function-function-minipixels-audio-audio-clip-function-clip-path-name-src-minipixels-audio-audio-ml-1063573672"></a>
### clip

```ml
function clip(path, name)
```

Performs the clip operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L216)

<a id="function-function-minipixels-audio-audio-clipfrombytes-function-clipfrombytes-data-name-src-minipixels-audio-audio-ml-1031187923"></a>
### clipFromBytes

```ml
function clipFromBytes(data, name)
```

Performs the clipFromBytes operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L225)

<a id="function-function-minipixels-audio-audio-create-function-create-src-minipixels-audio-audio-ml-1139740796"></a>
### create

```ml
function create()
```

Creates create for the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L209)

<a id="function-function-minipixels-audio-audio-effectiveclipvolume-function-effectiveclipvolume-audio-channelvolume-clipvolume-src-minipixels-audio-audio-ml-76886695"></a>
### effectiveClipVolume

```ml
function effectiveClipVolume(audio, channelVolume, clipVolume)
```

Performs the effectiveClipVolume operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `channelVolume` | `dynamic` | — | channelVolume value consumed by this operation. |
| `clipVolume` | `dynamic` | — | clipVolume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L272)

<a id="function-function-minipixels-audio-audio-effectivevolume-function-effectivevolume-audio-channelvolume-src-minipixels-audio-audio-ml-4040267"></a>
### effectiveVolume

```ml
function effectiveVolume(audio, channelVolume)
```

Performs the effectiveVolume operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `channelVolume` | `dynamic` | — | channelVolume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L263)

<a id="function-function-minipixels-audio-audio-mixer-function-mixer-maxchannels-src-minipixels-audio-audio-ml-1382070998"></a>
### mixer

```ml
function mixer(maxChannels)
```

Performs the mixer operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxChannels` | `dynamic` | — | maxChannels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L249)

<a id="function-function-minipixels-audio-audio-mixerplaymusic-function-mixerplaymusic-m-c-src-minipixels-audio-audio-ml-1716689716"></a>
### mixerPlayMusic

```ml
function mixerPlayMusic(m, c)
```

Performs the mixerPlayMusic operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L412)

<a id="function-function-minipixels-audio-audio-mixerplaysfx-function-mixerplaysfx-m-c-src-minipixels-audio-audio-ml-1829266276"></a>
### mixerPlaySfx

```ml
function mixerPlaySfx(m, c)
```

Performs the mixerPlaySfx operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L390)

<a id="function-function-minipixels-audio-audio-mixerstopall-function-mixerstopall-m-src-minipixels-audio-audio-ml-1233043679"></a>
### mixerStopAll

```ml
function mixerStopAll(m)
```

Performs the mixerStopAll operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `m` | `dynamic` | — | m value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L424)

<a id="function-function-minipixels-audio-audio-musicclip-function-musicclip-path-name-src-minipixels-audio-audio-ml-2047326674"></a>
### musicClip

```ml
function musicClip(path, name)
```

Performs the musicClip operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L235)

<a id="function-function-minipixels-audio-audio-normalizevolume-function-normalizevolume-value-src-minipixels-audio-audio-ml-1136828683"></a>
### normalizeVolume

```ml
function normalizeVolume(value)
```

Normalizes volume for the minipixels audio audio workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L201)

<a id="function-function-minipixels-audio-audio-playclip-function-playclip-audio-c-src-minipixels-audio-audio-ml-1995858673"></a>
### playClip

```ml
function playClip(audio, c)
```

Performs the playClip operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L361)

<a id="function-function-minipixels-audio-audio-playmusic-function-playmusic-path-src-minipixels-audio-audio-ml-1533567019"></a>
### playMusic

```ml
function playMusic(path)
```

Performs the playMusic operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L335)

<a id="function-function-minipixels-audio-audio-playmusicwithstate-function-playmusicwithstate-audio-path-src-minipixels-audio-audio-ml-1696997549"></a>
### playMusicWithState

```ml
function playMusicWithState(audio, path)
```

Performs the playMusicWithState operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L351)

<a id="function-function-minipixels-audio-audio-playsfx-function-playsfx-audio-path-src-minipixels-audio-audio-ml-696113711"></a>
### playSfx

```ml
function playSfx(audio, path)
```

Performs the playSfx operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L342)

<a id="function-function-minipixels-audio-audio-playsound-function-playsound-path-src-minipixels-audio-audio-ml-222199423"></a>
### playSound

```ml
function playSound(path)
```

Performs the playSound operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L293)

<a id="function-function-minipixels-audio-audio-playsoundbytes-function-playsoundbytes-data-src-minipixels-audio-audio-ml-253944656"></a>
### playSoundBytes

```ml
function playSoundBytes(data)
```

Performs the playSoundBytes operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L314)

<a id="function-function-minipixels-audio-audio-playsoundbytessync-function-playsoundbytessync-data-src-minipixels-audio-audio-ml-2100117544"></a>
### playSoundBytesSync

```ml
function playSoundBytesSync(data)
```

Performs the playSoundBytesSync operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L322)

<a id="function-function-minipixels-audio-audio-playsoundloop-function-playsoundloop-path-src-minipixels-audio-audio-ml-792422107"></a>
### playSoundLoop

```ml
function playSoundLoop(path)
```

Performs the playSoundLoop operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L307)

<a id="extern_function-extern-function-minipixels-audio-audio-playsoundmemory-extern-function-playsoundmemory-data-as-ptr-module-as-ptr-flags-as-int-from-winmm-dll-symbol-playsoundw-returns-bool-src-minipixels-audio-audio-ml-698928250"></a>
### PlaySoundMemory

```ml
extern function PlaySoundMemory(data as ptr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
```

Invokes the native PlaySoundMemory entry point used by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `ptr` | — | Input data consumed by the operation. |
| `module` | `ptr` | — | module value consumed by this operation. |
| `flags` | `int` | — | Bit flags controlling the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L18)

<a id="function-function-minipixels-audio-audio-playsoundsync-function-playsoundsync-path-src-minipixels-audio-audio-ml-1212590181"></a>
### playSoundSync

```ml
function playSoundSync(path)
```

Performs the playSoundSync operation for the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L300)

<a id="extern_function-extern-function-minipixels-audio-audio-playsoundw-extern-function-playsoundw-path-as-wstr-module-as-ptr-flags-as-int-from-winmm-dll-symbol-playsoundw-returns-bool-src-minipixels-audio-audio-ml-1708401531"></a>
### PlaySoundW

```ml
extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
```

Invokes the native PlaySoundW entry point used by the minipixels audio audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `module` | `ptr` | — | module value consumed by this operation. |
| `flags` | `int` | — | Bit flags controlling the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L12)

<a id="constant-constant-minipixels-audio-audio-snd-async-const-snd-async-1-src-minipixels-audio-audio-ml-1322667142"></a>
### SND_ASYNC

```ml
const SND_ASYNC = 1
```

Defines the snd async constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L23)

<a id="constant-constant-minipixels-audio-audio-snd-filename-const-snd-filename-131072-src-minipixels-audio-audio-ml-215512995"></a>
### SND_FILENAME

```ml
const SND_FILENAME = 131072
```

Defines the snd filename constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L33)

<a id="constant-constant-minipixels-audio-audio-snd-loop-const-snd-loop-8-src-minipixels-audio-audio-ml-420892747"></a>
### SND_LOOP

```ml
const SND_LOOP = 8
```

Defines the snd loop constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L27)

<a id="constant-constant-minipixels-audio-audio-snd-memory-const-snd-memory-4-src-minipixels-audio-audio-ml-28765133"></a>
### SND_MEMORY

```ml
const SND_MEMORY = 4
```

Defines the snd memory constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L31)

<a id="constant-constant-minipixels-audio-audio-snd-nodefault-const-snd-nodefault-2-src-minipixels-audio-audio-ml-1562408735"></a>
### SND_NODEFAULT

```ml
const SND_NODEFAULT = 2
```

Defines the snd nodefault constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L25)

<a id="constant-constant-minipixels-audio-audio-snd-purge-const-snd-purge-64-src-minipixels-audio-audio-ml-1070278709"></a>
### SND_PURGE

```ml
const SND_PURGE = 64
```

Defines the snd purge constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L29)

<a id="constant-constant-minipixels-audio-audio-snd-sync-const-snd-sync-0-src-minipixels-audio-audio-ml-1889669705"></a>
### SND_SYNC

```ml
const SND_SYNC = 0
```

Defines the snd sync constant used by the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L21)

<a id="function-function-minipixels-audio-audio-stopsound-function-stopsound-src-minipixels-audio-audio-ml-2145337042"></a>
### stopSound

```ml
function stopSound()
```

Stops sound for the minipixels audio audio workflow.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L329)

<a id="function-function-minipixels-audio-audio-supportsmultiplesfx-function-supportsmultiplesfx-src-minipixels-audio-audio-ml-886731190"></a>
### supportsMultipleSfx

```ml
function supportsMultipleSfx()
```

Performs the supportsMultipleSfx operation for the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L282)

<a id="function-function-minipixels-audio-audio-supportsvolumecontrol-function-supportsvolumecontrol-src-minipixels-audio-audio-ml-956723918"></a>
### supportsVolumeControl

```ml
function supportsVolumeControl()
```

Performs the supportsVolumeControl operation for the minipixels audio audio module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/audio/audio.ml#L287)
