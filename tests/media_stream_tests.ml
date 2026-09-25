import minipixels as mp
import minipixels.media.media as packedMedia
import minipixels.assets.pack as packs
import std.assert as a

function main(args)
  pack = mp.openAssetPack("build/tests/assets.mpx")
  a.assertTrue(typeof(pack) != "error", "media fixture pack opens")
  slot = mp.assetSlotFromPack(pack, "tone_mp3")
  info = packs.streamInfoAt(pack, slot)
  a.assertTrue(typeof(info) != "error", "audio exposes stream metadata")
  source = packedMedia._openSource(info, "audio/mpeg", ".mp3")
  a.assertTrue(typeof(source) != "error", "native MPX range source opens")
  a.assertTrue(len(source.url) > 20, "range source returns a local URL")
  a.assertTrue(source.close(), "range source closes")
  audio = packedMedia.openAudioAt(pack, slot, "audio/mpeg", ".mp3")
  a.assertTrue(typeof(audio) != "error", "std.audio opens the MPX range stream")
  a.assertTrue(audio.close(), "packed audio player closes")
  videoSlot = mp.assetSlotFromPack(pack, "intro")
  video = packedMedia.openVideoAt(pack, videoSlot, "video/mp4", ".mp4")
  a.assertTrue(typeof(video) != "error", "std.video opens the MPX range stream")
  a.assertTrue(video.close(), "packed video player closes")
  a.assertTrue(mp.closeAssetPack(pack), "media fixture pack closes")
  print "=== MEDIA STREAM TESTS DONE ==="
  return 0
end function
