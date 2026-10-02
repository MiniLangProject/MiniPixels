import minipixels as mp
import generated.assets as gen
import generated.levels as lvl
import "../../showcase.ml" as showcase
import "gameplay.ml" as play

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
captureMode = false
previewLevel = 0
motionPreview = ""
motionPortal = false
levelIndex = 0
player = void
camera = void
cameraMotion = void
world = void
tileSheet = void
bgBaseSprite = void
bgNearSprite = void
decorSheet = void
treeSheet = void
playerSheet = void
playerRunSheet = void
enemySheet = void
coinSheet = void
portalSheet = void
cloudSprite = void
flowerSprite = void
sparkSprite = void
campfireSprite = void
jumpSfx = void
coinSfx = void
hurtSfx = void
winSfx = void
enemies = []
coins = []
particles = []
enemyCount = 0
coinCount = 0
particleCount = 0
particleCursor = 0
coinsTaken = 0
spawnX = 36
spawnY = 180
exitX = 720
exitY = 160
levelIntro = 0
hitFlash = 0
lives = 3
invuln = 0
animationTime = 0

function intDiv(n, d)
  return (n - (n % d)) / d
end function

function setCoin(i, x, y)
  global coins
  coins[i] = Coin(x, y, false)
end function

function setEnemy(i, x, y, minX, maxX, kind)
  global enemies
  enemies[i] = play.enemy(x, y, minX, maxX, kind)
end function

function resetParticles()
  global particles, particleCount, particleCursor
  particles = array(64)
  particleCount = 0
  particleCursor = 0
end function

function addParticle(x, y, vx, vy, life, color, size)
  global particles, particleCount, particleCursor
  i = 0
  while i < particleCount
    p = particles[i]
    if p == void or p.life <= 0 then
      particles[i] = Particle(x, y, vx, vy, life, color, size)
      return
    end if
    i = i + 1
  end while
  if particleCount >= 64 then
    particles[particleCursor] = Particle(x, y, vx, vy, life, color, size)
    particleCursor = (particleCursor + 1) % 64
    return
  end if
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

function loadLevelAssets(n)
  global bgBaseSprite, bgNearSprite
  if n == 0 then
    bgBaseSprite = gen.make_bg_base_0()
    bgNearSprite = gen.make_bg_near_0()
    return
  end if
  if n == 1 then
    bgBaseSprite = gen.make_bg_base_1()
    bgNearSprite = gen.make_bg_near_1()
    return
  end if
  bgBaseSprite = gen.make_bg_base_2()
  bgNearSprite = gen.make_bg_near_2()
end function

function loadLevel(n)
  global levelIndex, player, camera, world, enemies, coins, enemyCount, coinCount, coinsTaken, spawnX, spawnY, exitX, exitY, levelIntro, hitFlash, invuln
  global cameraMotion
  levelIndex = n
  loadLevelAssets(n)
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
  player = play.player(spawnX, spawnY)
  play.stepPlayer(player, world, false, false, false, 1.0 / 60)
  camera = mp.camera(400, 225)
  camera.worldWidth = w * 32
  camera.worldHeight = h * 32
  cameraMotion = play.initializeCamera(camera, player)

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
  global tileSheet, decorSheet, playerSheet, enemySheet, coinSheet, portalSheet, cloudSprite, flowerSprite, sparkSprite, campfireSprite, jumpSfx, coinSfx, hurtSfx, winSfx
  global state, levelIntro
  global playerRunSheet, treeSheet
  global player, cameraMotion
  tileSheet = gen.sheet_tiles()
  decorSheet = gen.sheet_decor()
  treeSheet = gen.sheet_trees()
  playerSheet = gen.sheet_player()
  playerRunSheet = gen.sheet_player_run()
  enemySheet = gen.sheet_enemy()
  jumpSfx = gen.audio_jump_sfx()
  coinSfx = gen.audio_coin_sfx()
  hurtSfx = gen.audio_hurt_sfx()
  winSfx = gen.audio_win_sfx()
  coinSheet = gen.sheet_coin()
  portalSheet = gen.sheet_portal()
  cloudSprite = tileSheet.getFrame(5)
  flowerSprite = tileSheet.getFrame(5)
  sparkSprite = tileSheet.getFrame(6)
  campfireSprite = tileSheet.getFrame(6)
  loadLevel(previewLevel)
  if captureMode then
    state = 1
    levelIntro = 0
  end if
  if motionPortal then
    player = play.player(exitX - 120, 192)
    cameraMotion = play.initializeCamera(camera, player)
  end if
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
  mp.playAudio(game.audio, hurtSfx)
  burst(player.x + 16, player.y + 18, mp.rgb(255, 90, 105))
  hitFlash = 0.18
  lives = 0
  state = 3
