# `src/minipixels.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels facilities for this project.

Package: [`minipixels`](Package-minipixels-983934759.md)

Reachable from entry: **yes**

## Imports

- `minipixels/animation/animation.ml` as `anim` → [src/minipixels/animation/animation.ml](File-src-minipixels-animation-animation-ml-2065983051.md)
- `minipixels/assets/assets.ml` as `ast` → [src/minipixels/assets/assets.ml](File-src-minipixels-assets-assets-ml-652120143.md)
- `minipixels/assets/pack.ml` as `pack` → [src/minipixels/assets/pack.ml](File-src-minipixels-assets-pack-ml-1157891367.md)
- `minipixels/audio/audio.ml` as `aud` → [src/minipixels/audio/audio.ml](File-src-minipixels-audio-audio-ml-660527635.md)
- `minipixels/core/time.ml` as `tm` → [src/minipixels/core/time.ml](File-src-minipixels-core-time-ml-1360759889.md)
- `minipixels/debug/debug.ml` as `dbg` → [src/minipixels/debug/debug.ml](File-src-minipixels-debug-debug-ml-1202344879.md)
- `minipixels/graphics/canvas.ml` as `cv` → [src/minipixels/graphics/canvas.ml](File-src-minipixels-graphics-canvas-ml-370061960.md)
- `minipixels/graphics/font.ml` as `font` → [src/minipixels/graphics/font.ml](File-src-minipixels-graphics-font-ml-906525775.md)
- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `minipixels/input/input.ml` as `inp` → [src/minipixels/input/input.ml](File-src-minipixels-input-input-ml-1476207415.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)
- `minipixels/platform/windows.ml` as `win` → [src/minipixels/platform/windows.ml](File-src-minipixels-platform-windows-ml-1027159307.md)
- `minipixels/scene/scene.ml` as `scn` → [src/minipixels/scene/scene.ml](File-src-minipixels-scene-scene-ml-552680371.md)
- `minipixels/world/camera.ml` as `cam` → [src/minipixels/world/camera.ml](File-src-minipixels-world-camera-ml-397830650.md)
- `minipixels/world/tilemap.ml` as `tile` → [src/minipixels/world/tilemap.ml](File-src-minipixels-world-tilemap-ml-2079329797.md)

## Declarations

<a id="function-function-minipixels-activerenderer-function-activerenderer-game-src-minipixels-ml-1731526494"></a>
### activeRenderer

```ml
function activeRenderer(game)
```

Performs the activeRenderer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `game` | `dynamic` | — | game value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L149)

<a id="function-function-minipixels-animation-function-animation-maxframes-src-minipixels-ml-1356665698"></a>
### animation

```ml
function animation(maxFrames)
```

Performs the animation operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxFrames` | `dynamic` | — | maxFrames value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L234)

<a id="function-function-minipixels-animationfromsheet-function-animationfromsheet-sheet-start-count-duration-src-minipixels-ml-308571094"></a>
### animationFromSheet

```ml
function animationFromSheet(sheet, start, count, duration)
```

Performs the animationFromSheet operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sheet` | `dynamic` | — | sheet value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L240)

<a id="function-function-minipixels-assetkindfrompack-function-assetkindfrompack-assetpack-name-src-minipixels-ml-482972938"></a>
### assetKindFromPack

```ml
function assetKindFromPack(assetPack, name)
```

Performs the assetKindFromPack operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `assetPack` | `dynamic` | — | assetPack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L227)

<a id="function-function-minipixels-audiobackend-function-audiobackend-src-minipixels-ml-1835271036"></a>
### audioBackend

```ml
function audioBackend()
```

Performs the audioBackend operation for the minipixels module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L394)

<a id="function-function-minipixels-audioclip-function-audioclip-path-name-src-minipixels-ml-515413188"></a>
### audioClip

```ml
function audioClip(path, name)
```

Performs the audioClip operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L366)

<a id="function-function-minipixels-audioclipfrombytes-function-audioclipfrombytes-data-name-src-minipixels-ml-1400301461"></a>
### audioClipFromBytes

```ml
function audioClipFromBytes(data, name)
```

Performs the audioClipFromBytes operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L370)

<a id="function-function-minipixels-audiomixer-function-audiomixer-maxchannels-src-minipixels-ml-246446996"></a>
### audioMixer

```ml
function audioMixer(maxChannels)
```

