import minipixels as mp
import minipixels.graphics.canvas as cv
import minipixels.platform.windows as win

function drawFrame(canvas, frame)
  canvas.clear(mp.rgb((frame * 3) & 255, 24, 42))
  for y = 0 to canvas.height - 1
    for x = 0 to canvas.width - 1
      if ((x + frame) % 17) == 0 or ((y + frame) % 19) == 0 then
        canvas.setPixel(x, y, mp.rgb((x + frame) & 255, (y * 2) & 255, 180))
      end if
    end for
  end for
  canvas.fillRect((frame * 3) % (canvas.width - 40), 24, 40, 24, mp.rgba(255, 205, 80, 220))
  canvas.fillRect(canvas.width - 72, (frame * 2) % (canvas.height - 36), 36, 36, mp.rgba(78, 205, 196, 220))
end function

function benchMode(label, renderer, scaleMode, smoothing)
  canvas = cv.create(320, 180)
  w = win.open("MiniPixels Renderer Bench " + label, canvas.width, canvas.height, 4, renderer, scaleMode, smoothing)
  if typeof(w) == "error" then
    print label + " ERROR"
    return
  end if

  frames = 180
  start = win.ticks()
  for i = 0 to frames - 1
    win.pollEvents(w)
    drawFrame(canvas, i)
    win.present(w, canvas)
  end for
  elapsed = win.ticks() - start
  if elapsed < 1 then elapsed = 1 end if
  fps = (frames * 1000) / elapsed
  print label + " renderer=" + win.rendererName(w) + " scale=" + scaleMode + " smoothing=" + smoothing
  print label + " frames=" + frames + " elapsedMs=" + elapsed + " fps=" + fps
  if win.rendererFallbackReason(w) != "" then
    print label + " fallback=" + win.rendererFallbackReason(w)
  end if
  win.close(w)
end function

function main(args)
  benchMode("gdi-stretch", "gdi", "stretch", false)
  benchMode("opengl-stretch", "opengl", "stretch", false)
  benchMode("opengl-integer", "opengl", "integer", false)
  benchMode("opengl-fit-smooth", "opengl", "fit", true)
  return 0
end function
