# `minipixels.scene.scene.SceneStack`

[Home](README.md) · [Source file](File-src-minipixels-scene-scene-ml-552680371.md)

<a id="struct-struct-minipixels-scene-scene-scenestack-struct-scenestack-src-minipixels-scene-scene-ml-1713858613"></a>
## SceneStack

```ml
struct SceneStack
```

Represents a growable registry and active stack of scenes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L34)

## Members

<a id="field-field-minipixels-scene-scene-scenestack-capacity-capacity-src-minipixels-scene-scene-ml-1945404035"></a>
### capacity

```ml
capacity
```

Allocated registry capacity.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L46)

<a id="method-method-minipixels-scene-scene-scenestack-change-function-change-name-game-void-src-minipixels-scene-scene-ml-79460411"></a>
### change

```ml
function change(name, game = void)
```

Replaces the active scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Registered scene name. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L64)

<a id="field-field-minipixels-scene-scene-scenestack-count-count-src-minipixels-scene-scene-ml-928834095"></a>
### count

```ml
count
```

Number of registered scenes.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L40)

<a id="method-method-minipixels-scene-scene-scenestack-current-function-current-src-minipixels-scene-scene-ml-721034261"></a>
### current

```ml
function current()
```

Returns the active top scene.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L82)

<a id="method-method-minipixels-scene-scene-scenestack-depth-function-depth-src-minipixels-scene-scene-ml-1662695093"></a>
### depth

```ml
function depth()
```

Returns the number of active stack entries.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L87)

<a id="field-field-minipixels-scene-scene-scenestack-index-index-src-minipixels-scene-scene-ml-1654660647"></a>
### index

```ml
index
```

Hash index mapping registered names to registry slots.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L44)

<a id="field-field-minipixels-scene-scene-scenestack-names-names-src-minipixels-scene-scene-ml-1533092843"></a>
### names

```ml
names
```

Registered scene names retained for compatibility and iteration.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L36)

<a id="method-method-minipixels-scene-scene-scenestack-pop-function-pop-game-void-src-minipixels-scene-scene-ml-607602366"></a>
### pop

```ml
function pop(game = void)
```

Removes the current scene and resumes the scene below it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L77)

<a id="method-method-minipixels-scene-scene-scenestack-push-function-push-name-game-void-src-minipixels-scene-scene-ml-1926926043"></a>
### push

```ml
function push(name, game = void)
```

Pushes a scene above the current scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Registered scene name. |
| `game` | `dynamic` | `void` | Game passed to lifecycle callbacks. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L71)

<a id="method-method-minipixels-scene-scene-scenestack-register-function-register-name-scene-src-minipixels-scene-scene-ml-860881476"></a>
### register

```ml
function register(name, scene)
```

Registers or replaces a named scene.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Stable scene name. |
| `scene` | `dynamic` | — | Scene value or arbitrary compatibility value. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L57)

<a id="field-field-minipixels-scene-scene-scenestack-scenes-scenes-src-minipixels-scene-scene-ml-1062264693"></a>
### scenes

```ml
scenes
```

Registered scene objects retained for compatibility and iteration.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L38)

<a id="field-field-minipixels-scene-scene-scenestack-stack-stack-src-minipixels-scene-scene-ml-728090623"></a>
### stack

```ml
stack
```

Registry indices making up the active scene stack.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L48)

<a id="field-field-minipixels-scene-scene-scenestack-stackcapacity-stackcapacity-src-minipixels-scene-scene-ml-1983174215"></a>
### stackCapacity

```ml
stackCapacity
```

Allocated active-stack capacity.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L52)

<a id="field-field-minipixels-scene-scene-scenestack-stackcount-stackcount-src-minipixels-scene-scene-ml-1512933537"></a>
### stackCount

```ml
stackCount
```

Number of active stack entries.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L50)

<a id="field-field-minipixels-scene-scene-scenestack-top-top-src-minipixels-scene-scene-ml-156063571"></a>
### top

```ml
top
```

Registry index of the active top scene, or -1.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L42)
