import minipixels as mp
import generated.assets as gen

struct Player
  x
  y
  vx
  vy
  grounded
  facing
end struct

struct Enemy
  x
  y
  minX
  maxX
  dir
  alive
end struct

struct Coin
  x
  y
  got
end struct

state = 0
levelIndex = 0
player = void
camera = void
world = void
tileSheet = void
playerSheet = void
enemySheet = void
coinSprite = void
exitSprite = void
cloudSprite = void
flowerSprite = void
sparkSprite = void
enemies = []
coins = []
enemyCount = 0
coinCount = 0
coinsTaken = 0
spawnX = 36
spawnY = 180
exitX = 720
exitY = 126

function makeSolidData(w, h, level)
  data = array(w * h, 0)
  for y = 0 to h - 1
    for x = 0 to w - 1
      if y >= h - 2 then
        data[(y * w) + x] = 1
      end if
    end for
  end for

  if level == 0 then
    for x = 7 to 13
      data[(9 * w) + x] = 1
    end for
    for x = 18 to 24
      data[(7 * w) + x] = 1
    end for
    for x = 31 to 38
      data[(8 * w) + x] = 1
    end for
  else if level == 1 then
    for x = 5 to 10
      data[(10 * w) + x] = 1
    end for
    for x = 14 to 20
      data[(8 * w) + x] = 1
    end for
    for x = 25 to 28
      data[(6 * w) + x] = 1
    end for
    for x = 34 to 42
      data[(8 * w) + x] = 1
    end for
    for x = 49 to 55
      data[(5 * w) + x] = 1
    end for
  else
    for x = 4 to 8
      data[(10 * w) + x] = 1
    end for
    for x = 11 to 16
      data[(8 * w) + x] = 1
    end for
    for x = 20 to 25
      data[(6 * w) + x] = 1
    end for
    for x = 29 to 35
      data[(8 * w) + x] = 1
    end for
    for x = 39 to 45
      data[(5 * w) + x] = 1
    end for
    for x = 50 to 60
      data[(9 * w) + x] = 1
    end for
  end if
  return data
end function

function intDiv(n, d)
  return (n - (n % d)) / d
end function

function setCoin(i, x, y)
  global coins
  coins[i] = Coin(x, y, false)
end function

function setEnemy(i, x, y, minX, maxX)
  global enemies
  enemies[i] = Enemy(x, y, minX, maxX, 1, true)
end function

function loadLevel(n)
  global levelIndex, player, camera, world, enemies, coins, enemyCount, coinCount, coinsTaken, spawnX, spawnY, exitX, exitY
  levelIndex = n
  w = 72 + (n * 10)
  h = 14
  data = makeSolidData(w, h, n)
  world = mp.tilemap(18, 18, w, h, mp.tileset(tileSheet), 2)
  world.addLayer(mp.tileLayer("ground", w, h, data, true, false, 1, 1))
  world.addLayer(mp.tileLayer("collision", w, h, data, false, true, 1, 1))

  spawnX = 36
  spawnY = 180
  exitX = (w * 18) - 72
  exitY = 180
  player = Player(spawnX, spawnY, 0, 0, false, 1)
  camera = mp.camera(320, 180)
  camera.worldWidth = w * 18
  camera.worldHeight = h * 18

  enemies = array(6)
  coins = array(10)
  enemyCount = 2 + n
  coinCount = 5 + n
  coinsTaken = 0

  setEnemy(0, 230, 198, 200, 310)
  setEnemy(1, 500, 198, 460, 590)
  if n >= 1 then setEnemy(2, 640, 126, 590, 720) end if
  if n >= 2 then setEnemy(3, 875, 198, 820, 960) end if

  setCoin(0, 150, 148)
  setCoin(1, 225, 112)
  setCoin(2, 360, 76)
  setCoin(3, 560, 94)
  setCoin(4, exitX - 36, 148)
  if n >= 1 then setCoin(5, 720, 76) end if
  if n >= 2 then setCoin(6, 910, 58) end if
end function

function resetLevel()
  loadLevel(levelIndex)
end function

