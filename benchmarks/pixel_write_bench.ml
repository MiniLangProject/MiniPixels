import minipixels as mp
import minipixels.graphics.canvas as cv
import std.assert as a
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif

function main(args)
  width = 320
  height = 180
  frames = 100
  direct = cv.create(width, height)
  batched = cv.create(width, height)
  source = bytes(width * height * 4, 255)
  direct.clear(mp.rgb(0, 0, 0))

  start = win.seconds()
  for frame = 0 to frames - 1
    for y = 0 to height - 1
      for x = 0 to width - 1
        direct.setPixel(x, y, mp.rgb((x + frame) & 255, y & 255, 120))
      end for
    end for
  end for
  directMs = (win.seconds() - start) * 1000

  start = win.seconds()
  for frame = 0 to frames - 1
    i = 0
    for y = 0 to height - 1
      for x = 0 to width - 1
        source[i] = (x + frame) & 255
        source[i + 1] = y & 255
        source[i + 2] = 120
        i = i + 4
      end for
    end for
    if batched.replacePixels(source) == false then return 1 end if
  end for
  batchMs = (win.seconds() - start) * 1000

  a.assertEq(mp.frameHash(batched), mp.frameHash(direct), "bulk pixels match setPixel output")
  print "setPixel ms=" + directMs + " MPix/s=" + ((frames * width * height) / (directMs * 1000))
  print "replacePixels ms=" + batchMs + " MPix/s=" + ((frames * width * height) / (batchMs * 1000))
  print "hash=" + mp.frameHash(batched)
  return 0
end function
