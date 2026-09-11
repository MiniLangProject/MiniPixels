# `src/minipixels/world/tilemap.ml`

[Home](README.md) · [Files](Files.md)

Provides minipixels world tilemap facilities for this project.

Package: [`minipixels.world.tilemap`](Package-minipixels-world-tilemap-1065267261.md)

Reachable from entry: **yes**

## Imports

- `minipixels/collision/collision.ml` as `col` → [src/minipixels/collision/collision.ml](File-src-minipixels-collision-collision-ml-1544745439.md)
- `minipixels/graphics/canvas.ml` as `cv` → [src/minipixels/graphics/canvas.ml](File-src-minipixels-graphics-canvas-ml-370061960.md)
- `minipixels/graphics/sprite.ml` as `sp` → [src/minipixels/graphics/sprite.ml](File-src-minipixels-graphics-sprite-ml-1992064667.md)
- `minipixels/math/types.ml` as `mt` → [src/minipixels/math/types.ml](File-src-minipixels-math-types-ml-311947336.md)

## Declarations

<a id="function-function-minipixels-world-tilemap-addlayer-function-addlayer-map-layer-src-minipixels-world-tilemap-ml-1107730357"></a>
### addLayer

```ml
function addLayer(map, layer)
```

Adds layer to the state managed by the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `layer` | `dynamic` | — | layer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L113)

<a id="function-function-minipixels-world-tilemap-create-function-create-tilewidth-tileheight-width-height-tileset-maxlayers-src-minipixels-world-tilemap-ml-790301030"></a>
### create

```ml
function create(tileWidth, tileHeight, width, height, tileset, maxLayers)
```

Creates create for the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tileWidth` | `dynamic` | — | tileWidth value consumed by this operation. |
| `tileHeight` | `dynamic` | — | tileHeight value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `tileset` | `dynamic` | — | tileset value consumed by this operation. |
| `maxLayers` | `dynamic` | — | maxLayers value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L90)

<a id="function-function-minipixels-world-tilemap-draw-function-draw-map-canvas-camera-src-minipixels-world-tilemap-ml-1120777813"></a>
### draw

```ml
function draw(map, canvas, camera)
```

Draws draw through the minipixels world tilemap rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L176)

<a id="function-function-minipixels-world-tilemap-drawlayer-function-drawlayer-map-layer-canvas-camera-src-minipixels-world-tilemap-ml-1963841698"></a>
### drawLayer

```ml
function drawLayer(map, layer, canvas, camera)
```

Draws layer through the minipixels world tilemap rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `layer` | `dynamic` | — | layer value consumed by this operation. |
| `canvas` | `dynamic` | — | canvas value consumed by this operation. |
| `camera` | `dynamic` | — | camera value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L140)

<a id="function-function-minipixels-world-tilemap-issolidatpixel-function-issolidatpixel-map-px-py-src-minipixels-world-tilemap-ml-966868149"></a>
### isSolidAtPixel

```ml
function isSolidAtPixel(map, px, py)
```

Returns whether solid at pixel satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `px` | `dynamic` | — | px value consumed by this operation. |
| `py` | `dynamic` | — | py value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L201)

<a id="function-function-minipixels-world-tilemap-issolidattile-function-issolidattile-map-tx-ty-src-minipixels-world-tilemap-ml-312196433"></a>
### isSolidAtTile

```ml
function isSolidAtTile(map, tx, ty)
```

Returns whether solid at tile satisfies the required condition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `tx` | `dynamic` | — | tx value consumed by this operation. |
| `ty` | `dynamic` | — | ty value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L186)

<a id="function-function-minipixels-world-tilemap-layer-function-layer-name-width-height-data-visible-collision-px-py-src-minipixels-world-tilemap-ml-472480845"></a>
### layer

```ml
function layer(name, width, height, data, visible, collision, px, py)
```

Performs the layer operation for the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `visible` | `dynamic` | — | visible value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `px` | `dynamic` | — | px value consumed by this operation. |
| `py` | `dynamic` | — | py value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L106)

<a id="function-function-minipixels-world-tilemap-moveandcollide-function-moveandcollide-map-rect-vx-vy-src-minipixels-world-tilemap-ml-884331035"></a>
### moveAndCollide

```ml
function moveAndCollide(map, rect, vx, vy)
```

Performs the moveAndCollide operation for the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `rect` | `dynamic` | — | rect value consumed by this operation. |
| `vx` | `dynamic` | — | vx value consumed by this operation. |
| `vy` | `dynamic` | — | vy value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L210)

<a id="function-function-minipixels-world-tilemap-tileat-function-tileat-layer-x-y-src-minipixels-world-tilemap-ml-833627148"></a>
### tileAt

```ml
function tileAt(layer, x, y)
```

Performs the tileAt operation for the minipixels world tilemap module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layer` | `dynamic` | — | layer value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniPixels/blob/main/src/minipixels/world/tilemap.ml#L130)

- [minipixels.world.tilemap.TileLayer](Type-minipixels-world-tilemap-tilelayer-990760038.md) — struct
- [minipixels.world.tilemap.TileMap](Type-minipixels-world-tilemap-tilemap-1121128705.md) — struct
- [minipixels.world.tilemap.Tileset](Type-minipixels-world-tilemap-tileset-1821463123.md) — struct
