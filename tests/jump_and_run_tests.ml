import minipixels as mp
import minipixels.tools.json as json
import std.fs as fs
import std.assert as a
import std.math as math
import "../examples/jump-and-run/src/gameplay.ml" as play

function fieldNumber(object, key)
  return json.asNumber(json.get(object, key), 0)
end function

function makeWorld(level)
  w = fieldNumber(level, "width")
  h = fieldNumber(level, "height")
  data = array(w * h, 0)
  platforms = json.get(level, "platforms")
  for i = 0 to json.lenOf(platforms) - 1
    platform = json.at(platforms, i)
    for x = fieldNumber(platform, "x") to fieldNumber(platform, "x") + fieldNumber(platform, "w") - 1
      data[fieldNumber(platform, "y") * w + x] = 1
    end for
  end for
  sheet = mp.spriteSheet(mp.solidImage(32, 32, mp.rgb(0, 0, 0), "test"), 32, 32, 0, 0)
  map = mp.tilemap(32, 32, w, h, mp.tileset(sheet), 1)
  map.addLayer(mp.tileLayer("collision", w, h, data, false, true, 1, 1))
  return map
end function

function tick(p, map, left, right, jump, coins, taken)
  play.stepPlayer(p, map, left, right, jump, 1.0 / 60)
  for i = 0 to json.lenOf(coins) - 1
    coin = json.at(coins, i)
    if play.collectsCoin(p, fieldNumber(coin, "x"), fieldNumber(coin, "y")) then taken[i] = true end if
  end for
end function

function walkTo(p, map, target, coins, taken)
  frames = 0
  while math.abs(p.x - target) > 3 and frames < 3000
    tick(p, map, p.x > target, p.x < target, false, coins, taken)
    frames = frames + 1
  end while
  a.assertTrue(frames < 3000, "route reaches horizontal waypoint")
end function

function testRoute(level, index)
  map = makeWorld(level)
  spawn = json.get(level, "spawn")
  p = play.player(fieldNumber(spawn, "x"), fieldNumber(spawn, "y"))
  coins = json.get(level, "coins")
  taken = array(json.lenOf(coins), false)
  tick(p, map, false, false, false, coins, taken)
  platforms = json.get(level, "platforms")
  for i = 2 to json.lenOf(platforms) - 1
    platform = json.at(platforms, i)
    start = fieldNumber(platform, "x") * 32
    top = fieldNumber(platform, "y") * 32
    walkTo(p, map, start + 18, coins, taken)
    // If we walked off the previous ledge, settle before a fresh jump press.
    for settle = 0 to 89
      if p.grounded then break end if
      tick(p, map, false, false, false, coins, taken)
    end for
    // From wherever the previous traversal landed, jump straight through this ledge.
    tick(p, map, false, false, false, coins, taken)
    frames = 0
    while (p.grounded == false or math.abs(p.y + 32 - top) > 0.01) and frames < 180
      tick(p, map, false, false, true, coins, taken)
      frames = frames + 1
    end while
    a.assertTrue(frames < 180, "level " + index + " platform " + i + " reachable with real physics")
    a.assertEq(p.y + 32, top, "feet rest exactly on platform")
    walkTo(p, map, start + fieldNumber(platform, "w") * 32 - 32, coins, taken)
  end for
  // The wider ledges also form a continuous upper route, with no required damage boost.
  for i = 3 to json.lenOf(platforms) - 1
    previous = json.at(platforms, i - 1)
    target = json.at(platforms, i)
    hop = play.player((fieldNumber(previous, "x") + fieldNumber(previous, "w")) * 32 - 32, fieldNumber(previous, "y") * 32 - 32)
    play.stepPlayer(hop, map, false, false, false, 1.0 / 60)
    landed = false
    for frame = 0 to 119
      play.stepPlayer(hop, map, false, hop.x < fieldNumber(target, "x") * 32 + 24, true, 1.0 / 60)
      if hop.grounded and hop.y + 32 == fieldNumber(target, "y") * 32 and hop.x + 16 >= fieldNumber(target, "x") * 32 then landed = true end if
    end for
    a.assertTrue(landed, "level " + index + " upper route hop " + i)
  end for
  exit = json.get(level, "exit")
  walkTo(p, map, fieldNumber(exit, "x"), coins, taken)
  for i = 0 to 59
    tick(p, map, false, false, false, coins, taken)
  end for
  for i = 0 to len(taken) - 1
    a.assertTrue(taken[i], "level " + index + " coin " + i + " collected on playable route")
  end for
  a.assertTrue(play.overlaps(p.x + 9, p.y + 4, 14, 28, fieldNumber(exit, "x"), fieldNumber(exit, "y"), 32, 64), "route reaches exit")

  enemies = json.get(level, "enemies")
  for i = 0 to json.lenOf(enemies) - 1
    spec = json.at(enemies, i)
    e = play.enemy(fieldNumber(spec, "x"), fieldNumber(spec, "y"), fieldNumber(spec, "minX"), fieldNumber(spec, "maxX"), fieldNumber(spec, "kind"))
    valid = true
    for frame = 0 to 899
      play.stepEnemy(e, map, 1.0 / 60)
      if e.x < e.minX or e.x > e.maxX then valid = false end if
      if e.kind == play.SLIME then
        if e.y + 32 != 224 or play.enemyFrame(e) >= 4 then valid = false end if
      else
        if math.abs(e.y - e.baseY) > 5.01 or play.enemyFrame(e) < 4 then valid = false end if
      end if
    end for
    a.assertTrue(valid, "enemy patrol, ground contact and sheet kind " + index + "/" + i)
  end for
  a.assertEq(play.decorY(map, 96, 1) + 31, 224, "decor visible baseline meets ground")
  a.assertEq(play.decorY(map, 448, 2) + 62, 224, "scaled tree baseline meets ground")
