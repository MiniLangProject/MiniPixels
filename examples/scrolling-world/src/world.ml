package example.world

import minipixels as mp

function makeSolidData(width, height)
  data = array(width * height, 0)
  for y = 0 to height - 1
    for x = 0 to width - 1
      if y >= height - 3 then
        data[(y * width) + x] = 1
      end if
      if y == height - 6 and x >= 10 and x <= 16 then
        data[(y * width) + x] = 1
      end if
      if y == height - 8 and x >= 24 and x <= 31 then
        data[(y * width) + x] = 1
      end if
      if y == height - 5 and x >= 40 and x <= 46 then
        data[(y * width) + x] = 1
      end if
      if y == height - 10 and x >= 55 and x <= 62 then
        data[(y * width) + x] = 1
      end if
    end for
  end for
  return data
end function

function create(sprite)
  sheet = mp.spriteSheet(sprite.image, 16, 16, 0, 0)
  tileset = mp.tileset(sheet)
  map = mp.tilemap(16, 16, 80, 20, tileset, 3)
  solid = makeSolidData(80, 20)
  map.addLayer(mp.tileLayer("world", 80, 20, solid, true, false, 1, 1))
  map.addLayer(mp.tileLayer("collision", 80, 20, solid, false, true, 1, 1))
  return map
end function
