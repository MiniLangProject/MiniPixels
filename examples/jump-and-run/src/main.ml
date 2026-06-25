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
  kind
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
bgFarSheet = void
decorSheet = void
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
lives = 3
invuln = 0

function intDiv(n, d)
  return (n - (n % d)) / d
end function

function setCoin(i, x, y)
  global coins
  coins[i] = Coin(x, y, false)
end function

function setEnemy(i, x, y, minX, maxX, kind)
  global enemies
  enemies[i] = Enemy(x, y, minX, maxX, 1, true, kind)
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

function coinBurst(x, y)
  i = 0
  while i < 14
    vx = (((i % 7) - 3) * 24)
    vy = -38 - ((i % 4) * 16)
    color = mp.rgb(255, 220, 80)
    if i % 3 == 1 then color = mp.rgb(255, 170, 55) end if
    if i % 3 == 2 then color = mp.rgb(255, 245, 160) end if
    size = 1
    if i % 4 == 0 then size = 2 end if
    addParticle(x + (i % 5), y + ((i % 3) * 3), vx, vy, 0.42 + ((i % 4) * 0.04), color, size)
    i = i + 1
  end while
end function

function loadLevel(n)
  global levelIndex, player, camera, world, enemies, coins, enemyCount, coinCount, coinsTaken, spawnX, spawnY, exitX, exitY, levelIntro, hitFlash, invuln
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
  camera = mp.camera(400, 225)
  camera.worldWidth = w * 32
  camera.worldHeight = h * 32

  enemies = array(16)
  coins = array(32)
  enemyCount = lvl.enemyCount(n)
  coinCount = lvl.coinCount(n)
  coinsTaken = 0
  levelIntro = 1.1
  hitFlash = 0
  invuln = 0
  resetParticles()

  i = 0
  while i < enemyCount
    setEnemy(i, lvl.enemyX(n, i), lvl.enemyY(n, i), lvl.enemyMinX(n, i), lvl.enemyMaxX(n, i), lvl.enemyKind(n, i))
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
  global tileSheet, bgFarSheet, decorSheet, playerSheet, enemySheet, coinSprite, exitSprite, cloudSprite, flowerSprite, sparkSprite, campfireSprite
  game.assets = gen.registry()
  tileSheet = gen.sheet_tiles()
  bgFarSheet = gen.sheet_bg_far()
  decorSheet = gen.sheet_decor()
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
  global state, hitFlash, lives
  mp.playSfx(game.audio, "assets\\audio\\hurt.wav")
  burst(player.x + 16, player.y + 18, mp.rgb(255, 90, 105))
  hitFlash = 0.18
  lives = 0
  state = 3
end function

function playerHurt(game)
  global lives, invuln, hitFlash, player, state
  if invuln > 0 then return end if
  lives = lives - 1
  mp.playSfx(game.audio, "assets\\audio\\hurt.wav")
  burst(player.x + 16, player.y + 18, mp.rgb(255, 90, 105))
  hitFlash = 0.18
  if lives <= 0 then
    state = 3
    return
  end if
  invuln = 2.5
  player.vy = -145
  player.grounded = false
end function

function updateEnemies(dt)
  global enemies
  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      speed = 48
      if e.kind == 1 then speed = 34 end if
      e.x = e.x + (e.dir * speed * dt)
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
  global player, camera, coinsTaken, state, levelIndex, levelIntro, hitFlash, invuln
  updateParticles(dt)
  if hitFlash > 0 then hitFlash = hitFlash - dt end if
  if invuln > 0 then
    invuln = invuln - dt
    if invuln < 0 then invuln = 0 end if
  end if
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
  jumpNow = (game.input.jump or game.input.up) and (player.grounded or player.coyote > 0)
  if jumpNow then
    player.vy = -315
    player.grounded = false
    player.coyote = 0
    mp.playSfx(game.audio, "assets\\audio\\jump.wav")
  else
    if player.grounded then player.vy = 0 end if
  end if
  if player.grounded == false then
    player.vy = player.vy + (760 * dt)
  end if
  if player.vy > 360 then player.vy = 360 end if

  rect = mp.recti(player.x + 9, player.y + 13, 14, 19)
  moveY = player.vy * dt
  if player.grounded and jumpNow == false then moveY = 1 end if
  res = mp.tileMoveAndCollide(world, rect, player.vx * dt, moveY)
  player.x = res.x - 9
  player.y = res.y - 13
  if player.x < 0 then
    player.x = 0
  end if
  if player.x > camera.worldWidth - 32 then
    player.x = camera.worldWidth - 32
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
    if e.alive and rectHit(player.x + 9, player.y + 13, 14, 19, e.x + 4, e.y + 4, 24, 22) then
      if player.vy > 20 and player.y + 31 < e.y + 14 then
        e.alive = false
        enemies[i] = e
        player.vy = -210
        coinBurst(e.x + 16, e.y + 16)
        hitFlash = 0.08
        mp.playSfx(game.audio, "assets\\audio\\coin.wav")
      else
        playerHurt(game)
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false and rectHit(player.x + 9, player.y + 13, 14, 19, c.x + 6, c.y + 4, 20, 24) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
      coinBurst(c.x + 16, c.y + 16)
      mp.playSfx(game.audio, "assets\\audio\\coin.wav")
    end if
    i = i + 1
  end while

  if rectHit(player.x + 9, player.y + 13, 14, 19, exitX, exitY, 32, 64) and coinsTaken >= coinCount then
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
  global state, lives
  if state == 0 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      lives = 3
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
      lives = 3
      loadLevel(0)
    end if
    return
  end if
  if state == 3 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      lives = 3
      loadLevel(0)
    end if
  end if
