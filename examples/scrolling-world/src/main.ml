import minipixels as mp
import generated.assets as gen
import "player.ml" as pmod
import "world.ml" as wmod

player = void
world = void
camera = void

function initialize(game)
  global player, world, camera
  game.assets = gen.registry()
  player = pmod.create(game.assets.getSprite("player"))
  world = wmod.create(game.assets.getSprite("world"))
  camera = mp.camera(game.config.width, game.config.height)
  camera.worldWidth = world.width * world.tileWidth
  camera.worldHeight = world.height * world.tileHeight
end function

function update(game, dt)
  global player, world, camera
  accel = 180
  player.vx = 0
  if game.input.left then player.vx = 0 - accel end if
  if game.input.right then player.vx = accel end if
  player.vy = player.vy + (520 * dt)
  if game.input.jump and player.grounded then
    player.vy = -220
    player.grounded = false
  end if
  rect = mp.recti(player.x, player.y, 12, 15)
  res = mp.tileMoveAndCollide(world, rect, player.vx * dt, player.vy * dt)
  player.x = res.x
  player.y = res.y
  if res.hitBottom then
    player.vy = 0
    player.grounded = true
  else
    player.grounded = false
  end if
  player.animation.update(dt)
  camera.follow(player.x, player.y)
end function

function render(game, canvas)
  global player, world, camera
  canvas.clear(mp.rgb(48, 78, 112))
  canvas.fillRect(0 - (camera.x / 5), 24, 800, 22, mp.rgb(72, 110, 158))
  canvas.fillRect(40 - (camera.x / 3), 70, 120, 18, mp.rgb(58, 96, 132))
  canvas.fillRect(210 - (camera.x / 3), 62, 160, 26, mp.rgb(58, 96, 132))
  canvas.fillRect(430 - (camera.x / 3), 78, 140, 16, mp.rgb(58, 96, 132))
  world.draw(canvas, camera)
  canvas.drawSprite(player.animation.currentSprite(), player.x - camera.x, player.y - camera.y)
  if game.debug then
    canvas.drawRect(player.x - camera.x, player.y - camera.y, 12, 15, mp.rgb(255, 60, 60))
  end if
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Scrolling World", 320, 180, 4)
  cfg.debug = false
  return mp.run(cfg, initialize, update, render, void)
end function
