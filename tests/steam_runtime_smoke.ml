import std.test as test
import std.bytes as by
import std.string as str
import minipixels as mp
import minipixels.steam as steam

function main(args)
  cfg = steam.defaults()
  test.assertTrue(cfg.enabled, "Steam define and generated configuration loaded")
  test.assertEqual(cfg.appId, 480)
  s = steam.session(cfg, steam.nativeBackend)
  test.assertTrue(steam.start(s, false), "optional native stub fallback")
  test.assertFalse(s.available)
  test.assertTrue(str.contains(s.lastError, "Test stub"), "native output buffer ABI")
  test.assertTrue(steam.writeSave(s, "slot.json", bytes("first")))
  test.assertTrue(steam.writeSave(s, "slot.json", bytes("second")), "replace existing save")
  test.assertEqual(by.decodeUtf8(steam.readSave(s, "slot.json")), "second")
  local = steam.savePath(s, "slot.json")
  s.userId = "76561198012345678"
  test.assertTrue(steam.writeSave(s, "slot.json", bytes("account")))
  test.assertNotEqual(local, steam.savePath(s, "slot.json"), "account isolation")
  s.userId = ""
  test.assertEqual(by.decodeUtf8(steam.readSave(s, "slot.json")), "second", "local save not overwritten by account")
  test.assertEqual(typeof(try(steam.writeSave(s, "../escape", bytes("bad")))), "error")
  steam.close(s)
  headless = mp.createConfig("Steam smoke", 8, 8, 1)
  headless.headlessFrames = 1
  game = mp.runHeadless(headless, void, void, void, void)
  test.assertFalse(game.steam.available)
  print "=== STEAM NATIVE/SAVE SMOKE DONE ==="
  return 0
end function