end function

function drawBgLayer(canvas, sheet, divisor, y)
  frame = sheet.getFrame(levelIndex)
  canvas.drawSpriteEx(frame, 0, y, false, false, 4, mp.rgba(255, 255, 255, 255))
end function

function drawSkyBirds(canvas, frame, baseY, step, divisor)
  spr = decorSheet.getFrame(frame)
  shift = (camera.x / divisor) % step
  x = 0 - shift
  i = 0
  while x < 430
    y = baseY + ((i % 3) * 4)
    canvas.drawSprite(spr, x, y)
    x = x + step
    i = i + 1
  end while
end function

function drawTreeBand(canvas, divisor, baseY, color, trunkColor, step, maxHeight)
  shift = (camera.x / divisor) % (step * 8)
  x = 0 - shift
  i = 0
  while x < 420
    h = 18 + ((i % 5) * (maxHeight / 5))
    canvas.fillRect(x + 3, baseY - h, 4, h, trunkColor)
    canvas.fillRect(x, baseY - h - 8, 16, h + 10, color)
    canvas.fillRect(x + 5, baseY - h - 15, 6, 10, color)
    x = x + step
    i = i + 1
  end while
end function

function drawParallax(canvas)
  drawBgLayer(canvas, bgFarSheet, 16, 0)
  drawSkyBirds(canvas, 0, 29, 220, 20)
  drawSkyBirds(canvas, 1, 49, 276, 16)
  drawTreeBand(canvas, 10, 175, mp.rgba(67, 91, 58, 190), mp.rgba(43, 58, 40, 210), 30, 18)
  drawTreeBand(canvas, 5, 198, mp.rgba(42, 67, 45, 210), mp.rgba(30, 45, 32, 230), 26, 26)
  canvas.fillRect(0, 202, 400, 23, mp.rgba(39, 57, 39, 165))
end function

function drawBackDecor(canvas)
  for d = 0 to 11
    x = 160 + (d * 294)
    frame = 3 + (d % 3)
    y = 192
    if d % 2 == 1 then y = 160 end if
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(frame), x, y)
  end for
  for d = 0 to 5
    x = 430 + (d * 560)
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(9 + (d % 2)), x, 192)
  end for
end function

function drawFrontDecor(canvas)
  for d = 0 to 20
    x = 90 + (d * 150)
    frame = 6 + (d % 2)
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(frame), x, 204)
  end for
  for d = 0 to 8
    x = 260 + (d * 360)
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(11), x, 192)
  end for
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
  canvas.fillRect(0, 0, 400, 18, mp.rgba(20, 28, 34, 170))
  mp.drawText(canvas, "LEVEL " + (levelIndex + 1), 7, 6, 1, mp.rgb(255, 255, 255))
  mp.drawText(canvas, "COINS " + coinsTaken + "/" + coinCount, 122, 6, 1, mp.rgb(255, 220, 80))
  mp.drawText(canvas, "HP " + lives, 258, 6, 1, mp.rgb(255, 110, 120))
  canvas.fillRect(326, 6, 62, 5, mp.rgb(38, 62, 44))
  canvas.fillRect(326, 6, (coinsTaken * 62) / coinCount, 5, mp.rgb(116, 220, 98))
end function

