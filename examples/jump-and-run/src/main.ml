import minipixels as mp
import generated.assets as gen
import generated.levels as lvl

struct Player
  x
  y
  vx
  vy
  grounded
  facing
  coyote
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

struct Particle
  x
  y
  vx
  vy
  life
  color
  size
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
campfireSprite = void
enemies = []
coins = []
particles = []
enemyCount = 0
coinCount = 0
particleCount = 0
coinsTaken = 0
spawnX = 36
spawnY = 180
exitX = 720
exitY = 160
levelIntro = 0
hitFlash = 0

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

function resetParticles()
  global particles, particleCount
  particles = array(64)
  particleCount = 0
end function

function addParticle(x, y, vx, vy, life, color, size)
  global particles, particleCount
  if particleCount >= 64 then return end if
  particles[particleCount] = Particle(x, y, vx, vy, life, color, size)
  particleCount = particleCount + 1
end function

function burst(x, y, color)
  i = 0
  while i < 10
    vx = (((i % 5) - 2) * 22)
    vy = -44 - ((i % 3) * 18)
    addParticle(x + (i % 4), y + ((i % 2) * 4), vx, vy, 0.35 + ((i % 3) * 0.05), color, 2)
    i = i + 1
  end while
end function

function loadLevel(n)
  global levelIndex, player, camera, world, enemies, coins, enemyCount, coinCount, coinsTaken, spawnX, spawnY, exitX, exitY, levelIntro, hitFlash
  levelIndex = n
  w = lvl.width(n)
  h = lvl.height(n)
  data = lvl.tileData(n)
  world = mp.tilemap(32, 32, w, h, mp.tileset(tileSheet), 2)
  world.addLayer(mp.tileLayer("ground", w, h, data, true, false, 1, 1))
  world.addLayer(mp.tileLayer("collision", w, h, data, false, true, 1, 1))

  spawnX = lvl.spawnX(n)
  spawnY = lvl.spawnY(n)
  exitX = lvl.exitX(n)
  exitY = lvl.exitY(n)
  player = Player(spawnX, spawnY, 0, 0, false, 1, 0)
  camera = mp.camera(320, 180)
  camera.worldWidth = w * 32
  camera.worldHeight = h * 32

  enemies = array(6)
  coins = array(10)
  enemyCount = lvl.enemyCount(n)
  coinCount = lvl.coinCount(n)
  coinsTaken = 0
  levelIntro = 1.1
  hitFlash = 0
  resetParticles()

  i = 0
  while i < enemyCount
    setEnemy(i, lvl.enemyX(n, i), lvl.enemyY(n, i), lvl.enemyMinX(n, i), lvl.enemyMaxX(n, i))
    i = i + 1
  end while

  i = 0
  while i < coinCount
    setCoin(i, lvl.coinX(n, i), lvl.coinY(n, i))
    i = i + 1
  end while
end function

function resetLevel()
  loadLevel(levelIndex)
end function

function initialize(game)
  global tileSheet, playerSheet, enemySheet, coinSprite, exitSprite, cloudSprite, flowerSprite, sparkSprite, campfireSprite
  game.assets = gen.registry()
  tileSheet = gen.sheet_tiles()
  playerSheet = gen.sheet_player()
  enemySheet = gen.sheet_enemy()
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

function playerDie(game)
  global state, hitFlash
  mp.playSfx(game.audio, "assets\\audio\\hurt.wav")
  burst(player.x + 20, player.y + 16, mp.rgb(255, 90, 105))
  hitFlash = 0.18
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

