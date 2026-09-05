# `minipixels.scene.scene.Scene`

[Home](README.md) · [Source file](File-src-minipixels-scene-scene-ml-552680371.md)

<a id="struct-struct-minipixels-scene-scene-scene-struct-scene-src-minipixels-scene-scene-ml-1041453467"></a>
## Scene

```ml
struct Scene
```

Represents one scene and its optional lifecycle callbacks.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L10)

## Members

<a id="field-field-minipixels-scene-scene-scene-enabled-enabled-src-minipixels-scene-scene-ml-1661227561"></a>
### enabled

```ml
enabled
```

Whether this scene receives fixed updates while it is on top.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L28)

<a id="field-field-minipixels-scene-scene-scene-name-name-src-minipixels-scene-scene-ml-769812139"></a>
### name

```ml
name
```

Stable scene name used by stack transitions.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L12)

<a id="field-field-minipixels-scene-scene-scene-onenter-onenter-src-minipixels-scene-scene-ml-1592530577"></a>
### onEnter

```ml
onEnter
```

Callback invoked as onEnter(game, scene).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L16)

<a id="field-field-minipixels-scene-scene-scene-onexit-onexit-src-minipixels-scene-scene-ml-436952435"></a>
### onExit

```ml
onExit
```

Callback invoked as onExit(game, scene).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L18)

<a id="field-field-minipixels-scene-scene-scene-onpause-onpause-src-minipixels-scene-scene-ml-43372581"></a>
### onPause

```ml
onPause
```

Callback invoked as onPause(game, scene).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L20)

<a id="field-field-minipixels-scene-scene-scene-onresume-onresume-src-minipixels-scene-scene-ml-2015772317"></a>
### onResume

```ml
onResume
```

Callback invoked as onResume(game, scene).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L22)

<a id="field-field-minipixels-scene-scene-scene-render-render-src-minipixels-scene-scene-ml-752903553"></a>
### render

```ml
render
```

Callback invoked as render(game, scene, canvas).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L26)

<a id="field-field-minipixels-scene-scene-scene-renderbelow-renderbelow-src-minipixels-scene-scene-ml-580731881"></a>
### renderBelow

```ml
renderBelow
```

Whether scenes below this scene remain visible.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L30)

<a id="field-field-minipixels-scene-scene-scene-state-state-src-minipixels-scene-scene-ml-137319045"></a>
### state

```ml
state
```

User-owned state associated with the scene.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L14)

<a id="field-field-minipixels-scene-scene-scene-update-update-src-minipixels-scene-scene-ml-1496355567"></a>
### update

```ml
update
```

Callback invoked as update(game, scene, dt).


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/scene/scene.ml#L24)
