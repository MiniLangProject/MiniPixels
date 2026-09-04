// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels debug debug facilities for this project.

package minipixels.debug.debug

import minipixels.math.types as mt
import minipixels.graphics.canvas as cv

/// Stores module-wide digit patterns state for the minipixels debug debug module.
digitPatterns = [
  0x7B, 0x48, 0x3D, 0x6D, 0x4E,
  0x67, 0x77, 0x49, 0x7F, 0x6F
]

/// Draws digit through the minipixels debug debug rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param n n value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function drawDigit(canvas, n, x, y, color)
  global digitPatterns
  if n < 0 or n > 9 then return end if
  p = digitPatterns[n]
  if (p & 0x01) != 0 then cv.drawLine(canvas, x + 1, y, x + 3, y, color) end if
  if (p & 0x02) != 0 then cv.drawLine(canvas, x, y + 1, x, y + 3, color) end if
  if (p & 0x04) != 0 then cv.drawLine(canvas, x + 4, y + 1, x + 4, y + 3, color) end if
  if (p & 0x08) != 0 then cv.drawLine(canvas, x + 1, y + 4, x + 3, y + 4, color) end if
  if (p & 0x10) != 0 then cv.drawLine(canvas, x, y + 5, x, y + 7, color) end if
  if (p & 0x20) != 0 then cv.drawLine(canvas, x + 4, y + 5, x + 4, y + 7, color) end if
  if (p & 0x40) != 0 then cv.drawLine(canvas, x + 1, y + 8, x + 3, y + 8, color) end if
end function

/// Draws number through the minipixels debug debug rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param color color value consumed by this operation.
function drawNumber(canvas, value, x, y, color)
  if value < 0 then value = 0 end if
  value = mt.floorInt(value)
  text = "" + value
  xx = x
  for each ch in text
    n = toNumber(ch)
    if typeof(n) == "int" then
      drawDigit(canvas, n, xx, y, color)
    end if
    xx = xx + 6
  end for
end function

/// Draws stats through the minipixels debug debug rendering path.
/// @param game game value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
function drawStats(game, canvas)
  white = mt.rgb(255, 255, 255)
  cv.fillRect(canvas, 0, 0, 50, 43, mt.rgba(0, 0, 0, 160))
  cv.fillRect(canvas, 2, 3, 4, 4, mt.rgb(255, 255, 255))
  drawNumber(canvas, game.time.fps, 9, 1, white)
  cv.fillRect(canvas, 2, 14, 4, 4, mt.rgb(255, 220, 80))
  drawNumber(canvas, canvas.spriteCount, 9, 12, mt.rgb(255, 220, 80))
  cv.fillRect(canvas, 2, 25, 4, 4, mt.rgb(100, 220, 255))
  drawNumber(canvas, canvas.tileCount, 9, 23, mt.rgb(100, 220, 255))
  cv.fillRect(canvas, 2, 36, 4, 4, mt.rgb(255, 128, 180))
  drawNumber(canvas, game.time.delta * 1000, 9, 34, mt.rgb(255, 128, 180))
end function

/// Performs the captureHash operation for the minipixels debug debug module.
/// @param canvas canvas value consumed by this operation.
function captureHash(canvas)
  return cv.hash(canvas)
end function