function updateParticles(dt)
  global particles
  i = 0
  while i < particleCount
    p = particles[i]
    if p.life > 0 then
      p.x = p.x + (p.vx * dt)
      p.y = p.y + (p.vy * dt)
      p.vy = p.vy + (180 * dt)
      p.life = p.life - dt
      particles[i] = p
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
  global player, camera, coinsTaken, state, levelIndex, levelIntro, hitFlash
  updateParticles(dt)
  if hitFlash > 0 then hitFlash = hitFlash - dt end if
  if levelIntro > 0 then
    levelIntro = levelIntro - dt
    camera.follow(player.x, player.y)
    return
  end if
  player.vx = 0
  if game.input.left then
    player.vx = -130
    player.facing = -1
  end if
  if game.input.right then
    player.vx = 130
    player.facing = 1
  end if
  if (game.input.jump or game.input.up) and (player.grounded or player.coyote > 0) then
    player.vy = -315
    player.grounded = false
    player.coyote = 0
    mp.playSfx(game.audio, "assets\\audio\\jump.wav")
  end if
  player.vy = player.vy + (760 * dt)
  if player.vy > 360 then player.vy = 360 end if

  rect = mp.recti(player.x + 12, player.y + 6, 16, 26)
  res = mp.tileMoveAndCollide(world, rect, player.vx * dt, player.vy * dt)
  player.x = res.x - 12
  player.y = res.y - 6
  if player.x < 0 then
    player.x = 0
  end if
  if player.x > camera.worldWidth - 40 then
    player.x = camera.worldWidth - 40
  end if
  if res.hitBottom then
    player.vy = 0
    player.grounded = true
    player.coyote = 0.09
  else
    player.grounded = false
    player.coyote = player.coyote - dt
    if player.coyote < 0 then player.coyote = 0 end if
  end if
  if res.hitTop then player.vy = 0 end if
  if player.y > camera.worldHeight then
    playerDie(game)
    return
  end if

  updateEnemies(dt)
  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive and rectHit(player.x + 12, player.y + 6, 16, 26, e.x + 4, e.y + 4, 24, 22) then
      if player.vy > 20 and player.y + 31 < e.y + 14 then
        e.alive = false
        enemies[i] = e
        player.vy = -210
        burst(e.x + 16, e.y + 16, mp.rgb(255, 220, 80))
        hitFlash = 0.08
        mp.playSfx(game.audio, "assets\\audio\\coin.wav")
      else
        playerDie(game)
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false and rectHit(player.x + 12, player.y + 6, 16, 26, c.x + 6, c.y + 4, 20, 24) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
      burst(c.x + 16, c.y + 16, mp.rgb(255, 220, 80))
      hitFlash = 0.05
      mp.playSfx(game.audio, "assets\\audio\\coin.wav")
    end if
    i = i + 1
  end while

  if rectHit(player.x + 12, player.y + 6, 16, 26, exitX, exitY, 32, 64) and coinsTaken >= coinCount then
    if levelIndex < lvl.count() - 1 then
      loadLevel(levelIndex + 1)
      mp.playSfx(game.audio, "assets\\audio\\win.wav")
    else
      state = 2
      mp.playSfx(game.audio, "assets\\audio\\win.wav")
    end if
  end if

  camera.follow(player.x, player.y)
end function

function update(game, dt)
  global state
  if state == 0 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      loadLevel(0)
      mp.playSfx(game.audio, "assets\\audio\\coin.wav")
    end if
    return
  end if
  if state == 1 then
    updatePlay(game, dt)
    return
  end if
  if state == 2 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      loadLevel(0)
    end if
    return
  end if
  if state == 3 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      resetLevel()
    end if
  end if
end function

function drawParallax(canvas)
  canvas.clear(mp.rgb(125, 184, 198))
  canvas.fillRect(0, 82, 320, 98, mp.rgb(74, 105, 78))
  canvas.fillRect(0, 108, 320, 72, mp.rgb(54, 78, 58))
  canvas.fillRect(0 - (camera.x / 10), 62, 420, 24, mp.rgb(92, 123, 80))
  canvas.fillRect(40 - (camera.x / 7), 42, 76, 18, mp.rgb(106, 134, 88))
  canvas.fillRect(164 - (camera.x / 7), 34, 90, 22, mp.rgb(106, 134, 88))
  canvas.fillRect(286 - (camera.x / 7), 50, 88, 18, mp.rgb(106, 134, 88))
end function

function drawParticles(canvas)
  i = 0
  while i < particleCount
    p = particles[i]
    if p.life > 0 then
      mp.fillRectWorld(canvas, camera, p.x, p.y, p.size, p.size, p.color)
    end if
    i = i + 1
  end while
end function

