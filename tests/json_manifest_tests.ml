import minipixels.tools.json as json
import minipixels.tools.manifest as mani
import std.assert as a

function main(args)
  doc = json.parse("{\"name\":\"demo\",\"n\":12,\"flag\":true,\"items\":[1,\"two\",null]}")
  a.assertEq(doc.kind, "object", "json object parses")
  a.assertEq(json.asString(json.get(doc, "name"), ""), "demo", "json string field")
  a.assertEq(json.asNumber(json.get(doc, "n"), 0), 12, "json number field")
  a.assertTrue(json.asBool(json.get(doc, "flag"), false), "json bool field")
  items = json.get(doc, "items")
  a.assertEq(json.lenOf(items), 3, "json array length")
  a.assertEq(json.at(items, 1).stringValue, "two", "json array item")

  bad = try(json.parse("{\"x\": [1,]}"))
  a.assertEq(typeof(bad), "error", "json syntax error returns error")

  m = mani.load("examples\\moving-sprite\\minipixels.json")
  a.assertTrue(mani.isValid(m), "moving-sprite manifest valid")
  a.assertEq(m.name, "moving-sprite", "manifest name")
  a.assertEq(m.width, 320, "manifest width")
  a.assertEq(m.assetCount, 1, "manifest asset count")

  j = mani.load("examples\\jump-and-run\\minipixels.json")
  a.assertTrue(mani.isValid(j), "jump-and-run manifest valid")
  a.assertEq(j.levelPath, "assets/levels/levels.json", "manifest level path")

  t = mani.load("examples\\tiled-platformer\\minipixels.json")
  a.assertTrue(mani.isValid(t), "procedural asset manifest valid")

  invalid = mani.parseText("{\"name\":\"bad\",\"window\":{\"width\":0,\"height\":180}}", "inline", ".")
  a.assertFalse(mani.isValid(invalid), "invalid manifest fails")
  a.assertTrue(len(invalid.errors) > 0, "invalid manifest reports errors")

  invalidAsset = mani.parseText("{\"name\":\"bad-asset\",\"window\":{\"width\":320,\"height\":180},\"assets\":[{\"id\":\"thing\",\"type\":\"shader\"}]}", "inline", ".")
  a.assertFalse(mani.isValid(invalidAsset), "invalid asset type fails")
  a.assertTrue(len(invalidAsset.errors) > 0, "invalid asset type reports errors")

  print "=== JSON MANIFEST TESTS DONE ==="
  return 0
end function
