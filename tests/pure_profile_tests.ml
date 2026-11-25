// Run via pure_profile_tests.py; all binary fixtures are generated there.
#option MINIPIXELS_PURE: bool = false
#if not MINIPIXELS_PURE
#error "pure_profile_tests requires -DMINIPIXELS_PURE=true"
#endif
import minipixels as mp
import minipixels.assets.png as png
import minipixels.assets.pack as pack
import minipixels.assets.packed_image as prepared
import minipixels.audio.audio as audio
import minipixels.graphics.gpu as gpu
import minipixels.graphics.scene3d as scene3d
import minipixels.media.media as media
import std.fs as fs
import std.string as strings

function expect(condition, message)
  if not condition then return error(1, message) end if
end function

function equalBytes(actual, expected, message)
  expect(len(actual) == len(expected), message + " length")
  for i = 0 to len(actual) - 1
    expect(actual[i] == expected[i], message + " byte " + str(i))
  end for
end function

function unsupported(value, message)
  expect(typeof(value) == "error", message + " must fail")
  expect(strings.contains(value.message, "MINIPIXELS_PURE"), message + " must name the profile")
end function

function run(directory)
  expected = fs.readAllBytes(directory + "/expected.bin")
  names = ["stored.zlib", "fixed.zlib", "dynamic.zlib"]
  for i = 0 to len(names) - 1
    compressed = fs.readAllBytes(directory + "/" + names[i])
    decoded = png.inflateZlib(compressed, len(expected))
    equalBytes(decoded, expected, names[i])
    compressed[len(compressed) - 1] = compressed[len(compressed) - 1] ^ 1
    expect(typeof(try(png.inflateZlib(compressed, len(expected)))) == "error", "checksum corruption rejected")
  end for
  expectedPixels = fs.readAllBytes(directory + "/pixels.bin")
  image = png.decode(fs.readAllBytes(directory + "/image.png"), "synthetic")
  expect(image.width == 3 and image.height == 2, "PNG dimensions")
  equalBytes(image.pixels, expectedPixels, "pure PNG decode")
  packed = prepared.encode(3, 2, expectedPixels)
  restored = prepared.decode(packed, "synthetic")
  equalBytes(restored.pixels, expectedPixels, "prepared MRI1")
  equalBytes(pack._decodePayloadRange(0, expected, 0, len(expected), len(expected)), expected, "uncompressed MPX payload")
  wav = audio.clipFromBytes(fs.readAllBytes(directory + "/pcm.wav"), "synthetic")
  expect(audio.prepareClip(wav), "PCM WAV is supported")
  expect(wav.valid and wav.channels == 1 and wav.bitsPerSample == 8 and wav.frameCount == 4, "PCM WAV metadata")
  mp3 = audio.clipFromBytes(fs.readAllBytes(directory + "/probe.mp3"), "unsupported")
  expect(not audio.supportsMp3(), "MP3 capability is false")
  unsupported(try(audio.prepareClip(mp3)), "MP3")
  lz4 = fs.readAllBytes(directory + "/probe.lz4")
  unsupported(try(pack._decodePayloadRange(3, lz4, 0, len(lz4), 4)), "LZ4")
  expect(not gpu.supported(), "GPU scene capability is false")
  unsupported(try(gpu.create(void, 16, 16, false)), "GPU scene creation")
  expect(not scene3d.begin(0, 0, 1, 0, 0), "3D scene capability is false")
  unsupported(try(media.openAudioAt(void, 0)), "streamed audio")
  unsupported(try(media.openVideoAt(void, 0)), "streamed video")
  print "Pure MiniLang profile: PNG/Deflate/MRI1/MPX/PCM passed; unsupported features rejected."
end function

function main(args)
  if len(args) != 1 then print "Expected generated fixture directory"; return 2 end if
  result = try(run(args[0]))
  if typeof(result) == "error" then print result.message; return 1 end if
  return 0
end function