Performs the audioMixer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxChannels` | `dynamic` | — | maxChannels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L381)

<a id="function-function-minipixels-audiostate-function-audiostate-src-minipixels-ml-872649788"></a>
### audioState

```ml
function audioState()
```

Performs the audioState operation for the minipixels module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L354)

<a id="function-function-minipixels-audiosupportsmultiplesfx-function-audiosupportsmultiplesfx-src-minipixels-ml-155152452"></a>
### audioSupportsMultipleSfx

```ml
function audioSupportsMultipleSfx()
```

Performs the audioSupportsMultipleSfx operation for the minipixels module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L396)

<a id="function-function-minipixels-audiosupportsvolumecontrol-function-audiosupportsvolumecontrol-src-minipixels-ml-442255824"></a>
### audioSupportsVolumeControl

```ml
function audioSupportsVolumeControl()
```

Performs the audioSupportsVolumeControl operation for the minipixels module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L398)

<a id="function-function-minipixels-calliffunction-function-calliffunction-fn-a-src-minipixels-ml-1622940695"></a>
### callIfFunction

```ml
function callIfFunction(fn, a)
```

Performs the callIfFunction operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | fn value consumed by this operation. |
| `a` | `dynamic` | — | a value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L406)

<a id="function-function-minipixels-callrender-function-callrender-fn-game-canvas-src-minipixels-ml-417238454"></a>
### callRender

```ml
function callRender(fn, game, canvas)
```

Performs the callRender operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | fn value consumed by this operation. |
| `game` | `dynamic` | — | game value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L422)

<a id="function-function-minipixels-callupdate-function-callupdate-fn-game-dt-src-minipixels-ml-623549234"></a>
### callUpdate

```ml
function callUpdate(fn, game, dt)
```

Performs the callUpdate operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | fn value consumed by this operation. |
| `game` | `dynamic` | — | game value consumed by this operation. |
| `dt` | `dynamic` | — | dt value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L414)

<a id="function-function-minipixels-camera-function-camera-width-height-src-minipixels-ml-1194025291"></a>
### camera

```ml
function camera(width, height)
```

Performs the camera operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L244)

<a id="function-function-minipixels-createconfig-function-createconfig-title-width-height-scale-src-minipixels-ml-867415209"></a>
### createConfig

```ml
function createConfig(title, width, height, scale)
```

Creates config for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L85)

<a id="function-function-minipixels-creategame-function-creategame-cfg-src-minipixels-ml-177514248"></a>
### createGame

```ml
function createGame(cfg)
```

Creates game for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L94)

<a id="function-function-minipixels-drawrectworld-function-drawrectworld-canvas-camera-x-y-w-h-color-src-minipixels-ml-629981828"></a>
### drawRectWorld

```ml
function drawRectWorld(canvas, camera, x, y, w, h, color)
```

Draws rect world through the minipixels rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L289)

<a id="function-function-minipixels-drawspriteworld-function-drawspriteworld-canvas-camera-sprite-x-y-src-minipixels-ml-379099541"></a>
### drawSpriteWorld

```ml
function drawSpriteWorld(canvas, camera, sprite, x, y)
```

Draws sprite world through the minipixels rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L296)

<a id="function-function-minipixels-drawspriteworldex-function-drawspriteworldex-canvas-camera-sprite-x-y-flipx-flipy-scale-tint-src-minipixels-ml-480820627"></a>
### drawSpriteWorldEx

```ml
function drawSpriteWorldEx(canvas, camera, sprite, x, y, flipX, flipY, scale, tint)
```

Draws sprite world ex through the minipixels rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `flipX` | `dynamic` | — | flipX value consumed by this operation. |
| `flipY` | `dynamic` | — | flipY value consumed by this operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `tint` | `dynamic` | — | tint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L307)

<a id="function-function-minipixels-drawtext-function-drawtext-canvas-text-x-y-scale-color-src-minipixels-ml-520545259"></a>
### drawText

```ml
function drawText(canvas, text, x, y, scale, color)
```

Draws text through the minipixels rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L327)

<a id="function-function-minipixels-drawtextcentered-function-drawtextcentered-canvas-text-y-scale-color-src-minipixels-ml-1797824963"></a>
### drawTextCentered

```ml
function drawTextCentered(canvas, text, y, scale, color)
```

Draws text centered through the minipixels rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L334)

<a id="function-function-minipixels-fillrectworld-function-fillrectworld-canvas-camera-x-y-w-h-color-src-minipixels-ml-1539538118"></a>
### fillRectWorld

```ml
function fillRectWorld(canvas, camera, x, y, w, h, color)
```

Performs the fillRectWorld operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L280)

<a id="function-function-minipixels-framehash-function-framehash-canvas-src-minipixels-ml-1907773514"></a>
### frameHash

```ml
function frameHash(canvas)
```

Performs the frameHash operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L401)

- [minipixels.Game](Type-minipixels-game-1761105865.md) — struct
- [minipixels.GameConfig](Type-minipixels-gameconfig-282091547.md) — struct
<a id="function-function-minipixels-image-function-image-width-height-pixels-name-src-minipixels-ml-1561410215"></a>
### image

```ml
function image(width, height, pixels, name)
```

Performs the image operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L199)

<a id="function-function-minipixels-inputdown-function-inputdown-input-action-src-minipixels-ml-1105939080"></a>
### inputDown

```ml
function inputDown(input, action)
```

Performs the inputDown operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L311)

<a id="function-function-minipixels-inputpressed-function-inputpressed-input-action-src-minipixels-ml-574904456"></a>
### inputPressed

```ml
function inputPressed(input, action)
```

Performs the inputPressed operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L315)

<a id="function-function-minipixels-inputreleased-function-inputreleased-input-action-src-minipixels-ml-2125100718"></a>
### inputReleased

```ml
function inputReleased(input, action)
```

Performs the inputReleased operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L319)

<a id="function-function-minipixels-isgpurenderer-function-isgpurenderer-game-src-minipixels-ml-1641277372"></a>
### isGpuRenderer

```ml
function isGpuRenderer(game)
```

Returns whether gpu renderer satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `game` | `dynamic` | — | game value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L156)

<a id="function-function-minipixels-loadbytesfrompack-function-loadbytesfrompack-assetpack-name-src-minipixels-ml-594477536"></a>
### loadBytesFromPack

```ml
function loadBytesFromPack(assetPack, name)
```

Loads bytes from pack for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `assetPack` | `dynamic` | — | assetPack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L223)

<a id="function-function-minipixels-loadpngfrompack-function-loadpngfrompack-assetpack-name-src-minipixels-ml-560140056"></a>
### loadPngFromPack

```ml
function loadPngFromPack(assetPack, name)
```

Loads png from pack for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `assetPack` | `dynamic` | — | assetPack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L231)

<a id="function-function-minipixels-mixerplaymusic-function-mixerplaymusic-mixer-clip-src-minipixels-ml-680020851"></a>
### mixerPlayMusic

```ml
function mixerPlayMusic(mixer, clip)
```

Performs the mixerPlayMusic operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `clip` | `dynamic` | — | clip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L389)

<a id="function-function-minipixels-mixerplaysfx-function-mixerplaysfx-mixer-clip-src-minipixels-ml-1261022307"></a>
### mixerPlaySfx

```ml
function mixerPlaySfx(mixer, clip)
```

Performs the mixerPlaySfx operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `clip` | `dynamic` | — | clip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L385)

<a id="function-function-minipixels-mixerstopall-function-mixerstopall-mixer-src-minipixels-ml-1666561493"></a>
### mixerStopAll

```ml
function mixerStopAll(mixer)
```

Performs the mixerStopAll operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L392)

<a id="function-function-minipixels-musicclip-function-musicclip-path-name-src-minipixels-ml-1876241718"></a>
### musicClip

```ml
function musicClip(path, name)
```

Performs the musicClip operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L374)

<a id="function-function-minipixels-openassetpack-function-openassetpack-path-src-minipixels-ml-1608444883"></a>
### openAssetPack

```ml
function openAssetPack(path)
```

Opens asset pack for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L219)

<a id="function-function-minipixels-playaudio-function-playaudio-audio-clip-src-minipixels-ml-1404017418"></a>
### playAudio

```ml
function playAudio(audio, clip)
```

Performs the playAudio operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `clip` | `dynamic` | — | clip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L378)

<a id="function-function-minipixels-playmusic-function-playmusic-path-src-minipixels-ml-497976999"></a>
### playMusic

```ml
function playMusic(path)
```

Performs the playMusic operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L350)

<a id="function-function-minipixels-playmusicwithstate-function-playmusicwithstate-audio-path-src-minipixels-ml-57082401"></a>
### playMusicWithState

```ml
function playMusicWithState(audio, path)
```

Performs the playMusicWithState operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L362)

<a id="function-function-minipixels-playsfx-function-playsfx-audio-path-src-minipixels-ml-1629492027"></a>
### playSfx

```ml
function playSfx(audio, path)
```

Performs the playSfx operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audio` | `dynamic` | — | audio value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L358)

