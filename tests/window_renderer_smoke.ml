import minipixels.graphics.canvas as cv
import minipixels.platform.windows as win
import minipixels as mp

function main(args)
  canvas = cv.create(64, 36)
  canvas.clear(mp.rgb(20, 20, 30))
  canvas.fillRect(8, 8, 20, 12, mp.rgb(255, 205, 80))
  canvas.fillRect(34, 10, 18, 18, mp.rgb(78, 205, 196))

  w = win.open("MiniPixels Renderer Smoke", canvas.width, canvas.height, 6, "opengl")
  if typeof(w) == "error" then
    print "WINDOW_RENDERER_ERROR"
    return 1
  end if

  win.present(w, canvas)
  print "WINDOW_RENDERER " + win.rendererName(w)
  win.sleepMs(120)
  win.close(w)
  return 0
end function