function initialize(game)
  global tileSheet, playerSheet, enemySheet, coinSprite, exitSprite, cloudSprite, flowerSprite, sparkSprite
  game.assets = gen.registry()
  tileSheet = mp.spriteSheet(game.assets.getSprite("tiles").image, 18, 18, 0, 0)
  playerSheet = mp.spriteSheet(game.assets.getSprite("player").image, 24, 24, 0, 0)
  enemySheet = mp.spriteSheet(game.assets.getSprite("enemy").image, 24, 24, 0, 0)
  coinSprite = tileSheet.getFrame(3)
  exitSprite = tileSheet.getFrame(1)
  cloudSprite = tileSheet.getFrame(7)
  flowerSprite = tileSheet.getFrame(8)
  sparkSprite = tileSheet.getFrame(9)
  loadLevel(0)
end function

function rectHit(ax, ay, aw, ah, bx, by, bw, bh)
  if ax + aw <= bx then return false end if
  if bx + bw <= ax then return false end if
  if ay + ah <= by then return false end if
  if by + bh <= ay then return false end if
  return true
end function

function playerDie()
  global state
  mp.playSound("assets\\audio\\hurt.wav")
  state = 3
end function

function updateEnemies(dt)
  global enemies
  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      e.x = e.x + (e.dir * 48 * dt)
      if e.x < e.minX then
        e.x = e.minX
        e.dir = 1
      end if
      if e.x > e.maxX then
        e.x = e.maxX
        e.dir = -1
      end if
      enemies[i] = e
    end if
    i = i + 1
  end while
end function

function animFrame(game, speed)
  return game.time.frameNumber % speed
end function

function cycle4(game, speed)
  t = game.time.frameNumber % (speed * 4)
  if t < speed then return 0 end if
  if t < speed * 2 then return 1 end if
  if t < speed * 3 then return 2 end if
  return 3
end function

function pulse2(game, speed)
  t = game.time.frameNumber % (speed * 2)
  if t < speed then return 0 end if
  return 1
end function

function bob4(frame)
  if frame == 0 then return 0 end if
  if frame == 1 then return -1 end if
  if frame == 2 then return 0 end if
  return 1
end function

function updatePlay(game, dt)
  global player, camera, coinsTaken, state, levelIndex
  player.vx = 0
  if game.input.left then
    player.vx = -105
    player.facing = -1
  end if
  if game.input.right then
    player.vx = 105
    player.facing = 1
  end if
  if (game.input.jump or game.input.up) and player.grounded then
    player.vy = -245
    player.grounded = false
    mp.playSound("assets\\audio\\jump.wav")
  end if
  player.vy = player.vy + (620 * dt)
  if player.vy > 260 then player.vy = 260 end if

  rect = mp.recti(player.x + 5, player.y + 5, 14, 18)
  res = mp.tileMoveAndCollide(world, rect, player.vx * dt, player.vy * dt)
  player.x = res.x - 5
  player.y = res.y - 5
  if player.x < 0 then
    player.x = 0
  end if
  if player.x > camera.worldWidth - 24 then
    player.x = camera.worldWidth - 24
  end if
  if res.hitBottom then
    player.vy = 0
    player.grounded = true
  else
    player.grounded = false
  end if
  if res.hitTop then player.vy = 0 end if
  if player.y > camera.worldHeight then
    playerDie()
    return
  end if

  updateEnemies(dt)
  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive and rectHit(player.x + 5, player.y + 5, 14, 18, e.x + 4, e.y + 7, 16, 14) then
      if player.vy > 20 and player.y + 18 < e.y + 10 then
        e.alive = false
        enemies[i] = e
        player.vy = -150
        mp.playSound("assets\\audio\\coin.wav")
      else
        playerDie()
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false and rectHit(player.x + 5, player.y + 5, 14, 18, c.x, c.y, 18, 18) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
      mp.playSound("assets\\audio\\coin.wav")
    end if
    i = i + 1
  end while

  if rectHit(player.x + 5, player.y + 5, 14, 18, exitX, exitY, 18, 36) and coinsTaken >= coinCount then
    if levelIndex < 2 then
      loadLevel(levelIndex + 1)
      mp.playSound("assets\\audio\\win.wav")
    else
      state = 2
      mp.playSound("assets\\audio\\win.wav")
    end if
  end if

  camera.follow(player.x, player.y)
end function

