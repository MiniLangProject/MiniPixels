import std.assert as a
import minipixels.graphics.gpu as gpu

#if TARGET_OS == "windows"
import minipixels as mp
import minipixels.graphics.canvas as cv
import minipixels.platform.windows as win
#endif

function main(args)
#if TARGET_OS == "windows"
  w = win.open("MiniPixels GPU Scene Smoke", 64, 36, 4, "opengl", "integer", false)
  if typeof(w) == "error" then return 1 end if
  scene = gpu.create(w, 64, 36, false)
  if typeof(scene) == "void" then
    win.close(w)
    return 2
  end if
  a.assertTrue(gpu.begin(w), "GPU scene begins")
  scene.clear(mp.rgb(10, 20, 30))
  scene.fillRect(8, 7, 20, 12, mp.rgb(200, 100, 50))
  copy = cv.create(64, 36)
  a.assertTrue(gpu.readback(copy), "GPU scene reads back")
  a.assertEq(copy.getPixel(9, 8), mp.rgb(200, 100, 50), "GPU rectangle reaches framebuffer")
  a.assertTrue(gpu.finish(w), "GPU scene resolves")
  a.assertTrue(win.present(w, scene), "GPU scene swaps")
  a.assertTrue(scene.resize(80, 45), "GPU scene resizes")
  a.assertTrue(gpu.begin(w), "resized GPU scene begins")
  scene.clear(mp.rgb(5, 10, 15))
  copy.resize(80, 45)
  a.assertTrue(gpu.readback(copy), "resized GPU scene reads back")
  a.assertEq(copy.getPixel(79, 44), mp.rgb(5, 10, 15), "GPU clear covers resized framebuffer")
  gpu.finish(w)
  win.present(w, scene)
  gpu.shutdown()
  win.close(w)
#else
  a.assertFalse(gpu.supported(), "GPU scene backend is an optional Windows runtime")
#endif
  print "GPU_SCENE_SMOKE_OK"
  return 0
end function
