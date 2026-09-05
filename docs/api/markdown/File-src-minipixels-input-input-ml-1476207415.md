# `src/minipixels/input/input.ml`

[Home](README.md) · [Files](Files.md)

Provides buffered action, keyboard, and pointer input for MiniPixels.

Package: [`minipixels.input.input`](Package-minipixels-input-input-1057851307.md)

Reachable from entry: **yes**

## Imports

- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerML/std/ds/hashmap.ml` — external dependency

## Declarations

<a id="function-function-minipixels-input-input-actionslot-function-actionslot-i-action-src-minipixels-input-input-ml-1123221897"></a>
### actionSlot

```ml
function actionSlot(i, action)
```

Finds an existing action slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to inspect. |
| `action` | `dynamic` | — | Name of the action to find. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L204)

<a id="function-function-minipixels-input-input-addmousewheel-function-addmousewheel-i-delta-src-minipixels-input-input-ml-2050748279"></a>
### addMouseWheel

```ml
function addMouseWheel(i, delta)
```

Adds a platform wheel delta to the pending simulation input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |
| `delta` | `dynamic` | — | Signed wheel-step delta, including fractional high-resolution input. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L392)

<a id="function-function-minipixels-input-input-beginpoll-function-beginpoll-i-src-minipixels-input-input-ml-729759027"></a>
### beginPoll

```ml
function beginPoll(i)
```

Starts one platform poll while preserving unconsumed input edges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L300)

<a id="function-function-minipixels-input-input-beginupdate-function-beginupdate-i-src-minipixels-input-input-ml-822292563"></a>
### beginUpdate

```ml
function beginUpdate(i)
```

Publishes buffered edges and pointer deltas to one simulation update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L312)

<a id="function-function-minipixels-input-input-bindkeys-function-bindkeys-i-action-primary-secondary-src-minipixels-input-input-ml-1002032201"></a>
### bindKeys

```ml
function bindKeys(i, action, primary, secondary)
```

Assigns primary and secondary virtual-key bindings to an action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to configure. |
| `action` | `dynamic` | — | Name of the action to configure. |
| `primary` | `dynamic` | — | Primary Win32 virtual-key code. |
| `secondary` | `dynamic` | — | Secondary Win32 virtual-key code, or -1. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L238)

<a id="function-function-minipixels-input-input-create-function-create-src-minipixels-input-input-ml-1940254108"></a>
### create

```ml
function create()
```

Creates an input state with conventional keyboard and mouse bindings.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L141)

<a id="constant-constant-minipixels-input-input-default-action-capacity-const-default-action-capacity-16-src-minipixels-input-input-ml-1470367548"></a>
### DEFAULT_ACTION_CAPACITY

```ml
const DEFAULT_ACTION_CAPACITY = 16
```

Initial number of action slots allocated for an input state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L10)

<a id="function-function-minipixels-input-input-endupdate-function-endupdate-i-src-minipixels-input-input-ml-2075493675"></a>
### endUpdate

```ml
function endUpdate(i)
```

Clears edges after one simulation update so catch-up updates cannot replay them.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L332)

<a id="function-function-minipixels-input-input-ensureaction-function-ensureaction-i-action-src-minipixels-input-input-ml-1461760981"></a>
### ensureAction

```ml
function ensureAction(i, action)
```

Finds or creates an action slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to mutate. |
| `action` | `dynamic` | — | Name of the action to register. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L214)

<a id="function-function-minipixels-input-input-ensureactioncapacity-function-ensureactioncapacity-i-src-minipixels-input-input-ml-1942901487"></a>
### ensureActionCapacity

```ml
function ensureActionCapacity(i)
```

Grows the parallel action arrays when another slot is required.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to resize. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L170)

- [minipixels.input.input.InputState](Type-minipixels-input-input-inputstate-2086348942.md) — struct
<a id="function-function-minipixels-input-input-isdown-function-isdown-i-action-src-minipixels-input-input-ml-2109353501"></a>
### isDown

```ml
function isDown(i, action)
```

Returns whether an action is currently held.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to inspect. |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L399)

<a id="function-function-minipixels-input-input-pressed-function-pressed-i-action-src-minipixels-input-input-ml-1827530821"></a>
### pressed

```ml
function pressed(i, action)
```

Returns whether an action became held since the previous consumed update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to inspect. |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L422)

<a id="function-function-minipixels-input-input-releaseall-function-releaseall-i-src-minipixels-input-input-ml-828367711"></a>
### releaseAll

```ml
function releaseAll(i)
```

Releases every registered action, buffering release edges where needed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L366)

<a id="function-function-minipixels-input-input-released-function-released-i-action-src-minipixels-input-input-ml-1900633497"></a>
### released

```ml
function released(i, action)
```

Returns whether an action became released since the previous consumed update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to inspect. |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L431)

<a id="function-function-minipixels-input-input-setactionstate-function-setactionstate-i-action-down-src-minipixels-input-input-ml-1827232289"></a>
### setActionState

```ml
function setActionState(i, action, down)
```

Updates an action and buffers any resulting edge until a simulation update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to mutate. |
| `action` | `dynamic` | — | Name of the action to update. |
| `down` | `dynamic` | — | Whether the action is held. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L281)

<a id="function-function-minipixels-input-input-setkeyboard-function-setkeyboard-i-left-right-up-down-jump-fire-escape-src-minipixels-input-input-ml-1358514256"></a>
### setKeyboard

```ml
function setKeyboard(i, left, right, up, down, jump, fire, escape)
```

Updates the conventional keyboard actions for tests and non-Windows providers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |
| `left` | `dynamic` | — | Whether left is held. |
| `right` | `dynamic` | — | Whether right is held. |
| `up` | `dynamic` | — | Whether up is held. |
| `down` | `dynamic` | — | Whether down is held. |
| `jump` | `dynamic` | — | Whether jump is held. |
| `fire` | `dynamic` | — | Whether fire is held. |
| `escape` | `dynamic` | — | Whether escape is held. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L354)

<a id="function-function-minipixels-input-input-setmouseposition-function-setmouseposition-i-x-y-inside-src-minipixels-input-input-ml-2142517230"></a>
### setMousePosition

```ml
function setMousePosition(i, x, y, inside)
```

Records a pointer sample in logical canvas coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to update. |
| `x` | `dynamic` | — | Logical x coordinate. |
| `y` | `dynamic` | — | Logical y coordinate. |
| `inside` | `dynamic` | — | Whether the pointer lies inside the viewport. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L378)

<a id="function-function-minipixels-input-input-synclegacyaction-function-synclegacyaction-i-action-down-src-minipixels-input-input-ml-1772081145"></a>
### syncLegacyAction

```ml
function syncLegacyAction(i, action, down)
```

Synchronizes backward-compatible named fields after an action change.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to mutate. |
| `action` | `dynamic` | — | Name of the changed action. |
| `down` | `dynamic` | — | Whether the action is held. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L264)

<a id="function-function-minipixels-input-input-unbind-function-unbind-i-action-src-minipixels-input-input-ml-1366931409"></a>
### unbind

```ml
function unbind(i, action)
```

Removes all virtual-key bindings from an action while retaining its state slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to configure. |
| `action` | `dynamic` | — | Name of the action to unbind. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L251)

<a id="function-function-minipixels-input-input-wasdown-function-wasdown-i-action-src-minipixels-input-input-ml-1524276487"></a>
### wasDown

```ml
function wasDown(i, action)
```

Returns the previous platform-poll state for a built-in action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Input state to inspect. |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L408)
