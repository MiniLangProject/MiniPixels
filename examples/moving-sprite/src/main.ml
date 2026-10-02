import minipixels as mp
import generated.assets as gen
import "../../showcase.ml" as showcase

playerX = 152
playerY = 100
playerSprite = void
background = void

function initialize(game)
  global playerSprite, background
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
  background = game.assets.getSprite("background")
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
  canvas.drawSprite(background, 0, 0)
  showcase.heading(canvas, "SPRITE LAB", "ARROWS MOVE / ESC EXIT")
  canvas.drawSprite(playerSprite, playerX - (playerX % 1), playerY - (playerY % 1))
end function

function shutdown(game)
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Moving Sprite", 320, 180, 4)
  cfg.debug = false
  return showcase.run(args, cfg, initialize, update, render, shutdown)
end function
