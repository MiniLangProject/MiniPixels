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
bgSprite = void
coinSprite = void
exitSprite = void
cloudSprite = void
flowerSprite = void
sparkSprite = void
campfireSprite = void
enemies = []
coins = []
enemyCount = 0
coinCount = 0
coinsTaken = 0
spawnX = 36
spawnY = 180
exitX = 720
exitY = 160

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
    for x = 6 to 11
      data[(5 * w) + x] = 1
    end for
    for x = 16 to 21
      data[(4 * w) + x] = 1
    end for
    for x = 29 to 35
      data[(5 * w) + x] = 1
    end for
  else if level == 1 then
    for x = 5 to 10
      data[(5 * w) + x] = 1
    end for
    for x = 14 to 19
      data[(4 * w) + x] = 1
    end for
    for x = 24 to 28
      data[(3 * w) + x] = 1
    end for
    for x = 33 to 40
      data[(5 * w) + x] = 1
    end for
    for x = 45 to 51
      data[(4 * w) + x] = 1
    end for
  else
    for x = 4 to 8
      data[(5 * w) + x] = 1
    end for
    for x = 12 to 17
      data[(4 * w) + x] = 1
    end for
    for x = 22 to 27
      data[(3 * w) + x] = 1
    end for
    for x = 32 to 38
      data[(5 * w) + x] = 1
    end for
    for x = 42 to 48
      data[(4 * w) + x] = 1
    end for
    for x = 53 to 62
      data[(5 * w) + x] = 1
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
  w = 46 + (n * 8)
  h = 9
  data = makeSolidData(w, h, n)
  world = mp.tilemap(32, 32, w, h, mp.tileset(tileSheet), 2)
  world.addLayer(mp.tileLayer("ground", w, h, data, true, false, 1, 1))
  world.addLayer(mp.tileLayer("collision", w, h, data, false, true, 1, 1))

  spawnX = 48
  spawnY = 192
  exitX = (w * 32) - 96
  exitY = 160
  player = Player(spawnX, spawnY, 0, 0, false, 1)
  camera = mp.camera(320, 180)
  camera.worldWidth = w * 32
  camera.worldHeight = h * 32

  enemies = array(6)
  coins = array(10)
  enemyCount = 2 + n
  coinCount = 5 + n
  coinsTaken = 0

  setEnemy(0, 360, 192, 330, 490)
  setEnemy(1, 760, 192, 710, 900)
  if n >= 1 then setEnemy(2, 1080, 128, 1030, 1210) end if
  if n >= 2 then setEnemy(3, 1370, 192, 1310, 1510) end if

  setCoin(0, 230, 124)
  setCoin(1, 545, 92)
  setCoin(2, 690, 92)
  setCoin(3, 980, 124)
  setCoin(4, exitX - 54, 124)
  if n >= 1 then setCoin(5, 1160, 92) end if
  if n >= 2 then setCoin(6, 1480, 124) end if
end function

function resetLevel()
  loadLevel(levelIndex)
end function

function initialize(game)
  global tileSheet, playerSheet, enemySheet, bgSprite, coinSprite, exitSprite, cloudSprite, flowerSprite, sparkSprite, campfireSprite
  game.assets = gen.registry()
  bgSprite = game.assets.getSprite("background")
  tileSheet = mp.spriteSheet(game.assets.getSprite("tiles").image, 32, 32, 0, 0)
  playerSheet = mp.spriteSheet(game.assets.getSprite("player").image, 24, 32, 0, 0)
  enemySheet = mp.spriteSheet(game.assets.getSprite("enemy").image, 24, 32, 0, 0)
  coinSprite = tileSheet.getFrame(1)
  exitSprite = tileSheet.getFrame(3)
  cloudSprite = tileSheet.getFrame(5)
  flowerSprite = tileSheet.getFrame(5)
  sparkSprite = tileSheet.getFrame(6)
  campfireSprite = tileSheet.getFrame(6)
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
    player.vx = -130
    player.facing = -1
  end if
  if game.input.right then
    player.vx = 130
    player.facing = 1
  end if
  if (game.input.jump or game.input.up) and player.grounded then
    player.vy = -315
    player.grounded = false
    mp.playSound("assets\\audio\\jump.wav")
  end if
  player.vy = player.vy + (760 * dt)
  if player.vy > 360 then player.vy = 360 end if

  rect = mp.recti(player.x + 7, player.y + 3, 18, 29)
  res = mp.tileMoveAndCollide(world, rect, player.vx * dt, player.vy * dt)
  player.x = res.x - 7
  player.y = res.y - 3
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
    if e.alive and rectHit(player.x + 7, player.y + 3, 18, 29, e.x + 5, e.y + 8, 23, 20) then
      if player.vy > 20 and player.y + 28 < e.y + 13 then
        e.alive = false
        enemies[i] = e
        player.vy = -210
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
    if c.got == false and rectHit(player.x + 7, player.y + 3, 18, 29, c.x + 6, c.y + 4, 20, 24) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
      mp.playSound("assets\\audio\\coin.wav")
    end if
    i = i + 1
  end while

  if rectHit(player.x + 7, player.y + 3, 18, 29, exitX, exitY, 32, 64) and coinsTaken >= coinCount then
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
  canvas.clear(mp.rgb(126, 190, 207))
  canvas.drawSpriteEx(bgSprite, 0, 0, false, false, 8, mp.rgba(255, 255, 255, 255))
  canvas.fillRect(0, 100, 320, 80, mp.rgba(62, 91, 74, 120))
