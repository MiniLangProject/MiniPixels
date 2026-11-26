import minipixels as mp
import minipixels.core.time as tm
import std.test as test

function frame(clock, delta, limit, policy)
  tm.beginFixedFrame(clock, delta, 0.25, policy)
  updates = 0
  while clock.backlogSeconds >= clock.fixedDelta and updates < limit
    tm.consumeFixedUpdate(clock)
    updates = updates + 1
  end while
  tm.finishFixedFrame(clock, updates, limit, policy)
  return updates
end function

function retainedTime()
  clock = tm.create(60)
  wall = 0.0
  for each delta in [0.4, 0.6, 0.016, 0.016, 0.4, 0.6, 0.016, 0.016]
    wall = wall + delta
    count = frame(clock, delta, 32, "retain")
    test.assertTrue(count <= 32, "each frame has a bounded update budget")
    test.assertApproxEqual(clock.updateNumber * clock.fixedDelta + clock.backlogSeconds, wall, 0.0000001, "all wall time is simulated or queued")
    test.assertEqual(clock.droppedSeconds, 0, "retained debt is never silently lost")
    test.assertTrue(clock.alpha >= 0 and clock.alpha <= 1, "interpolation remains bounded")
    test.assertTrue(clock.delta <= 0.25, "presentation delta stays bounded")
  end for
  for i = 0 to 9
    frame(clock, 0, 32, "retain")
  end for
  test.assertTrue(clock.backlogSeconds < clock.fixedDelta, "backlog drains when budget permits")
  test.assertTrue(clock.catchUpLimitedFrames > 0, "budget exhaustion is visible")
  test.assertApproxEqual(clock.elapsed, wall, 0.0000001, "elapsed measures full wall time")
end function

function explicitDiscardAndPause()
  clock = tm.create(60)
  frame(clock, 0.6, 5, "discard")
  test.assertEqual(clock.updateNumber, 5, "legacy update budget")
  test.assertEqual(clock.backlogSeconds, 0, "legacy policy discards remaining debt")
  test.assertApproxEqual(clock.droppedSeconds, 0.6 - 5.0 / 60.0, 0.0000001, "frame clamp and catch-up discard are both accounted")
  frame(clock, 0.6, 5, "retain")
  queued = clock.backlogSeconds
  lost = clock.droppedSeconds
  tm.pauseFixedUpdates(clock)
  test.assertEqual(clock.backlogSeconds, 0, "pause clears queued simulation")
  test.assertApproxEqual(clock.pausedBacklogSeconds, queued, 0.0000001, "pause is recorded separately")
  test.assertEqual(clock.droppedSeconds, lost, "deliberate pause is not overload discard")
  cfg = mp.createConfig("Timing", 1, 1, 1)
  test.assertEqual(cfg.catchUpPolicy, "discard", "legacy configuration default")
  mp.setCatchUpPolicy(cfg, "retain")
  test.assertEqual(cfg.catchUpPolicy, "retain", "explicit retaining policy")
  mp.setCatchUpPolicy(cfg, "invalid")
  test.assertEqual(cfg.catchUpPolicy, "retain", "invalid policy preserves configuration")
  game = mp.createGame(cfg)
  tm.beginFixedFrame(game.time, 0.6, 0.25, "retain")
  mp.clearCatchUpDebt(game)
  test.assertEqual(game.time.backlogSeconds, 0, "application pause clears pending updates")
  test.assertApproxEqual(game.time.pausedBacklogSeconds, 0.6, 0.0000001, "application pause records cleared debt")
  frame(game.time, 1.0 / 60.0, 32, "retain")
  test.assertTrue(game.time.updateNumber <= 1, "resume cannot replay pre-pause updates")
end function

function main(args)
  suite = test.Suite.new("Fixed-update debt")
  suite.add("retained wall time and recovery", retainedTime)
  suite.add("explicit discard and pause", explicitDiscardAndPause)
  return test.run([suite], args)
end function
