import std.test as test
import minipixels.graphics.canvas as cv
import minipixels.graphics.geometry3d as geometry
import minipixels.graphics.sprite as textureImages

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
  filteredTextureColors()
  perspectiveTextureCoordinates()
  transparentTextureDoesNotOcclude()
  transparentCachePreservesCutout()
  print "GEOMETRY3D [OK]"
  return 0
end function

function imageFromColors(width,height,colors)
  pixels = bytes(width*height*4,0)
  for i = 0 to len(colors)-1
    color = colors[i]
    pixels[i*4] = (color>>24)&255
    pixels[i*4+1] = (color>>16)&255
    pixels[i*4+2] = (color>>8)&255
    pixels[i*4+3] = color&255
  end for
  return textureImages.newImage(width,height,pixels,"texture-test")
end function

function filteredTextureColors()
  checker = imageFromColors(2,2,[0xff0000ff,0x00ff00ff,0x0000ffff,0xffffffff])
  material = geometry.texture(checker,0xffffffff,128,true)
  test.assertEqual(geometry.sampleTexture(material,0.5,0.5),0x808080ff,"bilinear center averages all four opaque texels")
  test.assertEqual(geometry.sampleTexture(material,-0.5,-0.5),0xff0000ff,"UVs clamp to image bounds")
  edge = imageFromColors(2,1,[0xffffff00,0xff0000ff])
  cutout = geometry.texture(edge,0xffffffff,128,true)
  test.assertEqual(geometry.sampleTexture(cutout,0.5,0.0),0xff000080,"transparent white does not bleed a white halo into red")
end function

function perspectiveTextureCoordinates()
  colors = imageFromColors(4,1,[0xff0000ff,0x00ff00ff,0x0000ffff,0xffffffff])
  material = geometry.texture(colors,0xffffffff,128,false)
  target = geometry.surface(cv.create(34,34))
  a = geometry.Projected(2.5,2.5,1.0,true)
  b = geometry.Projected(30.5,2.5,4.0,true)
  c = geometry.Projected(2.5,30.5,1.0,true)
  geometry.clear(target,0x101010ff)
  geometry.rasterTexturedTriangle(target,a,b,c,geometry.UV(0.0,0.0),geometry.UV(1.0,0.0),geometry.UV(0.0,1.0),material,0xffffffff,true)
  test.assertEqual(target.canvas.getPixel(17,4),0x00ff00ff,"perspective u about0.224 samples green instead of affine blue")
  geometry.clear(target,0x101010ff)
  geometry.rasterTexturedTriangle(target,a,b,c,geometry.UV(0.0,0.0),geometry.UV(1.0,0.0),geometry.UV(0.0,1.0),material,0xffffffff,false)
  test.assertEqual(target.canvas.getPixel(17,4),0x0000ffff,"orthographic interpolation keeps affine u about0.536")
end function

function transparentTextureDoesNotOcclude()
  camera = geometry.camera(16.0,16.0,20.0,0.0,0.0,0.0,0.0,0.0,3.0,false)
  camera.sinPitch = 1.0
  camera.cosPitch = 0.0
  target = geometry.surface(cv.create(32,32))
  geometry.clear(target,0x881111ff)
  mask = imageFromColors(2,1,[0xffffff00,0x00ff00ff])
  material = geometry.texture(mask,0xffffffff,128,false)
  front = geometry.mesh()
  geometry.texturedQuad(front,geometry.Point(-0.6,-0.6,1.0),geometry.Point(0.6,-0.6,1.0),geometry.Point(0.6,0.6,1.0),geometry.Point(-0.6,0.6,1.0),material)
  geometry.drawAt(target,front,camera)
  index = (16*32+8)*2
  test.assertEqual(target.depth[index]|(target.depth[index+1]<<8),65535,"transparent texel leaves depth untouched")
  behind = geometry.mesh()
  geometry.quad(behind,geometry.Point(-0.7,-0.7,0.0),geometry.Point(0.7,-0.7,0.0),geometry.Point(0.7,0.7,0.0),geometry.Point(-0.7,0.7,0.0),0x2040e0ff,false)
  geometry.drawAt(target,behind,camera)
  test.assertEqual(target.canvas.getPixel(8,16),0x2040e0ff,"later background remains visible through cutout")
  test.assertEqual(target.canvas.getPixel(23,16),0x00ff00ff,"opaque foreground still occludes background")
end function

function transparentCachePreservesCutout()
  camera = geometry.camera(16.0,16.0,20.0,0.0,0.0,0.0,0.0,0.0,3.0,false)
  camera.sinPitch = 1.0
  camera.cosPitch = 0.0
  cached = geometry.surface(cv.create(32,32))
  live = geometry.surface(cv.create(32,32))
  geometry.clear(cached,0x00000000)
  geometry.clear(live,0x111111ff)
  mask = imageFromColors(2,1,[0xffffff00,0x00ff00ff])
  material = geometry.texture(mask,0xffffffff,128,false)
  front = geometry.mesh()
  geometry.texturedQuad(front,geometry.Point(-0.6,-0.6,1.0),geometry.Point(0.6,-0.6,1.0),geometry.Point(0.6,0.6,1.0),geometry.Point(-0.6,0.6,1.0),material)
  geometry.drawAt(cached,front,camera)
  test.assertTrue(geometry.copySurface(live,cached))
  test.assertFalse(live.canvas.imageView.opaque,"a transparent cache must retain its alpha metadata")
  composite = cv.create(32,32)
  composite.clear(0x2040e0ff)
  cv.drawCanvas(composite,live.canvas,0,0)
  test.assertEqual(composite.getPixel(8,16),0x2040e0ff,"cached cutout keeps the compositing background visible")
  test.assertEqual(composite.getPixel(23,16),0x00ff00ff,"cached opaque texel still composites over the background")
  holeIndex = (16*32+8)*2
  opaqueIndex = (16*32+23)*2
  test.assertEqual(live.depth[holeIndex]|(live.depth[holeIndex+1]<<8),65535,"cached cutout leaves clear depth")
  test.assertEqual(live.depth[opaqueIndex]|(live.depth[opaqueIndex+1]<<8),8192,"cached opaque texel retains its exact depth")
  behind = geometry.mesh()
  geometry.quad(behind,geometry.Point(-0.7,-0.7,0.0),geometry.Point(0.7,-0.7,0.0),geometry.Point(0.7,0.7,0.0),geometry.Point(-0.7,0.7,0.0),0xd02020ff,false)
  geometry.drawAt(live,behind,camera)
  test.assertEqual(live.canvas.getPixel(8,16),0xd02020ff,"later geometry can fill a copied cutout")
  test.assertEqual(live.canvas.getPixel(23,16),0x00ff00ff,"copied opaque depth continues to occlude later geometry")
  test.assertEqual(cached.canvas.getPixel(8,16),0x00000000,"live drawing must not mutate cached color")
  test.assertEqual(cached.depth[holeIndex]|(cached.depth[holeIndex+1]<<8),65535,"live drawing must not mutate cached depth")
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
