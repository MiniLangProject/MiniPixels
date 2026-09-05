# `minipixels.core.time.TimeState`

[Home](README.md) · [Source file](File-src-minipixels-core-time-ml-1360759889.md)

<a id="struct-struct-minipixels-core-time-timestate-struct-timestate-src-minipixels-core-time-ml-2125012709"></a>
## TimeState

```ml
struct TimeState
```

Represents the time state data used by the minipixels core time module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L8)

## Members

<a id="field-field-minipixels-core-time-timestate-alpha-alpha-src-minipixels-core-time-ml-2096108825"></a>
### alpha

```ml
alpha
```

Fraction of the next fixed update used for render interpolation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L24)

<a id="field-field-minipixels-core-time-timestate-delta-delta-src-minipixels-core-time-ml-2094871913"></a>
### delta

```ml
delta
```

Stores the delta value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L10)

<a id="field-field-minipixels-core-time-timestate-elapsed-elapsed-src-minipixels-core-time-ml-1958262765"></a>
### elapsed

```ml
elapsed
```

Stores the elapsed value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L14)

<a id="field-field-minipixels-core-time-timestate-fixeddelta-fixeddelta-src-minipixels-core-time-ml-2072001441"></a>
### fixedDelta

```ml
fixedDelta
```

Stores the fixed delta value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L12)

<a id="field-field-minipixels-core-time-timestate-fps-fps-src-minipixels-core-time-ml-1372739141"></a>
### fps

```ml
fps
```

Stores the fps value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L20)

<a id="field-field-minipixels-core-time-timestate-framenumber-framenumber-src-minipixels-core-time-ml-983426189"></a>
### frameNumber

```ml
frameNumber
```

Stores the frame number value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L16)

<a id="field-field-minipixels-core-time-timestate-sampleelapsed-sampleelapsed-src-minipixels-core-time-ml-1691691649"></a>
### sampleElapsed

```ml
sampleElapsed
```

Accumulated wall time used for smoothed rate reporting.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L26)

<a id="field-field-minipixels-core-time-timestate-sampleframes-sampleframes-src-minipixels-core-time-ml-476611041"></a>
### sampleFrames

```ml
sampleFrames
```

Number of rendered frames in the active rate sample.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L28)

<a id="field-field-minipixels-core-time-timestate-sampleupdates-sampleupdates-src-minipixels-core-time-ml-1134860801"></a>
### sampleUpdates

```ml
sampleUpdates
```

Number of fixed updates in the active rate sample.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L30)

<a id="field-field-minipixels-core-time-timestate-updatenumber-updatenumber-src-minipixels-core-time-ml-1430882737"></a>
### updateNumber

```ml
updateNumber
```

Stores the update number value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L18)

<a id="field-field-minipixels-core-time-timestate-ups-ups-src-minipixels-core-time-ml-2090518801"></a>
### ups

```ml
ups
```

Stores the ups value associated with time state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/core/time.ml#L22)
