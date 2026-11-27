import minipixels.audio.audio as audio
import std.test as test

function pcm(level, frames, looping)
  source = audio.clip("", "layer-" + level)
  source.prepared = true
  source.valid = true
  source.channels = 1
  source.bitsPerSample = 16
  source.blockAlign = 2
  source.sampleRate = 44100
  source.frameCount = frames
  source.sampleData = bytes(frames * 2, 0)
  source.looping = looping
  for frame = 0 to frames - 1
    source.sampleData[frame * 2] = level & 255
    source.sampleData[frame * 2 + 1] = (level >> 8) & 255
  end for
  return source
end function

function firstSample(data, side = 0)
  offset = side * 2
  value = data[offset] + (data[offset + 1] << 8)
  if value >= 32768 then value = value - 65536 end if
  return value
end function

function musicBusAndVoiceIsolation()
  mixer = audio.mixer(1)
  mixer.bufferFrames = 4
  mixer.audio.masterVolume = 100
  mixer.audio.musicVolume = 50
  mixer.audio.sfxVolume = 0
  test.assertTrue(mixer.queueMusicLayer(0, pcm(2000, 8, true), 100, 0, 0))
  test.assertTrue(mixer.queueMusicLayer(1, pcm(1000, 8, true), 50, -100, 0))
  mixer.channels[0].clip = pcm(30000, 8, true)
  mixer.channels[0].playing = true
  output = bytes(16, 0)
  audio.mixBuffer(mixer, output)
  test.assertEqual(firstSample(output), 1250, "music layers use the music bus while the effects bus is silent")
  test.assertEqual(firstSample(output, 1), 1000, "independent layer pan is preserved")
  test.assertEqual(audio.chooseChannel(mixer), 0, "effect overload chooses only an effect voice")
  test.assertTrue(mixer.musicLayers[0].playing)
  test.assertEqual(mixer.musicLayers[0].clip.name, "layer-2000")
  mixer.audio.sfxVolume = 100
  mixer.audio.musicVolume = 0
  audio.mixBuffer(mixer, output)
  test.assertEqual(firstSample(output), 30000, "muting music does not mute effects")
  test.assertFalse(mixer.ready, "queueing/mixing an ensemble never opens hardware")
  mixer.close()
end function

function phaseAndSilentProgression()
  mixer = audio.mixer(1)
  mixer.bufferFrames = 5
  mixer.audio.masterVolume = 100
  mixer.audio.musicVolume = 100
  test.assertTrue(mixer.queueMusicLayer(0, pcm(1000, 8, true), 100, 0, 6.0))
  test.assertTrue(mixer.queueMusicLayer(1, pcm(2000, 8, true), 0, 0, 6.0))
  output = bytes(20, 0)
  audio.mixBuffer(mixer, output)
  test.assertEqual(mixer.musicLayers[0].cursor, 3)
  test.assertEqual(mixer.musicLayers[1].cursor, 3, "zero-volume stems wrap with the audible stem")
  mixer.audio.muted = true
  audio.mixBuffer(mixer, output)
  test.assertEqual(firstSample(output), 0)
  test.assertEqual(mixer.musicLayers[0].cursor, mixer.musicLayers[1].cursor)
  mixer.audio.muted = false
  mixer.musicLayers[1].volume = 100
  audio.mixBuffer(mixer, output)
  test.assertEqual(firstSample(output), 3000, "fading a layer back in keeps the shared phase")
  test.assertEqual(mixer.musicLayers[0].cursor, mixer.musicLayers[1].cursor)
  mixer.close()
end function

function boundsAndLifecycle()
  mixer = audio.mixer(1)
  source = pcm(1000, 8, true)
  test.assertFalse(audio.queueMusicLayer(mixer, -1, source))
  test.assertFalse(audio.queueMusicLayer(mixer, 8, source))
  test.assertFalse(audio.queueMusicLayer(mixer, 0.5, source))
  test.assertFalse(mixer.queueMusicLayer(0, source, 100, 0, -1))
  test.assertFalse(mixer.queueMusicLayer(0, source, 100, 0, "bad"))
  test.assertTrue(mixer.queueMusicLayer(0, source, 100, 0, 17))
  test.assertEqual(mixer.musicLayers[0].cursor, 1, "initial phase is bounded by the source loop")
  test.assertFalse(audio.queueMusicLayer(mixer, 0, audio.clip("missing.wav", "bad")))
  test.assertTrue(mixer.musicLayers[0].playing, "invalid replacement leaves the existing layer running")
  test.assertTrue(mixer.stopMusicLayer(0))
  test.assertFalse(mixer.musicLayers[0].playing)
  test.assertEqual(mixer.musicLayers[0].cursor, 0)
  test.assertTrue(audio.queueMusicLayer(mixer, 0, source))
  test.assertTrue(audio.queueMusicLayer(mixer, 1, source))
  mixer.stopAll()
  test.assertFalse(mixer.musicLayers[0].playing)
  test.assertFalse(mixer.musicLayers[1].playing)
  test.assertTrue(audio.queueMusicLayer(mixer, 0, source))
  mixer.close()
  test.assertFalse(mixer.musicLayers[0].playing, "closing a software-only mixer releases layers too")
end function

function main(args)
  suite = test.Suite.new("Independent phase-aligned music layers")
  suite.add("music bus, pan and effect voice isolation", musicBusAndVoiceIsolation)
  suite.add("loop phase through zero volume and mute", phaseAndSilentProgression)
  suite.add("bounds, invalid replacement and lifecycle", boundsAndLifecycle)
  return test.run([suite], args)
end function