function drawLevelIntro(canvas)
  if levelIntro <= 0 then return end if
  canvas.fillRect(0, 78, 400, 48, mp.rgba(0, 0, 0, 150))
  mp.drawTextCentered(canvas, "LEVEL " + (levelIndex + 1), 87, 2, mp.rgb(255, 255, 255))
  mp.drawTextCentered(canvas, "COLLECT ALL COINS", 111, 1, mp.rgb(255, 220, 80))
end function

function drawPlay(game, canvas)
  coinFrame = pulse2(game, 7)
  enemyFrame = cycle4(game, 9)
  exitFrame = 3 + pulse2(game, 12)
  runFrame = cycle4(game, 7)
  drawParallax(canvas)
  drawBackDecor(canvas)
  world.draw(canvas, camera)
  drawFrontDecor(canvas)
  mp.drawSpriteWorldEx(canvas, camera, tileSheet.getFrame(exitFrame), exitX, exitY, false, false, 2, mp.rgba(255, 255, 255, 255))
  if coinsTaken < coinCount then
    sx = exitX - camera.x
    if sx > -48 and sx < 400 then
      mp.drawText(canvas, "LOCKED", sx - 4, exitY - camera.y - 10, 1, mp.rgb(255, 220, 80))
    end if
  end if

  for d = 0 to 15
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
      spr = enemySheet.getFrame((e.kind * 4) + enemyFrame)
      if e.dir < 0 then
        mp.drawSpriteWorldEx(canvas, camera, spr, e.x, e.y, true, false, 1, mp.rgba(255, 255, 255, 255))
      else
        mp.drawSpriteWorld(canvas, camera, spr, e.x, e.y)
      end if
    end if
    i = i + 1
  end while

  pframe = 0
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
  drawPlayer = true
  if invuln > 0 and pulse2(game, 4) == 1 then drawPlayer = false end if
  if drawPlayer then
    if player.facing < 0 then
      mp.drawSpriteWorldEx(canvas, camera, pspr, player.x, player.y, true, false, 1, mp.rgba(255, 255, 255, 255))
    else
      mp.drawSpriteWorld(canvas, camera, pspr, player.x, player.y)
    end if
  end if

  drawParticles(canvas)
  drawHud(canvas)
  drawLevelIntro(canvas)
end function

function drawMenuScreen(game, canvas, title, subtitle, color)
  menuPulse = pulse2(game, 18)
  glow = pulse2(game, 18)
  canvas.drawSpriteEx(bgFarSheet.getFrame(0), 0, 0, false, false, 4, mp.rgba(255, 255, 255, 255))
  drawSkyBirds(canvas, 0, 29, 220, 20)
  drawSkyBirds(canvas, 1, 49, 276, 16)
  drawTreeBand(canvas, 10, 175, mp.rgba(67, 91, 58, 190), mp.rgba(43, 58, 40, 210), 30, 18)
  drawTreeBand(canvas, 5, 198, mp.rgba(42, 67, 45, 210), mp.rgba(30, 45, 32, 230), 26, 26)
  canvas.drawSprite(decorSheet.getFrame(3), 38, 150)
  canvas.drawSprite(decorSheet.getFrame(4), 326, 151)
  canvas.drawSprite(decorSheet.getFrame(10), 44, 160)
  canvas.drawSprite(decorSheet.getFrame(9), 326, 160)
  canvas.fillRect(0, 160, 400, 65, mp.rgba(24, 42, 30, 120))
  canvas.fillRect(84, 48, 232, 76, mp.rgba(0, 0, 0, 175))
  canvas.drawRect(84, 48, 232, 76, color)
  if glow == 1 then
    canvas.drawRect(86, 50, 228, 72, mp.rgba(255, 255, 255, 90))
  end if
  mp.drawTextCentered(canvas, title, 65, 3, color)
  canvas.fillRect(123, 103, 154, 12, mp.rgb(255, 255, 255))
  mp.drawTextCentered(canvas, subtitle, 105, 1, mp.rgb(30, 42, 60))
  canvas.drawSprite(tileSheet.getFrame(0), 112, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 144, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 256, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 288, 162)
  canvas.drawSprite(playerSheet.getFrame(0), 176, 146)
  canvas.drawSprite(enemySheet.getFrame(menuPulse), 245, 154)
  canvas.drawSprite(tileSheet.getFrame(1 + menuPulse), 197, 160)
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
  cfg = mp.createConfig("MiniPixels Skyline Run", 400, 225, 4)
  cfg = mp.useGpuRenderer(cfg)
  return mp.run(cfg, initialize, update, render, void)
end function
