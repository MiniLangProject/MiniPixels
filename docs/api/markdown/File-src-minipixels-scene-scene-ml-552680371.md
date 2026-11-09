# `src/minipixels/scene/scene.ml`

[Home](README.md) · [Files](Files.md)

Provides registered scenes, stack transitions, and lifecycle dispatch.

Package: [`minipixels.scene.scene`](Package-minipixels-scene-scene-2050449523.md)

Reachable from entry: **yes**

## Imports

- `std/ds/hashmap.ml` as `hm` → `../MiniLangCompilerPy/std/ds/hashmap.ml` — external dependency

## Declarations

<a id="function-function-minipixels-scene-scene-calllifecycle-function-calllifecycle-callback-game-value-src-minipixels-scene-scene-ml-1529096808"></a>
### callLifecycle

```ml
function callLifecycle(callback, game, value)
```

Calls a two-argument lifecycle callback when present.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callback` | `dynamic` | — | Callback to invoke. |
| `game` | `dynamic` | — | Game passed to the callback. |
| `value` | `dynamic` | — | Scene passed to the callback. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L176)

<a id="function-function-minipixels-scene-scene-change-function-change-s-name-game-void-src-minipixels-scene-scene-ml-1483978669"></a>
### change

```ml
function change(s, name, game = void)
```

Replaces the active scene with a registered scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to mutate. |
| `name` | `dynamic` | — | Registered scene name. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L256)

<a id="function-function-minipixels-scene-scene-clear-function-clear-s-game-void-src-minipixels-scene-scene-ml-996723452"></a>
### clear

```ml
function clear(s, game = void)
```

Removes all active scenes from top to bottom.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to mutate. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L279)

<a id="function-function-minipixels-scene-scene-create-function-create-capacity-src-minipixels-scene-scene-ml-247768924"></a>
### create

```ml
function create(capacity)
```

Creates an empty growable scene registry and active stack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `capacity` | `dynamic` | — | Initial registry and stack capacity. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L108)

<a id="function-function-minipixels-scene-scene-current-function-current-s-src-minipixels-scene-scene-ml-1892853947"></a>
### current

```ml
function current(s)
```

Returns the active top scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to inspect. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L293)

<a id="function-function-minipixels-scene-scene-ensureregistrycapacity-function-ensureregistrycapacity-s-src-minipixels-scene-scene-ml-124207381"></a>
### ensureRegistryCapacity

```ml
function ensureRegistryCapacity(s)
```

Grows the scene registry when full.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to resize. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L119)

<a id="function-function-minipixels-scene-scene-ensurestackcapacity-function-ensurestackcapacity-s-src-minipixels-scene-scene-ml-1366482957"></a>
### ensureStackCapacity

```ml
function ensureStackCapacity(s)
```

Grows the active scene stack when full.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to resize. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L133)

<a id="function-function-minipixels-scene-scene-enter-function-enter-value-game-src-minipixels-scene-scene-ml-343703591"></a>
### enter

```ml
function enter(value, game)
```

Calls a scene enter hook when the registered value is a Scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Registered scene value. |
| `game` | `dynamic` | — | Game passed to the hook. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L183)

<a id="function-function-minipixels-scene-scene-exitscene-function-exitscene-value-game-src-minipixels-scene-scene-ml-395190103"></a>
### exitScene

```ml
function exitScene(value, game)
```

Calls a scene exit hook when the registered value is a Scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Registered scene value. |
| `game` | `dynamic` | — | Game passed to the hook. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L190)

<a id="function-function-minipixels-scene-scene-find-function-find-s-name-src-minipixels-scene-scene-ml-879765724"></a>
### find

```ml
function find(s, name)
```

Finds a registered scene index in constant expected time.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to inspect. |
| `name` | `dynamic` | — | Registered scene name. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L165)

<a id="function-function-minipixels-scene-scene-pause-function-pause-value-game-src-minipixels-scene-scene-ml-1128457003"></a>
### pause

```ml
function pause(value, game)
```

Calls a scene pause hook when the registered value is a Scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Registered scene value. |
| `game` | `dynamic` | — | Game passed to the hook. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L197)

<a id="function-function-minipixels-scene-scene-pop-function-pop-s-game-void-src-minipixels-scene-scene-ml-1349747740"></a>
### pop

```ml
function pop(s, game = void)
```

Removes the active scene and resumes the scene below it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to mutate. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L235)

<a id="function-function-minipixels-scene-scene-push-function-push-s-name-game-void-src-minipixels-scene-scene-ml-651555517"></a>
### push

```ml
function push(s, name, game = void)
```

Pushes a registered scene above the active scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to mutate. |
| `name` | `dynamic` | — | Registered scene name. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L212)

<a id="function-function-minipixels-scene-scene-register-function-register-s-name-value-src-minipixels-scene-scene-ml-487302613"></a>
### register

```ml
function register(s, name, value)
```

Registers or replaces a named scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to mutate. |
| `name` | `dynamic` | — | Stable scene name. |
| `value` | `dynamic` | — | Scene value or arbitrary compatibility value. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L146)

<a id="function-function-minipixels-scene-scene-renderstack-function-renderstack-s-game-canvas-src-minipixels-scene-scene-ml-1066460679"></a>
### renderStack

```ml
function renderStack(s, game, canvas)
```

Renders the visible portion of the active scene stack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to render. |
| `game` | `dynamic` | — | Game passed to scenes. |
| `canvas` | `dynamic` | — | Canvas receiving scene output. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L312)

<a id="function-function-minipixels-scene-scene-resume-function-resume-value-game-src-minipixels-scene-scene-ml-1789309755"></a>
### resume

```ml
function resume(value, game)
```

Calls a scene resume hook when the registered value is a Scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Registered scene value. |
| `game` | `dynamic` | — | Game passed to the hook. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L204)

<a id="function-function-minipixels-scene-scene-scene-function-scene-name-state-void-onenter-void-onexit-void-update-void-render-void-onpause-void-onresume-void-renderbelow-false-src-minipixels-scene-scene-ml-1408418874"></a>
### scene

```ml
function scene(name, state = void, onEnter = void, onExit = void, update = void, render = void, onPause = void, onResume = void, renderBelow = false)
```

Creates a scene from optional lifecycle callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable scene name. |
| `state` | `dynamic` | `void` | User-owned scene state. |
| `onEnter` | `dynamic` | `void` | Callback invoked when the scene becomes active. |
| `onExit` | `dynamic` | `void` | Callback invoked when the scene leaves the stack. |
| `update` | `dynamic` | `void` | Callback invoked for fixed simulation updates. |
| `render` | `dynamic` | `void` | Callback invoked for rendering. |
| `onPause` | `dynamic` | `void` | Callback invoked when another scene is pushed above this one. |
| `onResume` | `dynamic` | `void` | Callback invoked after the scene above is popped. |
| `renderBelow` | `dynamic` | `false` | Whether scenes underneath remain visible. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L102)

- [minipixels.scene.scene.Scene](Type-minipixels-scene-scene-scene-727861925.md) — struct
- [minipixels.scene.scene.SceneStack](Type-minipixels-scene-scene-scenestack-1227700927.md) — struct
<a id="function-function-minipixels-scene-scene-updatecurrent-function-updatecurrent-s-game-dt-src-minipixels-scene-scene-ml-1853866323"></a>
### updateCurrent

```ml
function updateCurrent(s, game, dt)
```

Dispatches a fixed update to the active top scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | Scene stack to update. |
| `game` | `dynamic` | — | Game passed to the scene. |
| `dt` | `dynamic` | — | Fixed simulation delta. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L302)
