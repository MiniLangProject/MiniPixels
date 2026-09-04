# `src/minipixels/input/input.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels input input facilities for this project.

Package: [`minipixels.input.input`](Package-minipixels-input-input-1057851307.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-minipixels-input-input-beginframe-function-beginframe-i-src-minipixels-input-input-ml-1319033435"></a>
### beginFrame

```ml
function beginFrame(i)
```

Performs the beginFrame operation for the minipixels input input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L73)

<a id="function-function-minipixels-input-input-create-function-create-src-minipixels-input-input-ml-1940254108"></a>
### create

```ml
function create()
```

Creates create for the minipixels input input module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L67)

- [minipixels.input.input.InputState](Type-minipixels-input-input-inputstate-2086348942.md) — struct
<a id="function-function-minipixels-input-input-isdown-function-isdown-i-action-src-minipixels-input-input-ml-2109353501"></a>
### isDown

```ml
function isDown(i, action)
```

Returns whether down satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L105)

<a id="function-function-minipixels-input-input-pressed-function-pressed-i-action-src-minipixels-input-input-ml-1827530821"></a>
### pressed

```ml
function pressed(i, action)
```

Performs the pressed operation for the minipixels input input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L133)

<a id="function-function-minipixels-input-input-released-function-released-i-action-src-minipixels-input-input-ml-1900633497"></a>
### released

```ml
function released(i, action)
```

Performs the released operation for the minipixels input input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L140)

<a id="function-function-minipixels-input-input-setkeyboard-function-setkeyboard-i-left-right-up-down-jump-fire-escape-src-minipixels-input-input-ml-1358514256"></a>
### setKeyboard

```ml
function setKeyboard(i, left, right, up, down, jump, fire, escape)
```

Updates keyboard maintained by the minipixels input input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |
| `left` | `dynamic` | — | left value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |
| `up` | `dynamic` | — | up value consumed by this operation. |
| `down` | `dynamic` | — | down value consumed by this operation. |
| `jump` | `dynamic` | — | jump value consumed by this operation. |
| `fire` | `dynamic` | — | fire value consumed by this operation. |
| `escape` | `dynamic` | — | escape value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L92)

<a id="function-function-minipixels-input-input-wasdown-function-wasdown-i-action-src-minipixels-input-input-ml-1524276487"></a>
### wasDown

```ml
function wasDown(i, action)
```

Performs the wasDown operation for the minipixels input input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | i value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L119)
