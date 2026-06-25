import minipixels as mp
import std.assert as a

function drawScene(canvas)
  canvas.clear(mp.rgb(12, 18, 28))
  canvas.fillRect(2, 3, 10, 5, mp.rgb(40, 120, 200))
  canvas.drawRect(1, 1, 14, 10, mp.rgb(255, 220, 80))
  img = mp.solidImage(3, 3, mp.rgba(255, 80, 80, 210), "reg")
  spr = mp.spriteFromImage(img, "reg")
  canvas.drawSpriteEx(spr, 6, 6, false, false, 2, mp.rgba(255, 255, 255, 255))
  mp.drawText(canvas, "CI", 18, 4, 1, mp.rgb(220, 240, 255))
end function

function drawWorldScene(canvas)
  canvas.clear(mp.rgb(0, 0, 0))
  cam = mp.camera(32, 24)
  cam.x = 16
  cam.y = 8
  mp.fillRectWorld(canvas, cam, 18, 10, 8, 6, mp.rgb(90, 200, 120))
  mp.drawRectWorld(canvas, cam, 16, 8, 16, 12, mp.rgb(255, 255, 255))
end function

function main(args)
  scene = minipixels.graphics.canvas.create(48, 24)
  drawScene(scene)
  sceneHash = mp.frameHash(scene)
  print "REGRESSION_SCENE_HASH " + sceneHash
  a.assertEq(sceneHash, 1365052421, "scene framehash regression")

  world = minipixels.graphics.canvas.create(32, 24)
  drawWorldScene(world)
  worldHash = mp.frameHash(world)
  print "REGRESSION_WORLD_HASH " + worldHash
  a.assertEq(worldHash, 809759349, "world framehash regression")

  print "=== RENDER REGRESSION TESTS DONE ==="
  return 0
end function
