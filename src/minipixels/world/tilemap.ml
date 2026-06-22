package minipixels.world.tilemap

import minipixels.math.types as mt
import minipixels.graphics.sprite as sp
import minipixels.graphics.canvas as cv
import minipixels.collision.collision as col

struct Tileset
  sheet
end struct

struct TileLayer
  name
  width
  height
  data
  visible
  collision
  parallaxX
  parallaxY
end struct

struct TileMap
  tileWidth
  tileHeight
  width
  height
  tileset
  layers
  layerCount

  function draw(canvas, camera)
    return minipixels.world.tilemap.draw(this, canvas, camera)
  end function

  function isSolidAtTile(tx, ty)
    return minipixels.world.tilemap.isSolidAtTile(this, tx, ty)
  end function

  function isSolidAtPixel(px, py)
    return minipixels.world.tilemap.isSolidAtPixel(this, px, py)
  end function

  function addLayer(layer)
    return minipixels.world.tilemap.addLayer(this, layer)
  end function
end struct

function create(tileWidth, tileHeight, width, height, tileset, maxLayers)
  return TileMap(tileWidth, tileHeight, width, height, tileset, array(maxLayers), 0)
end function

function layer(name, width, height, data, visible, collision, px, py)
  return TileLayer(name, width, height, data, visible, collision, px, py)
end function

function addLayer(map, layer)
  if map.layerCount >= len(map.layers) then return false end if
  map.layers[map.layerCount] = layer
  map.layerCount = map.layerCount + 1
  return true
end function

function tileAt(layer, x, y)
  if x < 0 or y < 0 or x >= layer.width or y >= layer.height then return 0 end if
  return layer.data[(y * layer.width) + x]
end function

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
    for tx = firstCol to lastCol
      id = tileAt(layer, tx, ty)
      if id > 0 then
        spr = map.tileset.sheet.getFrame(id - 1)
        x = (tx * map.tileWidth) - ox
        y = (ty * map.tileHeight) - oy
        cv.drawSprite(canvas, spr, x, y)
        canvas.tileCount = canvas.tileCount + 1
      end if
    end for
  end for
end function

function draw(map, canvas, camera)
  for i = 0 to map.layerCount - 1
    drawLayer(map, map.layers[i], canvas, camera)
  end for
end function

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

function isSolidAtPixel(map, px, py)
  return isSolidAtTile(map, mt.floorInt(px / map.tileWidth), mt.floorInt(py / map.tileHeight))
end function

function moveAndCollide(map, rect, vx, vy)
  res = col.result(rect.x, rect.y)
  nx = rect.x + vx
  if vx != 0 then
    test = mt.RectangleInt(nx, rect.y, rect.width, rect.height)
    left = mt.floorInt(test.x / map.tileWidth)
    right = mt.floorInt((test.x + test.width - 1) / map.tileWidth)
    top = mt.floorInt(test.y / map.tileHeight)
    bottom = mt.floorInt((test.y + test.height - 1) / map.tileHeight)
    for ty = top to bottom
      if vx > 0 and isSolidAtTile(map, right, ty) then
        nx = (right * map.tileWidth) - rect.width
        res.hitRight = true
      end if
      if vx < 0 and isSolidAtTile(map, left, ty) then
        nx = (left + 1) * map.tileWidth
        res.hitLeft = true
      end if
    end for
  end if
  ny = rect.y + vy
  if vy != 0 then
    test = mt.RectangleInt(nx, ny, rect.width, rect.height)
    left = mt.floorInt(test.x / map.tileWidth)
    right = mt.floorInt((test.x + test.width - 1) / map.tileWidth)
    top = mt.floorInt(test.y / map.tileHeight)
    bottom = mt.floorInt((test.y + test.height - 1) / map.tileHeight)
    for tx = left to right
      if vy > 0 and isSolidAtTile(map, tx, bottom) then
        ny = (bottom * map.tileHeight) - rect.height
        res.hitBottom = true
      end if
      if vy < 0 and isSolidAtTile(map, tx, top) then
        ny = (top + 1) * map.tileHeight
        res.hitTop = true
      end if
    end for
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
