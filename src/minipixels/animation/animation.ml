// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels animation animation facilities for this project.

package minipixels.animation.animation

/// Represents the animation data used by the minipixels animation animation module.
struct Animation
  /// Stores the frames value associated with animation.
  frames
  /// Stores the durations value associated with animation.
  durations
  /// Stores the count value associated with animation.
  count
  /// Stores the index value associated with animation.
  index
  /// Stores the elapsed value associated with animation.
  elapsed
  /// Stores the playing value associated with animation.
  playing
  /// Stores the looping value associated with animation.
  looping
  /// Stores the ping pong value associated with animation.
  pingPong
  /// Stores the direction value associated with animation.
  direction
  /// Stores the speed value associated with animation.
  speed

  /// Adds frame to the state managed by the minipixels animation animation module.
  /// @param sprite sprite value consumed by this operation.
  /// @param duration duration value consumed by this operation.
  function addFrame(sprite, duration)
    return minipixels.animation.animation.addFrame(this, sprite, duration)
  end function

  /// Performs the play operation for the minipixels animation animation animation module.
  function play()
    this.playing = true
  end function

  /// Stops stop for the minipixels animation animation workflow.
  function stop()
    return minipixels.animation.animation.stop(this)
  end function

  /// Performs the reset operation for the minipixels animation animation animation module.
  function reset()
    return minipixels.animation.animation.reset(this)
  end function

  /// Performs the pause operation for the minipixels animation animation animation module.
  function pause()
    this.playing = false
  end function

  /// Updates looping maintained by the minipixels animation animation module.
  /// @param value Value consumed or transformed by the operation.
  function setLooping(value)
    this.looping = value
  end function

  /// Updates ping pong maintained by the minipixels animation animation module.
  /// @param value Value consumed or transformed by the operation.
  function setPingPong(value)
    this.pingPong = value
  end function

  /// Updates update for the minipixels animation animation workflow.
  /// @param dt dt value consumed by this operation.
  function update(dt)
    return minipixels.animation.animation.update(this, dt)
  end function

  /// Performs the currentSprite operation for the minipixels animation animation animation module.
  function currentSprite()
    return minipixels.animation.animation.currentSprite(this)
  end function
end struct

/// Creates create for the minipixels animation animation module.
/// @param maxFrames maxFrames value consumed by this operation.
function create(maxFrames)
  if maxFrames <= 0 then maxFrames = 16 end if
  return Animation(array(maxFrames), array(maxFrames, 0.1), 0, 0, 0, false, true, false, 1, 1.0)
end function

/// Adds frame to the state managed by the minipixels animation animation module.
/// @param a a value consumed by this operation.
/// @param sprite sprite value consumed by this operation.
/// @param duration duration value consumed by this operation.
function addFrame(a, sprite, duration)
  if a.count >= len(a.frames) then return false end if
  if duration <= 0 then duration = 0.016 end if
  a.frames[a.count] = sprite
  a.durations[a.count] = duration
  a.count = a.count + 1
  return true
end function

/// Performs the reset operation for the minipixels animation animation module.
/// @param a a value consumed by this operation.
function reset(a)
  a.index = 0
  a.elapsed = 0
  a.direction = 1
end function

/// Stops stop for the minipixels animation animation workflow.
/// @param a a value consumed by this operation.
function stop(a)
  a.playing = false
  reset(a)
end function

/// Performs the currentSprite operation for the minipixels animation animation module.
/// @param a a value consumed by this operation.
function currentSprite(a)
  if a.count <= 0 then return void end if
  return a.frames[a.index]
end function

/// Performs the stepForward operation for the minipixels animation animation module.
/// @param a a value consumed by this operation.
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

/// Updates update for the minipixels animation animation workflow.
/// @param a a value consumed by this operation.
/// @param dt dt value consumed by this operation.
function update(a, dt)
  if a.playing == false or a.count <= 0 then return end if
  a.elapsed = a.elapsed + (dt * a.speed)
  while a.elapsed >= a.durations[a.index]
    a.elapsed = a.elapsed - a.durations[a.index]
    stepForward(a)
    if a.playing == false then break end if
  end while
end function

/// Performs the fromSheet operation for the minipixels animation animation module.
/// @param sheet sheet value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param count Number of items or units to process.
/// @param duration duration value consumed by this operation.
function fromSheet(sheet, start, count, duration)
  a = create(count)
  if count <= 0 then return a end if
  i = 0
  while i < count
    a.addFrame(sheet.getFrame(start + i), duration)
    i = i + 1
  end while
  return a
end function
