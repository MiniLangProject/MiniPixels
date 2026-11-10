import std.assert as a
import minipixels.graphics.gpu as gpu
import minipixels.graphics.scene3d as s3d

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
    // Hosted Windows runners may only expose OpenGL 1.1 without framebuffer
    // objects. Execute the capability/fallback path, and report a visible skip.
    if len(args) > 0 and args[0] == "--allow-unavailable" then
      print "GPU_SCENE_UNAVAILABLE: framebuffer runtime unsupported; pixel checks skipped"
      return 0
    end if
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
  a.assertTrue(gpu.begin(w), "3D scene begins")
  a.assertTrue(s3d.meshBegin(), "retained mesh builder begins")
  a.assertTrue(s3d.box(0, 0, 0, 1, 1, 1, mp.rgb(200, 100, 50)), "box geometry appended")
  mesh = s3d.meshEnd()
  a.assertTrue(mesh > 0, "mesh uploaded through native ABI")
  a.assertTrue(s3d.begin(0, 0, 1, 40, 20), "3D depth pass begins")
  a.assertTrue(s3d.draw(mesh), "retained mesh draws")
  a.assertTrue(s3d.drawAt(mesh, 1, 0, 0, 45, 1, 1, 1), "transformed mesh draws")
  a.assertEq(s3d.metric(0), 2, "both mesh draws counted")
  s3d.finish()
  a.assertTrue(s3d.beginProjected(10, 5, 40, 30, 2.2), "projected 3D pass begins")
  s3d.finish()
  s3d.release(mesh)
  a.assertEq(s3d.metric(3), 0, "retained mesh released")
  gpu.finish(w)
  gpu.shutdown()
  win.close(w)
#else
  a.assertFalse(gpu.supported(), "GPU scene backend is an optional Windows runtime")
  a.assertFalse(s3d.begin(0, 0, 1, 40, 20), "3D fallback rejects unsupported pass")
  a.assertFalse(s3d.beginProjected(0, 0, 40, 30, 2.2), "projected fallback rejects unsupported pass")
  a.assertFalse(s3d.meshBegin(), "unsupported mesh builder")
  a.assertFalse(s3d.box(0, 0, 0, 1, 1, 1, 0xffffffff), "unsupported box")
  a.assertEq(s3d.meshEnd(), 0, "unsupported upload")
  a.assertFalse(s3d.draw(1), "unsupported mesh draw")
  a.assertFalse(s3d.drawAt(1, 0, 0, 0), "unsupported transformed draw")
  s3d.finish()
  s3d.release(1)
  a.assertEq(s3d.metric(3), 0, "unsupported backend owns no meshes")
#endif
  print "GPU_SCENE_SMOKE_OK"
  return 0
end function
