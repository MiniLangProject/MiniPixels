// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels world tilemap facilities for this project.

package minipixels.world.tilemap

import minipixels.math.types as mt
import minipixels.graphics.sprite as sp
import minipixels.graphics.canvas as cv
import minipixels.collision.collision as col

/// Represents the tileset data used by the minipixels world tilemap module.
struct Tileset
  /// Stores the sheet value associated with tileset.
  sheet
end struct

/// Represents the tile layer data used by the minipixels world tilemap module.
struct TileLayer
  /// Stores the name value associated with tile layer.
  name
  /// Stores the width value associated with tile layer.
  width
  /// Stores the height value associated with tile layer.
  height
  /// Stores the data value associated with tile layer.
  data
  /// Stores the visible value associated with tile layer.
  visible
  /// Stores the collision value associated with tile layer.
  collision
  /// Stores the parallax x value associated with tile layer.
  parallaxX
  /// Stores the parallax y value associated with tile layer.
  parallaxY
end struct

/// Represents the tile map data used by the minipixels world tilemap module.
struct TileMap
  /// Stores the tile width value associated with tile map.
  tileWidth
  /// Stores the tile height value associated with tile map.
  tileHeight
  /// Stores the width value associated with tile map.
  width
  /// Stores the height value associated with tile map.
  height
  /// Stores the tileset value associated with tile map.
  tileset
  /// Stores the layers value associated with tile map.
  layers
  /// Stores the layer count value associated with tile map.
  layerCount

  /// Draws draw through the minipixels world tilemap rendering path.
  /// @param canvas canvas value consumed by this operation.
  /// @param camera camera value consumed by this operation.
  function draw(canvas, camera)
    return minipixels.world.tilemap.draw(this, canvas, camera)
  end function

  /// Returns whether solid at tile satisfies the required condition.
  /// @param tx tx value consumed by this operation.
  /// @param ty ty value consumed by this operation.
  function isSolidAtTile(tx, ty)
    return minipixels.world.tilemap.isSolidAtTile(this, tx, ty)
  end function

  /// Returns whether solid at pixel satisfies the required condition.
  /// @param px px value consumed by this operation.
  /// @param py py value consumed by this operation.
  function isSolidAtPixel(px, py)
    return minipixels.world.tilemap.isSolidAtPixel(this, px, py)
  end function

  /// Adds layer to the state managed by the minipixels world tilemap module.
  /// @param layer layer value consumed by this operation.
  function addLayer(layer)
    return minipixels.world.tilemap.addLayer(this, layer)
  end function
end struct

/// Creates create for the minipixels world tilemap module.
/// @param tileWidth tileWidth value consumed by this operation.
/// @param tileHeight tileHeight value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param tileset tileset value consumed by this operation.
/// @param maxLayers maxLayers value consumed by this operation.
function create(tileWidth, tileHeight, width, height, tileset, maxLayers)
  // Frame descriptors are immutable and otherwise allocated lazily from the
  // render loop. Prewarming makes tile traversal allocation-free.
  sp.cacheFrames(tileset.sheet)
  return TileMap(tileWidth, tileHeight, width, height, tileset, array(maxLayers), 0)
end function

/// Performs the layer operation for the minipixels world tilemap module.
/// @param name Name of the affected item.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param data Input data consumed by the operation.
/// @param visible visible value consumed by this operation.
/// @param collision collision value consumed by this operation.
/// @param px px value consumed by this operation.
/// @param py py value consumed by this operation.
function layer(name, width, height, data, visible, collision, px, py)
  return TileLayer(name, width, height, data, visible, collision, px, py)
end function

/// Adds layer to the state managed by the minipixels world tilemap module.
/// @param map map value consumed by this operation.
/// @param layer layer value consumed by this operation.
function addLayer(map, layer)
  if map.layerCount >= len(map.layers) then
    nextCapacity = len(map.layers) * 2
    if nextCapacity < 1 then nextCapacity = 4 end if
    layers = array(nextCapacity)
    if map.layerCount > 0 then copyArray(layers, 0, map.layers, 0, map.layerCount) end if
    map.layers = layers
  end if
  map.layers[map.layerCount] = layer
  map.layerCount = map.layerCount + 1
  return true
end function

/// Performs the tileAt operation for the minipixels world tilemap module.
/// @param layer layer value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function tileAt(layer, x, y)
  if x < 0 or y < 0 or x >= layer.width or y >= layer.height then return 0 end if
  return layer.data[(y * layer.width) + x]
end function