function drawHud(canvas)
  canvas.fillRect(0, 0, 320, 18, mp.rgba(20, 28, 34, 170))
  mp.drawText(canvas, "LEVEL " + (levelIndex + 1), 7, 6, 1, mp.rgb(255, 255, 255))
  mp.drawText(canvas, "COINS " + coinsTaken + "/" + coinCount, 104, 6, 1, mp.rgb(255, 220, 80))
  canvas.fillRect(244, 6, 66, 5, mp.rgb(38, 62, 44))
  canvas.fillRect(244, 6, (coinsTaken * 66) / coinCount, 5, mp.rgb(116, 220, 98))
end function

function drawLevelIntro(canvas)
  if levelIntro <= 0 then return end if
  canvas.fillRect(0, 58, 320, 48, mp.rgba(0, 0, 0, 150))
  mp.drawTextCentered(canvas, "LEVEL " + (levelIndex + 1), 67, 2, mp.rgb(255, 255, 255))
  mp.drawTextCentered(canvas, "COLLECT ALL COINS", 91, 1, mp.rgb(255, 220, 80))
end function

function drawPlay(game, canvas)
  coinFrame = pulse2(game, 7)
  enemyFrame = cycle4(game, 9)
  exitFrame = 3 + pulse2(game, 12)
  runFrame = cycle4(game, 11)
  idleFrame = pulse2(game, 28)
  drawParallax(canvas)
  world.draw(canvas, camera)
  mp.drawSpriteWorldEx(canvas, camera, tileSheet.getFrame(exitFrame), exitX, exitY, false, false, 2, mp.rgba(255, 255, 255, 255))
  if coinsTaken < coinCount then
    sx = exitX - camera.x
    if sx > -48 and sx < 320 then
      mp.drawText(canvas, "LOCKED", sx - 4, exitY - camera.y - 10, 1, mp.rgb(255, 220, 80))
    end if
  end if

  for d = 0 to 10
    dx = 120 + (d * 146)
    mp.drawSpriteWorld(canvas, camera, tileSheet.getFrame(5), dx, 194)
  end for
  mp.drawSpriteWorld(canvas, camera, tileSheet.getFrame(6), 72, 192)

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false then
      cspr = tileSheet.getFrame(1 + coinFrame)
      mp.drawSpriteWorld(canvas, camera, cspr, c.x, c.y + bob4((coinFrame + i) % 4))
    end if
    i = i + 1
  end while

  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      spr = enemySheet.getFrame(enemyFrame)
      if e.dir < 0 then
        mp.drawSpriteWorldEx(canvas, camera, spr, e.x, e.y, true, false, 1, mp.rgba(255, 255, 255, 255))
      else
        mp.drawSpriteWorld(canvas, camera, spr, e.x, e.y)
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
    mp.drawSpriteWorldEx(canvas, camera, pspr, player.x, player.y, true, false, 1, mp.rgba(255, 255, 255, 255))
  else
    mp.drawSpriteWorld(canvas, camera, pspr, player.x, player.y)
  end if

  drawParticles(canvas)
  drawHud(canvas)
  drawLevelIntro(canvas)
  if hitFlash > 0 then
    canvas.fillRect(0, 0, 320, 180, mp.rgba(255, 255, 255, 35))
  end if
end function

function drawMenuScreen(game, canvas, title, subtitle, color)
  menuFrame = cycle4(game, 11)
  menuPulse = pulse2(game, 8)
  glow = pulse2(game, 18)
  canvas.clear(mp.rgb(125, 184, 198))
  canvas.fillRect(0, 82, 320, 98, mp.rgb(74, 105, 78))
  canvas.fillRect(0, 108, 320, 72, mp.rgb(54, 78, 58))
  canvas.fillRect(0, 136, 320, 44, mp.rgb(44, 74, 48))
  canvas.fillRect(0, 150, 320, 30, mp.rgb(34, 58, 40))
  canvas.fillRect(44, 27, 232, 76, mp.rgba(0, 0, 0, 175))
  canvas.drawRect(44, 27, 232, 76, color)
  if glow == 1 then
    canvas.drawRect(46, 29, 228, 72, mp.rgba(255, 255, 255, 90))
  end if
  mp.drawTextCentered(canvas, title, 44, 3, color)
  canvas.fillRect(83, 82, 154, 12, mp.rgb(255, 255, 255))
  mp.drawTextCentered(canvas, subtitle, 84, 1, mp.rgb(30, 42, 60))
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
