// Shared by the playable example and its headless gameplay regression tests.
package example.skyline.gameplay

import std.math as math

SLIME = 1
BAT = 0
RUN_SPEED = 160
JUMP_SPEED = 420
GRAVITY = 800
RUN_FRAMES = 8
RUN_FRAME_DISTANCE = 7
COIN_FRAMES = 12
COIN_PERIOD = 1.2
PORTAL_FRAMES = 12
PORTAL_PERIOD = 1.8

struct CameraMotion
  vx
  vy
end struct

function initializeCamera(camera, p)
  camera.pixelSnap = false
  camera.x = p.x + 16 - camera.width * 0.45
  camera.y = p.y + 16 - 180
  camera.clampToWorld()
  return CameraMotion(0, 0)
end function

// Critically damped spring, with retained fractional positions and velocity.
function cameraSpring(position, target, velocity, speed, dt)
  decay = math.exp(0 - speed * dt)
  offset = position - target
  step = (velocity + speed * offset) * dt
  return [target + (offset + step) * decay, (velocity - speed * step) * decay]
end function

function followCamera(camera, motion, p, dt)
  targetX = camera.x
  center = camera.width * 0.45
  screenX = p.x + 16 - camera.x
  if screenX < center - 20 then targetX = p.x + 16 - (center - 20) end if
  if screenX > center + 20 then targetX = p.x + 16 - (center + 20) end if
  targetY = camera.y
  screenY = p.y + 16 - camera.y
  // Normal ground/platform movement stays inside this quiet vertical band.
  if screenY < 72 then targetY = p.y + 16 - 72 end if
  if screenY > 180 then targetY = p.y + 16 - 180 end if
  maxX = math.max(0, camera.worldWidth - camera.width)
  maxY = math.max(0, camera.worldHeight - camera.height)
  targetX = math.max(0, math.min(maxX, targetX))
  targetY = math.max(0, math.min(maxY, targetY))
  horizontal = cameraSpring(camera.x, targetX, motion.vx, 10, dt)
  vertical = cameraSpring(camera.y, targetY, motion.vy, 7, dt)
  camera.x = math.max(0, math.min(maxX, horizontal[0]))
  camera.y = math.max(0, math.min(maxY, vertical[0]))
  motion.vx = horizontal[1]
  motion.vy = vertical[1]
  if camera.x == 0 or camera.x == maxX then motion.vx = 0 end if
  if camera.y == 0 or camera.y == maxY then motion.vy = 0 end if
end function

function forestLayerY(camera, height)
  // Roots sit eight pixels behind the ground, not at the bottom of the viewport.
  return 224 - camera.y + 8 - height
end function

function playerRunFrame(p)
  return floorInt(p.stride) % RUN_FRAMES
end function

function coinFrame(time)
  return floorInt(time * COIN_FRAMES / COIN_PERIOD) % COIN_FRAMES
end function

function portalFrame(time)
  return floorInt(time * PORTAL_FRAMES / PORTAL_PERIOD) % PORTAL_FRAMES
end function

function coinBob(time, index)
  // Independent, gentle floating motion; rotation no longer steps the coin up/down.
  return math.sin(time * 3.141592653589793 + index * 0.6) * 1.25
end function

struct Player
  x
  y
  vx
  vy
  grounded
  facing
  coyote
  jumpBuffer
  jumpHeld
  stride
  idleTime
end struct

struct Enemy
  x
  y
  minX
  maxX
  dir
  alive
  kind
  vy
  baseY
  age
  stride
end struct

function player(x, y)
  return Player(x, y, 0, 0, false, 1, 0, 0, false, 0, 0)
end function

function enemy(x, y, minX, maxX, kind)
  return Enemy(x, y, minX, maxX, 1, true, kind, 0, y, 0, 0)
end function

function floorInt(value)
  return math.floor(value)
end function

function overlaps(ax, ay, aw, ah, bx, by, bw, bh)
  return ax + aw > bx and bx + bw > ax and ay + ah > by and by + bh > ay
end function

function collectsCoin(p, x, y)
  return overlaps(p.x + 9, p.y + 4, 14, 28, x + 6, y + 4, 20, 24)
end function

