// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels collision collision facilities for this project.

package minipixels.collision.collision

import minipixels.math.types as mt

/// Represents the collision result data used by the minipixels collision collision module.
struct CollisionResult
  /// Stores the x value associated with collision result.
  x
  /// Stores the y value associated with collision result.
  y
  /// Stores the hit left value associated with collision result.
  hitLeft
  /// Stores the hit right value associated with collision result.
  hitRight
  /// Stores the hit top value associated with collision result.
  hitTop
  /// Stores the hit bottom value associated with collision result.
  hitBottom
end struct

/// Performs the pointRect operation for the minipixels collision collision module.
/// @param px px value consumed by this operation.
/// @param py py value consumed by this operation.
/// @param r r value consumed by this operation.
function pointRect(px, py, r)
  return mt.rectangleContainsPoint(r, px, py)
end function

/// Performs the rectRect operation for the minipixels collision collision module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function rectRect(a, b)
  return mt.rectangleIntersects(a, b)
end function

/// Performs the circleCircle operation for the minipixels collision collision module.
/// @param ax ax value consumed by this operation.
/// @param ay ay value consumed by this operation.
/// @param ar ar value consumed by this operation.
/// @param bx bx value consumed by this operation.
/// @param by by value consumed by this operation.
/// @param br br value consumed by this operation.
function circleCircle(ax, ay, ar, bx, by, br)
  dx = ax - bx
  dy = ay - by
  rr = ar + br
  return dx * dx + dy * dy <= rr * rr
end function

/// Performs the circleRect operation for the minipixels collision collision module.
/// @param cx cx value consumed by this operation.
/// @param cy cy value consumed by this operation.
/// @param cr cr value consumed by this operation.
/// @param r r value consumed by this operation.
function circleRect(cx, cy, cr, r)
  nx = mt.clamp(cx, r.x, r.x + r.width)
  ny = mt.clamp(cy, r.y, r.y + r.height)
  dx = cx - nx
  dy = cy - ny
  return dx * dx + dy * dy <= cr * cr
end function

/// Performs the lineRect operation for the minipixels collision collision module.
/// @param x1 x1 value consumed by this operation.
/// @param y1 y1 value consumed by this operation.
/// @param x2 x2 value consumed by this operation.
/// @param y2 y2 value consumed by this operation.
/// @param r r value consumed by this operation.
function lineRect(x1, y1, x2, y2, r)
  if pointRect(x1, y1, r) or pointRect(x2, y2, r) then return true end if
  // Conservative broad-phase fallback until exact segment-vs-rect clipping is needed.
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

/// Performs the result operation for the minipixels collision collision module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function result(x, y)
  return CollisionResult(x, y, false, false, false, false)
end function
