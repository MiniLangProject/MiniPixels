import minipixels as mp

phase = 0

function update(game, dt)
  global phase
  phase = phase + 1
end function

function render(game, canvas)
  global phase
  y = 0
  while y < canvas.height
    x = 0
    while x < canvas.width
      v = ((x * x) + (y * 3) + phase * 7) & 255
      r = (v + x) & 255
      g = (v + y) & 255
      b = (x + y + phase) & 255
      canvas.setPixel(x, y, mp.rgb(r, g, b))
      x = x + 1
    end while
    y = y + 1
  end while
end function

function main(args)
  cfg = mp.createConfig("MiniPixels Pixel Effects", 320, 180, 4)
  return mp.run(cfg, void, update, render, void)
end function
