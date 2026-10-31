import minipixels as mp
import std.assert as a
import minipixels.math.types as mt
import minipixels.graphics.sprite as sp

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

function testScaledSpritePixels()
  image = sp.solidImage(5, 4, mt.rgba(20, 40, 60, 255), "scaled-regression")
  for y = 0 to 3
    for x = 0 to 4
      alpha = ((x + y) * 53) % 256
      sp.imageSetPixel(image, x, y, mt.rgba(20 + x * 31, 40 + y * 43, 60 + x * 13 + y * 11, alpha))
    end for
  end for
  sprite = sp.spriteFromImage(image, "scaled-regression")
  canvas = minipixels.graphics.canvas.create(32, 24)
  canvas.clear(mt.rgba(12, 18, 24, 255))
  canvas.drawSpriteScaled(sprite, 27, 19, 0.75, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 307075489, "clipped downscaled sprite pixels")

  canvas.clear(mt.rgba(12, 18, 24, 0))
  canvas.drawSpriteScaled(sprite, -3, -2, 1.5, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 479451288, "clipped tinted upscaled sprite over transparent canvas")

  canvas.clear(mt.rgba(12, 18, 24, 255))
  canvas.drawSpriteScaled(sprite, 0, 0, 2.0, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 1324411517, "tinted upscaled sprite over opaque canvas")
end function

function testIntegerScaledSpritePixels()
  image = sp.solidImage(7, 6, mt.rgba(20, 40, 60, 255), "integer-scale-regression")
  opaqueImage = sp.solidImage(7, 6, mt.rgba(20, 40, 60, 255), "opaque-transform-regression")
  for y = 0 to 5
    for x = 0 to 6
      alpha = ((x + y) * 53) % 256
      sp.imageSetPixel(image, x, y, mt.rgba(20 + x * 21, 40 + y * 31, 60 + x * 13 + y * 11, alpha))
      sp.imageSetPixel(opaqueImage, x, y, mt.rgba(20 + x * 21, 40 + y * 31, 60 + x * 13 + y * 11, 255))
    end for
  end for
  sprite = sp.spriteRegion(image, 1, 1, 5, 4, "integer-scale-regression")
  sprite.pivotX = 1
  sprite.pivotY = 2
  opaqueSprite = sp.spriteRegion(opaqueImage, 1, 1, 5, 4, "opaque-transform-regression")
  opaqueSprite.pivotX = 1
  opaqueSprite.pivotY = 2
  canvas = minipixels.graphics.canvas.create(32, 24)

  canvas.clear(mt.rgba(12, 18, 24, 0))
  canvas.drawSpriteEx(sprite, -2, 0, true, false, 1, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 767385695, "clipped flipped tinted 1x sprite")
  a.assertFalse(canvas.imageView.opaque, "1x sprite keeps transparent canvas non-opaque")

  canvas.clear(mt.rgba(12, 18, 24, 255))
  canvas.drawSpriteEx(opaqueSprite, 0, 0, false, true, 1, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 1077497177, "vertically flipped opaque 1x sprite")

  canvas.clear(mt.rgba(12, 18, 24, 0))
  canvas.drawSpriteEx(opaqueSprite, -2, 0, true, false, 1, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 78620663, "clipped horizontally flipped opaque 1x sprite")

  canvas.clear(mt.rgba(12, 18, 24, 255))
  canvas.drawSpriteEx(opaqueSprite, 31, 24, false, false, 1, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 1772919970, "clipped tinted opaque 1x sprite")

  canvas.clear(mt.rgba(12, 18, 24, 0))
  canvas.drawSpriteEx(sprite, -4, -3, true, false, 2, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 1676495142, "clipped flipped 2x sprite over transparent canvas")
  a.assertFalse(canvas.imageView.opaque, "2x sprite keeps transparent canvas non-opaque")

  canvas.clear(mt.rgba(12, 18, 24, 255))
  canvas.drawSpriteEx(sprite, 27, 20, false, true, 3, mt.rgba(230, 110, 190, 173))
  a.assertEq(mp.frameHash(canvas), 885534575, "clipped flipped 3x sprite over opaque canvas")
  a.assertTrue(canvas.imageView.opaque, "3x sprite keeps opaque canvas opaque")
end function

function testUnitSpriteSelfBlit()
  canvas = minipixels.graphics.canvas.create(8, 8)
  canvas.clear(mt.rgb(0, 0, 0))
  for y = 0 to 7
    for x = 0 to 7
      canvas.setPixel(x, y, mt.rgb(x * 25, y * 27, (x + y) * 12))
    end for
  end for
  sprite = sp.spriteRegion(canvas.imageView, 1, 1, 5, 4, "self-blit")
  canvas.drawSpriteEx(sprite, 2, 2, false, true, 1, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 822985925, "vertically flipped self-blit preserves pixel order")

  line = minipixels.graphics.canvas.create(8, 1)
  line.clear(mt.rgb(0, 0, 0))
  for x = 0 to 7
    line.setPixel(x, 0, mt.rgb(x * 20, 0, 0))
  end for
  flipped = sp.spriteRegion(line.imageView, 0, 0, 8, 1, "horizontal-self-blit")
  line.drawSpriteEx(flipped, 0, 0, true, false, 1, mt.rgba(255, 255, 255, 255))
  a.assertEq(line.getPixel(0, 0), mt.rgb(140, 0, 0), "horizontal self-blit copies rightmost first")
  a.assertEq(line.getPixel(3, 0), mt.rgb(80, 0, 0), "horizontal self-blit keeps left-to-right stores")
  a.assertEq(line.getPixel(4, 0), mt.rgb(80, 0, 0), "horizontal self-blit reads prior write")
  a.assertEq(line.getPixel(7, 0), mt.rgb(140, 0, 0), "horizontal self-blit copies rightmost last")