/// Draws layer through the minipixels world tilemap rendering path.
/// @param map map value consumed by this operation.
/// @param layer layer value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
function drawLayer(map, layer, canvas, camera)
  if layer.visible == false then return end if
  ox = camera.x * layer.parallaxX
  oy = camera.y * layer.parallaxY
  firstCol = mt.floorInt(ox / map.tileWidth)
  firstRow = mt.floorInt(oy / map.tileHeight)
  lastCol = mt.floorInt((ox + camera.width) / map.tileWidth) + 1
  lastRow = mt.floorInt((oy + camera.height) / map.tileHeight) + 1
  firstCol = mt.clamp(firstCol, 0, layer.width - 1)
  firstRow = mt.clamp(firstRow, 0, layer.height - 1)
  lastCol = mt.clamp(lastCol, 0, layer.width - 1)
  lastRow = mt.clamp(lastRow, 0, layer.height - 1)
  for ty = firstRow to lastRow
    rowOffset = ty * layer.width
    for tx = firstCol to lastCol
      // Camera clipping already guarantees valid coordinates here, so avoid a
      // second bounds-checked function call for every visible tile.
      id = layer.data[rowOffset + tx]
      if id > 0 then
        frameIndex = id - 1
        if frameIndex >= map.tileset.sheet.frameCount then frameIndex = map.tileset.sheet.frameCount - 1 end if
        spr = map.tileset.sheet.frames[frameIndex]
        if typeof(spr) == "void" then spr = map.tileset.sheet.getFrame(frameIndex) end if
        x = (tx * map.tileWidth) - ox
        y = (ty * map.tileHeight) - oy
        cv.drawSprite(canvas, spr, x, y)
        canvas.tileCount = canvas.tileCount + 1
      end if
    end for
  end for
end function

/// Draws draw through the minipixels world tilemap rendering path.
/// @param map map value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
function draw(map, canvas, camera)
  for i = 0 to map.layerCount - 1
    drawLayer(map, map.layers[i], canvas, camera)
  end for
end function

/// Returns whether solid at tile satisfies the required condition.
/// @param map map value consumed by this operation.
/// @param tx tx value consumed by this operation.
/// @param ty ty value consumed by this operation.
function isSolidAtTile(map, tx, ty)
  if tx < 0 or ty < 0 or tx >= map.width or ty >= map.height then return true end if
  for i = 0 to map.layerCount - 1
    l = map.layers[i]
    if l.collision then
      if tileAt(l, tx, ty) > 0 then return true end if
    end if
  end for
  return false
end function

/// Returns whether solid at pixel satisfies the required condition.
/// @param map map value consumed by this operation.
/// @param px px value consumed by this operation.
/// @param py py value consumed by this operation.
function isSolidAtPixel(map, px, py)
  return isSolidAtTile(map, mt.floorInt(px / map.tileWidth), mt.floorInt(py / map.tileHeight))
end function

/// Performs the moveAndCollide operation for the minipixels world tilemap module.
/// @param map map value consumed by this operation.
/// @param rect rect value consumed by this operation.
/// @param vx vx value consumed by this operation.
/// @param vy vy value consumed by this operation.
function moveAndCollide(map, rect, vx, vy)
  res = col.result(rect.x, rect.y)
  nx = rect.x + vx
  top = mt.floorInt(rect.y / map.tileHeight)
  bottom = mt.floorInt((rect.y + rect.height - 1) / map.tileHeight)
  if vx > 0 then
    startColumn = mt.floorInt((rect.x + rect.width - 1) / map.tileWidth)
    endColumn = mt.floorInt((nx + rect.width - 1) / map.tileWidth)
    column = startColumn + 1
    while column <= endColumn and res.hitRight == false
      row = top
      while row <= bottom
        if isSolidAtTile(map, column, row) then
          nx = (column * map.tileWidth) - rect.width
          res.hitRight = true
          break
        end if
        row = row + 1
      end while
      column = column + 1
    end while
  else
    if vx < 0 then
      startColumn = mt.floorInt(rect.x / map.tileWidth)
      endColumn = mt.floorInt(nx / map.tileWidth)
      column = startColumn - 1
      while column >= endColumn and res.hitLeft == false
        row = top
        while row <= bottom
          if isSolidAtTile(map, column, row) then
            nx = (column + 1) * map.tileWidth
            res.hitLeft = true
            break
          end if
          row = row + 1
        end while
        column = column - 1
      end while
    end if
  end if
  ny = rect.y + vy
  left = mt.floorInt(nx / map.tileWidth)
  right = mt.floorInt((nx + rect.width - 1) / map.tileWidth)
  if vy > 0 then
    startRow = mt.floorInt((rect.y + rect.height - 1) / map.tileHeight)
    endRow = mt.floorInt((ny + rect.height - 1) / map.tileHeight)
    row = startRow + 1
    while row <= endRow and res.hitBottom == false
      column = left
      while column <= right
        if isSolidAtTile(map, column, row) then
          ny = (row * map.tileHeight) - rect.height
          res.hitBottom = true
          break
        end if
        column = column + 1
      end while
      row = row + 1
    end while
  else
    if vy < 0 then
      startRow = mt.floorInt(rect.y / map.tileHeight)
      endRow = mt.floorInt(ny / map.tileHeight)
      row = startRow - 1
      while row >= endRow and res.hitTop == false
        column = left
        while column <= right
          if isSolidAtTile(map, column, row) then
            ny = (row + 1) * map.tileHeight
            res.hitTop = true
            break
          end if
          column = column + 1
        end while
        row = row - 1
      end while
    end if
  end if
  worldW = map.width * map.tileWidth
  worldH = map.height * map.tileHeight
  if nx < 0 then
    nx = 0
    res.hitLeft = true
  end if
  if nx + rect.width > worldW then
    nx = worldW - rect.width
    res.hitRight = true
  end if
  if ny < 0 then
    ny = 0
    res.hitTop = true
  end if
  if ny + rect.height > worldH then
    ny = worldH - rect.height
    res.hitBottom = true
  end if
  res.x = nx
  res.y = ny
  return res
end function