end function

function testMovement(level)
  map = makeWorld(level)
  p = play.player(48, 192)
  play.stepPlayer(p, map, false, false, false, 1.0 / 60)
  minY = p.y
  jumps = 0
  for i = 0 to 119
    if play.stepPlayer(p, map, false, false, true, 1.0 / 60) then jumps = jumps + 1 end if
    if p.y < minY then minY = p.y end if
  end for
  a.assertEq(jumps, 1, "holding jump does not auto-bounce")
  a.assertTrue(192 - minY > 105, "jump has clearance above 96px platforms")
  a.assertTrue(p.grounded, "jump returns to ground")
  a.assertEq(play.playerFrame(p), play.floorInt(p.idleTime / 0.45) % 2, "idle uses breathing frames")
  short = play.player(48, 192)
  play.stepPlayer(short, map, false, false, false, 1.0 / 60)
  shortTop = 192
  for i = 0 to 119
    play.stepPlayer(short, map, false, false, i < 6, 1.0 / 60)
    shortTop = math.min(shortTop, short.y)
  end for
  a.assertTrue(shortTop > minY + 30, "release gives controllable short jump")

  slow = play.player(48, 192)
  fast = play.player(48, 192)
  for i = 0 to 29
    play.stepPlayer(slow, map, false, true, false, 1.0 / 30)
  end for
  for i = 0 to 119
    play.stepPlayer(fast, map, false, true, false, 1.0 / 120)
  end for
  a.assertTrue(math.abs(slow.x - fast.x) < 0.001, "movement independent of update rate")
  a.assertEq(play.playerRunFrame(slow), play.playerRunFrame(fast), "run animation follows distance, not frames")
  a.assertTrue(play.playerRunFrame(slow) >= 0 and play.playerRunFrame(slow) < 8, "running uses dedicated run poses")
  play.stepPlayer(slow, map, false, false, true, 1.0 / 60)
  a.assertEq(play.playerFrame(slow), 6, "upward jump pose")
  slow.vy = 80
  a.assertEq(play.playerFrame(slow), 7, "falling pose")

  // Deliberately let patrol limits extend past a platform to test ledge sensing.
  e = play.enemy(200, 128, 140, 550, play.SLIME)
  valid = true
  for i = 0 to 1199
    play.stepEnemy(e, map, 1.0 / 60)
    if e.y != 128 then valid = false end if
  end for
  a.assertTrue(valid, "ground enemy turns before platform edge")

  buffered = play.player(48, 184)
  buffered.vy = 230
  play.stepPlayer(buffered, map, false, false, true, 1.0 / 60)
  jumped = false
  for i = 0 to 5
    if play.stepPlayer(buffered, map, false, false, true, 1.0 / 60) then jumped = true end if
  end for
  a.assertTrue(jumped, "jump pressed just before landing is buffered")

  edge = play.player(480 - 20, 128)
  play.stepPlayer(edge, map, false, false, false, 1.0 / 60)
  for i = 0 to 29
    if edge.grounded == false then break end if
    play.stepPlayer(edge, map, false, true, false, 1.0 / 60)
  end for
  a.assertTrue(edge.grounded == false and edge.coyote > 0, "leaving a ledge grants coyote time")
  a.assertTrue(play.stepPlayer(edge, map, false, true, true, 1.0 / 60), "late edge jump succeeds")
end function

function main(args)
  doc = json.parse(fs.readAllText("examples/jump-and-run/assets/levels/levels.json"))
  levels = json.get(doc, "levels")
  for i = 0 to json.lenOf(levels) - 1
    testRoute(json.at(levels, i), i + 1)
  end for
  testMovement(json.at(levels, 0))
  testCamera(json.at(levels, 0))
  testAnimation()
  print "=== JUMP AND RUN GAMEPLAY TESTS DONE ==="
  return 0
