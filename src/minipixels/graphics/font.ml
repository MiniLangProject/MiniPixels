package minipixels.graphics.font

import minipixels.graphics.canvas as cv

function glyphRows(ch)
  if ch == "0" then return [14, 17, 19, 21, 25, 17, 14] end if
  if ch == "1" then return [4, 12, 4, 4, 4, 4, 14] end if
  if ch == "2" then return [14, 17, 1, 2, 4, 8, 31] end if
  if ch == "3" then return [30, 1, 1, 14, 1, 1, 30] end if
  if ch == "4" then return [2, 6, 10, 18, 31, 2, 2] end if
  if ch == "5" then return [31, 16, 16, 30, 1, 1, 30] end if
  if ch == "6" then return [14, 16, 16, 30, 17, 17, 14] end if
  if ch == "7" then return [31, 1, 2, 4, 8, 8, 8] end if
  if ch == "8" then return [14, 17, 17, 14, 17, 17, 14] end if
  if ch == "9" then return [14, 17, 17, 15, 1, 1, 14] end if
  if ch == "A" then return [14, 17, 17, 31, 17, 17, 17] end if
  if ch == "B" then return [30, 17, 17, 30, 17, 17, 30] end if
  if ch == "C" then return [14, 17, 16, 16, 16, 17, 14] end if
  if ch == "D" then return [30, 17, 17, 17, 17, 17, 30] end if
  if ch == "E" then return [31, 16, 16, 30, 16, 16, 31] end if
  if ch == "F" then return [31, 16, 16, 30, 16, 16, 16] end if
  if ch == "G" then return [14, 17, 16, 23, 17, 17, 14] end if
  if ch == "H" then return [17, 17, 17, 31, 17, 17, 17] end if
  if ch == "I" then return [14, 4, 4, 4, 4, 4, 14] end if
  if ch == "J" then return [7, 2, 2, 2, 2, 18, 12] end if
  if ch == "K" then return [17, 18, 20, 24, 20, 18, 17] end if
  if ch == "L" then return [16, 16, 16, 16, 16, 16, 31] end if
  if ch == "M" then return [17, 27, 21, 21, 17, 17, 17] end if
  if ch == "N" then return [17, 25, 21, 19, 17, 17, 17] end if
  if ch == "O" then return [14, 17, 17, 17, 17, 17, 14] end if
  if ch == "P" then return [30, 17, 17, 30, 16, 16, 16] end if
  if ch == "Q" then return [14, 17, 17, 17, 21, 18, 13] end if
  if ch == "R" then return [30, 17, 17, 30, 20, 18, 17] end if
  if ch == "S" then return [15, 16, 16, 14, 1, 1, 30] end if
  if ch == "T" then return [31, 4, 4, 4, 4, 4, 4] end if
  if ch == "U" then return [17, 17, 17, 17, 17, 17, 14] end if
  if ch == "V" then return [17, 17, 17, 17, 17, 10, 4] end if
  if ch == "W" then return [17, 17, 17, 21, 21, 27, 17] end if
  if ch == "X" then return [17, 17, 10, 4, 10, 17, 17] end if
  if ch == "Y" then return [17, 17, 10, 4, 4, 4, 4] end if
  if ch == "Z" then return [31, 1, 2, 4, 8, 16, 31] end if
  if ch == ":" then return [0, 4, 4, 0, 4, 4, 0] end if
  if ch == "." then return [0, 0, 0, 0, 0, 12, 12] end if
  if ch == "!" then return [4, 4, 4, 4, 4, 0, 4] end if
  if ch == "?" then return [14, 17, 1, 2, 4, 0, 4] end if
  if ch == "-" then return [0, 0, 0, 31, 0, 0, 0] end if
  if ch == "/" then return [1, 1, 2, 4, 8, 16, 16] end if
  return [31, 17, 21, 17, 21, 17, 31]
end function

function glyphMask(x)
  if x == 0 then return 16 end if
  if x == 1 then return 8 end if
  if x == 2 then return 4 end if
  if x == 3 then return 2 end if
  return 1
end function

function textWidth(text, scale)
  if scale <= 0 then scale = 1 end if
  if len(text) <= 0 then return 0 end if
  return ((len(text) * 6) - 1) * scale
end function

function drawGlyph(canvas, ch, x, y, scale, color)
  if scale <= 0 then scale = 1 end if
  if ch == " " then return end if
  rows = glyphRows(ch)
  yy = 0
  while yy < 7
    row = rows[yy]
    xx = 0
    while xx < 5
      if (row & glyphMask(xx)) != 0 then
        cv.fillRect(canvas, x + (xx * scale), y + (yy * scale), scale, scale, color)
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
end function

function drawText(canvas, text, x, y, scale, color)
  if scale <= 0 then scale = 1 end if
  xx = x
  for each ch in text
    drawGlyph(canvas, ch, xx, y, scale, color)
    xx = xx + (6 * scale)
  end for
end function

function drawTextCentered(canvas, text, y, scale, color)
  drawText(canvas, text, (canvas.width - textWidth(text, scale)) / 2, y, scale, color)
end function