end function

function playerHurt(game)
  global lives, invuln, hitFlash, player, state
  if invuln > 0 then return end if
  lives = lives - 1
  mp.playAudio(game.audio, hurtSfx)
  burst(player.x + 16, player.y + 18, mp.rgb(255, 90, 105))
  hitFlash = 0.18
  if lives <= 0 then
    state = 3
    return
  end if
  invuln = 2.5
  player.vy = -145
  player.grounded = false
  player.coyote = 0
  player.jumpBuffer = 0
end function

function updateEnemies(dt)
  global enemies
  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      play.stepEnemy(e, world, dt)
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
    if p != void and p.life > 0 then
      p.x = p.x + (p.vx * dt)
      p.y = p.y + (p.vy * dt)
      p.vy = p.vy + (180 * dt)
      p.life = p.life - dt
      particles[i] = p
    end if
    i = i + 1
  end while
end function

function pulse2(game, speed)
  return play.floorInt(animationTime * 60 / speed) % 2
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
    player.jumpHeld = game.input.jump or game.input.up
    play.followCamera(camera, cameraMotion, player, dt)
    return
  end if
  previousFeet = player.y + 32
  jumpNow = play.stepPlayer(player, world, game.input.left, game.input.right, game.input.jump or game.input.up, dt)
  if jumpNow then mp.playAudio(game.audio, jumpSfx) end if
  if player.y > camera.worldHeight then
    playerDie(game)
    return
  end if

  updateEnemies(dt)
  i = 0
  while i < enemyCount
    e = enemies[i]
    enemyTop = e.y + 12
    if e.kind == play.BAT then enemyTop = e.y + 7 end if
    if e.alive and rectHit(player.x + 9, player.y + 4, 14, 28, e.x + 4, enemyTop, 24, 32 - (enemyTop - e.y)) then
      if player.vy > 0 and previousFeet <= enemyTop + 6 then
        e.alive = false
        enemies[i] = e
        player.vy = -210
        player.grounded = false
        player.coyote = 0
        coinBurst(e.x + 16, e.y + 16)
        hitFlash = 0.08
        mp.playAudio(game.audio, coinSfx)
      else
        playerHurt(game)
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false and play.collectsCoin(player, c.x, c.y) then
      c.got = true
      coins[i] = c
      coinsTaken = coinsTaken + 1
      coinBurst(c.x + 16, c.y + 16)
      mp.playAudio(game.audio, coinSfx)
    end if
    i = i + 1
  end while

  if rectHit(player.x + 9, player.y + 13, 14, 19, exitX, exitY, 32, 64) and coinsTaken >= coinCount then
    if levelIndex < lvl.count() - 1 then
      loadLevel(levelIndex + 1)
      mp.playAudio(game.audio, winSfx)
    else
      state = 2
      mp.playAudio(game.audio, winSfx)
    end if
  end if

  play.followCamera(camera, cameraMotion, player, dt)
end function

function update(game, dt)
  global state, lives, animationTime
  animationTime = animationTime + dt
  if motionPreview != "" and motionPortal == false then
    game.input.right = game.time.frameNumber < 130
    game.input.jump = game.time.frameNumber >= 40 and game.time.frameNumber < 90
  end if
  if state == 0 then
    if mp.inputPressed(game.input, "jump") or mp.inputPressed(game.input, "up") then
      state = 1
      lives = 3
      loadLevel(0)
      mp.playAudio(game.audio, coinSfx)
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

function drawParallaxLayer(canvas, spr, divisor, y)
  if spr == void then return end if
  shift = 0
  layerWidth = spr.width
  if divisor > 0 then shift = intDiv(camera.x, divisor) % layerWidth end if
  canvas.drawSprite(spr, 0 - shift, y)
  if shift > 0 then
    canvas.drawSprite(spr, layerWidth - shift, y)
  end if