end function

function testCamera(level)
  map = makeWorld(level)
  p = play.player(48, 192)
  camera = mp.camera(400, 225)
  camera.worldWidth = map.width * 32
  camera.worldHeight = map.height * 32
  motion = play.initializeCamera(camera, p)
  a.assertEq(camera.y, 28, "camera starts at settled ground framing")
  a.assertFalse(camera.pixelSnap, "camera retains subpixel spring state")
  origin = camera.y
  p.y = 96
  for i = 0 to 119
    play.followCamera(camera, motion, p, 1.0 / 60)
  end for
  a.assertEq(camera.y, origin, "landing on a high platform does not recenter camera")
  p.y = 192
  for i = 0 to 119
    play.followCamera(camera, motion, p, 1.0 / 60)
  end for
  a.assertEq(camera.y, origin, "stepping down to ground stays in camera dead zone")
  p.x = 260
  p.y = 128
  play.stepPlayer(p, map, false, false, false, 1.0 / 60)
  maxStep = 0
  for i = 0 to 179
    previous = camera.y
    play.stepPlayer(p, map, false, i < 110, i < 70, 1.0 / 60)
    play.followCamera(camera, motion, p, 1.0 / 60)
    maxStep = math.max(maxStep, math.abs(camera.y - previous))
  end for
  a.assertTrue(maxStep < 2, "jump and walk-off camera have no vertical snap")
  a.assertTrue(camera.x >= 0 and camera.x <= camera.worldWidth - 400, "smoothed camera stays in horizontal bounds")
  a.assertTrue(camera.y >= 0 and camera.y <= 63, "smoothed camera stays in vertical bounds")
  one = play.cameraSpring(0, 60, 0, 7, 1.0 / 30)
  half = play.cameraSpring(0, 60, 0, 7, 1.0 / 60)
  two = play.cameraSpring(half[0], 60, half[1], 7, 1.0 / 60)
  a.assertTrue(math.abs(one[0] - two[0]) < 0.0001, "camera damping is timestep independent")
  a.assertEq(play.forestLayerY(camera, 156) + 156, 224 - camera.y + 8, "parallax roots track ground instead of viewport bottom")
  for i = 0 to 7
    p.stride = i
    a.assertEq(play.playerRunFrame(p), i, "dedicated run pose " + i)
  end for
  p.stride = 8
  a.assertEq(play.playerRunFrame(p), 0, "run cycle loops after eight equally timed phases")
end function

function testAnimation()
  a.assertEq(play.RUN_FRAMES, 8, "eight balanced run phases")
  a.assertEq(play.COIN_FRAMES, 12, "twelve coin phases")
  a.assertEq(play.PORTAL_FRAMES, 12, "twelve portal phases")
  a.assertEq(play.coinFrame(0), 0, "coin starts face-on")
  a.assertEq(play.portalFrame(0), 0, "portal starts at phase zero")
  for i = 0 to 11
    a.assertEq(play.coinFrame((i + 0.5) * 0.1), i, "coin phase at 100ms cadence " + i)
    a.assertEq(play.portalFrame((i + 0.5) * 0.15), i, "portal phase at 150ms cadence " + i)
    a.assertEq(play.coinFrame(6 + (i + 0.5) * 0.1), i, "coin loops continuously " + i)
    a.assertEq(play.portalFrame(9 + (i + 0.5) * 0.15), i, "portal loops continuously " + i)
  end for
  a.assertEq(play.coinFrame(1.199), 11, "coin holds last phase until full rotation")
  a.assertEq(play.coinFrame(1.201), 0, "coin loops in 1.2 seconds, not 0.23")
  a.assertEq(play.portalFrame(1.799), 11, "portal holds last phase")
  a.assertEq(play.portalFrame(1.801), 0, "portal loops in 1.8 seconds")
  for rate = 30 to 144
    time = 0
    for tick = 1 to rate * 3
      time = time + 1.0 / rate
    end for
    // Sample off the frame boundary to avoid accumulated floating-point rounding.
    a.assertEq(play.coinFrame(time + 0.025), play.coinFrame(3.025), "coin cadence independent of update rate " + rate)
    a.assertEq(play.portalFrame(time + 0.025), play.portalFrame(3.025), "portal cadence independent of update rate " + rate)
  end for
  maxBobStep = 0
  boundedBob = true
  for tick = 0 to 300
    t = tick / 60.0
    if math.abs(play.coinBob(t, 2)) > 1.25 then boundedBob = false end if
    maxBobStep = math.max(maxBobStep, math.abs(play.coinBob(t + 1.0 / 60, 2) - play.coinBob(t, 2)))
  end for
  a.assertTrue(boundedBob, "coin float stays subtle")
  a.assertTrue(maxBobStep < 0.07, "coin float is continuous, not tied to spin frame changes")
end function
