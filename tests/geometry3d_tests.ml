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
  worldSpaceLightingRespondsToSources()
  geometryShadowMapMovesWithOccluder()
  movingMeshShadowsDoNotAccumulate()
  repeatingMaterialsPreserveWorldUv()
  fixedPoseLightingCacheMatchesLive()
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

function fixedPoseLightingCacheMatchesLive()
  camera=geometry.camera(32.0,32.0,45.0,0.0,0.0,0.0,1.0,0.2,3.0,true)
  lights=geometry.lighting()
  geometry.addPointLight(lights,0.3,-0.2,0.4,0xff9944ff,1.0,1.0)
  source=geometry.mesh()
  geometry.box(source,0.0,0.0,0.0,0.3,0.2,0.2,0xb7a080ff)
  live=geometry.surface(cv.create(64,64)); cached=geometry.surface(cv.create(64,64))
  geometry.clear(live,0x161d20ff); geometry.clear(cached,0x161d20ff)
  geometry.drawLitAt(live,source,camera,lights,0.03,0.04,0.02,0.2,1.0,1.0,1.0,0.30,48)
  pose=geometry.bakeLitMesh(source,camera,lights,0.03,0.04,0.02,0.2,1.0,1.0,1.0,0.30,48)
  geometry.drawAt(cached,pose,camera)
  test.assertEqual(live.canvas.pixels,cached.canvas.pixels,"fixed pose cache preserves exact lit framebuffer pixels")
  test.assertEqual(live.depth,cached.depth,"fixed pose cache preserves exact world-space depth")
end function

