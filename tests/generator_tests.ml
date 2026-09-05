import minipixels.tools.generator as gen
import minipixels.assets.pack as assetPack
import std.assert as a
import std.fs as fs

function main(args)
  outDir = "build\\tests\\native_generated"
  r = gen.generate("examples\\pixel-effects\\minipixels.json", outDir)
  a.assertTrue(r.ok, "generator succeeds for empty assets")
  a.assertTrue(fs.exists(outDir + "\\assets.ml"), "generator writes assets module")
  text = fs.readAllText(outDir + "\\assets.ml")
  a.assertTrue(typeof(text) == "string", "generated assets readable")
  a.assertTrue(stringIndexOf(text, "function registry", 0) >= 0, "generated assets registry")

  r2 = gen.generate("examples\\jump-and-run\\minipixels.json", "build\\tests\\native_generated_levels\\generated")
  a.assertTrue(r2.ok, "generator writes concrete levels")
  a.assertTrue(fs.exists("build\\tests\\native_generated_levels\\generated\\levels.ml"), "generator level module exists")
  a.assertEq(len(r2.warnings), 0, "native generation no longer needs legacy warnings")
  a.assertTrue(fs.exists("examples\\jump-and-run\\build\\assets.mpx"), "native generator writes asset pack")
  packed = assetPack.open("examples\\jump-and-run\\build\\assets.mpx")
  a.assertTrue(typeof(packed) != "error", "native asset pack opens")
  a.assertEq(assetPack.getKind(packed, "player"), 1, "native pack stores images")
  a.assertEq(assetPack.getKind(packed, "coin_sfx"), 2, "native pack stores audio")
  levels = fs.readAllText("build\\tests\\native_generated_levels\\generated\\levels.ml")
  a.assertTrue(stringIndexOf(levels, "return 3", 0) >= 0, "generator level count")
  a.assertTrue(stringIndexOf(levels, "fillPlatform(data, w, 0, 7, 92, 8, 9, 10, 11)", 0) >= 0, "generator level platforms")
  a.assertTrue(stringIndexOf(levels, "function enemyMaxX", 0) >= 0, "generator enemy accessors")
  a.assertTrue(stringIndexOf(levels, "function enemyKind", 0) >= 0, "generator enemy kind accessor")
  assets = fs.readAllText("build\\tests\\native_generated_levels\\generated\\assets.ml")
  a.assertTrue(stringIndexOf(assets, "function make_player", 0) >= 0, "generator asset maker")
  a.assertTrue(stringIndexOf(assets, "function sheet_player", 0) >= 0, "generator sheet maker")
  a.assertTrue(stringIndexOf(assets, "function audio_coin_sfx", 0) >= 0, "generator audio helper")

  r3 = gen.generate("examples\\tiled-platformer\\minipixels.json", "build\\tests\\native_generated_procedural\\generated")
  a.assertTrue(r3.ok, "generator supports procedural manifest")
  procedural = fs.readAllText("build\\tests\\native_generated_procedural\\generated\\assets.ml")
  a.assertTrue(stringIndexOf(procedural, "function make_tiles", 0) >= 0, "generator procedural tiles")
  a.assertTrue(stringIndexOf(procedural, "\"tiles\"", 0) >= 0, "generator procedural kind")
  a.assertTrue(stringIndexOf(procedural, "proceduralPixels", 0) < 0, "procedural images load from the pack")
  tiledLevels = fs.readAllText("build\\tests\\native_generated_procedural\\generated\\levels.ml")
  a.assertTrue(stringIndexOf(tiledLevels, "return 30", 0) >= 0, "native Tiled map width")
  a.assertTrue(stringIndexOf(tiledLevels, "return 858", 0) >= 0, "native Tiled exit object")
  a.assertTrue(stringIndexOf(tiledLevels, "function coinX", 0) >= 0, "native Tiled object accessors")

  print "=== GENERATOR TESTS DONE ==="
  return 0
end function
