package minipixels.animation.animation

struct Animation
  frames
  durations
  count
  index
  elapsed
  playing
  looping
  pingPong
  direction
  speed

  function addFrame(sprite, duration)
    return minipixels.animation.animation.addFrame(this, sprite, duration)
  end function

  function play()
    this.playing = true
  end function

  function pause()
    this.playing = false
  end function

  function update(dt)
    return minipixels.animation.animation.update(this, dt)
  end function

  function currentSprite()
    return minipixels.animation.animation.currentSprite(this)
  end function
end struct

function create(maxFrames)
  if maxFrames <= 0 then maxFrames = 16 end if
  return Animation(array(maxFrames), array(maxFrames, 0.1), 0, 0, 0, false, true, false, 1, 1.0)
end function

function addFrame(a, sprite, duration)
  if a.count >= len(a.frames) then return false end if
  if duration <= 0 then duration = 0.016 end if
  a.frames[a.count] = sprite
  a.durations[a.count] = duration
  a.count = a.count + 1
  return true
end function

function currentSprite(a)
  if a.count <= 0 then return void end if
  return a.frames[a.index]
end function

function stepForward(a)
  if a.count <= 1 then return end if
  if a.pingPong then
    a.index = a.index + a.direction
    if a.index >= a.count then
      a.direction = -1
      a.index = a.count - 2
    end if
    if a.index < 0 then
      a.direction = 1
      a.index = 1
    end if
    return
  end if

  a.index = a.index + a.direction
  if a.index >= a.count or a.index < 0 then
    if a.looping then
      if a.direction >= 0 then a.index = 0 else a.index = a.count - 1 end if
    else
      if a.direction >= 0 then a.index = a.count - 1 else a.index = 0 end if
      a.playing = false
    end if
  end if
end function

function update(a, dt)
  if a.playing == false or a.count <= 0 then return end if
  a.elapsed = a.elapsed + (dt * a.speed)
  while a.elapsed >= a.durations[a.index]
    a.elapsed = a.elapsed - a.durations[a.index]
    stepForward(a)
    if a.playing == false then break end if
  end while
end function
