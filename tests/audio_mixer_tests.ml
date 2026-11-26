import minipixels.audio.audio as audio
import std.test as test

function pcm(frames, looping)
  value = audio.clip("", "synthetic")
  value.valid = true
  value.channels = 1
  value.bitsPerSample = 16
  value.blockAlign = 2
  value.sampleRate = 44100
  value.frameCount = frames
  value.sampleData = bytes(frames * 2, 0)
  value.looping = looping
  for frame = 0 to frames - 1
    value.sampleData[frame * 2] = 232
    value.sampleData[frame * 2 + 1] = 3
  end for
  return value
end function
function preparedMixer(source, frames)
  value = audio.mixer(1)
  value.bufferFrames = frames
  value.audio.masterVolume = 100
  value.audio.sfxVolume = 100
  value.channels[0].clip = source
  value.channels[0].playing = true
  return value
end function
function signedSample(output, offset)
  value = output[offset] + (output[offset + 1] << 8)
  if value >= 32768 then value = value - 65536 end if
  return value
end function
function fractionalVolume()
  source = pcm(8, false)
  source.volume = 20
  value = preparedMixer(source, 4)
  value.channels[0].volume = 33
  value.channels[0].pan = 17
  output = bytes(16, 0)
  audio.mixBuffer(value, output)
  test.assertEqual(signedSample(output, 0), 54, "fractional voice/clip volume keeps 6.6 percent with left pan attenuation")
  test.assertEqual(signedSample(output, 2), 66, "fractional gain is not reset to full volume")
  test.assertEqual(value.channels[0].cursor, 4, "cursor advances once per output frame")
  audio.mixBuffer(value, output)
  test.assertEqual(value.channels[0].cursor, 8)
  audio.mixBuffer(value, output)
  test.assertFalse(value.channels[0].playing, "completed voices become inactive")
  test.assertEqual(signedSample(output, 0), 0, "finished voices leave silence")
end function
function mutedLifecycle()
  value = preparedMixer(pcm(3, false), 4)
  value.audio.muted = true
  output = bytes(16, 91)
  audio.mixBuffer(value, output)
  test.assertFalse(value.channels[0].playing, "muted nonlooping clips still finish")
  test.assertEqual(value.channels[0].cursor, 3)
  for index = 0 to len(output) - 1
    test.assertEqual(output[index], 0)
  end for
  value = preparedMixer(pcm(3, true), 4)
  value.audio.muted = true
  audio.mixBuffer(value, output)
  test.assertTrue(value.channels[0].playing, "muted looping clips retain playback state")
  test.assertEqual(value.channels[0].cursor, 1, "muted loop wraps its timeline")
  value.audio.muted = false
  audio.mixBuffer(value, output)
  test.assertEqual(value.channels[0].cursor, 2)
  test.assertEqual(signedSample(output, 0), 1000, "unmuted loop resumes at current time")
end function
function streamingResume()
  source = audio.musicClip("build/tests/tone_stereo.mp3", "streaming-oracle")
  test.assertTrue(audio.prepareClip(source))
  source.looping = true
  reference = preparedMixer(source, 512)
  silent = preparedMixer(source, 512)
  reference.channels[0] = audio.openVoiceDecoder(reference.channels[0])
  silent.channels[0] = audio.openVoiceDecoder(silent.channels[0])
  expected = bytes(2048, 0)
  actual = bytes(2048, 0)
  silent.audio.muted = true
  for index = 0 to 9
    audio.mixBuffer(reference, expected)
    audio.mixBuffer(silent, actual)
  end for
  test.assertEqual(silent.channels[0].cursor, reference.channels[0].cursor, "silent streaming follows the same source timeline")
  test.assertEqual(silent.channels[0].streamFrames, -1, "silent streaming defers decoding")
  silent.audio.muted = false
  audio.mixBuffer(reference, expected)
  audio.mixBuffer(silent, actual)
  mismatches = 0
  for index = 0 to len(actual) - 1
    if actual[index] != expected[index] then mismatches = mismatches + 1 end if
  end for
  test.assertEqual(mismatches, 0, "seek-on-unmute resumes the same decoded PCM")
  audio.closeMixer(reference)
  audio.closeMixer(silent)
end function
function main(args)
  suite = test.Suite.new("Batched PCM mixer")
  suite.add("fractional gain and completion", fractionalVolume)
  suite.add("silent voice lifecycle", mutedLifecycle)
  suite.add("streaming cursor and unmute", streamingResume)
  return test.run([suite], args)
end function