<a id="function-function-minipixels-playsound-function-playsound-path-src-minipixels-ml-908724171"></a>
### playSound

```ml
function playSound(path)
```

Performs the playSound operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L341)

<a id="function-function-minipixels-playsoundloop-function-playsoundloop-path-src-minipixels-ml-1662601623"></a>
### playSoundLoop

```ml
function playSoundLoop(path)
```

Performs the playSoundLoop operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L347)

<a id="function-function-minipixels-playsoundsync-function-playsoundsync-path-src-minipixels-ml-959644505"></a>
### playSoundSync

```ml
function playSoundSync(path)
```

Performs the playSoundSync operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L344)

<a id="function-function-minipixels-random-function-random-seed-src-minipixels-ml-1310410303"></a>
### random

```ml
function random(seed)
```

Performs the random operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seed` | `dynamic` | — | seed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L189)

<a id="function-function-minipixels-recti-function-recti-x-y-w-h-src-minipixels-ml-1140640022"></a>
### recti

```ml
function recti(x, y, w, h)
```

Performs the recti operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L186)

<a id="function-function-minipixels-rendererfallbackreason-function-rendererfallbackreason-game-src-minipixels-ml-512016926"></a>
### rendererFallbackReason

```ml
function rendererFallbackReason(game)
```

Performs the rendererFallbackReason operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `game` | `dynamic` | — | game value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L162)

<a id="function-function-minipixels-rgb-function-rgb-r-g-b-src-minipixels-ml-1814822953"></a>
### rgb

```ml
function rgb(r, g, b)
```

Performs the rgb operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `g` | `dynamic` | — | g value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L170)

<a id="function-function-minipixels-rgba-function-rgba-r-g-b-a-src-minipixels-ml-66620594"></a>
### rgba

```ml
function rgba(r, g, b, a)
```

Performs the rgba operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | r value consumed by this operation. |
| `g` | `dynamic` | — | g value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |
| `a` | `dynamic` | — | a value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L176)

<a id="function-function-minipixels-run-function-run-cfg-initialize-update-render-shutdown-src-minipixels-ml-1457808081"></a>
### run

```ml
function run(cfg, initialize, update, render, shutdown)
```

Runs run for the minipixels workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |
| `initialize` | `dynamic` | — | initialize value consumed by this operation. |
| `update` | `dynamic` | — | update value consumed by this operation. |
| `render` | `dynamic` | — | render value consumed by this operation. |
| `shutdown` | `dynamic` | — | shutdown value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L455)

<a id="function-function-minipixels-runheadless-function-runheadless-cfg-initialize-update-render-shutdown-src-minipixels-ml-1345190063"></a>
### runHeadless

```ml
function runHeadless(cfg, initialize, update, render, shutdown)
```

Runs headless for the minipixels workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |
| `initialize` | `dynamic` | — | initialize value consumed by this operation. |
| `update` | `dynamic` | — | update value consumed by this operation. |
| `render` | `dynamic` | — | render value consumed by this operation. |
| `shutdown` | `dynamic` | — | shutdown value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L432)

<a id="function-function-minipixels-setrenderer-function-setrenderer-cfg-renderer-src-minipixels-ml-2072096035"></a>
### setRenderer

```ml
function setRenderer(cfg, renderer)
```

Updates renderer maintained by the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L114)

<a id="function-function-minipixels-setscalemode-function-setscalemode-cfg-mode-src-minipixels-ml-628364205"></a>
### setScaleMode

```ml
function setScaleMode(cfg, mode)
```

Updates scale mode maintained by the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L127)

<a id="function-function-minipixels-setsmoothing-function-setsmoothing-cfg-enabled-src-minipixels-ml-2017300397"></a>
### setSmoothing

```ml
function setSmoothing(cfg, enabled)
```

Updates smoothing maintained by the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L143)

<a id="function-function-minipixels-solidimage-function-solidimage-width-height-color-name-src-minipixels-ml-358627443"></a>
### solidImage

```ml
function solidImage(width, height, color, name)
```

Performs the solidImage operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L205)

<a id="function-function-minipixels-spritefromimage-function-spritefromimage-img-name-src-minipixels-ml-927567202"></a>
### spriteFromImage

```ml
function spriteFromImage(img, name)
```

Performs the spriteFromImage operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L209)

<a id="function-function-minipixels-spritesheet-function-spritesheet-img-fw-fh-spacing-margin-src-minipixels-ml-2134396515"></a>
### spriteSheet

```ml
function spriteSheet(img, fw, fh, spacing, margin)
```

Performs the spriteSheet operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | img value consumed by this operation. |
| `fw` | `dynamic` | — | fw value consumed by this operation. |
| `fh` | `dynamic` | — | fh value consumed by this operation. |
| `spacing` | `dynamic` | — | spacing value consumed by this operation. |
| `margin` | `dynamic` | — | margin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L216)

<a id="function-function-minipixels-stopsound-function-stopsound-src-minipixels-ml-1217573942"></a>
### stopSound

```ml
function stopSound()
```

Stops sound for the minipixels workflow.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L352)

<a id="function-function-minipixels-textwidth-function-textwidth-text-scale-src-minipixels-ml-979331937"></a>
### textWidth

```ml
function textWidth(text, scale)
```

Performs the textWidth operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `scale` | `dynamic` | — | scale value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L338)

<a id="function-function-minipixels-tilelayer-function-tilelayer-name-width-height-data-visible-collision-px-py-src-minipixels-ml-1882362233"></a>
### tileLayer

```ml
function tileLayer(name, width, height, data, visible, collision, px, py)
```

Performs the tileLayer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `visible` | `dynamic` | — | visible value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `px` | `dynamic` | — | px value consumed by this operation. |
| `py` | `dynamic` | — | py value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L265)

<a id="function-function-minipixels-tilemap-function-tilemap-tilewidth-tileheight-width-height-tileset-maxlayers-src-minipixels-ml-1267631058"></a>
### tilemap

```ml
function tilemap(tileWidth, tileHeight, width, height, tileset, maxLayers)
```

Performs the tilemap operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tileWidth` | `dynamic` | — | tileWidth value consumed by this operation. |
| `tileHeight` | `dynamic` | — | tileHeight value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `tileset` | `dynamic` | — | tileset value consumed by this operation. |
| `maxLayers` | `dynamic` | — | maxLayers value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L255)

