import std.test as test
import std.bytes as by
import minipixels.steam as steam
import minipixels.input.input as input
import minipixels as mp

_calls = array(18, 0)
_available = true
_restart = false
_overlay = false
_stored = 0
_accept = true
_stat = -2147483648

function mockBackend(op, name, value, output)
  global _calls, _available, _restart, _overlay, _stored, _accept, _stat
  _calls[op] = _calls[op] + 1
  if op == 1 or op == 6 then
    if _available then return 1 end if
    return 0
  end if
  if op == 2 then
    if _restart then return 1 end if
    return 0
  end if
  if op == 5 then
    if _overlay then return 1 end if
    return 0
  end if
  if op == 11 or op == 12 then return 1 end if
  if op == 13 then _stat = value; return 1 end if
  if op == 14 then return _stat end if
  if op == 15 then
    if _accept then _stored = 1; return 1 end if
    return 0
  end if
  if op == 16 then return _stored end if
  text = ""
  if op == 7 then text = "Test player" end if
  if op == 8 then text = "76561198012345678" end if
  if op == 9 then text = "german" end if
  if op == 17 then text = "Expected test failure" end if
  if text == "" then return 0 end if
  raw = bytes(text)
  for i = 0 to len(raw) - 1
    output[i] = raw[i]
  end for
  return len(raw)
end function

function sessionAndInputTests()
  global _calls, _available, _restart, _overlay, _stored, _accept
  cfg = steam.config(480, false)
  s = steam.session(cfg, mockBackend)
  test.assertTrue(steam.start(s, true), "headless skips Steam")
  test.assertEqual(_calls[1], 0)
  test.assertTrue(steam.start(s, false))
  test.assertTrue(s.available)
  test.assertEqual(s.userId, "76561198012345678", "SteamID remains an exact string")
  test.assertEqual(s.language, "german")
  test.assertEqual(s.userName, "Test player")
  before = _calls[1]
  steam.start(s, false)
  test.assertEqual(_calls[1], before, "repeated start does not initialize twice")
  steam.setRenderer(s, "x11")
  test.assertFalse(s.overlaySupported)
  test.assertFalse(steam.openOverlay(s, "friends"))
  test.assertEqual(_calls[10], 0, "software presenter never requests overlay")
  steam.setRenderer(s, "opengl")
  test.assertTrue(s.overlaySupported)
  _overlay = true
  steam.update(s, 0)
  test.assertTrue(s.overlayActive, "callbacks pumped even while paused")
  _overlay = false
  steam.update(s, 0)
  test.assertTrue(s.wasOverlayActive, "close frame still suppresses input")
  test.assertFalse(s.overlayActive)
  test.assertTrue(steam.unlockAchievement(s, "FIRST_WIN"))
  test.assertTrue(steam.setStat(s, "score", -2147483648))
  test.assertEqual(steam.stat(s, "score"), -2147483648)
  test.assertFalse(steam.setStat(s, "score", 2147483648))
  test.assertFalse(steam.setStat(s, "score", 1.5))
  test.assertTrue(steam.flush(s))
  test.assertEqual(s.storeStatus, "pending", "acceptance is not confirmation")
  test.assertFalse(steam.flush(s), "one store in flight")
  steam.setStat(s, "score", 7)
  _stored = 2
  steam.update(s, 0)
  test.assertEqual(s.storeStatus, "confirmed")
  test.assertTrue(s.dirty, "changes during pending store are retained")
  steam.update(s, 5)
  test.assertEqual(s.storeStatus, "pending")
  _stored = -1
  steam.update(s, 0)
  test.assertEqual(s.storeStatus, "failed")
  test.assertTrue(s.dirty)
  before = _calls[15]
  steam.update(s, 1)
  test.assertEqual(_calls[15], before, "failed stores do not busy-loop")
  _accept = false
  steam.update(s, 5)
  test.assertTrue(s.dirty, "synchronous rejection preserves dirty stats")
  _accept = true
  steam.close(s)
  steam.close(s)
  test.assertEqual(_calls[4], 1, "idempotent shutdown")
  test.assertFalse(steam.unlockAchievement(s, "FIRST_WIN"))

  _available = false
  fallback = steam.session(cfg, mockBackend)
  test.assertTrue(steam.start(fallback, false), "optional mode survives missing client")
  test.assertFalse(fallback.available)
  required = steam.session(steam.config(480, true), mockBackend)
  result = try(steam.start(required, false))
  test.assertEqual(typeof(result), "error", "required mode fails clearly")
  _restart = true
  before = _calls[1]
  relaunch = steam.session(steam.config(480, true), mockBackend)
  test.assertTrue(steam.start(relaunch, false))
  test.assertTrue(relaunch.restartRequested)
  test.assertEqual(_calls[1], before, "restart exits before init")
  _restart = false
  _available = true
  lost = steam.session(cfg, mockBackend)
  steam.start(lost, false)
  lost.overlayActive = true
  before = _calls[4]
  _available = false
  steam.update(lost, 0)
  test.assertTrue(lost.wasOverlayActive, "shutdown clears overlay on its close frame")
  steam.update(lost, 0)
  test.assertFalse(lost.wasOverlayActive, "client loss cannot leave simulation paused forever")
  steam.close(lost)
  test.assertEqual(_calls[4], before + 1, "client shutdown releases backend exactly once")

  test.assertTrue(steam.safeSaveName("slot-1.json"))
  test.assertFalse(steam.safeSaveName("../slot.json"))
  test.assertFalse(steam.safeSaveName("a/b"))
  test.assertFalse(steam.safeSaveName("a\\b"))
  test.assertFalse(steam.safeSaveName("C:slot"))
  test.assertFalse(steam.safeSaveName(""))
  test.assertFalse(steam.safeSaveName("a..b"))
  test.assertFalse(steam.safeSaveName("slot."))

  state = input.create()
  input.setActionState(state, "jump", true)
  input.setActionState(state, "escape", true)
  input.setActionState(state, "mouse_left", true)
  input.setActionState(state, "custom", true)
  state.pendingMouseWheel = 4
  state.pendingMouseDeltaX = 9
  input.suppress(state)
  state.beginUpdate()
  test.assertFalse(state.jump)
  test.assertFalse(state.escape)
  test.assertFalse(state.mouseLeft)
  test.assertFalse(state.isDown("custom"))
  test.assertFalse(state.pressed("jump"))
  test.assertFalse(state.released("jump"))
  test.assertEqual(state.mouseWheel, 0)
  test.assertEqual(state.mouseDeltaX, 0)

  // Even required Steam configurations must never contact Steam in headless runs.
  gameConfig = mp.createConfig("Steam headless", 8, 8, 1)
  gameConfig.steam = steam.config(480, true)
  gameConfig.headlessFrames = 1
  game = mp.runHeadless(gameConfig, void, void, void, void)
  test.assertFalse(game.steam.available)
  print "=== STEAM TESTS DONE ==="
end function

function main(args)
  suite = test.Suite.new("MiniPixels Steam")
  suite.add("session lifecycle, stores, saves and overlay input", sessionAndInputTests)
  return test.run([suite], args)
end function
