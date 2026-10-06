import minipixels.audio.audio as audio
import std.assert as a
extern function configure(mode as i32) from "libasound.so.2" symbol "mpTestConfigure" returns void
extern function tick() from "libasound.so.2" symbol "mpTestTick" returns void
extern function total() from "libasound.so.2" symbol "mpTestTotal" returns u64
extern function pointerOK() from "libasound.so.2" symbol "mpTestPointerOK" returns i32
extern function calls() from "libasound.so.2" symbol "mpTestCalls" returns i32

function fakeMixer()
  mixer = audio.mixer(1)
  mixer.ready = true
  mixer.handle = 1
  mixer.buffers[0] = bytes(mixer.bufferFrames * 4, 0)
  return mixer
end function

function main(args)
  configure(0)
  mixer = fakeMixer()
  for frame = 0 to 29
    tick()
    before = calls()
    audio.updateMixer(mixer)
    a.assertTrue(calls() - before <= mixer.bufferCount * 2, "refill work is bounded")
  end for
  a.assertEq(total(), 44032, "30 FPS feeds every complete available period")
  audio.closeMixer(mixer)
  for mode = 1 to 3
    configure(mode)
    mixer = fakeMixer()
    audio.updateMixer(mixer)
    a.assertTrue(mixer.pendingFrames > 0, "unwritten PCM retained")
    if mode == 1 then
      a.assertEq(mixer.pendingFrames, 767, "partial write retains remainder")
      a.assertEq(mixer.pendingOffset, 257, "partial write advances output offset")
    end if
    audio.updateMixer(mixer)
    a.assertEq(total(), 1024, "retry writes each sample exactly once")
    a.assertEq(mixer.pendingFrames, 0, "retry drains pending PCM")
    a.assertEq(pointerOK(), 1, "partial write resumes at correct byte offset")
    audio.closeMixer(mixer)
  end for
  configure(1)
  mixer = fakeMixer()
  audio.updateMixer(mixer)
  audio.mixerStopAll(mixer)
  a.assertEq(mixer.pendingFrames, 0, "stop discards pending PCM")
  audio.closeMixer(mixer)
  print "ALSA_MIXER_TESTS_DONE"
  return 0
end function