<a id="function-function-minipixels-tilemoveandcollide-function-tilemoveandcollide-map-rect-vx-vy-src-minipixels-ml-522107279"></a>
### tileMoveAndCollide

```ml
function tileMoveAndCollide(map, rect, vx, vy)
```

Performs the tileMoveAndCollide operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `rect` | `dynamic` | — | rect value consumed by this operation. |
| `vx` | `dynamic` | — | vx value consumed by this operation. |
| `vy` | `dynamic` | — | vy value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L271)

<a id="function-function-minipixels-tileset-function-tileset-sheet-src-minipixels-ml-313027703"></a>
### tileset

```ml
function tileset(sheet)
```

Performs the tileset operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sheet` | `dynamic` | — | sheet value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L247)

<a id="function-function-minipixels-timer-function-timer-seconds-repeat-src-minipixels-ml-74789418"></a>
### timer

```ml
function timer(seconds, repeat)
```

Performs the timer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seconds` | `dynamic` | — | seconds value consumed by this operation. |
| `repeat` | `dynamic` | — | repeat value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L193)

<a id="function-function-minipixels-usecpurenderer-function-usecpurenderer-cfg-src-minipixels-ml-861003236"></a>
### useCpuRenderer

```ml
function useCpuRenderer(cfg)
```

