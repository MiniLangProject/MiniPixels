import minipixels as mp
import minipixels.graphics.sprite as sp
import std.assert as a

function main(args)
  c = mp.solidImage(2, 2, mp.rgb(255, 0, 0), "red")
  spr = mp.spriteFromImage(c, "red")
  canvas = minipixels.graphics.canvas.create(8, 8)
  canvas.clear(mp.rgb(1, 2, 3))
  a.assertEq(canvas.getPixel(0, 0), mp.rgb(1, 2, 3), "clear fills first pixel")
  a.assertEq(canvas.getPixel(7, 7), mp.rgb(1, 2, 3), "clear fills last pixel")
  canvas.setPixel(3, 4, mp.rgb(9, 8, 7))
  a.assertEq(canvas.getPixel(3, 4), mp.rgb(9, 8, 7), "setPixel/getPixel")
  canvas.setPixel(-1, -1, mp.rgb(0, 0, 0))
  a.assertEq(canvas.getPixel(0, 0), mp.rgb(1, 2, 3), "out of bounds write is ignored")
  canvas.fillRect(1, 1, 3, 2, mp.rgb(10, 20, 30))
  a.assertEq(canvas.getPixel(2, 2), mp.rgb(10, 20, 30), "fillRect")
  canvas.drawLine(0, 0, 7, 0, mp.rgb(40, 50, 60))
  a.assertEq(canvas.getPixel(4, 0), mp.rgb(40, 50, 60), "drawLine horizontal")
  canvas.drawSprite(spr, 5, 5)
  a.assertEq(canvas.getPixel(5, 5), mp.rgb(255, 0, 0), "drawSprite")
  canvas.fillRect(1.75, 6.2, 2.9, 1.1, mp.rgb(11, 22, 33))
  a.assertEq(canvas.getPixel(1, 6), mp.rgb(11, 22, 33), "fillRect snaps float coordinates")
  canvas.drawSprite(spr, 2.8, 5.9)
  a.assertEq(canvas.getPixel(2, 5), mp.rgb(255, 0, 0), "drawSprite snaps float coordinates")
  print "=== CANVAS TESTS DONE ==="
  return 0
end function
