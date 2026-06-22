import minipixels as mp
import minipixels.world.tilemap as tile
import std.assert as a

function main(args)
  cam = mp.camera(10, 10)
  cam.worldWidth = 100
  cam.worldHeight = 80
  cam.follow(95, 75)
  a.assertEq(cam.x, 90, "camera clamp x")
  a.assertEq(cam.y, 70, "camera clamp y")
  cam.worldWidth = 500
  cam.worldHeight = 500
  cam.follow(170.75, 108.25)
  a.assertEq(cam.x, 165, "camera snaps float x")
  a.assertEq(cam.y, 103, "camera snaps float y")

  img = mp.solidImage(16, 16, mp.rgb(255, 255, 255), "tile")
  sheet = mp.spriteSheet(img, 16, 16, 0, 0)
  map = mp.tilemap(16, 16, 4, 4, mp.tileset(sheet), 1)
  data = array(16, 0)
  data[5] = 1
  map.addLayer(mp.tileLayer("collision", 4, 4, data, false, true, 1, 1))
  a.assertTrue(map.isSolidAtTile(1, 1), "solid tile query")
  a.assertFalse(map.isSolidAtTile(0, 0), "empty tile query")
  res = mp.tileMoveAndCollide(map, mp.recti(0, 16, 16, 16), 16, 0)
  a.assertTrue(res.hitRight, "tile collision right")
  leftRes = mp.tileMoveAndCollide(map, mp.recti(0, 0, 16, 16), -4, 0)
  a.assertEq(leftRes.x, 0, "tilemap clamps left world edge")
  a.assertTrue(leftRes.hitLeft, "tilemap reports left world edge")
  bottomRes = mp.tileMoveAndCollide(map, mp.recti(8, 56, 16, 16), 0, 20)
  a.assertEq(bottomRes.y, 48, "tilemap clamps bottom world edge")
  a.assertTrue(bottomRes.hitBottom, "tilemap reports bottom world edge")

  sheet2 = mp.spriteSheet(mp.solidImage(32, 16, mp.rgb(1, 2, 3), "sheet2"), 16, 16, 0, 0)
  a.assertEq(sheet2.columns, 2, "sprite sheet column count")
  a.assertEq(sheet2.frameCount, 2, "sprite sheet frame count")
  a.assertEq(sheet2.getFrame(-1).sx, 0, "sprite sheet clamps negative frame")
  a.assertEq(sheet2.getFrame(99).sx, 16, "sprite sheet clamps large frame")

  anim = mp.animation(2)
  anim.addFrame(sheet2.getFrame(0), 0)
  anim.play()
  anim.update(1.0)
  a.assertEq(anim.index, 0, "single frame animation stays valid")

  r = mp.recti(3.75, 4.25, 12.9, 15.1)
  a.assertEq(r.x, 3, "recti floors x")
  a.assertEq(r.y, 4, "recti floors y")

  rnd = mp.random(123)
  v1 = rnd.nextInt(1, 10)
  rnd2 = mp.random(123)
  a.assertEq(v1, rnd2.nextInt(1, 10), "random seed deterministic")

  print "=== SYSTEMS TESTS DONE ==="
  return 0
end function
