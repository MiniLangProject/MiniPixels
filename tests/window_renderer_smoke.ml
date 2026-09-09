import minipixels.graphics.canvas as cv
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif
import minipixels as mp

nativeWidth = 0
nativeHeight = 0

function captureNativeResolution(game)
  global nativeWidth, nativeHeight
  nativeWidth = game.canvas.width
  nativeHeight = game.canvas.height
end function

function stopNativeSmoke(game, dt)
  game.quit()
end function

function main(args)
  canvas = cv.create(64, 36)
  canvas.clear(mp.rgb(20, 20, 30))
  canvas.fillRect(8, 8, 20, 12, mp.rgb(255, 205, 80))
  canvas.fillRect(34, 10, 18, 18, mp.rgb(78, 205, 196))

  w = win.open("MiniPixels Renderer Smoke", canvas.width, canvas.height, 6, "opengl", "integer", false)
  if typeof(w) == "error" then
    print "WINDOW_RENDERER_ERROR"
    return 1
  end if

  win.present(w, canvas)
  print "WINDOW_RENDERER " + win.rendererName(w)
  print "WINDOW_RENDERER_GPU " + win.isGpuRenderer(w)
  print "WINDOW_RENDERER_FALLBACK " + win.rendererFallbackReason(w)
  // Exercise runtime framebuffer reallocation and backend source-size updates.
  canvas.resize(96, 54)
  win.setRenderSize(w, canvas.width, canvas.height)
  canvas.clear(mp.rgb(12, 18, 30))
  canvas.fillRect(12, 10, 40, 20, mp.rgb(240, 160, 70))
  if win.present(w, canvas) == false then return 2 end if
#if TARGET_OS == "linux"
  // Exercise the safe crop path used when an integer-scale window is smaller than its logical canvas.
  w.clientWidth = canvas.width - 5
  w.clientHeight = canvas.height - 3
  if win.present(w, canvas) == false then return 3 end if
#endif
  win.sleepMs(120)
  win.close(w)

  cfg = mp.createConfig("MiniPixels Native Resolution Smoke", 64, 36, 2)
  mp.useNativeRenderResolution(cfg)
  mp.setPauseWhenUnfocused(cfg, false)
  result = mp.run(cfg, captureNativeResolution, stopNativeSmoke, void, void)
  if typeof(result) == "error" or result != 0 then return 4 end if
  if nativeWidth <= 64 or nativeHeight <= 36 then return 5 end if
  print "WINDOW_NATIVE_RESOLUTION " + nativeWidth + "x" + nativeHeight
  return 0
end function
