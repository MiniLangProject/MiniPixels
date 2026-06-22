package minipixels.collision.collision

import minipixels.math.types as mt

struct CollisionResult
  x
  y
  hitLeft
  hitRight
  hitTop
  hitBottom
end struct

function pointRect(px, py, r)
  return mt.rectangleContainsPoint(r, px, py)
end function

function rectRect(a, b)
  return mt.rectangleIntersects(a, b)
end function

function circleCircle(ax, ay, ar, bx, by, br)
  dx = ax - bx
  dy = ay - by
  rr = ar + br
  return dx * dx + dy * dy <= rr * rr
end function

function circleRect(cx, cy, cr, r)
  nx = mt.clamp(cx, r.x, r.x + r.width)
  ny = mt.clamp(cy, r.y, r.y + r.height)
  dx = cx - nx
  dy = cy - ny
  return dx * dx + dy * dy <= cr * cr
end function

function lineRect(x1, y1, x2, y2, r)
  if pointRect(x1, y1, r) or pointRect(x2, y2, r) then return true end if
  // Conservative fallback for the first version.
  minX = x1
  if x2 < minX then minX = x2 end if
  minY = y1
  if y2 < minY then minY = y2 end if
  maxX = x1
  if x2 > maxX then maxX = x2 end if
  maxY = y1
  if y2 > maxY then maxY = y2 end if
  return rectRect(mt.RectangleInt(minX, minY, maxX - minX + 1, maxY - minY + 1), r)
end function

function result(x, y)
  return CollisionResult(x, y, false, false, false, false)
end function
