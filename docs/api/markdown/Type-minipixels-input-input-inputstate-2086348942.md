# `minipixels.input.input.InputState`

[Home](README.md) · [Source file](File-src-minipixels-input-input-ml-1476207415.md)

<a id="struct-struct-minipixels-input-input-inputstate-struct-inputstate-src-minipixels-input-input-ml-1384170933"></a>
## InputState

```ml
struct InputState
```

Represents the input state consumed by fixed simulation updates.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L30)

## Members

<a id="field-field-minipixels-input-input-inputstate-actioncapacity-actioncapacity-src-minipixels-input-input-ml-932530210"></a>
### actionCapacity

```ml
actionCapacity
```

Allocated action capacity.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L104)

<a id="field-field-minipixels-input-input-inputstate-actioncount-actioncount-src-minipixels-input-input-ml-1568798282"></a>
### actionCount

```ml
actionCount
```

Number of registered actions.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L102)

<a id="field-field-minipixels-input-input-inputstate-actiondown-actiondown-src-minipixels-input-input-ml-1732237154"></a>
### actionDown

```ml
actionDown
```

Current state for each action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L92)

<a id="field-field-minipixels-input-input-inputstate-actionindex-actionindex-src-minipixels-input-input-ml-1429437410"></a>
### actionIndex

```ml
actionIndex
```

Hash index mapping action names to slots.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L106)

<a id="field-field-minipixels-input-input-inputstate-actionnames-actionnames-src-minipixels-input-input-ml-1215417562"></a>
### actionNames

```ml
actionNames
```

Registered action names.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L86)

<a id="method-method-minipixels-input-input-inputstate-beginframe-function-beginframe-src-minipixels-input-input-ml-1239601872"></a>
### beginFrame

```ml
function beginFrame()
```

Starts a platform input poll without consuming pending edges.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L109)

<a id="method-method-minipixels-input-input-inputstate-beginupdate-function-beginupdate-src-minipixels-input-input-ml-1003960744"></a>
### beginUpdate

```ml
function beginUpdate()
```

Makes buffered edges visible to one fixed simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L114)

<a id="method-method-minipixels-input-input-inputstate-bindkey-function-bindkey-action-key-src-minipixels-input-input-ml-1150314497"></a>
### bindKey

```ml
function bindKey(action, key)
```

Binds one virtual key to an action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `action` | `dynamic` | — | Name of the action to configure. |
| `key` | `dynamic` | — | Win32 virtual-key code used as the primary binding. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L144)

<a id="method-method-minipixels-input-input-inputstate-bindkeys-function-bindkeys-action-primary-secondary-src-minipixels-input-input-ml-348991682"></a>
### bindKeys

```ml
function bindKeys(action, primary, secondary)
```

Binds two alternative virtual keys to an action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `action` | `dynamic` | — | Name of the action to configure. |
| `primary` | `dynamic` | — | Primary Win32 virtual-key code. |
| `secondary` | `dynamic` | — | Secondary Win32 virtual-key code, or -1. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L152)

<a id="field-field-minipixels-input-input-inputstate-down-down-src-minipixels-input-input-ml-692075714"></a>
### down

```ml
down
```

Legacy state for the built-in down action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L38)

<a id="method-method-minipixels-input-input-inputstate-endupdate-function-endupdate-src-minipixels-input-input-ml-1793981632"></a>
### endUpdate

```ml
function endUpdate()
```

Finishes one fixed simulation update and clears its edge snapshot.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L119)

<a id="field-field-minipixels-input-input-inputstate-escape-escape-src-minipixels-input-input-ml-1763941932"></a>
### escape

```ml
escape
```

Legacy state for the built-in escape action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L44)

<a id="field-field-minipixels-input-input-inputstate-fire-fire-src-minipixels-input-input-ml-1603767390"></a>
### fire

```ml
fire
```

Legacy state for the built-in fire action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L42)

