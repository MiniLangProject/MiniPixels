import minipixels as mp
import std.assert as a

frames = 0

function update(game, dt)
  global frames
  frames = frames + 1
  if frames >= 4 then game.quit() end if
end function

function render(game, canvas)
  canvas.clear(mp.rgb(2, 4, 6))
  canvas.setPixel(frames, frames, mp.rgb(100, 120, 140))
end function

function main(args)
  cfg = mp.createConfig("Headless", 32, 24, 1)
  cfg.headlessFrames = 10
  game = mp.runHeadless(cfg, void, update, render, void)
  a.assertEq(frames, 4, "headless update loop stops on quit")
  a.assertEq(game.time.updateNumber, 4, "update counter")
  a.assertTrue(mp.frameHash(game.canvas) > 0, "framebuffer hash")
  print "=== HEADLESS TESTS DONE ==="
  return 0
end function