end function

function testSinglePixelSprite()
  canvas = minipixels.graphics.canvas.create(2, 2)
  canvas.clear(mt.rgba(0, 0, 0, 0))
  image = sp.solidImage(1, 1, mt.rgba(200, 40, 80, 128), "single-pixel")
  sprite = sp.spriteFromImage(image, "single-pixel")
  canvas.drawSpriteEx(sprite, 0, 0, true, true, 1, mt.rgba(230, 110, 190, 173))
  a.assertEq(canvas.getPixel(0, 0), mt.rgba(180, 17, 59, 86), "flipped tinted single-pixel sprite")
  a.assertFalse(canvas.imageView.opaque, "single-pixel blend keeps transparent canvas non-opaque")
end function

function testRotatedSpriteBytePaths()
  image = sp.solidImage(9, 7, mt.rgb(0, 0, 0), "rotated-pattern")
  opaqueImage = sp.solidImage(9, 7, mt.rgb(0, 0, 0), "rotated-opaque")
  for y = 0 to 6
    for x = 0 to 8
      alpha = (x * 71 + y * 39) % 256
      sp.imageSetPixel(image, x, y, mt.rgba(10 + x * 22, 20 + y * 30, 40 + x * 12, alpha))
      sp.imageSetPixel(opaqueImage, x, y, mt.rgb(10 + x * 22, 20 + y * 30, 40 + x * 12))
    end for
  end for
  sprite = sp.spriteRegion(image, 1, 1, 7, 5, "rotated")
  sprite.pivotX = 2
  sprite.pivotY = 3
  opaqueSprite = sp.spriteRegion(opaqueImage, 1, 1, 7, 5, "rotated-opaque")
  opaqueSprite.pivotX = 2
  opaqueSprite.pivotY = 3
  canvas = minipixels.graphics.canvas.create(26, 22)

  canvas.clear(mt.rgb(12, 18, 24))
  canvas.drawSpriteRotated(sprite, 4, 5, 0.37, 1, mt.rgba(220, 170, 255, 190))
  a.assertEq(mp.frameHash(canvas), 1163031530, "rotated alpha sprite with tint")

  canvas.clear(mt.rgb(12, 18, 24))
  canvas.drawSpriteRotated(opaqueSprite, 24, 20, 1.5707963267948966, 2, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 959223085, "rotated opaque clipped sprite")

  canvas.clear(mt.rgb(12, 18, 24))
  for yy = 0 to 21
    for xx = 0 to 25
      canvas.setPixel(xx, yy, mt.rgb((xx * 19 + yy * 7) % 256, (xx * 11 + yy * 13) % 256, (xx * 5 + yy * 17) % 256))
    end for
  end for
  selfSprite = sp.spriteRegion(canvas.imageView, 1, 1, 7, 5, "rotated-self")
  canvas.drawSpriteRotated(selfSprite, 5, 5, 0.37, 1, mt.rgba(255, 255, 255, 255))
  a.assertEq(mp.frameHash(canvas), 1686343468, "rotated self-blit preserves source order")
end function

function testAlphaRectAndLineBytePaths()
  canvas = minipixels.graphics.canvas.create(26, 22)
  canvas.clear(mt.rgb(12, 18, 24))
  canvas.fillRect(-3.4, 2.2, 14.7, 9.9, mt.rgba(220, 60, 130, 127))
  a.assertEq(mp.frameHash(canvas), 864129917, "clipped alpha rectangle over opaque canvas")
  a.assertTrue(canvas.imageView.opaque, "alpha rectangle preserves opaque destination")

  canvas.clear(mt.rgba(12, 18, 24, 0))
  canvas.fillRect(2, 3, 13, 8, mt.rgba(220, 60, 130, 127))
  a.assertEq(mp.frameHash(canvas), 217990261, "alpha rectangle over transparent canvas")

  canvas.clear(mt.rgb(12, 18, 24))
  minipixels.graphics.canvas.resetDirty(canvas)
  canvas.drawLine(-4.7, 0.2, 27.9, 18.6, mt.rgba(220, 60, 130, 127))
  a.assertEq(mp.frameHash(canvas), 108391401, "clipped translucent line pixels")
  a.assertFalse(canvas.imageView.opaque, "translucent line replaces destination alpha")
  a.assertEq(canvas.dirtyX0, 0, "clipped line dirty x0")
  a.assertEq(canvas.dirtyY0, 3, "clipped line dirty y0")
  a.assertEq(canvas.dirtyX1, 26, "clipped line dirty x1")
  a.assertEq(canvas.dirtyY1, 18, "clipped line dirty y1")

  canvas.clear(mt.rgb(12, 18, 24))
  minipixels.graphics.canvas.resetDirty(canvas)
  canvas.cameraX = 3.5
  canvas.cameraY = -2.25
  canvas.drawLine(20.9, 20.1, 1.2, -5.3, mt.rgba(220, 60, 130, 0))
  a.assertEq(mp.frameHash(canvas), 446282453, "reversed line with fractional camera")
  a.assertEq(canvas.dirtyX1, 16, "camera line dirty x1")
  a.assertEq(canvas.dirtyY1, 22, "camera line dirty y1")
end function

function main(args)
  testFractionalTileSeams()
  testScaledSpritePixels()
  testIntegerScaledSpritePixels()
  testUnitSpriteSelfBlit()
  testSinglePixelSprite()
  testRotatedSpriteBytePaths()
  testAlphaRectAndLineBytePaths()
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
