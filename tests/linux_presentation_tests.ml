// Synthetic pixel oracle; no window, native bridge, original assets or network.
import minipixels.platform.linux as linux
import minipixels.graphics.canvas as cv
import std.time as time

struct Surface
  clientWidth as int
  clientHeight as int
  presentPixels as bytes
end struct

function expect(condition, message)
  if not condition then return error(1, message) end if
end function

function source(width, height)
  canvas = cv.create(width, height)
  for i = 0 to len(canvas.pixels) - 1
    // Distinct channels and changing alpha catch accidental RGBA/BGRA copies.
    canvas.pixels[i] = ((i * 37) + (i div 7) + 19) & 255
  end for
  return canvas
end function

function surface(width, height)
  return Surface(width, height, bytes(width * height * 4, 213))
end function

function compare(actual, expected, label)
  expect(len(actual) == len(expected), label + " size")
  for i = 0 to len(actual) - 1
    if actual[i] != expected[i] then
      return error(1, label + " at byte " + str(i) + ": " + str(actual[i]) + " != " + str(expected[i]))
    end if
  end for
end function

function pixel(destination, di, source, si)
  destination[di] = source[si + 2]
  destination[di + 1] = source[si + 1]
  destination[di + 2] = source[si]
  destination[di + 3] = 0
end function

// Deliberately simple destination-pixel oracle, independent of row replication
// and offset-map implementation. Off-viewport pixels are black.
function nearestOracle(w, canvas, vx, vy, vw, vh)
  expected = bytes(len(w.presentPixels), 0)
  for y = 0 to w.clientHeight - 1
    for x = 0 to w.clientWidth - 1
      if x >= vx and y >= vy and x < vx + vw and y < vy + vh then
        sx = ((x - vx) * canvas.width) div vw
        sy = ((y - vy) * canvas.height) div vh
        pixel(expected, (y * w.clientWidth + x) * 4, canvas.pixels, (sy * canvas.width + sx) * 4)
      end if
    end for
  end for
  return expected
end function

function testRows()
  canvas = source(7, 5)
  w = surface(7, 5)
  expected = bytes(len(w.presentPixels), 213)
  for y = 1 to 3
    for x = 2 to 5
      i = (y * 7 + x) * 4
      pixel(expected, i, canvas.pixels, i)
    end for
  end for
  linux.convertNativeRegion(w, canvas, 2, 1, 6, 4)
  compare(w.presentPixels, expected, "dirty rectangle preserves outside pixels")
  expect(not linux.copyBgraRow(w.presentPixels, canvas.pixels, -1, 0, 1, 1), "negative destination rejected")
  expect(not linux.copyBgraRow(w.presentPixels, canvas.pixels, 0, len(canvas.pixels), 1, 1), "truncated source rejected")
  expect(not linux.copyBgraRow(w.presentPixels, canvas.pixels, len(w.presentPixels) - 3, 0, 1, 1), "truncated destination rejected")
  expect(not linux.copyBgraRow(w.presentPixels, canvas.pixels, 0, 0, 1, 0), "zero factor rejected")
  compare(w.presentPixels, expected, "rejected rows do not write")
end function

function testInteger()
  cases = 0
  for sw = 1 to 5
    for sh = 1 to 4
      canvas = source(sw, sh)
      for factor = 1 to 5
        for margin = 0 to 2
          w = surface(sw * factor + margin * 2, sh * factor + margin * 2)
          expected = nearestOracle(w, canvas, margin, margin, sw * factor, sh * factor)
          expect(linux.scaleInteger(w, canvas, margin, margin, factor), "integer scale accepted")
          compare(w.presentPixels, expected, "integer " + str(sw) + "x" + str(sh) + " factor " + str(factor) + " margin " + str(margin))
          cases = cases + 1
        end for
      end for
    end for
  end for
  return cases
end function

function testNearest()
  cases = 0
  positions = [-8, -2, 0, 1, 4, 8]
  sizes = [1, 2, 5, 9]
  for sw = 1 to 4
    for sh = 1 to 3
      canvas = source(sw, sh)
      for xi = 0 to len(positions) - 1
        for yi = 0 to len(positions) - 1
          for wi = 0 to len(sizes) - 1
            for hi = 0 to len(sizes) - 1
              w = surface(7, 6)
              vx = positions[xi]
              vy = positions[yi]
              vw = sizes[wi]
              vh = sizes[hi]
              expected = nearestOracle(w, canvas, vx, vy, vw, vh)
              expect(linux.scaleGeneric(w, canvas, vx, vy, vw, vh), "nearest scale accepted")
              compare(w.presentPixels, expected, "nearest mapping and clipped viewport")
              cases = cases + 1
            end for
          end for
        end for
      end for
    end for
  end for
  return cases
end function

function benchmark()
  canvas = source(320, 200)
  w = surface(960, 600)
  start = time.ticks()
  for i = 0 to 199
    linux.scaleInteger(w, canvas, 0, 0, 3)
  end for
  print "Integer 320x200 -> 960x600, 200 frames: " + str(time.ticks() - start) + " ms"
  w = surface(913, 557)
  start = time.ticks()
  for i = 0 to 199
    linux.scaleGeneric(w, canvas, 11, 7, 891, 543)
  end for
  print "Nearest 320x200 -> 891x543 in 913x557, 200 frames: " + str(time.ticks() - start) + " ms"
end function

function run()
  testRows()
  integerCases = testInteger()
  nearestCases = testNearest()
  print "Linux presentation pixel cases passed: " + str(integerCases + nearestCases)
  benchmark()
end function

function main(args)
  result = try(run())
  if typeof(result) == "error" then print result.message; return 1 end if
  return 0
end function
