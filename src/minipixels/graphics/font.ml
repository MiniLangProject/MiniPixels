// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels graphics font facilities for this project.

package minipixels.graphics.font

import minipixels.graphics.canvas as cv

/// Performs the glyphBits operation for the minipixels graphics font module.
/// @param ch ch value consumed by this operation.
function glyphBits(ch)
  if ch == "0" then return 0x3A39ACE2E end if
  if ch == "1" then return 0x388421184 end if
  if ch == "2" then return 0x7D041062E end if
  if ch == "3" then return 0x78217043E end if
  if ch == "4" then return 0x85F928C2 end if
  if ch == "5" then return 0x7821F421F end if
  if ch == "6" then return 0x3A31F420E end if
  if ch == "7" then return 0x21082083F end if
  if ch == "8" then return 0x3A317462E end if
  if ch == "9" then return 0x38217C62E end if
  if ch == "A" then return 0x4631FC62E end if
  if ch == "B" then return 0x7A31F463E end if
  if ch == "C" then return 0x3A308422E end if
  if ch == "D" then return 0x7A318C63E end if
  if ch == "E" then return 0x7E10F421F end if
  if ch == "F" then return 0x4210F421F end if
  if ch == "G" then return 0x3A31BC22E end if
  if ch == "H" then return 0x4631FC631 end if
  if ch == "I" then return 0x38842108E end if
  if ch == "J" then return 0x324210847 end if
  if ch == "K" then return 0x4654C5251 end if
  if ch == "L" then return 0x7E1084210 end if
  if ch == "M" then return 0x4631AD771 end if
  if ch == "N" then return 0x46319D731 end if
  if ch == "O" then return 0x3A318C62E end if
  if ch == "P" then return 0x4210F463E end if
  if ch == "Q" then return 0x36558C62E end if
  if ch == "R" then return 0x4654F463E end if
  if ch == "S" then return 0x78217420F end if
  if ch == "T" then return 0x10842109F end if
  if ch == "U" then return 0x3A318C631 end if
  if ch == "V" then return 0x11518C631 end if
  if ch == "W" then return 0x4775AC631 end if
  if ch == "X" then return 0x462A22A31 end if
  if ch == "Y" then return 0x108422A31 end if
  if ch == "Z" then return 0x7E082083F end if
  if ch == ":" then return 0x8401080 end if
  if ch == "." then return 0x318000000 end if
  if ch == "!" then return 0x100421084 end if
  if ch == "?" then return 0x10041062E end if
  if ch == "-" then return 0xF8000 end if
  if ch == "/" then return 0x420820821 end if
  return 0x7E358D63F
end function

/// Performs the textWidth operation for the minipixels graphics font module.
/// @param text Text consumed by the operation.
/// @param scale scale value consumed by this operation.
function textWidth(text, scale)
  if scale <= 0 then scale = 1 end if
  if len(text) <= 0 then return 0 end if
  return ((len(text) * 6) - 1) * scale
end function

/// Draws glyph through the minipixels graphics font rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param ch ch value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function drawGlyph(canvas, ch, x, y, scale, color)
  if scale <= 0 then scale = 1 end if
  if ch == " " then return end if
  previousDrawCalls = canvas.drawCalls
  bits = glyphBits(ch)
  yy = 0
  while yy < 7
    row = (bits >> (yy * 5)) & 31
    xx = 0
    while xx < 5
      if (row & (16 >> xx)) != 0 then
        start = xx
        xx = xx + 1
        while xx < 5 and (row & (16 >> xx)) != 0
          xx = xx + 1
        end while
        cv.fillRect(canvas, x + (start * scale), y + (yy * scale), (xx - start) * scale, scale, color)
      else
        xx = xx + 1
      end if
    end while
    yy = yy + 1
  end while
  canvas.drawCalls = previousDrawCalls + 1
end function

/// Draws text through the minipixels graphics font rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function drawText(canvas, text, x, y, scale, color)
  if scale <= 0 then scale = 1 end if
  xx = x
  for each ch in text
    drawGlyph(canvas, ch, xx, y, scale, color)
    xx = xx + (6 * scale)
  end for
end function

/// Draws text centered through the minipixels graphics font rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function drawTextCentered(canvas, text, y, scale, color)
  drawText(canvas, text, (canvas.width - textWidth(text, scale)) / 2, y, scale, color)
end function
