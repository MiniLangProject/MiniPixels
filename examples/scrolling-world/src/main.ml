import minipixels as mp
import generated.assets as gen
import "player.ml" as pmod
import "world.ml" as wmod
import "../../showcase.ml" as showcase

player = void
world = void
camera = void
background = void
near = void

function initialize(game)
  global player, world, camera, background, near
  game.assets = gen.registry()
  background = game.assets.getSprite("background")
  near = game.assets.getSprite("near")
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
  canvas.drawSprite(background, 0, 0)
  shift = (camera.x / 5) % near.width
  canvas.drawSprite(near, 0 - shift, 55)
  canvas.drawSprite(near, near.width - shift, 55)
  world.draw(canvas, camera)
  canvas.drawSpriteEx(player.animation.currentSprite(), player.x - camera.x, player.y - camera.y, player.vx < 0, false, 1, mp.rgba(255, 255, 255, 255))
  showcase.heading(canvas, "FOREST TRAIL", "ARROWS MOVE / SPACE JUMP")
  if game.debug then
    canvas.drawRect(player.x - camera.x, player.y - camera.y, 12, 15, mp.rgb(255, 60, 60))
  end if
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Scrolling World", 320, 180, 4)
  cfg.debug = false
  return showcase.run(args, cfg, initialize, update, render, void)
end function
