import minipixels as mp
import generated.assets as gen
import generated.levels as lvl

struct Player
  x
  y
  vx
  vy
  grounded
end struct

struct Coin
  x
  y
  got
end struct

player = void
camera = void
world = void
tileSheet = void
playerSprite = void
coins = []
coinCount = 0
coinsTaken = 0
exitX = 0
exitY = 0
won = false

function rectHit(ax, ay, aw, ah, bx, by, bw, bh)
  if ax + aw <= bx then return false end if
  if bx + bw <= ax then return false end if
  if ay + ah <= by then return false end if
  if by + bh <= ay then return false end if
  return true
end function

function loadLevel()
  global player, camera, world, coins, coinCount, coinsTaken, exitX, exitY, won
  w = lvl.width(0)
  h = lvl.height(0)
  data = lvl.tileData(0)
  world = mp.tilemap(32, 32, w, h, mp.tileset(tileSheet), 2)
  world.addLayer(mp.tileLayer("ground", w, h, data, true, false, 1, 1))
  world.addLayer(mp.tileLayer("collision", w, h, data, false, true, 1, 1))

  player = Player(lvl.spawnX(0), lvl.spawnY(0), 0, 0, false)
  camera = mp.camera(320, 180)
  camera.worldWidth = w * 32
  camera.worldHeight = h * 32
  exitX = lvl.exitX(0)
  exitY = lvl.exitY(0)
  coinCount = lvl.coinCount(0)
  coins = array(coinCount)
  coinsTaken = 0
  won = false
  i = 0
  while i < coinCount
    coins[i] = Coin(lvl.coinX(0, i), lvl.coinY(0, i), false)
    i = i + 1
  end while
end function

function initialize(game)
  global tileSheet, playerSprite
  game.assets = gen.registry()
  tileSheet = gen.sheet_tiles()
  playerSprite = game.assets.getSprite("player")
  loadLevel()
end function

function update(game, dt)
  global player, camera, coins, coinsTaken, won
  if won then
    if mp.inputPressed(game.input, "jump") then loadLevel() end if
    return
  end if

  player.vx = 0
  if game.input.left then player.vx = -135 end if
  if game.input.right then player.vx = 135 end if
  if (game.input.jump or game.input.up) and player.grounded then
    player.vy = -285
    player.grounded = false
  end if
  player.vy = player.vy + (720 * dt)
  if player.vy > 360 then player.vy = 360 end if

  res = mp.tileMoveAndCollide(world, mp.recti(player.x, player.y, 14, 16), player.vx * dt, player.vy * dt)
  player.x = res.x
  player.y = res.y
  if res.hitBottom then
    player.vy = 0
    player.grounded = true
  else
    player.grounded = false
  end if
  if res.hitTop then player.vy = 0 end if

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false and rectHit(player.x, player.y, 14, 16, c.x, c.y, 16, 16) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
    end if
    i = i + 1
  end while

  if coinsTaken >= coinCount and rectHit(player.x, player.y, 14, 16, exitX, exitY, 32, 64) then
    won = true
  end if
  camera.follow(player.x, player.y)
end function

function drawBackground(canvas)
  canvas.clear(mp.rgb(62, 103, 140))
  canvas.fillRect(0 - (camera.x / 6), 44, 460, 18, mp.rgb(86, 132, 154))
  canvas.fillRect(90 - (camera.x / 4), 74, 260, 16, mp.rgb(72, 118, 136))
  canvas.fillRect(260 - (camera.x / 5), 34, 210, 24, mp.rgb(92, 142, 164))
end function

function render(game, canvas)
  drawBackground(canvas)
  world.draw(canvas, camera)

  canvas.fillRect(exitX - camera.x, exitY - camera.y, 20, 52, mp.rgb(255, 220, 80))
  canvas.drawRect(exitX - camera.x, exitY - camera.y, 20, 52, mp.rgb(80, 50, 30))

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false then
      canvas.fillCircle(c.x - camera.x + 8, c.y - camera.y + 8, 6, mp.rgb(255, 220, 80))
      canvas.drawRect(c.x - camera.x + 3, c.y - camera.y + 3, 10, 10, mp.rgb(168, 104, 32))
    end if
    i = i + 1
  end while

  canvas.drawSprite(playerSprite, player.x - camera.x, player.y - camera.y)
  canvas.fillRect(0, 0, 320, 18, mp.rgba(20, 28, 36, 170))
  mp.drawText(canvas, "TILED IMPORT", 8, 6, 1, mp.rgb(255, 255, 255))
  mp.drawText(canvas, "COINS " + coinsTaken + "/" + coinCount, 210, 6, 1, mp.rgb(255, 220, 80))
  if won then
    canvas.fillRect(0, 64, 320, 48, mp.rgba(0, 0, 0, 160))
    mp.drawTextCentered(canvas, "TILED LEVEL CLEAR", 76, 2, mp.rgb(255, 220, 80))
    mp.drawTextCentered(canvas, "SPACE TO RESET", 98, 1, mp.rgb(255, 255, 255))
  end if
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Tiled Platformer", 320, 180, 4)
  return mp.run(cfg, initialize, update, render, void)
end function
