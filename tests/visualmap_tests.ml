import minipixels as mp
import minipixels.graphics.canvas as cv
import minipixels.world.visualmap as vm
import std.assert as a

function document(values)
  return "{\"type\":\"map\",\"orientation\":\"orthogonal\",\"infinite\":false,\"width\":5,\"height\":1,\"tilewidth\":2,\"tileheight\":2,\"tilesets\":[{\"firstgid\":1,\"tilewidth\":2,\"tileheight\":2,\"tilecount\":1,\"columns\":1,\"imagewidth\":2,\"imageheight\":2}],\"layers\":[{\"type\":\"tilelayer\",\"width\":5,\"height\":1,\"data\":[" + values + "]}]}"
end function

function rejected(text, sheet)
  result = try(vm.parse(text, sheet))
  return typeof(result) == "error"
end function

function main(args)
  // Four different pixels expose incorrect flip orientation.
  pix = bytes(16, 0)
  pix[0] = 255; pix[3] = 255
  pix[5] = 255; pix[7] = 255
  pix[10] = 255; pix[11] = 255
  pix[12] = 255; pix[13] = 255; pix[15] = 255
  sheet = mp.spriteSheet(mp.image(2, 2, pix, "synthetic"), 2, 2, 0, 0)
  map = try(vm.parse(document("1,1073741825,2147483649,3221225473,0"), sheet))
  if typeof(map) == "error" then print map.message; return 1 end if
  canvas = cv.create(10, 2)
  canvas.clear(mp.rgb(0,0,0))
  camera = mp.camera(10,2)
  vm.draw(map, canvas, camera)
  a.assertEq(canvas.getPixel(0,0), mp.rgb(255,0,0), "normal top left")
  a.assertEq(canvas.getPixel(2,0), mp.rgb(0,0,255), "vertical top left")
  a.assertEq(canvas.getPixel(4,0), mp.rgb(0,255,0), "horizontal top left")
  a.assertEq(canvas.getPixel(6,0), mp.rgb(255,255,0), "combined top left")
  a.assertEq(canvas.getPixel(8,0), mp.rgb(0,0,0), "empty cell")
  a.assertEq(canvas.tileCount, 4, "four visible cells")
  cropped = cv.create(2,2)
  camera.x = 2
  vm.draw(map, cropped, camera)
  a.assertEq(cropped.tileCount, 1, "camera culls other tiles")
  a.assertEq(cropped.getPixel(0,0), mp.rgb(0,0,255), "camera translation")
  a.assertTrue(rejected(document("1,1,1,1,2"), sheet), "out of atlas")
  a.assertTrue(rejected(document("1,1,1,1,536870913"), sheet), "diagonal flag")
  a.assertTrue(rejected(document("1,1,1,1,268435457"), sheet), "hexagonal flag")
  a.assertTrue(rejected(document("1,1,1,1,1073741824"), sheet), "flags without tile")
  a.assertTrue(rejected(document("1,1,1,1,-1"), sheet), "negative GID")
  a.assertTrue(rejected(document("1,1,1,1,1.5"), sheet), "fractional GID")
  a.assertTrue(rejected(document("1,1,1,1"), sheet), "truncated map")
  a.assertTrue(rejected(document("1,1,1,1,1,1"), sheet), "extra map cells")
  print "Visual tilemap tests passed."
  return 0
end function
