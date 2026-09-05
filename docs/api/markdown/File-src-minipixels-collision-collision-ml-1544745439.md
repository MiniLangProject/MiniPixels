# `src/minipixels/collision/collision.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels collision collision facilities for this project.

Package: [`minipixels.collision.collision`](Package-minipixels-collision-collision-1331696867.md)

Reachable from entry: **yes**

## Imports

- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="function-function-minipixels-collision-collision-circlecircle-function-circlecircle-ax-ay-ar-bx-by-br-src-minipixels-collision-collision-ml-381173789"></a>
### circleCircle

```ml
function circleCircle(ax, ay, ar, bx, by, br)
```

Performs the circleCircle operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ax` | `dynamic` | — | ax value consumed by this operation. |
| `ay` | `dynamic` | — | ay value consumed by this operation. |
| `ar` | `dynamic` | — | ar value consumed by this operation. |
| `bx` | `dynamic` | — | bx value consumed by this operation. |
| `by` | `dynamic` | — | by value consumed by this operation. |
| `br` | `dynamic` | — | br value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L47)

<a id="function-function-minipixels-collision-collision-circlerect-function-circlerect-cx-cy-cr-r-src-minipixels-collision-collision-ml-242174790"></a>
### circleRect

```ml
function circleRect(cx, cy, cr, r)
```

Performs the circleRect operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cx` | `dynamic` | — | cx value consumed by this operation. |
| `cy` | `dynamic` | — | cy value consumed by this operation. |
| `cr` | `dynamic` | — | cr value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L59)

<a id="function-function-minipixels-collision-collision-clipaxis-function-clipaxis-p-q-t0-t1-src-minipixels-collision-collision-ml-1426590628"></a>
### clipAxis

```ml
function clipAxis(p, q, t0, t1)
```

Clips one Liang-Barsky segment interval against a rectangle boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Signed segment delta for the boundary. |
| `q` | `dynamic` | — | Signed origin distance from the boundary. |
| `t0` | `dynamic` | — | Current lower segment parameter. |
| `t1` | `dynamic` | — | Current upper segment parameter. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L99)

- [minipixels.collision.collision.CollisionResult](Type-minipixels-collision-collision-collisionresult-132924904.md) — struct
<a id="function-function-minipixels-collision-collision-linerect-function-linerect-x1-y1-x2-y2-r-src-minipixels-collision-collision-ml-1481786696"></a>
### lineRect

```ml
function lineRect(x1, y1, x2, y2, r)
```

Performs the lineRect operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | x1 value consumed by this operation. |
| `y1` | `dynamic` | — | y1 value consumed by this operation. |
| `x2` | `dynamic` | — | x2 value consumed by this operation. |
| `y2` | `dynamic` | — | y2 value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L73)

<a id="function-function-minipixels-collision-collision-pointrect-function-pointrect-px-py-r-src-minipixels-collision-collision-ml-1580897763"></a>
### pointRect

```ml
function pointRect(px, py, r)
```

Performs the pointRect operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `px` | `dynamic` | — | px value consumed by this operation. |
| `py` | `dynamic` | — | py value consumed by this operation. |
| `r` | `dynamic` | — | r value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L29)

<a id="function-function-minipixels-collision-collision-rectrect-function-rectrect-a-b-src-minipixels-collision-collision-ml-517571253"></a>
### rectRect

```ml
function rectRect(a, b)
```

Performs the rectRect operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L36)

<a id="function-function-minipixels-collision-collision-result-function-result-x-y-src-minipixels-collision-collision-ml-2085394241"></a>
### result

```ml
function result(x, y)
```

Performs the result operation for the minipixels collision collision module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/collision/collision.ml#L118)