end function

function drawParallax(canvas)
  drawParallaxLayer(canvas, bgBaseSprite, 0, 0)
  drawParallaxLayer(canvas, bgNearSprite, 5, play.forestLayerY(camera, bgNearSprite.height))
end function

function drawBackDecor(canvas)
  for d = 0 to 5
    x = 430 + (d * 560)
    mp.drawSpriteWorld(canvas, camera, treeSheet.getFrame(d % 2), x, play.decorY(world, x + 32, 2))
  end for
end function

function drawFrontDecor(canvas)
  for d = 0 to 20
    x = 90 + (d * 150)
    frame = d % 2
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(frame), x, play.decorY(world, x + 16, 1))
  end for
  for d = 0 to 8
    x = 260 + (d * 360)
    mp.drawSpriteWorld(canvas, camera, decorSheet.getFrame(5), x, play.decorY(world, x + 16, 1))
  end for
end function

function drawParticles(canvas)
  i = 0
  while i < particleCount
    p = particles[i]
    if p != void and p.life > 0 then
      mp.fillRectWorld(canvas, camera, p.x, p.y, p.size, p.size, p.color)
    end if
    i = i + 1
  end while
end function

function drawHud(canvas)
  canvas.fillRect(8, 8, 384, 22, mp.rgba(12, 28, 42, 225))
  canvas.fillRect(8, 8, 2, 22, mp.rgb(100, 222, 193))
  mp.drawText(canvas, "TRAIL " + (levelIndex + 1), 17, 16, 1, mp.rgb(237, 241, 214))
  mp.drawText(canvas, "COINS " + coinsTaken + "/" + coinCount, 126, 16, 1, mp.rgb(247, 205, 110))
  mp.drawText(canvas, "HP " + lives, 268, 16, 1, mp.rgb(235, 150, 134))
  canvas.fillRect(330, 16, 50, 4, mp.rgb(38, 62, 64))
  canvas.fillRect(330, 16, (coinsTaken * 50) / coinCount, 4, mp.rgb(100, 222, 193))
end function

function drawLevelIntro(canvas)
  if levelIntro <= 0 then return end if
  canvas.fillRect(0, 78, 400, 48, mp.rgba(0, 0, 0, 150))
  mp.drawTextCentered(canvas, "LEVEL " + (levelIndex + 1), 87, 2, mp.rgb(255, 255, 255))
  mp.drawTextCentered(canvas, "COLLECT ALL COINS", 111, 1, mp.rgb(255, 220, 80))
end function

function drawPlay(game, canvas)
  coinFrame = play.coinFrame(animationTime)
  exitFrame = play.portalFrame(animationTime)
  drawParallax(canvas)
  drawBackDecor(canvas)
  world.draw(canvas, camera)
  drawFrontDecor(canvas)
  mp.drawSpriteWorldEx(canvas, camera, portalSheet.getFrame(exitFrame), exitX, exitY + 2, false, false, 2, mp.rgba(255, 255, 255, 255))
  if coinsTaken < coinCount then
    sx = exitX - camera.x
    if sx > -48 and sx < 400 then
      mp.drawText(canvas, "LOCKED", sx - 4, exitY - camera.y - 10, 1, mp.rgb(255, 220, 80))
    end if
  end if

  for d = 0 to 15
    dx = 120 + (d * 146)
    mp.drawSpriteWorld(canvas, camera, tileSheet.getFrame(5), dx, play.decorY(world, dx + 16, 1))
  end for
  mp.drawSpriteWorld(canvas, camera, tileSheet.getFrame(6), 72, play.decorY(world, 88, 1))

  i = 0
  while i < coinCount
    c = coins[i]
    if c.got == false then
      cspr = coinSheet.getFrame(coinFrame)
      mp.drawSpriteWorld(canvas, camera, cspr, c.x, c.y + play.coinBob(animationTime, i))
    end if
    i = i + 1
  end while

  i = 0
  while i < enemyCount
    e = enemies[i]
    if e.alive then
      spr = enemySheet.getFrame(play.enemyFrame(e))
      if e.dir < 0 then
        mp.drawSpriteWorldEx(canvas, camera, spr, e.x, e.y + 1, true, false, 1, mp.rgba(255, 255, 255, 255))
      else
        mp.drawSpriteWorld(canvas, camera, spr, e.x, e.y + 1)
      end if
    end if
    i = i + 1
  end while

  pframe = play.playerFrame(player)
  pspr = playerSheet.getFrame(pframe)
  if player.grounded and player.vx != 0 then pspr = playerRunSheet.getFrame(play.playerRunFrame(player)) end if
  drawPlayer = true
  if invuln > 0 and pulse2(game, 4) == 1 then drawPlayer = false end if
  if drawPlayer then
    if player.facing < 0 then
      mp.drawSpriteWorldEx(canvas, camera, pspr, player.x, player.y + 1, true, false, 1, mp.rgba(255, 255, 255, 255))
    else
      mp.drawSpriteWorld(canvas, camera, pspr, player.x, player.y + 1)
    end if
  end if

  drawParticles(canvas)
  drawHud(canvas)
  drawLevelIntro(canvas)
