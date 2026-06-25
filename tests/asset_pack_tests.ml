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
  print "=== ASSET PACK TESTS DONE ==="
end function
