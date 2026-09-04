import minipixels as mp
import std.assert as a

function main(args)
  pack = mp.openAssetPack("build\\tests\\assets.mpx")
  a.assertTrue(typeof(pack) != "error", "asset pack opens")
  img = mp.loadPngFromPack(pack, "hero")
  a.assertTrue(typeof(img) != "error", "packed png decodes")
  a.assertEq(img.width, 2, "packed png width")
  a.assertEq(img.height, 1, "packed png height")
  a.assertEq(img.getPixel(0, 0), mp.rgba(255, 0, 0, 255), "packed png first pixel")
  a.assertEq(img.getPixel(1, 0), mp.rgba(0, 0, 255, 255), "packed png second pixel")
  large = mp.loadPngFromPack(pack, "large")
  a.assertTrue(typeof(large) != "error", "multi-block packed png decodes")
  a.assertEq(large.width, 129, "multi-block packed png width")
  a.assertEq(large.getPixel(128, 127), mp.rgba(17, 34, 51, 255), "multi-block packed png last pixel")
  generated = mp.loadPngFromPack(pack, "generated")
  a.assertTrue(typeof(generated) != "error", "procedural packed png decodes")
  a.assertEq(generated.width, 4, "procedural packed png width")
  a.assertEq(generated.getPixel(0, 0), mp.rgba(255, 128, 0, 255), "procedural packed png first pixel")
  tone = mp.loadBytesFromPack(pack, "tone")
  a.assertTrue(typeof(tone) == "bytes", "packed audio bytes load")
  a.assertEq(len(tone), 8, "packed audio byte length")
  a.assertEq(tone[0], 82, "packed audio first byte")
  a.assertEq(mp.assetKindFromPack(pack, "tone"), 2, "packed audio kind")
  print "=== ASSET PACK TESTS DONE ==="
end function
