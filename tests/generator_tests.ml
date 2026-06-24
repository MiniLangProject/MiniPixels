import minipixels.tools.generator as gen
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

  r2 = gen.generate("examples\\jump-and-run\\minipixels.json", "build\\tests\\native_generated_levels")
  a.assertTrue(r2.ok, "generator writes level stub")
  a.assertTrue(fs.exists("build\\tests\\native_generated_levels\\levels.ml"), "generator level stub exists")
  a.assertTrue(len(r2.warnings) > 0, "generator warns for legacy work")

  print "=== GENERATOR TESTS DONE ==="
  return 0
end function
