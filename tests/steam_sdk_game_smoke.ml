// Opt-in read-only SDK test. Does not unlock achievements or store stats.
import std.test as test
import minipixels as mp
import minipixels.steam as steam

_requireClient = false

function realSdkStartup()
  global _requireClient
  cfg = steam.defaults()
  test.assertTrue(cfg.enabled, "Steam build selects the generated configuration")
  test.assertFalse(cfg.required, "integration remains optional")
  s = steam.session(cfg, steam.nativeBackend)
  test.assertTrue(steam.start(s, false), "optional startup succeeds with or without client")
  if _requireClient then test.assertTrue(s.available, s.lastError) end if
  if s.available then
    test.assertTrue(len(s.userId) > 0)
    test.assertTrue(len(s.language) > 0)
    steam.update(s, 0.016)
    test.assertTrue(s.available)
    test.assertEqual(s.storeStatus, "idle", "read-only smoke must not store stats")
    print "Real SDK connected through MiniLang"
  else
    test.assertTrue(len(s.lastError) > 0)
    print "Real SDK unavailable: " + s.lastError
  end if
  steam.close(s)
  test.assertTrue(s.closed)
  cfgGame = mp.createConfig("Steam SDK headless smoke", 8, 8, 1)
  cfgGame.headlessFrames = 1
  game = mp.runHeadless(cfgGame, void, void, void, void)
  test.assertFalse(game.steam.available, "headless game never initializes Steam")
end function

function main(args)
  global _requireClient
  if len(args) > 0 then _requireClient = args[0] == "--require-client" end if
  suite = test.Suite.new("Real Steam SDK game")
  suite.add("generated configuration, native ABI, lifecycle", realSdkStartup)
  return test.run([suite], [])
end function
