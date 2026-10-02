import minipixels as mp
import std.assert as a
import minipixels.math.types as mt

function testFractionalTileSeams()
  a.assertEq(mt.floorInt(-0.25), -1, "negative fraction floors once")
  a.assertEq(mt.floorInt(-15.75), -16, "negative tile origin floors once")
  a.assertEq(mt.floorInt(-16.0), -16, "negative integral float stays integral")
  a.assertEq(mt.floorInt(15.75), 15, "positive fraction floors down")
  color = mp.rgb(80, 180, 100)
  sheet = mp.spriteSheet(mp.solidImage(16, 16, color, "seam"), 16, 16, 0, 0)
  map = mp.tilemap(16, 16, 8, 8, mp.tileset(sheet), 1)
  layer = mp.tileLayer("solid", 8, 8, array(64, 1), true, false, 1, 1)
  map.addLayer(layer)
  canvas = minipixels.graphics.canvas.create(40, 40)
  camera = mp.camera(40, 40)
  camera.pixelSnap = false
  gaps = 0
  for sample = 0 to 127
    camera.x = 8 + sample / 8.0
    camera.y = 8 + sample / 16.0
    canvas.clear(mp.rgb(255, 0, 255))
    map.draw(canvas, camera)
    for y = 0 to 39
      for x = 0 to 39
        if canvas.getPixel(x, y) != color then gaps = gaps + 1 end if
      end for
    end for
  end for
  a.assertEq(gaps, 0, "fractional camera leaves no moving tile seams at clipped edges")
end function

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
  testFractionalTileSeams()
  scene = minipixels.graphics.canvas.create(48, 24)
  drawScene(scene)
  sceneHash = mp.frameHash(scene)
  print "REGRESSION_SCENE_HASH " + sceneHash
  a.assertEq(sceneHash, 1531060397, "scene framehash regression")

  world = minipixels.graphics.canvas.create(32, 24)
  drawWorldScene(world)
  worldHash = mp.frameHash(world)
  print "REGRESSION_WORLD_HASH " + worldHash
  a.assertEq(worldHash, 809759349, "world framehash regression")

  print "=== RENDER REGRESSION TESTS DONE ==="
  return 0
end function