<a id="method-method-minipixels-input-input-inputstate-isdown-function-isdown-action-src-minipixels-input-input-ml-1423967910"></a>
### isDown

```ml
function isDown(action)
```

Returns whether an action is currently held.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L125)

<a id="field-field-minipixels-input-input-inputstate-jump-jump-src-minipixels-input-input-ml-1177075938"></a>
### jump

```ml
jump
```

Legacy state for the built-in jump action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L40)

<a id="field-field-minipixels-input-input-inputstate-left-left-src-minipixels-input-input-ml-436117236"></a>
### left

```ml
left
```

Legacy state for the built-in left action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L32)

<a id="field-field-minipixels-input-input-inputstate-mousedeltax-mousedeltax-src-minipixels-input-input-ml-835095450"></a>
### mouseDeltaX

```ml
mouseDeltaX
```

Pointer movement consumed by the active simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L64)

<a id="field-field-minipixels-input-input-inputstate-mousedeltay-mousedeltay-src-minipixels-input-input-ml-662024546"></a>
### mouseDeltaY

```ml
mouseDeltaY
```

Pointer movement consumed by the active simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L66)

<a id="field-field-minipixels-input-input-inputstate-mouseinitialized-mouseinitialized-src-minipixels-input-input-ml-700192884"></a>
### mouseInitialized

```ml
mouseInitialized
```

Whether a pointer position has already been sampled.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L78)

<a id="field-field-minipixels-input-input-inputstate-mouseinside-mouseinside-src-minipixels-input-input-ml-1466666482"></a>
### mouseInside

```ml
mouseInside
```

Whether the pointer is inside the rendered viewport.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L70)

<a id="field-field-minipixels-input-input-inputstate-mouseleft-mouseleft-src-minipixels-input-input-ml-1818201442"></a>
### mouseLeft

```ml
mouseLeft
```

Current left mouse-button state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L72)

<a id="field-field-minipixels-input-input-inputstate-mousemiddle-mousemiddle-src-minipixels-input-input-ml-538818274"></a>
### mouseMiddle

```ml
mouseMiddle
```

Current middle mouse-button state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L76)

<a id="field-field-minipixels-input-input-inputstate-mouseright-mouseright-src-minipixels-input-input-ml-95668432"></a>
### mouseRight

```ml
mouseRight
```

Current right mouse-button state.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L74)

<a id="field-field-minipixels-input-input-inputstate-mousewheel-mousewheel-src-minipixels-input-input-ml-191311650"></a>
### mouseWheel

```ml
mouseWheel
```

Mouse-wheel delta consumed by the active simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L68)

<a id="field-field-minipixels-input-input-inputstate-mousex-mousex-src-minipixels-input-input-ml-1208908104"></a>
### mouseX

```ml
mouseX
```

Pointer x position in logical canvas coordinates.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L46)

<a id="field-field-minipixels-input-input-inputstate-mousey-mousey-src-minipixels-input-input-ml-536360146"></a>
### mouseY

```ml
mouseY
```

Pointer y position in logical canvas coordinates.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L48)

<a id="field-field-minipixels-input-input-inputstate-pendingmousedeltax-pendingmousedeltax-src-minipixels-input-input-ml-1583754874"></a>
### pendingMouseDeltaX

```ml
pendingMouseDeltaX
```

Pointer movement waiting for a simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L80)

<a id="field-field-minipixels-input-input-inputstate-pendingmousedeltay-pendingmousedeltay-src-minipixels-input-input-ml-401547596"></a>
### pendingMouseDeltaY

```ml
pendingMouseDeltaY
```

Pointer movement waiting for a simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L82)

<a id="field-field-minipixels-input-input-inputstate-pendingmousewheel-pendingmousewheel-src-minipixels-input-input-ml-1742282102"></a>
### pendingMouseWheel

```ml
pendingMouseWheel
```

Mouse-wheel movement waiting for a simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L84)

