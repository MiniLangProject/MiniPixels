package minipixels.world.camera

import minipixels.math.types as mt

struct Camera
  x
  y
  width
  height
  worldWidth
  worldHeight
  pixelSnap
  shakeX
  shakeY

  function clampToWorld()
    return minipixels.world.camera.clampToWorld(this)
  end function

  function follow(x, y)
    return minipixels.world.camera.follow(this, x, y)
  end function

  function worldToScreenX(x)
    return x - this.x
  end function

  function worldToScreenY(y)
    return y - this.y
  end function
end struct

function create(width, height)
  return Camera(0, 0, width, height, width, height, true, 0, 0)
end function

function setWorld(c, w, h)
  c.worldWidth = w
  c.worldHeight = h
end function

function clampToWorld(c)
  maxX = c.worldWidth - c.width
  maxY = c.worldHeight - c.height
  if maxX < 0 then maxX = 0 end if
  if maxY < 0 then maxY = 0 end if
  c.x = mt.clamp(c.x, 0, maxX)
  c.y = mt.clamp(c.y, 0, maxY)
  if c.pixelSnap then
    c.x = mt.floorInt(c.x)
    c.y = mt.floorInt(c.y)
  end if
end function

function follow(c, x, y)
  c.x = x - (c.width / 2)
  c.y = y - (c.height / 2)
  clampToWorld(c)
end function

function parallaxOffset(c, factorX, factorY)
  return mt.Vector2Int((0 - c.x) * factorX, (0 - c.y) * factorY)
end function