end function

function drawMenuScreen(game, canvas, title, subtitle, color)
  menuPulse = pulse2(game, 18)
  glow = pulse2(game, 18)
  drawParallax(canvas)
  canvas.drawSprite(treeSheet.getFrame(0), 16, 116)
  canvas.drawSprite(treeSheet.getFrame(1), 320, 116)
  canvas.fillRect(84, 48, 232, 82, mp.rgba(12, 28, 42, 232))
  canvas.drawRect(84, 48, 232, 82, color)
  if glow == 1 then
    canvas.drawRect(86, 50, 228, 78, mp.rgba(255, 255, 255, 90))
  end if
  mp.drawTextCentered(canvas, title, 65, 3, color)
  mp.drawTextCentered(canvas, subtitle, 106, 1, mp.rgb(237, 241, 214))
  mp.drawTextCentered(canvas, "ARROWS MOVE / SPACE JUMP / ESC EXIT", 210, 1, mp.rgb(237, 241, 214))
  canvas.drawSprite(tileSheet.getFrame(0), 112, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 144, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 176, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 208, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 240, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 272, 162)
  canvas.drawSprite(tileSheet.getFrame(0), 288, 162)
  canvas.drawSprite(playerSheet.getFrame(pulse2(game, 27)), 176, 131)
  canvas.drawSprite(enemySheet.getFrame(menuPulse), 276, 131)
  canvas.drawSprite(coinSheet.getFrame(play.coinFrame(animationTime)), 219, 130 + play.coinBob(animationTime, 0))
end function

function render(game, canvas)
  if state == 0 then
    canvas.clear(mp.rgb(18, 24, 42))
    drawMenuScreen(game, canvas, "SKYLINE RUN", "SPACE OR UP", mp.rgb(78, 205, 196))
    return
  end if
  if state == 1 then
    drawPlay(game, canvas)
    if motionPreview != "" and game.time.frameNumber % 5 == 0 then
      saved = mp.saveCanvasPng(canvas, motionPreview + "-" + game.time.frameNumber + ".png")
      if typeof(saved) == "error" then return saved end if
    end if
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
  global captureMode, previewLevel, motionPreview, motionPortal
  if len(args) >= 2 and args[0] == "--motion-preview" then
    motionPreview = args[1]
    if len(args) >= 3 and args[2] == "portal" then motionPortal = true end if
    captureMode = true
    cfg = mp.createConfig("Skyline animation preview", 400, 225, 1)
    cfg.headlessFrames = 180
    result = mp.runHeadless(cfg, initialize, update, render, void)
    if typeof(result) == "error" then return result end if
    return 0
  end if
  if len(args) >= 3 and args[0] == "--screenshot" and args[2] == "play" then
    captureMode = true
    if len(args) >= 4 and args[3] == "1" then previewLevel = 1 end if
    if len(args) >= 4 and args[3] == "2" then previewLevel = 2 end if
  end if
  cfg = mp.createConfig("MiniPixels Skyline Run", 400, 225, 4)
  cfg = mp.useGpuRenderer(cfg)
  return showcase.run(args, cfg, initialize, update, render, void)
end function
