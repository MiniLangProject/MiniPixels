# `minipixels.math.types.Vector2`

[Home](README.md) · [Source file](File-src-minipixels-math-types-ml-311947336.md)

<a id="struct-struct-minipixels-math-types-vector2-struct-vector2-src-minipixels-math-types-ml-2050492357"></a>
## Vector2

```ml
struct Vector2
```

Represents the vector2 data used by the minipixels math types module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L10)

## Members

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-float-operator-inline-left-as-vector2-scale-as-float-returns-vector2-src-minipixels-math-types-ml-456632948"></a>
### operator *

```ml
operator inline *(left as Vector2, scale as float) returns Vector2
```

Multiplies a vector by a floating-point scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Vector to scale. |
| `scale` | `float` | — | Floating-point scale. |


**Returns:** Scaled vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L51)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-int-operator-inline-left-as-vector2-scale-as-int-returns-vector2-src-minipixels-math-types-ml-979333478"></a>
### operator *

```ml
operator inline *(left as Vector2, scale as int) returns Vector2
```

Multiplies a vector by an integer scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Vector to scale. |
| `scale` | `int` | — | Integer scale. |


**Returns:** Scaled vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L43)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-vector2-operator-inline-left-as-vector2-right-as-vector2-returns-vector2-src-minipixels-math-types-ml-1962429172"></a>
### operator +

```ml
operator inline +(left as Vector2, right as Vector2) returns Vector2
```

Adds two vectors component-wise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Left vector. |
| `right` | `Vector2` | — | Right vector. |


**Returns:** Component-wise sum.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L20)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-operator-inline-value-as-vector2-returns-vector2-src-minipixels-math-types-ml-2146484444"></a>
### operator -

```ml
operator inline -(value as Vector2) returns Vector2
```

Negates both vector components.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `Vector2` | — | Vector to negate. |


**Returns:** Negated vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L35)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-vector2-operator-inline-left-as-vector2-right-as-vector2-returns-vector2-src-minipixels-math-types-ml-894326244"></a>
### operator -

```ml
operator inline -(left as Vector2, right as Vector2) returns Vector2
```

Subtracts two vectors component-wise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Left vector. |
| `right` | `Vector2` | — | Right vector. |


**Returns:** Component-wise difference.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L28)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-float-operator-inline-left-as-vector2-divisor-as-float-returns-vector2-src-minipixels-math-types-ml-930420398"></a>
### operator /

```ml
operator inline /(left as Vector2, divisor as float) returns Vector2
```

Divides a vector by a floating-point scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Vector to scale. |
| `divisor` | `float` | — | Floating-point divisor. |


**Returns:** Scaled vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L67)

<a id="operator-operator-minipixels-math-types-vector2-operator-vector2-int-operator-inline-left-as-vector2-divisor-as-int-returns-vector2-src-minipixels-math-types-ml-601888176"></a>
### operator /

```ml
operator inline /(left as Vector2, divisor as int) returns Vector2
```

Divides a vector by an integer scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `Vector2` | — | Vector to scale. |
| `divisor` | `int` | — | Integer divisor. |


**Returns:** Scaled vector.

[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L59)

<a id="field-field-minipixels-math-types-vector2-x-x-src-minipixels-math-types-ml-476140512"></a>
### x

```ml
x
```

Stores the x value associated with vector2.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L12)

<a id="field-field-minipixels-math-types-vector2-y-y-src-minipixels-math-types-ml-778943908"></a>
### y

```ml
y
```

Stores the y value associated with vector2.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/math/types.ml#L14)
