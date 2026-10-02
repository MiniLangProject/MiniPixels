import minipixels as mp
import minipixels.graphics.canvas as cv
import generated.assets as gen
import std.math as math
import "../../showcase.ml" as showcase

phase = 0
landscape = void

function initialize(game)
  global landscape
  landscape = gen.make_landscape()
end function

function update(game, dt)
  global phase
  phase = phase + dt * 2
end function

function render(game, canvas)
  canvas.drawSprite(landscape, 0, 0)
  // Mirror scanlines, offset them with waves, then tint the water.
  // The image is cached; the effect does not allocate any per-frame images.
  for y = 110 to 179
    depth = y - 110
    shift = math.sin(phase + depth * 0.24) * (1 + depth / 12)
    shift = shift + math.sin(phase * 1.7 + depth * 0.63) * 1.5
    cv.blitRegion(canvas, landscape.image, 0, 110 - depth, 320, 1, shift, y)
    if shift > 0 then
      cv.blitRegion(canvas, landscape.image, 0, 110 - depth, 320, 1, shift - 320, y)
    else
      cv.blitRegion(canvas, landscape.image, 0, 110 - depth, 320, 1, shift + 320, y)
    end if
  end for
  canvas.fillRect(0, 110, 320, 70, mp.rgba(7, 20, 46, 75))
  canvas.fillRect(0, 110, 320, 1, mp.rgba(123, 202, 222, 100))
  for i = 0 to 11
    x = (i * 47 + 17) % 320
    y = 48 + ((i * 19) % 58) + math.sin(phase + i) * 3
    canvas.setPixel(x, y, mp.rgba(202, 232, 174, 255))
  end for
  showcase.heading(canvas, "MOONLIT REFLECTIONS", "SCANLINE WAVES / CACHED IMAGE")
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Moonlit Reflections", 320, 180, 4)
  return showcase.run(args, cfg, initialize, update, render, void)
end function
