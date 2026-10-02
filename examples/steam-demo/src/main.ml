import minipixels as mp
import minipixels.steam as steam
import "../../showcase.ml" as showcase

notice = "SPACE OPENS FRIENDS / ESC EXITS"

function update(game, dt)
  global notice
  if game.input.pressed("jump") then
    if steam.openOverlay(game.steam, "friends") == false then
      notice = "OVERLAY NOT AVAILABLE"
    end if
  end if
end function

function render(game, canvas)
  global notice
  canvas.clear(mp.rgb(15, 26, 40))
  showcase.heading(canvas, "STEAM INTEGRATION", notice)
  color = mp.rgb(120, 220, 195)
  if game.steam.available then
    mp.drawText(canvas, "STEAM CONNECTED", 20, 60, 1, color)
    mp.drawText(canvas, "USER: " + game.steam.userName, 20, 82, 1, color)
    mp.drawText(canvas, "ID: " + game.steam.userId, 20, 104, 1, color)
    mp.drawText(canvas, "LANGUAGE: " + game.steam.language, 20, 126, 1, color)
  else
    mp.drawText(canvas, "STANDALONE MODE", 20, 60, 1, color)
    mp.drawText(canvas, "ENABLE STEAM IN MINIPIXELS.JSON", 20, 90, 1, color)
    mp.drawText(canvas, "BUILD WITH --steam-sdk AND --steam-dev", 20, 112, 1, color)
  end if
  if game.steam.overlaySupported then
    mp.drawText(canvas, "PRESENTER: OVERLAY CAPABLE", 20, 170, 1, color)
  else
    mp.drawText(canvas, "PRESENTER: NO STEAM OVERLAY", 20, 170, 1, color)
  end if
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Steam", 480, 270, 2)
  mp.useGpuRenderer(cfg)
  return showcase.run(args, cfg, void, update, render, void)
end function
