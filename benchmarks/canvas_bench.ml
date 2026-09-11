import minipixels as mp
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif

function main(args)
  cfg = mp.createConfig("Bench", 320, 180, 1)
  game = mp.runHeadless(cfg, void, void, void, void)
  canvas = game.canvas
  frames = 21
  start = win.ticks()
  for i = 0 to frames - 1
    canvas.clear(mp.rgb(i & 255, 40, 90))
    for y = 0 to canvas.height - 1
      for x = 0 to canvas.width - 1
        canvas.setPixel(x, y, mp.rgb((x + i) & 255, y & 255, 120))
      end for
    end for
  end for
  elapsed = win.ticks() - start
  if elapsed < 1 then elapsed = 1 end if
  megapixelsPerSecond = (frames * canvas.width * canvas.height) / (elapsed * 1000.0)
  print "canvas size=" + canvas.width + "x" + canvas.height + " frames=" + frames + " elapsedMs=" + elapsed + " MPix/s=" + megapixelsPerSecond
  print "canvas hash"
  print mp.frameHash(canvas)
  return 0
end function