<a id="field-field-minipixels-input-input-inputstate-pendingpressed-pendingpressed-src-minipixels-input-input-ml-872003272"></a>
### pendingPressed

```ml
pendingPressed
```

Press edges waiting for a simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L94)

<a id="field-field-minipixels-input-input-inputstate-pendingreleased-pendingreleased-src-minipixels-input-input-ml-165822622"></a>
### pendingReleased

```ml
pendingReleased
```

Release edges waiting for a simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L96)

<a id="method-method-minipixels-input-input-inputstate-pressed-function-pressed-action-src-minipixels-input-input-ml-745565982"></a>
### pressed

```ml
function pressed(action)
```

Returns whether an action became held for the active update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L131)

<a id="field-field-minipixels-input-input-inputstate-prevdown-prevdown-src-minipixels-input-input-ml-967226668"></a>
### prevDown

```ml
prevDown
```

Previous polled state for the built-in down action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L56)

<a id="field-field-minipixels-input-input-inputstate-prevescape-prevescape-src-minipixels-input-input-ml-1856732930"></a>
### prevEscape

```ml
prevEscape
```

Previous polled state for the built-in escape action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L62)

<a id="field-field-minipixels-input-input-inputstate-prevfire-prevfire-src-minipixels-input-input-ml-2143347784"></a>
### prevFire

```ml
prevFire
```

Previous polled state for the built-in fire action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L60)

<a id="field-field-minipixels-input-input-inputstate-prevjump-prevjump-src-minipixels-input-input-ml-1079514092"></a>
### prevJump

```ml
prevJump
```

Previous polled state for the built-in jump action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L58)

<a id="field-field-minipixels-input-input-inputstate-prevleft-prevleft-src-minipixels-input-input-ml-1465113786"></a>
### prevLeft

```ml
prevLeft
```

Previous polled state for the built-in left action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L50)

<a id="field-field-minipixels-input-input-inputstate-prevright-prevright-src-minipixels-input-input-ml-2075770434"></a>
### prevRight

```ml
prevRight
```

Previous polled state for the built-in right action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L52)

<a id="field-field-minipixels-input-input-inputstate-prevup-prevup-src-minipixels-input-input-ml-1709941958"></a>
### prevUp

```ml
prevUp
```

Previous polled state for the built-in up action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L54)

<a id="field-field-minipixels-input-input-inputstate-primarykeys-primarykeys-src-minipixels-input-input-ml-907311386"></a>
### primaryKeys

```ml
primaryKeys
```

Primary virtual-key binding for each action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L88)

<a id="method-method-minipixels-input-input-inputstate-released-function-released-action-src-minipixels-input-input-ml-1198384834"></a>
### released

```ml
function released(action)
```

Returns whether an action became released for the active update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `action` | `dynamic` | — | Name of the action to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L137)

<a id="field-field-minipixels-input-input-inputstate-right-right-src-minipixels-input-input-ml-1262078490"></a>
### right

```ml
right
```

Legacy state for the built-in right action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L34)

<a id="field-field-minipixels-input-input-inputstate-secondarykeys-secondarykeys-src-minipixels-input-input-ml-666174914"></a>
### secondaryKeys

```ml
secondaryKeys
```

Secondary virtual-key binding for each action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L90)

<a id="field-field-minipixels-input-input-inputstate-steppressed-steppressed-src-minipixels-input-input-ml-345462066"></a>
### stepPressed

```ml
stepPressed
```

Press edges visible to the active simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L98)

<a id="field-field-minipixels-input-input-inputstate-stepreleased-stepreleased-src-minipixels-input-input-ml-1408745136"></a>
### stepReleased

```ml
stepReleased
```

Release edges visible to the active simulation update.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L100)

<a id="field-field-minipixels-input-input-inputstate-up-up-src-minipixels-input-input-ml-1994655352"></a>
### up

```ml
up
```

Legacy state for the built-in up action.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/input/input.ml#L36)