function repeatingMaterialsPreserveWorldUv()
  source=imageFromColors(2,2,[0x503020ff,0xc0b0a0ff,0x203050ff,0x90a0b0ff])
  material=geometry.repeatingTexture(source,0xffffffff,1,true)
  first=geometry.sampleTexture(material,0.25,0.75)
  test.assertEqual(geometry.sampleTexture(material,1.25,-0.25),first,"world UV repeats support positive and negative coordinates")
  legacy=geometry.texture(source,0xffffffff,1,true)
  test.assertEqual(geometry.sampleTexture(legacy,2.0,0.0),0xc0b0a0ff,"ordinary art textures retain their clamped UV contract")
  camera=geometry.camera(16.0,16.0,20.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  target=geometry.surface(cv.create(32,32)); mesh=geometry.mesh()
  test.assertTrue(geometry.texturedQuad(mesh,geometry.Point(-0.6,-0.6,0.0),geometry.Point(0.6,-0.6,0.0),geometry.Point(0.6,0.6,0.0),geometry.Point(-0.6,0.6,0.0),material,void,true),"repeating material uses real textured geometry")
  geometry.clear(target,0x000000ff)
  geometry.drawLitAt(target,mesh,camera,geometry.lighting(0.0,0.0,1.0))
  test.assertTrue(target.canvas.getPixel(16,16) != 0x000000ff,"tiled material passes through the illuminated textured raster path")
end function

function worldSpaceLightingRespondsToSources()
  camera=geometry.camera(32.0,32.0,40.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  surface=geometry.surface(cv.create(64,64))
  mesh=geometry.mesh(1)
  geometry.quad(mesh,geometry.Point(-0.6,-0.6,0.0),geometry.Point(0.6,-0.6,0.0),geometry.Point(0.6,0.6,0.0),geometry.Point(-0.6,0.6,0.0),0x909090ff,true)
  oldColor=mesh.triangles[0].color
  lights=geometry.lighting(0.0,0.0,1.0,0x202020ff,0xffffffff,0.8)
  geometry.clear(surface,0x000000ff)
  geometry.drawLitAt(surface,mesh,camera,lights)
  bright=surface.canvas.getPixel(32,32)
  lights.z=-1.0
  geometry.clear(surface,0x000000ff)
  geometry.drawLitAt(surface,mesh,camera,lights)
  dark=surface.canvas.getPixel(32,32)
  test.assertTrue(((bright>>24)&255) > ((dark>>24)&255)+60,"world-space directional light follows its actual direction")
  geometry.addPointLight(lights,0.0,0.0,0.12,0xff3010ff,2.0,1.0)
  geometry.clear(surface,0x000000ff)
  geometry.drawLitAt(surface,mesh,camera,lights)
  warm=surface.canvas.getPixel(32,32)
  test.assertTrue(((warm>>24)&255) > ((warm>>8)&255)+40,"finite point light casts its actual RGB color")
  lights.points[0].x=5.0
  geometry.clear(surface,0x000000ff)
  geometry.drawLitAt(surface,mesh,camera,lights)
  test.assertEqual(surface.canvas.getPixel(32,32),dark,"point light contributes nothing outside its finite range")
  test.assertEqual(mesh.triangles[0].color,oldColor,"relighting leaves cached source mesh immutable")
  test.assertEqual(len(mesh.albedo),mesh.capacity,"mesh growth retains the albedo and lighting metadata")
end function

function geometryShadowMapMovesWithOccluder()
  lightCamera=geometry.camera(64.0,64.0,150.0,0.0,0.0,0.0,1.0,1.5707963267948966,3.0,false)
  shadow=geometry.surface(cv.create(128,128))
  floor=geometry.mesh(); caster=geometry.mesh()
  geometry.quad(floor,geometry.Point(-0.4,-0.4,0.0),geometry.Point(0.4,-0.4,0.0),geometry.Point(0.4,0.4,0.0),geometry.Point(-0.4,0.4,0.0),0xc0c0c0ff,false)
  geometry.box(caster,0.0,0.0,0.0,0.10,0.10,0.20,0xffffffff)
  geometry.clear(shadow,0x000000ff)
  geometry.drawDepthAt(shadow,floor,lightCamera)
  geometry.drawDepthAt(shadow,caster,lightCamera)
  test.assertTrue(geometry.shadowVisibility(shadow,lightCamera,0.12,0.0,0.001) < 0.5,"raised occluder shades a geometrically displaced floor point")
  test.assertTrue(geometry.shadowVisibility(shadow,lightCamera,-0.15,0.0,0.001) > 0.9,"the source-facing floor remains illuminated")
  lights=geometry.lighting(-0.54,0.0,0.84,0x202020ff,0xffffffff,0.9)
  lights.shadow=shadow; lights.shadowCamera=lightCamera
  occluded=geometry.illuminate(0xffffffff,0.0,0.0,1.0,0.12,0.0,0.001,lightCamera,lights)
  visible=geometry.illuminate(0xffffffff,0.0,0.0,1.0,-0.15,0.0,0.001,lightCamera,lights)
  test.assertTrue(((visible>>24)&255) > ((occluded>>24)&255)+100,"moving lit geometry receives the same real static occlusion")
  view=geometry.camera(64.0,64.0,150.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  receiver=geometry.surface(cv.create(128,128))
  geometry.clear(receiver,0x101010ff)
  geometry.drawAt(receiver,floor,view)
  before=receiver.canvas.getPixel(82,64)
  geometry.applyShadowMap(receiver,view,shadow,lightCamera,0.60)
  test.assertTrue(((receiver.canvas.getPixel(82,64)>>24)&255) < ((before>>24)&255)-50,"receiver pixels reconstruct world positions for depth-tested occlusion")
  geometry.clear(shadow,0x000000ff)
  geometry.drawDepthAt(shadow,floor,lightCamera)
  geometry.drawDepthAt(shadow,caster,lightCamera,-0.30,0.0,0.0)
  test.assertTrue(geometry.shadowVisibility(shadow,lightCamera,0.12,0.0,0.001) > 0.9,"moving the real caster removes its old shadow")
end function

function movingMeshShadowsDoNotAccumulate()
  camera=geometry.camera(32.0,32.0,70.0,0.0,0.0,0.0,1.5707963267948966,0.0,3.0,false)
  receiver=geometry.surface(cv.create(64,64)); floor=geometry.mesh(); caster=geometry.mesh()
  geometry.quad(floor,geometry.Point(-0.5,-0.5,0.0),geometry.Point(0.5,-0.5,0.0),geometry.Point(0.5,0.5,0.0),geometry.Point(-0.5,0.5,0.0),0xc0c0c0ff,false)
  geometry.box(caster,0.0,0.0,0.10,0.20,0.20,0.10,0xffffffff)
  geometry.clear(receiver,0x000000ff); geometry.drawAt(receiver,floor,camera)
  mask=geometry.shadowMask(receiver); light=geometry.lighting(0.0,0.0,1.0)
  depth=receiver.depth[4160]|(receiver.depth[4161]<<8)
  geometry.drawPlanarShadowAt(receiver,caster,camera,light,mask,0.001)
  once=receiver.canvas.getPixel(32,32)
  test.assertTrue(((once>>24)&255) < 140,"actual moving mesh silhouette shades its receiver")
  geometry.drawPlanarShadowAt(receiver,caster,camera,light,mask,0.001)
  test.assertEqual(receiver.canvas.getPixel(32,32),once,"overlapping triangles and casters do not multiply darkness")
  test.assertEqual(receiver.depth[4160]|(receiver.depth[4161]<<8),depth,"shadow overlay leaves receiver depth intact")
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