// Top faces are one-way: jumping up through a ledge never hits a ceiling.
// Sweep feet down through every crossed tile row, preserving fractional motion.
function land(body, map, previousFeet)
  if body.vy < 0 then return false end if
  feet = body.y + 32
  first = floorInt(previousFeet / 32)
  last = floorInt(feet / 32)
  left = floorInt((body.x + 9) / 32)
  right = floorInt((body.x + 22) / 32)
  for row = first to last
    top = row * 32
    if previousFeet <= top and feet >= top then
      for column = left to right
        if map.isSolidAtTile(column, row) and map.isSolidAtTile(column, row - 1) == false then
          body.y = top - 32
          body.vy = 0
          return true
        end if
      end for
    end if
  end for
  return false
end function

function supported(map, x, feet)
  row = floorInt(feet / 32)
  return map.isSolidAtTile(floorInt(x / 32), row)
end function

// Returns true only on a new jump, for the caller's sound effect.
function stepPlayer(p, map, left, right, jump, dt)
  if jump and p.jumpHeld == false then p.jumpBuffer = 0.12 end if
  if jump == false and p.jumpHeld and p.vy < -180 then p.vy = -180 end if
  p.jumpHeld = jump
  p.vx = 0
  if left then p.vx = 0 - RUN_SPEED end if
  if right then p.vx = RUN_SPEED end if
  if p.vx < 0 then p.facing = -1 end if
  if p.vx > 0 then p.facing = 1 end if
  jumped = false
  remaining = dt
  while remaining > 0.000001
    tick = remaining
    if tick > 1.0 / 120 then tick = 1.0 / 120 end if
    remaining = remaining - tick
    if p.grounded then p.coyote = 0.10 end if
    if p.jumpBuffer > 0 and p.coyote > 0 then
      p.vy = 0 - JUMP_SPEED
      p.grounded = false
      p.coyote = 0
      p.jumpBuffer = 0
      jumped = true
    end if
    p.coyote = math.max(0, p.coyote - tick)
    p.jumpBuffer = math.max(0, p.jumpBuffer - tick)
    previousFeet = p.y + 32
    previousX = p.x
    p.x = math.max(0, math.min(map.width * 32 - 32, p.x + p.vx * tick))
    p.vy = math.min(520, p.vy + GRAVITY * tick)
    p.y = p.y + p.vy * tick
    p.grounded = land(p, map, previousFeet)
    if p.grounded and p.vx != 0 then
      p.stride = p.stride + math.abs(p.x - previousX) / RUN_FRAME_DISTANCE
      p.idleTime = 0
    else
      if p.grounded then p.stride = 0 end if
      p.idleTime = p.idleTime + tick
    end if
  end while
  return jumped
end function

function playerFrame(p)
  if p.grounded == false then
    if p.vy < 0 then return 6 end if
    return 7
  end if
  return floorInt(p.idleTime / 0.45) % 2
end function

function stepEnemy(e, map, dt)
  if e.alive == false then return end if
  e.age = e.age + dt
  speed = 34
  if e.kind == BAT then speed = 48 end if
  nextX = e.x + e.dir * speed * dt
  if nextX < e.minX then
    nextX = e.minX
    e.dir = 1
  end if
  if nextX > e.maxX then
    nextX = e.maxX
    e.dir = -1
  end if
  if e.kind == SLIME then
    // Ground creatures turn at ledges, not just at their authored patrol bounds.
    leading = nextX + 23
    if e.dir < 0 then leading = nextX + 8 end if
    if supported(map, e.x + 16, e.y + 32) and supported(map, leading, e.y + 32) == false then
      nextX = e.x
      e.dir = 0 - e.dir
    end if
    previousFeet = e.y + 32
    e.vy = math.min(520, e.vy + GRAVITY * dt)
    e.y = e.y + e.vy * dt
    land(e, map, previousFeet)
  else
    e.y = e.baseY + math.sin(e.age * 3) * 5
  end if
  e.stride = e.stride + math.abs(nextX - e.x) / 7
  e.x = nextX
end function

function enemyFrame(e)
  if e.kind == SLIME then return floorInt(e.stride) % 4 end if
  // Authored bat poses go up -> middle -> down -> middle, without a double up pose.
  phase = floorInt(e.age / 0.10) % 4
  if phase == 3 then phase = 1 end if
  return 4 + phase
end function

// Put the visible bottom pixel on the supporting tile, including scaled trees.
function decorY(map, x, scale)
  for row = 7 to map.height - 1
    if map.isSolidAtTile(floorInt(x / 32), row) then return row * 32 - 31 * scale end if
  end for
  return map.height * 32 - 31 * scale
end function
