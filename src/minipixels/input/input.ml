package minipixels.input.input

struct InputState
  left
  right
  up
  down
  jump
  fire
  escape
  mouseX
  mouseY
  prevLeft
  prevRight
  prevUp
  prevDown
  prevJump
  prevFire
  prevEscape

  function beginFrame()
    return minipixels.input.input.beginFrame(this)
  end function

  function isDown(action)
    return minipixels.input.input.isDown(this, action)
  end function

  function pressed(action)
    return minipixels.input.input.pressed(this, action)
  end function

  function released(action)
    return minipixels.input.input.released(this, action)
  end function
end struct

function create()
  return InputState(false, false, false, false, false, false, false, 0, 0, false, false, false, false, false, false, false)
end function

function beginFrame(i)
  i.prevLeft = i.left
  i.prevRight = i.right
  i.prevUp = i.up
  i.prevDown = i.down
  i.prevJump = i.jump
  i.prevFire = i.fire
  i.prevEscape = i.escape
end function

function setKeyboard(i, left, right, up, down, jump, fire, escape)
  i.left = left
  i.right = right
  i.up = up
  i.down = down
  i.jump = jump
  i.fire = fire
  i.escape = escape
end function

function isDown(i, action)
  if action == "left" then return i.left end if
  if action == "right" then return i.right end if
  if action == "up" then return i.up end if
  if action == "down" then return i.down end if
  if action == "jump" then return i.jump end if
  if action == "fire" then return i.fire end if
  if action == "escape" then return i.escape end if
  return false
end function

function wasDown(i, action)
  if action == "left" then return i.prevLeft end if
  if action == "right" then return i.prevRight end if
  if action == "up" then return i.prevUp end if
  if action == "down" then return i.prevDown end if
  if action == "jump" then return i.prevJump end if
  if action == "fire" then return i.prevFire end if
  if action == "escape" then return i.prevEscape end if
  return false
end function

function pressed(i, action)
  return isDown(i, action) and (wasDown(i, action) == false)
end function

function released(i, action)
  return (isDown(i, action) == false) and wasDown(i, action)
end function
