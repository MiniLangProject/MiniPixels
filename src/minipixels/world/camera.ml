// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels world camera facilities for this project.

package minipixels.world.camera

import minipixels.math.types as mt

/// Represents the camera data used by the minipixels world camera module.
struct Camera
  /// Stores the x value associated with camera.
  x
  /// Stores the y value associated with camera.
  y
  /// Stores the width value associated with camera.
  width
  /// Stores the height value associated with camera.
  height
  /// Stores the world width value associated with camera.
  worldWidth
  /// Stores the world height value associated with camera.
  worldHeight
  /// Stores the pixel snap value associated with camera.
  pixelSnap
  /// Stores the shake x value associated with camera.
  shakeX
  /// Stores the shake y value associated with camera.
  shakeY

  /// Performs the clampToWorld operation for the minipixels world camera camera module.
  function clampToWorld()
    return minipixels.world.camera.clampToWorld(this)
  end function

  /// Performs the follow operation for the minipixels world camera camera module.
  /// @param x Horizontal coordinate used by the operation.
  /// @param y Vertical coordinate used by the operation.
  function follow(x, y)
    return minipixels.world.camera.follow(this, x, y)
  end function

  /// Performs the worldToScreenX operation for the minipixels world camera camera module.
  /// @param x Horizontal coordinate used by the operation.
  function worldToScreenX(x)
    return x - this.x
  end function

  /// Performs the worldToScreenY operation for the minipixels world camera camera module.
  /// @param y Vertical coordinate used by the operation.
  function worldToScreenY(y)
    return y - this.y
  end function
end struct

/// Creates create for the minipixels world camera module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function create(width, height)
  return Camera(0, 0, width, height, width, height, true, 0, 0)
end function

/// Updates world maintained by the minipixels world camera module.
/// @param c c value consumed by this operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
function setWorld(c, w, h)
  c.worldWidth = w
  c.worldHeight = h
end function

/// Performs the clampToWorld operation for the minipixels world camera module.
/// @param c c value consumed by this operation.
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

/// Performs the follow operation for the minipixels world camera module.
/// @param c c value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function follow(c, x, y)
  c.x = x - (c.width / 2)
  c.y = y - (c.height / 2)
  clampToWorld(c)
end function

/// Performs the parallaxOffset operation for the minipixels world camera module.
/// @param c c value consumed by this operation.
/// @param factorX factorX value consumed by this operation.
/// @param factorY factorY value consumed by this operation.
function parallaxOffset(c, factorX, factorY)
  return mt.Vector2Int((0 - c.x) * factorX, (0 - c.y) * factorY)
end function
