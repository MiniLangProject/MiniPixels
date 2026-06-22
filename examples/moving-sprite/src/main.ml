import minipixels as mp
import generated.assets as gen

playerX = 40
playerY = 40
playerSprite = void

function initialize(game)
  global playerSprite
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function

function update(game, dt)
  global playerX, playerY
  speed = 90 * dt
  if game.input.left then playerX = playerX - speed end if
  if game.input.right then playerX = playerX + speed end if
  if game.input.up then playerY = playerY - speed end if
  if game.input.down then playerY = playerY + speed end if
  if playerX < 0 then playerX = 0 end if
  if playerY < 0 then playerY = 0 end if
  if playerX > game.config.width - 16 then playerX = game.config.width - 16 end if
  if playerY > game.config.height - 16 then playerY = game.config.height - 16 end if
end function

function render(game, canvas)
  canvas.clear(mp.rgb(20, 20, 30))
  canvas.drawSprite(playerSprite, playerX - (playerX % 1), playerY - (playerY % 1))
end function

function shutdown(game)
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Moving Sprite", 320, 180, 4)
  cfg.debug = false
  return mp.run(cfg, initialize, update, render, shutdown)
end function
