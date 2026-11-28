import minipixels.audio.audio as audio
import std.test as test

function outputTestClip()
  value = audio.clip("", "owned-pcm-fixture")
  value.prepared = true
  value.valid = true
  value.channels = 1
  value.bitsPerSample = 16
  value.blockAlign = 2
  value.sampleRate = 44100
  value.frameCount = 1000
  value.sampleData = bytes(2000, 0)
  value.looping = true
  for frame = 0 to 999
    value.sampleData[frame * 2] = 224
    value.sampleData[frame * 2 + 1] = 46
  end for
  return value
end function

function openOutputTestMixer()
  value = audio.mixer(2)
  value.independentOutput = true
  value.nativeOutput = audio.mpAudioOutputCreate(44100, value.channelCount + 9)
  test.assertNotEqual(value.nativeOutput, 0)
  return value
end function

function outputTestSample(data, frame, side)
  offset = frame * 4 + side * 2
  sample = data[offset] + (data[offset + 1] << 8)
  if sample >= 32768 then sample = sample - 65536 end if
  return sample
end function

function independentManagedBridge()
  mixer = openOutputTestMixer()
  clip = outputTestClip()
  mixer.channels[0].clip = clip
  mixer.channels[0].playing = true
  mixer.channels[0].volume = 50
  mixer.channels[0].pan = -50
  mixer.channels[0].generation = 1
  test.assertTrue(audio.syncIndependentOutput(mixer))
  test.assertEqual(mixer.nativeClipCount, 1)
  data = bytes(1024, 0)
  test.assertEqual(audio.mpAudioOutputRender(mixer.nativeOutput, data, len(data), 256), 1)
  test.assertEqual(outputTestSample(data, 255, 0), 6000, "managed gain snapshot reaches native left PCM")
  test.assertEqual(outputTestSample(data, 255, 1), 3000, "managed pan snapshot reaches native right PCM")
  test.assertTrue(audio.syncIndependentOutput(mixer))
  test.assertEqual(mixer.channels[0].cursor, 256, "native cursor is returned through the actual ABI")
  test.assertEqual(mixer.nativeClipCount, 1, "repeated snapshots reuse one owned PCM allocation")
  mixer.channels[0].generation = 2
  mixer.channels[0].cursor = 0
  test.assertTrue(audio.syncIndependentOutput(mixer))
  test.assertEqual(mixer.channels[0].cursor, 0, "same-source new generation restarts the native voice")
  mixer.close()
  test.assertEqual(mixer.nativeOutput, 0)
  test.assertEqual(mixer.nativeClipCount, 0)
  test.assertFalse(mixer.channels[0].playing)
  mixer.nativeOutput = audio.mpAudioOutputCreate(44100, mixer.channelCount + 9)
  mixer.channels[0].playing = true
  mixer.channels[0].generation = 3
  test.assertTrue(audio.syncIndependentOutput(mixer), "reopening after close uploads the source into the new owner")
  test.assertEqual(mixer.nativeClipCount, 1)
  mixer.close()
end function

function independentMusicPhaseAndMute()
  mixer = openOutputTestMixer()
  clip = outputTestClip()
  mixer.musicChannel.clip = clip
  mixer.musicChannel.playing = true
  mixer.musicChannel.generation = 1
  test.assertTrue(audio.queueMusicLayer(mixer, 0, clip, 0, 0, 0))
  test.assertTrue(audio.queueMusicLayer(mixer, 1, clip, 0, 0, 0))
  mixer.audio.muted = true
  test.assertTrue(audio.syncIndependentOutput(mixer))
  data = bytes(8192, 0)
  test.assertEqual(audio.mpAudioOutputRender(mixer.nativeOutput, data, len(data), 2048), 1)
  test.assertTrue(audio.syncIndependentOutput(mixer))
  test.assertEqual(mixer.musicChannel.cursor, 48)
  test.assertEqual(mixer.musicLayers[0].cursor, 48)
  test.assertEqual(mixer.musicLayers[1].cursor, 48)
  for i = 0 to len(data) - 1
    test.assertEqual(data[i], 0)
  end for
  mixer.audio.muted = false
  test.assertTrue(audio.syncIndependentOutput(mixer))
  test.assertEqual(audio.mpAudioOutputRender(mixer.nativeOutput, data, len(data), 256), 1)
  test.assertEqual(outputTestSample(data, 255, 0), 12000)
  mixer.close()
end function

function independentFailureResetsRegistry()
  mixer = audio.mixer(2)
  mixer.independentOutput = true
  good = outputTestClip()
  invalid = outputTestClip()
  invalid.sampleData = void
  mixer.channels[0].clip = good
  mixer.channels[0].playing = true
  mixer.channels[0].generation = 1
  mixer.channels[1].clip = invalid
  mixer.channels[1].playing = true
  mixer.channels[1].generation = 1
  test.assertFalse(audio.ensureBackend(mixer), "unsupported PCM fails before opening a device")
  test.assertEqual(mixer.nativeOutput, 0)
  test.assertEqual(mixer.nativeClipCount, 0, "a partial upload cannot survive its native owner")
  test.assertFalse(mixer.ready)
  mixer.channels[1].playing = false
  mixer.nativeOutput = audio.mpAudioOutputCreate(44100, mixer.channelCount + 9)
  test.assertTrue(audio.syncIndependentOutput(mixer), "retry registers fresh clips, never stale native IDs")
  test.assertEqual(mixer.nativeClipCount, 1)
  mixer.close()
end function

function main(args)
  suite = test.Suite.new("Independent output managed bridge")
  suite.add("owned PCM, gain, pan, generations and reopen", independentManagedBridge)
  suite.add("atomic ensemble and phase through mute", independentMusicPhaseAndMute)
  suite.add("failed partial startup discards the native registry", independentFailureResetsRegistry)
  return test.run([suite], args)
end function
