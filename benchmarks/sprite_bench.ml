import minipixels as mp
import minipixels.graphics.canvas as cv
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif

function printResult(label, elapsed, frames, drawsPerFrame)
  if elapsed < 1 then elapsed = 1 end if
  drawsPerSecond = (frames * drawsPerFrame * 1000) / elapsed
  print label + " elapsedMs=" + elapsed + " draws/s=" + drawsPerSecond
end function

function main(args)
  canvas = cv.create(320, 180)
  image = mp.solidImage(16, 16, mp.rgba(180, 90, 40, 180), "sprite-bench")
  sprite = mp.spriteFromImage(image, "sprite-bench")
  frames = 50

  start = win.ticks()
  for frame = 0 to frames - 1
    canvas.clear(mp.rgb(8, 12, 20))
    for i = 0 to 199
      canvas.drawSprite(sprite, (i * 37 + frame) % canvas.width, (i * 19) % canvas.height)
    end for
  end for
  printResult("sprite-1x", win.ticks() - start, frames, 200)

  start = win.ticks()
  for frame = 0 to frames - 1
    canvas.clear(mp.rgb(8, 12, 20))
    for i = 0 to 39
      canvas.drawSpriteScaled(sprite, (i * 37 + frame) % canvas.width, (i * 19) % canvas.height, 1.5, mp.rgba(255, 220, 200, 255))
    end for
  end for
  printResult("sprite-scaled-tinted", win.ticks() - start, frames, 40)

  start = win.ticks()
  for frame = 0 to frames - 1
    canvas.clear(mp.rgb(8, 12, 20))
    for i = 0 to 39
      canvas.drawSpriteRotated(sprite, (i * 37 + frame) % canvas.width, (i * 19) % canvas.height, 0.37, 1, mp.rgba(255, 255, 255, 255))
    end for
  end for
  printResult("sprite-rotated", win.ticks() - start, frames, 40)

  print "sprite hash"
  print mp.frameHash(canvas)
  return 0
end function