function update(game, dt)
  global state
  if state == 0 then
    if game.input.jump or game.input.up then
      state = 1
      loadLevel(0)
      mp.playSound("assets\\audio\\coin.wav")
    end if
    return
  end if
  if state == 1 then
    updatePlay(game, dt)
    return
  end if
  if state == 2 then
    if game.input.jump or game.input.up then
      state = 1
      loadLevel(0)
    end if
    return
  end if
  if state == 3 then
    if game.input.jump or game.input.up then
      state = 1
      resetLevel()
    end if
  end if
end function

function drawParallax(canvas)
  canvas.clear(mp.rgb(74, 112, 162))
  canvas.fillRect(0, 0, 320, 72, mp.rgb(88, 142, 188))
  canvas.fillRect(0 - (camera.x / 8), 44, 900, 24, mp.rgb(96, 150, 190))
  canvas.fillRect(70 - (camera.x / 5), 76, 180, 22, mp.rgb(74, 122, 166))
  canvas.fillRect(330 - (camera.x / 5), 66, 190, 28, mp.rgb(70, 116, 158))
  canvas.drawSprite(cloudSprite, 36 - (camera.x / 7), 22)
  canvas.drawSprite(cloudSprite, 154 - (camera.x / 6), 36)
  canvas.drawSprite(cloudSprite, 278 - (camera.x / 7), 18)
  canvas.drawSprite(cloudSprite, 442 - (camera.x / 6), 34)
end function

function drawPlay(game, canvas)
  coinFrame = cycle4(game, 6)
  enemyFrame = cycle4(game, 8)
  exitFrame = 1 + pulse2(game, 12)
  runFrame = cycle4(game, 5)
  idleFrame = pulse2(game, 28)
  drawParallax(canvas)
  world.draw(canvas, camera)
  canvas.drawSprite(tileSheet.getFrame(exitFrame), exitX - camera.x, exitY - camera.y)
  canvas.drawSprite(tileSheet.getFrame(exitFrame), exitX - camera.x, exitY - 18 - camera.y)
  canvas.drawSprite(sparkSprite, exitX - camera.x, exitY - 37 - camera.y + bob4(coinFrame))

  for d = 0 to 10
    dx = 112 + (d * 118)
    canvas.drawSprite(flowerSprite, dx - camera.x, 215 - camera.y)
  end for

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false then
      cspr = tileSheet.getFrame(3 + coinFrame)
      canvas.drawSprite(cspr, c.x - camera.x, c.y - camera.y + bob4((coinFrame + i) % 4))
    end if
    i = i + 1
  end while

  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      spr = enemySheet.getFrame(enemyFrame)
      if e.dir < 0 then
        canvas.drawSpriteEx(spr, e.x - camera.x, e.y - camera.y, true, false, 1, mp.rgba(255, 255, 255, 255))
      else
        canvas.drawSprite(spr, e.x - camera.x, e.y - camera.y)
      end if
    end if
    i = i + 1
  end while

  pframe = idleFrame
  if player.grounded and player.vx != 0 then
    pframe = 2 + runFrame
  end if
  if player.grounded == false and player.vy < 0 then
    pframe = 6
  end if
  if player.grounded == false and player.vy >= 0 then
    pframe = 7
  end if
  pspr = playerSheet.getFrame(pframe)
  if player.facing < 0 then
    canvas.drawSpriteEx(pspr, player.x - camera.x, player.y - camera.y, true, false, 1, mp.rgba(255, 255, 255, 255))
  else
    canvas.drawSprite(pspr, player.x - camera.x, player.y - camera.y)
  end if

  for c = 0 to coinsTaken - 1
    canvas.fillRect(6 + (c * 8), 6, 5, 5, mp.rgb(255, 216, 64))
  end for
  canvas.fillRect(6, 16, (levelIndex + 1) * 18, 4, mp.rgb(115, 230, 145))
end function