Performs the useCpuRenderer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L123)

<a id="function-function-minipixels-usefitscale-function-usefitscale-cfg-src-minipixels-ml-1517206112"></a>
### useFitScale

```ml
function useFitScale(cfg)
```

Performs the useFitScale operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L136)

<a id="function-function-minipixels-usegpurenderer-function-usegpurenderer-cfg-src-minipixels-ml-702356132"></a>
### useGpuRenderer

```ml
function useGpuRenderer(cfg)
```

Performs the useGpuRenderer operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L120)

<a id="function-function-minipixels-useintegerscale-function-useintegerscale-cfg-src-minipixels-ml-1916074690"></a>
### useIntegerScale

```ml
function useIntegerScale(cfg)
```

Performs the useIntegerScale operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L139)

<a id="function-function-minipixels-usestretchscale-function-usestretchscale-cfg-src-minipixels-ml-482967016"></a>
### useStretchScale

```ml
function useStretchScale(cfg)
```

Performs the useStretchScale operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cfg` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L133)

<a id="function-function-minipixels-vec2-function-vec2-x-y-src-minipixels-ml-1313943249"></a>
### vec2

```ml
function vec2(x, y)
```

Performs the vec2 operation for the minipixels module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L180)

<a id="function-function-minipixels-version-function-version-src-minipixels-ml-86816988"></a>
### version

```ml
function version()
```

Performs the version operation for the minipixels module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels.ml#L110)
