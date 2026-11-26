import std.test as test
import minipixels.graphics.canvas as cv
import minipixels.graphics.geometry3d as geometry

function depthOrder()
  canvas = cv.create(64,64)
  surface = geometry.surface(canvas)
  camera = geometry.camera(32.0,32.0,40.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  farMesh = geometry.mesh()
  nearMesh = geometry.mesh()
  geometry.box(farMesh,0.0,0.0,0.0,1.2,1.2,0.05,0xd02020ff)
  geometry.box(nearMesh,0.0,0.0,0.3,0.55,0.55,0.05,0x2080e0ff)
  geometry.clear(surface,0x101010ff)
  geometry.drawAt(surface,nearMesh,camera)
  geometry.drawAt(surface,farMesh,camera)
  first = canvas.getPixel(32,32)
  test.assertTrue(((first >> 8)&255) > ((first >> 24)&255),"near geometry occludes farther geometry")
  geometry.clear(surface,0x101010ff)
  geometry.drawAt(surface,farMesh,camera)
  geometry.drawAt(surface,nearMesh,camera)
  test.assertEqual(canvas.getPixel(32,32),first,"opaque depth is independent of submission order")
  rejected = geometry.mesh()
  geometry.box(rejected,0.0,0.0,3.2,1.0,1.0,0.1,0xff00ffff)
  geometry.drawAt(surface,rejected,camera)
  test.assertEqual(canvas.getPixel(32,32),first,"geometry behind the camera is rejected")
end function

function projectionModes()
  camera = geometry.camera(100.0,100.0,100.0,0.0,0.0,0.0,0.9,0.0,2.6,true)
  low = geometry.project(camera,0.2,0.0,0.0)
  high = geometry.project(camera,0.2,0.0,0.2)
  far = geometry.project(camera,0.2,1.0,0.0)
  test.assertTrue(high.y < low.y,"height changes projected position")
  test.assertTrue(far.x < low.x,"perspective reduces distant horizontal extent")
  camera.perspective = false
  nearOrtho = geometry.project(camera,0.2,0.0,0.0)
  farOrtho = geometry.project(camera,0.2,1.0,0.0)
  test.assertApproxEqual(nearOrtho.x,farOrtho.x,0.00001,"orthographic extent stays parallel")
  invalid = geometry.project(camera,0.0,50.0,0.0)
  test.assertFalse(invalid.visible,"depth outside representable range is rejected")
end function

function cachedDepthSurvives()
  camera = geometry.camera(16.0,16.0,20.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  cached = geometry.surface(cv.create(32,32))
  live = geometry.surface(cv.create(32,32))
  front = geometry.mesh()
  behind = geometry.mesh()
  geometry.box(front,0.0,0.0,0.3,1.0,1.0,0.05,0x2080e0ff)
  geometry.box(behind,0.0,0.0,0.0,1.0,1.0,0.05,0xd02020ff)
  geometry.clear(cached,0x101010ff)
  geometry.drawAt(cached,front,camera)
  test.assertTrue(geometry.copySurface(live,cached))
  expected = cached.canvas.getPixel(16,16)
  geometry.drawAt(live,behind,camera)
  test.assertEqual(live.canvas.getPixel(16,16),expected,"cached depth occludes new dynamic geometry")
  test.assertEqual(cached.canvas.getPixel(16,16),expected,"drawing into live surface leaves cache unchanged")
  mismatch = geometry.surface(cv.create(16,16))
  test.assertFalse(geometry.copySurface(mismatch,cached),"surface size mismatch is rejected")
end function

function emptyMeshIsNoOp()
  testSurface = geometry.surface(cv.create(8,8))
  testCamera = geometry.camera(4.0,4.0,4.0)
  geometry.clear(testSurface,0x314659ff)
  emptyModel = geometry.mesh()
  geometry.drawAt(testSurface,emptyModel,testCamera)
  test.assertEqual(testSurface.canvas.getPixel(4,4),0x314659ff,"an empty mesh leaves the framebuffer unchanged")
  test.assertEqual(testSurface.triangles,0,"an empty mesh submits no triangles")
  test.assertEqual(testSurface.depth[0],255,"an empty mesh leaves depth clear")
end function

function main(args)
  emptyMeshIsNoOp()
  exactFloatDepth()
  depthOrder()
  projectionModes()
  cachedDepthSurvives()
  print "GEOMETRY3D [OK]"
  return 0
end function

function exactFloatDepth()
  testCamera = geometry.camera(16.5,16.5,20.0,0.0,0.0,0.0,0.0,0.0,3.0,false)
  testCamera.sinPitch = 1.0
  testCamera.cosPitch = 0.0
  testSurface = geometry.surface(cv.create(32,32))
  geometry.clear(testSurface,0x101010ff)
  model = geometry.mesh()
  geometry.triangle(model,-0.5,-0.5,0.0,0.5,-0.5,0.0,0.0,0.5,0.0,0x48c2a1ff,false)
  geometry.drawAt(testSurface,model,testCamera)
  test.assertEqual(testSurface.canvas.getPixel(16,16),0x48c2a1ff,"integral float depth and half-pixel edges render")
  index = (16*32+16)*2
  depth = testSurface.depth[index] | (testSurface.depth[index+1] << 8)
  test.assertEqual(depth,12288,"depth3.0 is encoded exactly without a float-to-int type error")
end function
