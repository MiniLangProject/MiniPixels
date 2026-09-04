# `minipixels.animation.animation.Animation`

[Home](README.md) · [Source file](File-src-minipixels-animation-animation-ml-2065983051.md)

<a id="struct-struct-minipixels-animation-animation-animation-struct-animation-src-minipixels-animation-animation-ml-684773679"></a>
## Animation

```ml
struct Animation
```

Represents the animation data used by the minipixels animation animation module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L8)

## Members

<a id="method-method-minipixels-animation-animation-animation-addframe-function-addframe-sprite-duration-src-minipixels-animation-animation-ml-1595593150"></a>
### addFrame

```ml
function addFrame(sprite, duration)
```

Adds frame to the state managed by the minipixels animation animation module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprite` | `dynamic` | — | sprite value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L33)

<a id="field-field-minipixels-animation-animation-animation-count-count-src-minipixels-animation-animation-ml-161217651"></a>
### count

```ml
count
```

Stores the count value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L14)

<a id="method-method-minipixels-animation-animation-animation-currentsprite-function-currentsprite-src-minipixels-animation-animation-ml-824986125"></a>
### currentSprite

```ml
function currentSprite()
```

Performs the currentSprite operation for the minipixels animation animation animation module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L76)

<a id="field-field-minipixels-animation-animation-animation-direction-direction-src-minipixels-animation-animation-ml-1070784835"></a>
### direction

```ml
direction
```

Stores the direction value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L26)

<a id="field-field-minipixels-animation-animation-animation-durations-durations-src-minipixels-animation-animation-ml-565314395"></a>
### durations

```ml
durations
```

Stores the durations value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L12)

<a id="field-field-minipixels-animation-animation-animation-elapsed-elapsed-src-minipixels-animation-animation-ml-344744515"></a>
### elapsed

```ml
elapsed
```

Stores the elapsed value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L18)

<a id="field-field-minipixels-animation-animation-animation-frames-frames-src-minipixels-animation-animation-ml-1526717047"></a>
### frames

```ml
frames
```

Stores the frames value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L10)

<a id="field-field-minipixels-animation-animation-animation-index-index-src-minipixels-animation-animation-ml-1832099195"></a>
### index

```ml
index
```

Stores the index value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L16)

<a id="field-field-minipixels-animation-animation-animation-looping-looping-src-minipixels-animation-animation-ml-484451407"></a>
### looping

```ml
looping
```

Stores the looping value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L22)

<a id="method-method-minipixels-animation-animation-animation-pause-function-pause-src-minipixels-animation-animation-ml-1311751301"></a>
### pause

```ml
function pause()
```

Performs the pause operation for the minipixels animation animation animation module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L53)

<a id="field-field-minipixels-animation-animation-animation-pingpong-pingpong-src-minipixels-animation-animation-ml-1408664911"></a>
### pingPong

```ml
pingPong
```

Stores the ping pong value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L24)

<a id="method-method-minipixels-animation-animation-animation-play-function-play-src-minipixels-animation-animation-ml-1407505749"></a>
### play

```ml
function play()
```

Performs the play operation for the minipixels animation animation animation module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L38)

<a id="field-field-minipixels-animation-animation-animation-playing-playing-src-minipixels-animation-animation-ml-396912447"></a>
### playing

```ml
playing
```

Stores the playing value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L20)

<a id="method-method-minipixels-animation-animation-animation-reset-function-reset-src-minipixels-animation-animation-ml-808946307"></a>
### reset

```ml
function reset()
```

Performs the reset operation for the minipixels animation animation animation module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L48)

<a id="method-method-minipixels-animation-animation-animation-setlooping-function-setlooping-value-src-minipixels-animation-animation-ml-36718806"></a>
### setLooping

```ml
function setLooping(value)
```

Updates looping maintained by the minipixels animation animation module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L59)

<a id="method-method-minipixels-animation-animation-animation-setpingpong-function-setpingpong-value-src-minipixels-animation-animation-ml-310683918"></a>
### setPingPong

```ml
function setPingPong(value)
```

Updates ping pong maintained by the minipixels animation animation module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L65)

<a id="field-field-minipixels-animation-animation-animation-speed-speed-src-minipixels-animation-animation-ml-1590331651"></a>
### speed

```ml
speed
```

Stores the speed value associated with animation.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L28)

<a id="method-method-minipixels-animation-animation-animation-stop-function-stop-src-minipixels-animation-animation-ml-654776825"></a>
### stop

```ml
function stop()
```

Stops stop for the minipixels animation animation workflow.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L43)

<a id="method-method-minipixels-animation-animation-animation-update-function-update-dt-src-minipixels-animation-animation-ml-1109193737"></a>
### update

```ml
function update(dt)
```

Updates update for the minipixels animation animation workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dt` | `dynamic` | — | dt value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/animation/animation.ml#L71)
