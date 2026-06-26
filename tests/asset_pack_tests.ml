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
  tone = mp.loadBytesFromPack(pack, "tone")
  a.assertTrue(typeof(tone) == "bytes", "packed audio bytes load")
  a.assertEq(len(tone), 8, "packed audio byte length")
  a.assertEq(tone[0], 82, "packed audio first byte")
  a.assertEq(mp.assetKindFromPack(pack, "tone"), 2, "packed audio kind")
  print "=== ASSET PACK TESTS DONE ==="
end function
