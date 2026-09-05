# `minipixels.graphics.sprite.SpriteSheet`

[Home](README.md) · [Source file](File-src-minipixels-graphics-sprite-ml-1992064667.md)

<a id="struct-struct-minipixels-graphics-sprite-spritesheet-struct-spritesheet-src-minipixels-graphics-sprite-ml-1775193257"></a>
## SpriteSheet

```ml
struct SpriteSheet
```

Represents the sprite sheet data used by the minipixels graphics sprite module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L51)

## Members

<a id="field-field-minipixels-graphics-sprite-spritesheet-columns-columns-as-int-src-minipixels-graphics-sprite-ml-436763532"></a>
### columns

```ml
columns as int
```

Stores the columns value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L63)

<a id="field-field-minipixels-graphics-sprite-spritesheet-framecount-framecount-as-int-src-minipixels-graphics-sprite-ml-1100835760"></a>
### frameCount

```ml
frameCount as int
```

Stores the frame count value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L65)

<a id="field-field-minipixels-graphics-sprite-spritesheet-frameheight-frameheight-as-int-src-minipixels-graphics-sprite-ml-1121873840"></a>
### frameHeight

```ml
frameHeight as int
```

Stores the frame height value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L57)

<a id="field-field-minipixels-graphics-sprite-spritesheet-frames-frames-src-minipixels-graphics-sprite-ml-206933779"></a>
### frames

```ml
frames
```

Lazily populated cache of immutable frame descriptors.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L67)

<a id="field-field-minipixels-graphics-sprite-spritesheet-framewidth-framewidth-as-int-src-minipixels-graphics-sprite-ml-1589277622"></a>
### frameWidth

```ml
frameWidth as int
```

Stores the frame width value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L55)

<a id="method-method-minipixels-graphics-sprite-spritesheet-getframe-function-getframe-index-src-minipixels-graphics-sprite-ml-281058737"></a>
### getFrame

```ml
function getFrame(index)
```

Returns frame maintained by the minipixels graphics sprite module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L71)

<a id="field-field-minipixels-graphics-sprite-spritesheet-image-image-src-minipixels-graphics-sprite-ml-1188201819"></a>
### image

```ml
image
```

Stores the image value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L53)

<a id="field-field-minipixels-graphics-sprite-spritesheet-margin-margin-as-int-src-minipixels-graphics-sprite-ml-54185096"></a>
### margin

```ml
margin as int
```

Stores the margin value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L61)

<a id="field-field-minipixels-graphics-sprite-spritesheet-spacing-spacing-as-int-src-minipixels-graphics-sprite-ml-432226440"></a>
### spacing

```ml
spacing as int
```

Stores the spacing value associated with sprite sheet.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/graphics/sprite.ml#L59)
