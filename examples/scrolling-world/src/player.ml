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
  anim = mp.animation(4)
  anim.addFrame(sprite, 0.12)
  anim.addFrame(sprite, 0.12)
  anim.play()
  return Player(48, 240, 0, 0, false, sprite, anim)
end function
