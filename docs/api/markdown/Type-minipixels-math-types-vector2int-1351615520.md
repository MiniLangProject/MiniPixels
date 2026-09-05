# `minipixels.math.types.Vector2Int`

[Home](README.md) · [Source file](File-src-minipixels-math-types-ml-311947336.md)

<a id="struct-struct-minipixels-math-types-vector2int-struct-vector2int-src-minipixels-math-types-ml-1891727213"></a>
## Vector2Int

```ml
struct Vector2Int
```

Represents the vector2 int data used by the minipixels math types module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L73)

## Members

<a id="operator-operator-minipixels-math-types-vector2int-operator-vector2int-int-operator-inline-left-as-vector2int-scale-as-int-returns-vector2int-src-minipixels-math-types-ml-243241816"></a>
### operator *

```ml
operator inline *(left as Vector2Int, scale as int) returns Vector2Int
```

Multiplies an integer vector by an integer scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2Int` | — | Vector to scale. |
| `scale` | `int` | — | Integer scale. |


**Returns:** Scaled vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L99)

<a id="operator-operator-minipixels-math-types-vector2int-operator-vector2int-vector2int-operator-inline-left-as-vector2int-right-as-vector2int-returns-vector2int-src-minipixels-math-types-ml-2036860408"></a>
### operator +

```ml
operator inline +(left as Vector2Int, right as Vector2Int) returns Vector2Int
```

Adds two integer vectors component-wise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2Int` | — | Left vector. |
| `right` | `Vector2Int` | — | Right vector. |


**Returns:** Component-wise sum.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L83)

<a id="operator-operator-minipixels-math-types-vector2int-operator-vector2int-vector2int-operator-inline-left-as-vector2int-right-as-vector2int-returns-vector2int-src-minipixels-math-types-ml-1851032004"></a>
### operator -

```ml
operator inline -(left as Vector2Int, right as Vector2Int) returns Vector2Int
```

Subtracts two integer vectors component-wise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2Int` | — | Left vector. |
| `right` | `Vector2Int` | — | Right vector. |


**Returns:** Component-wise difference.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L91)

<a id="field-field-minipixels-math-types-vector2int-x-x-src-minipixels-math-types-ml-1955339181"></a>
### x

```ml
x
```

Stores the x value associated with vector2 int.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L75)

<a id="field-field-minipixels-math-types-vector2int-y-y-src-minipixels-math-types-ml-1528625609"></a>
### y

```ml
y
```

Stores the y value associated with vector2 int.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L77)
