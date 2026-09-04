# `src/minipixels/world/camera.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels world camera facilities for this project.

Package: [`minipixels.world.camera`](Package-minipixels-world-camera-1173910486.md)

Reachable from entry: **yes**

## Imports

- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

- [minipixels.world.camera.Camera](Type-minipixels-world-camera-camera-1268062631.md) — struct
<a id="function-function-minipixels-world-camera-clamptoworld-function-clamptoworld-c-src-minipixels-world-camera-ml-716331063"></a>
### clampToWorld

```ml
function clampToWorld(c)
```

Performs the clampToWorld operation for the minipixels world camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/camera.ml#L73)

<a id="function-function-minipixels-world-camera-create-function-create-width-height-src-minipixels-world-camera-ml-1446888477"></a>
### create

```ml
function create(width, height)
```

Creates create for the minipixels world camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/camera.ml#L58)

<a id="function-function-minipixels-world-camera-follow-function-follow-c-x-y-src-minipixels-world-camera-ml-2113699124"></a>
### follow

```ml
function follow(c, x, y)
```

Performs the follow operation for the minipixels world camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/camera.ml#L90)

<a id="function-function-minipixels-world-camera-parallaxoffset-function-parallaxoffset-c-factorx-factory-src-minipixels-world-camera-ml-2128547342"></a>
### parallaxOffset

```ml
function parallaxOffset(c, factorX, factorY)
```

Performs the parallaxOffset operation for the minipixels world camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `factorX` | `dynamic` | — | factorX value consumed by this operation. |
| `factorY` | `dynamic` | — | factorY value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/camera.ml#L100)

<a id="function-function-minipixels-world-camera-setworld-function-setworld-c-w-h-src-minipixels-world-camera-ml-241450592"></a>
### setWorld

```ml
function setWorld(c, w, h)
```

Updates world maintained by the minipixels world camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `w` | `dynamic` | — | w value consumed by this operation. |
| `h` | `dynamic` | — | h value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/camera.ml#L66)
