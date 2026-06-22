package minipixels.world.entity

struct Entity
  id
  name
  tag
  x
  y
  width
  height
  vx
  vy
  visible
  active
  layer
  order
  sprite
end struct

function create(id, name, x, y, w, h)
  return Entity(id, name, "", x, y, w, h, 0, 0, true, true, 0, id, void)
end function
