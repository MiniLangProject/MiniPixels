package example.player

import minipixels as mp

struct Player
  x
  y
  vx
  vy
  grounded
  sprite
  animation
end struct

function create(sprite)
  sheet = mp.spriteSheet(sprite.image, 16, 16, 0, 0)
  anim = mp.animationFromSheet(sheet, 0, 2, 0.12)
  anim.play()
  return Player(48, 240, 0, 0, false, sprite, anim)
end function
