import std.test as test
import minipixels as mp
import minipixels.assets.assets as assets
import minipixels.assets.png as png
import minipixels.audio.audio as audio
import minipixels.collision.collision as collision
import minipixels.core.time as timing
import minipixels.graphics.canvas as canvas
import minipixels.graphics.sprite as sprite
import minipixels.input.input as input
import minipixels.math.types as mathTypes
import minipixels.scene.scene as scenes
import minipixels.world.tilemap as tilemap
import std.fs as fs

_lazyLoads = 0
_sceneEvents = ""
_shutdownCalled = false

function lazyAsset()
  global _lazyLoads
  _lazyLoads = _lazyLoads + 1
  return [_lazyLoads]
end function

function sceneEnterA(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "ea;" end function
function sceneExitA(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "xa;" end function
function scenePauseA(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "pa;" end function
function sceneResumeA(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "ra;" end function
function sceneRenderA(game, value, target) global _sceneEvents; _sceneEvents = _sceneEvents + "dra;" end function
function sceneEnterB(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "eb;" end function
function sceneExitB(game, value) global _sceneEvents; _sceneEvents = _sceneEvents + "xb;" end function
function sceneUpdateB(game, value, dt) global _sceneEvents; _sceneEvents = _sceneEvents + "ub;" end function
function sceneRenderB(game, value, target) global _sceneEvents; _sceneEvents = _sceneEvents + "drb;" end function

function failingUpdate(game, dt) return error(9901, "expected update failure") end function
function recordShutdown(game) global _shutdownCalled; _shutdownCalled = true end function

function inputBuffersEdges()
  state = input.create()
  for index = 0 to 24
    test.assertTrue(state.bindKey("custom_" + index, 0x30 + (index % 10)))
  end for
  test.assertTrue(state.actionCapacity >= 32, "custom actions grow storage")
  input.setActionState(state, "dash", true)
  test.assertTrue(state.pressed("dash"), "press is available before a fixed update")
  state.beginUpdate()
  test.assertTrue(state.pressed("dash"), "press reaches the first fixed update")
  state.endUpdate()
  test.assertFalse(state.pressed("dash"), "catch-up updates do not replay a press")
  test.assertTrue(state.isDown("dash"), "held state remains available")
  input.setActionState(state, "dash", false)
  state.beginUpdate()
  test.assertTrue(state.released("dash"), "release reaches the first fixed update")
  state.endUpdate()
  input.setMousePosition(state, 4, 5, true)
  input.setMousePosition(state, 9, 3, true)
  input.addMouseWheel(state, -2)
  state.beginUpdate()
  test.assertEqual(state.mouseDeltaX, 5)
  test.assertEqual(state.mouseDeltaY, -2)
  test.assertEqual(state.mouseWheel, -2)
  state.endUpdate()
  test.assertEqual(state.mouseDeltaX, 0)
  input.addMouseWheel(state, 0.5)
  state.beginUpdate()
  test.assertApproxEqual(state.mouseWheel, 0.5, 0.00001, "fractional wheel deltas are retained")
  state.endUpdate()
end function

function sceneStackRunsLifecycle()
  global _sceneEvents
  _sceneEvents = ""
  stack = scenes.create(1)
  first = scenes.scene("first", void, sceneEnterA, sceneExitA, void, sceneRenderA, scenePauseA, sceneResumeA, false)
  overlay = scenes.scene("overlay", void, sceneEnterB, sceneExitB, sceneUpdateB, sceneRenderB, void, void, true)
  test.assertTrue(stack.register("first", first))
  test.assertTrue(stack.register("overlay", overlay))
  test.assertTrue(scenes.push(stack, "first"))
  test.assertTrue(scenes.push(stack, "overlay"))
  test.assertEqual(stack.stackCount, 2)
  scenes.updateCurrent(stack, void, 1.0 / 60.0)
  scenes.renderStack(stack, void, canvas.create(8, 8))
  test.assertTrue(scenes.pop(stack))
  test.assertTrue(scenes.change(stack, "overlay"))
  test.assertEqual(_sceneEvents, "ea;pa;eb;ub;dra;drb;xb;ra;xa;eb;")
end function

function registriesCacheAndGrow()
  global _lazyLoads
  _lazyLoads = 0
  registry = assets.create(1)
  test.assertTrue(registry.addLazy("lazy", lazyAsset))
  for index = 0 to 20
    test.assertTrue(registry.add("eager_" + index, index))
  end for
  first = registry.get("lazy")
  second = registry.get("lazy")
  test.assertSame(first, second, "lazy asset is cached")
  test.assertEqual(_lazyLoads, 1)
  test.assertTrue(registry.unload("lazy"))
  third = registry.get("lazy")
  test.assertNotEqual(first, third)
  test.assertEqual(_lazyLoads, 2)
end function

function sweptTilesAndExactSegments()
  image = sprite.solidImage(10, 10, mathTypes.rgba(255, 255, 255, 255), "tile")
  sheet = sprite.cacheFrames(sprite.spriteSheet(image, 10, 10, 0, 0))
  map = tilemap.create(10, 10, 10, 3, tilemap.Tileset(sheet), 1)
  solid = array(30, 0)
  solid[15] = 1
  test.assertTrue(map.addLayer(tilemap.layer("solid", 10, 3, solid, true, true, 1, 1)))
  for index = 0 to 4
    test.assertTrue(map.addLayer(tilemap.layer("extra_" + index, 10, 3, array(30, 0), false, false, 1, 1)))
  end for
  moved = tilemap.moveAndCollide(map, mathTypes.RectangleInt(10, 10, 8, 8), 80, 0)
  test.assertTrue(moved.hitRight, "swept collision detects crossed tiles")
  test.assertEqual(moved.x, 42)
  falling = tilemap.moveAndCollide(map, mathTypes.RectangleInt(50, 0, 8, 8), 0, 25)
  test.assertTrue(falling.hitBottom)
  test.assertEqual(falling.y, 2)
  target = mathTypes.RectangleInt(0, 8, 2, 2)
  test.assertFalse(collision.lineRect(0, 0, 10, 10, target), "segment broad phase is not a false hit")
  test.assertTrue(collision.lineRect(0, 0, 10, 10, mathTypes.RectangleInt(4, 4, 2, 2)))
end function

function renderTargetsRotationAndDirtyRegions()
  source = canvas.create(3, 2)
  source.clear(mathTypes.rgba(20, 40, 60, 255))
  destination = canvas.create(10, 10)
  destination.clear(mathTypes.rgba(0, 0, 0, 255))
  canvas.drawCanvas(destination, source, 2, 3)
  test.assertEqual(destination.getPixel(2, 3), mathTypes.rgba(20, 40, 60, 255))
  canvas.resetDirty(destination)
  destination.fillRect(4, 5, 2, 3, mathTypes.rgba(1, 2, 3, 255))
  test.assertTrue(destination.dirty)
  test.assertEqual([destination.dirtyX0, destination.dirtyY0, destination.dirtyX1, destination.dirtyY1], [4, 5, 6, 8])
  pixels = bytes(8, 0)
  pixels[0] = 255
  pixels[3] = 255
  pixels[6] = 255
  pixels[7] = 255
  image = sprite.newImage(2, 1, pixels, "rotation")
  destination.clear(mathTypes.rgba(0, 0, 0, 255))
  canvas.drawSpriteRotated(destination, sprite.spriteFromImage(image, "rotation"), 5, 4, 1.5707963267948966, 1, mathTypes.rgba(255, 255, 255, 255))
  colored = 0
  for y = 0 to destination.height - 1
    for x = 0 to destination.width - 1
      if destination.getPixel(x, y) != mathTypes.rgba(0, 0, 0, 255) then colored = colored + 1 end if
    end for
  end for
  test.assertEqual(colored, 2, "rotated sprite retains both source pixels")
end function

function modernPngProfilesRoundTrip()
  dynamicImage = png.load("build\\tests\\png\\dynamic_filters.png")
  test.assertType(dynamicImage, "struct")
  test.assertEqual(dynamicImage.getPixel(63, 31), mathTypes.rgba(53, 19, 4, 105))
  fixedImage = png.load("build\\tests\\png\\fixed_filters.png")
  test.assertEqual(fixedImage.getPixel(3, 4), mathTypes.rgba(132, 175, 210, 225))
  indexedImage = png.load("build\\tests\\png\\indexed.png")
  test.assertEqual(indexedImage.getPixel(0, 0), mathTypes.rgba(255, 0, 0, 255))
  test.assertEqual(indexedImage.getPixel(2, 0), mathTypes.rgba(0, 0, 255, 128))
  test.assertEqual(indexedImage.getPixel(3, 0), mathTypes.rgba(255, 255, 0, 0))
  corrupted = fs.readAllBytes("build\\tests\\png\\dynamic_filters.png")
  corrupted[16] = corrupted[16] ^ 1
  corruptResult = try(png.decode(corrupted, "corrupted"))
  test.assertType(corruptResult, "error", "PNG chunk CRC is verified")
  target = canvas.create(2, 2)
  target.clear(mathTypes.rgba(12, 34, 56, 255))
  test.assertTrue(mp.saveCanvasPng(target, "build\\tests\\roundtrip.png"))
  roundTrip = mp.loadPng("build\\tests\\roundtrip.png")
  test.assertEqual(roundTrip.getPixel(1, 1), mathTypes.rgba(12, 34, 56, 255))
end function

function pcmMixerPreparesAndMixes()
  clip = audio.clip("build\\tests\\tone_valid.wav", "tone")
  test.assertTrue(audio.prepareClip(clip))
  test.assertEqual(clip.sampleRate, 22050)
  test.assertEqual(clip.channels, 1)
  test.assertEqual(clip.bitsPerSample, 16)
  malformed = fs.readAllBytes("build\\tests\\tone_valid.wav")
  malformed[32] = 1
  malformed[33] = 0
  test.assertFalse(audio.prepareClip(audio.clipFromBytes(malformed, "malformed")), "invalid PCM block alignment is rejected")
  mixer = audio.mixer(2)
  voice = mixer.channels[0]
  voice.clip = clip
  voice.playing = true
  voice.cursor = 0.0
  mixer.channels[0] = voice
  output = bytes(mixer.bufferFrames * 4, 0)
  audio.mixBuffer(mixer, output)
  test.assertFalse(mixer.channels[0].playing, "finite voice ends after its samples")
  nonzero = false
  for index = 0 to 63
    if output[index] != 0 then nonzero = true end if
  end for
  test.assertTrue(nonzero, "PCM samples reach the mixed output")
  test.assertTrue(mixer.setChannel(0, 150, -200))
  test.assertEqual(mixer.channels[0].volume, 100)
  test.assertEqual(mixer.channels[0].pan, -100)
end function

function compilerOptimizedMathAndTiming()
  vector = mathTypes.Vector2(3.0, 4.0)
  test.assertApproxEqual(mathTypes.vector2Length(vector), 5.0, 0.00001)
  sum = vector + mathTypes.Vector2(2.0, -1.0)
  scaled = sum * 2.0
  test.assertEqual([scaled.x, scaled.y], [10.0, 6.0])
  clock = timing.create(60)
  timing.beginFrame(clock, 0.5)
  timing.countUpdate(clock)
  timing.finishFrame(clock, 2.0)
  test.assertEqual(clock.alpha, 1)
  test.assertEqual(clock.fps, 2)
  test.assertEqual(clock.ups, 2)
end function

function gameLoopCleansUpAfterCallbackErrors()
  global _shutdownCalled
  _shutdownCalled = false
  config = mp.createConfig("failure", 8, 8, 1)
  config.headlessFrames = 2
  result = try(mp.runHeadless(config, void, failingUpdate, void, recordShutdown))
  test.assertType(result, "error")
  test.assertEqual(result.code, 9901)
  test.assertTrue(_shutdownCalled, "shutdown runs after callback errors")
end function

function main(args)
  suite = test.Suite.new("MiniPixels foundation")
  suite.add("input buffering and configurable actions", inputBuffersEdges)
  suite.add("scene stack lifecycle", sceneStackRunsLifecycle)
  suite.add("asset registry caching", registriesCacheAndGrow)
  suite.add("swept tiles and exact segment collision", sweptTilesAndExactSegments)
  suite.add("render targets, rotation, and dirty regions", renderTargetsRotationAndDirtyRegions)
  suite.add("modern PNG decoding and encoding", modernPngProfilesRoundTrip)
  suite.add("PCM mixer", pcmMixerPreparesAndMixes)
  suite.add("MiniLang 1.2.4 math and timing", compilerOptimizedMathAndTiming)
  suite.add("game loop error cleanup", gameLoopCleansUpAfterCallbackErrors)
  return test.run([suite], args)
end function