end function

function drawPlay(game, canvas)
  coinFrame = pulse2(game, 7)
  enemyFrame = pulse2(game, 9)
  exitFrame = 3 + pulse2(game, 12)
  runFrame = cycle4(game, 5)
  idleFrame = pulse2(game, 28)
  drawParallax(canvas)
  world.draw(canvas, camera)
  canvas.drawSpriteEx(tileSheet.getFrame(exitFrame), exitX - camera.x, exitY - camera.y, false, false, 2, mp.rgba(255, 255, 255, 255))

  for d = 0 to 10
    dx = 120 + (d * 146)
    canvas.drawSprite(tileSheet.getFrame(5), dx - camera.x, 194 - camera.y)
  end for
  canvas.drawSprite(tileSheet.getFrame(6), 72 - camera.x, 192 - camera.y)

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false then
      cspr = tileSheet.getFrame(1 + coinFrame)
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
    pframe = 4
  end if
  if player.grounded == false and player.vy >= 0 then
    pframe = 5
  end if
  pspr = playerSheet.getFrame(pframe)
  if player.facing < 0 then
    canvas.drawSpriteEx(pspr, player.x - camera.x, player.y - camera.y, true, false, 1, mp.rgba(255, 255, 255, 255))
  else
    canvas.drawSprite(pspr, player.x - camera.x, player.y - camera.y)
  end if

  for c = 0 to coinsTaken - 1
    canvas.drawSprite(tileSheet.getFrame(1), 6 + (c * 13), 6)
  end for
  canvas.fillRect(6, 21, (levelIndex + 1) * 22, 4, mp.rgb(116, 184, 90))
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
  menuPulse = pulse2(game, 8)
  glow = pulse2(game, 18)
  canvas.drawSpriteEx(bgSprite, 0, 0, false, false, 8, mp.rgba(255, 255, 255, 255))
  canvas.fillRect(0, 136, 320, 44, mp.rgb(44, 74, 48))
  canvas.fillRect(0, 150, 320, 30, mp.rgb(34, 58, 40))
  canvas.fillRect(44, 27, 232, 76, mp.rgba(0, 0, 0, 175))
  canvas.drawRect(44, 27, 232, 76, color)
  if glow == 1 then
    canvas.drawRect(46, 29, 228, 72, mp.rgba(255, 255, 255, 90))
  end if
  drawCentered(canvas, title, 44, 3, color)
  canvas.fillRect(83, 82, 154, 12, mp.rgb(255, 255, 255))
  drawCentered(canvas, subtitle, 84, 1, mp.rgb(30, 42, 60))
  canvas.drawSprite(tileSheet.getFrame(0), 32, 120)
  canvas.drawSprite(tileSheet.getFrame(0), 64, 120)
  canvas.drawSprite(tileSheet.getFrame(0), 224, 120)
  canvas.drawSprite(tileSheet.getFrame(0), 256, 120)
  canvas.drawSprite(playerSheet.getFrame(2 + menuFrame), 96, 104 + bob4(menuFrame))
  canvas.drawSprite(enemySheet.getFrame(menuPulse), 205, 112 + bob4((menuFrame + 1) % 4))
  canvas.drawSprite(tileSheet.getFrame(1 + menuPulse), 149, 118 + bob4(menuFrame))
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
