// Shared presentation and deterministic screenshot support for the examples.
package example.showcase

import minipixels as mp

function heading(canvas, title, hint)
  canvas.fillRect(8, 8, canvas.width - 16, 28, mp.rgba(12, 28, 42, 220))
  canvas.fillRect(8, 8, 2, 28, mp.rgb(100, 222, 193))
  mp.drawText(canvas, title, 17, 13, 1, mp.rgb(237, 241, 214))
  mp.drawText(canvas, hint, 17, 24, 1, mp.rgb(143, 185, 190))
end function

function run(args, cfg, initialize, update, render, shutdown)
  if len(args) >= 2 and args[0] == "--screenshot" then
    cfg.headlessFrames = 60
    game = mp.runHeadless(cfg, initialize, update, render, shutdown)
    if typeof(game) == "error" then return game end if
    result = mp.saveCanvasPng(game.canvas, args[1])
    if typeof(result) == "error" then return result end if
    print "Saved " + args[1]
    return 0
  end if
  return mp.run(cfg, initialize, update, render, shutdown)
end function