function glyphRows(ch)
  if ch == "A" then return [14, 17, 17, 31, 17, 17, 17] end if
  if ch == "C" then return [14, 17, 16, 16, 16, 17, 14] end if
  if ch == "E" then return [31, 16, 16, 30, 16, 16, 31] end if
  if ch == "G" then return [14, 17, 16, 23, 17, 17, 14] end if
  if ch == "I" then return [14, 4, 4, 4, 4, 4, 14] end if
  if ch == "K" then return [17, 18, 20, 24, 20, 18, 17] end if
  if ch == "L" then return [16, 16, 16, 16, 16, 16, 31] end if
  if ch == "N" then return [17, 25, 21, 19, 17, 17, 17] end if
  if ch == "O" then return [14, 17, 17, 17, 17, 17, 14] end if
  if ch == "P" then return [30, 17, 17, 30, 16, 16, 16] end if
  if ch == "R" then return [30, 17, 17, 30, 20, 18, 17] end if
  if ch == "S" then return [15, 16, 16, 14, 1, 1, 30] end if
  if ch == "T" then return [31, 4, 4, 4, 4, 4, 4] end if
  if ch == "U" then return [17, 17, 17, 17, 17, 17, 14] end if
  if ch == "W" then return [17, 17, 17, 21, 21, 27, 17] end if
  if ch == "Y" then return [17, 17, 10, 4, 4, 4, 4] end if
  return [31, 17, 21, 17, 21, 17, 31]
end function

function glyphMask(x)
  if x == 0 then return 16 end if
  if x == 1 then return 8 end if
  if x == 2 then return 4 end if
  if x == 3 then return 2 end if
  return 1
end function

function drawGlyph(canvas, ch, x, y, scale, color)
  if ch == " " then return end if
  rows = glyphRows(ch)
  yy = 0
  while yy < 7
    row = rows[yy]
    xx = 0
    while xx < 5
      mask = glyphMask(xx)
      if (row & mask) != 0 then
        canvas.fillRect(x + (xx * scale), y + (yy * scale), scale, scale, color)
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
end function

function drawText(canvas, text, x, y, scale, color)
  xx = x
  for each ch in text
    drawGlyph(canvas, ch, xx, y, scale, color)
    xx = xx + (6 * scale)
  end for
end function

function drawCentered(canvas, text, y, scale, color)
  width = len(text) * 6 * scale
  drawText(canvas, text, (320 - width) / 2, y, scale, color)
end function

function drawMenuScreen(game, canvas, title, subtitle, color)
  menuFrame = cycle4(game, 8)
  glow = pulse2(game, 18)
  canvas.fillRect(0, 80, 320, 100, mp.rgb(40, 66, 100))
  canvas.fillRect(0, 136, 320, 44, mp.rgb(38, 80, 62))
  canvas.fillRect(0, 148, 320, 32, mp.rgb(42, 92, 70))
  canvas.fillRect(44, 27, 232, 76, mp.rgba(0, 0, 0, 175))
  canvas.drawRect(44, 27, 232, 76, color)
  if glow == 1 then
    canvas.drawRect(46, 29, 228, 72, mp.rgba(255, 255, 255, 90))
  end if
  drawCentered(canvas, title, 44, 3, color)
  canvas.fillRect(83, 82, 154, 12, mp.rgb(255, 255, 255))
  drawCentered(canvas, subtitle, 84, 1, mp.rgb(30, 42, 60))
  canvas.fillRect(42, 134, 42, 10, mp.rgb(84, 178, 104))
  canvas.fillRect(47, 118, 26, 16, mp.rgb(84, 178, 104))
  canvas.fillRect(238, 124, 40, 10, mp.rgb(84, 178, 104))
  canvas.fillRect(250, 104, 18, 20, mp.rgb(84, 178, 104))
  canvas.drawSprite(playerSheet.getFrame(2 + menuFrame), 92, 110 + bob4(menuFrame))
  canvas.drawSprite(enemySheet.getFrame(menuFrame), 204, 116 + bob4((menuFrame + 1) % 4))
  canvas.drawSprite(tileSheet.getFrame(3 + menuFrame), 148, 121 + bob4(menuFrame))
end function

function render(game, canvas)
  if state == 0 then
    canvas.clear(mp.rgb(18, 24, 42))
    drawMenuScreen(game, canvas, "SKYLINE RUN", "SPACE OR UP", mp.rgb(78, 205, 196))
    return
  end if
  if state == 1 then
    drawPlay(game, canvas)
    return
  end if
  if state == 2 then
    canvas.clear(mp.rgb(18, 30, 28))
    drawMenuScreen(game, canvas, "YOU WIN", "SPACE OR UP", mp.rgb(255, 220, 80))
    return
  end if
  canvas.clear(mp.rgb(36, 18, 28))
  drawMenuScreen(game, canvas, "TRY AGAIN", "SPACE OR UP", mp.rgb(255, 90, 105))
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Skyline Run", 320, 180, 4)
  return mp.run(cfg, initialize, update, render, void)
end function
