import minipixels as mp

function main(args)
  cfg = mp.createConfig("Bench", 320, 180, 1)
  game = mp.runHeadless(cfg, void, void, void, void)
  canvas = game.canvas
  for i = 0 to 20
    canvas.clear(mp.rgb(i & 255, 40, 90))
    for y = 0 to canvas.height - 1
      for x = 0 to canvas.width - 1
        canvas.setPixel(x, y, mp.rgb((x + i) & 255, y & 255, 120))
      end for
    end for
  end for
  print "canvas hash"
  print mp.frameHash(canvas)
  return 0
end function
