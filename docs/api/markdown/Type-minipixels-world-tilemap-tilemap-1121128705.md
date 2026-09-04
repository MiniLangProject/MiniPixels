# `minipixels.world.tilemap.TileMap`

[Home](README.md) · [Source file](File-src-minipixels-world-tilemap-ml-2079329797.md)

<a id="struct-struct-minipixels-world-tilemap-tilemap-struct-tilemap-src-minipixels-world-tilemap-ml-1063290495"></a>
## TileMap

```ml
struct TileMap
```

Represents the tile map data used by the minipixels world tilemap module.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L39)

## Members

<a id="method-method-minipixels-world-tilemap-tilemap-addlayer-function-addlayer-layer-src-minipixels-world-tilemap-ml-1778928458"></a>
### addLayer

```ml
function addLayer(layer)
```

Adds layer to the state managed by the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layer` | `dynamic` | — | layer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L78)

<a id="method-method-minipixels-world-tilemap-tilemap-draw-function-draw-canvas-camera-src-minipixels-world-tilemap-ml-151968180"></a>
### draw

```ml
function draw(canvas, camera)
```

Draws draw through the minipixels world tilemap rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L58)

<a id="field-field-minipixels-world-tilemap-tilemap-height-height-src-minipixels-world-tilemap-ml-483839189"></a>
### height

```ml
height
```

Stores the height value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L47)

<a id="method-method-minipixels-world-tilemap-tilemap-issolidatpixel-function-issolidatpixel-px-py-src-minipixels-world-tilemap-ml-422911172"></a>
### isSolidAtPixel

```ml
function isSolidAtPixel(px, py)
```

Returns whether solid at pixel satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `px` | `dynamic` | — | px value consumed by this operation. |
| `py` | `dynamic` | — | py value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L72)

<a id="method-method-minipixels-world-tilemap-tilemap-issolidattile-function-issolidattile-tx-ty-src-minipixels-world-tilemap-ml-1073902724"></a>
### isSolidAtTile

```ml
function isSolidAtTile(tx, ty)
```

Returns whether solid at tile satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tx` | `dynamic` | — | tx value consumed by this operation. |
| `ty` | `dynamic` | — | ty value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L65)

<a id="field-field-minipixels-world-tilemap-tilemap-layercount-layercount-src-minipixels-world-tilemap-ml-1583372171"></a>
### layerCount

```ml
layerCount
```

Stores the layer count value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L53)

<a id="field-field-minipixels-world-tilemap-tilemap-layers-layers-src-minipixels-world-tilemap-ml-2140936223"></a>
### layers

```ml
layers
```

Stores the layers value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L51)

<a id="field-field-minipixels-world-tilemap-tilemap-tileheight-tileheight-src-minipixels-world-tilemap-ml-2016947557"></a>
### tileHeight

```ml
tileHeight
```

Stores the tile height value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L43)

<a id="field-field-minipixels-world-tilemap-tilemap-tileset-tileset-src-minipixels-world-tilemap-ml-1880537759"></a>
### tileset

```ml
tileset
```

Stores the tileset value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L49)

<a id="field-field-minipixels-world-tilemap-tilemap-tilewidth-tilewidth-src-minipixels-world-tilemap-ml-584294895"></a>
### tileWidth

```ml
tileWidth
```

Stores the tile width value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L41)

<a id="field-field-minipixels-world-tilemap-tilemap-width-width-src-minipixels-world-tilemap-ml-1740940743"></a>
### width

```ml
width
```

Stores the width value associated with tile map.


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L45)
