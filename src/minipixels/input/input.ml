// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels input input facilities for this project.

package minipixels.input.input

/// Represents the input state data used by the minipixels input input module.
struct InputState
  /// Stores the left value associated with input state.
  left
  /// Stores the right value associated with input state.
  right
  /// Stores the up value associated with input state.
  up
  /// Stores the down value associated with input state.
  down
  /// Stores the jump value associated with input state.
  jump
  /// Stores the fire value associated with input state.
  fire
  /// Stores the escape value associated with input state.
  escape
  /// Stores the mouse x value associated with input state.
  mouseX
  /// Stores the mouse y value associated with input state.
  mouseY
  /// Stores the prev left value associated with input state.
  prevLeft
  /// Stores the prev right value associated with input state.
  prevRight
  /// Stores the prev up value associated with input state.
  prevUp
  /// Stores the prev down value associated with input state.
  prevDown
  /// Stores the prev jump value associated with input state.
  prevJump
  /// Stores the prev fire value associated with input state.
  prevFire
  /// Stores the prev escape value associated with input state.
  prevEscape

  /// Performs the beginFrame operation for the minipixels input input input state module.
  function beginFrame()
    return minipixels.input.input.beginFrame(this)
  end function

  /// Returns whether down satisfies the required condition.
  /// @param action action value consumed by this operation.
  function isDown(action)
    return minipixels.input.input.isDown(this, action)
  end function

  /// Performs the pressed operation for the minipixels input input input state module.
  /// @param action action value consumed by this operation.
  function pressed(action)
    return minipixels.input.input.pressed(this, action)
  end function

  /// Performs the released operation for the minipixels input input input state module.
  /// @param action action value consumed by this operation.
  function released(action)
    return minipixels.input.input.released(this, action)
  end function
end struct

/// Creates create for the minipixels input input module.
function create()
  return InputState(false, false, false, false, false, false, false, 0, 0, false, false, false, false, false, false, false)
end function

/// Performs the beginFrame operation for the minipixels input input module.
/// @param i i value consumed by this operation.
function beginFrame(i)
  i.prevLeft = i.left
  i.prevRight = i.right
  i.prevUp = i.up
  i.prevDown = i.down
  i.prevJump = i.jump
  i.prevFire = i.fire
  i.prevEscape = i.escape
end function

/// Updates keyboard maintained by the minipixels input input module.
/// @param i i value consumed by this operation.
/// @param left left value consumed by this operation.
/// @param right right value consumed by this operation.
/// @param up up value consumed by this operation.
/// @param down down value consumed by this operation.
/// @param jump jump value consumed by this operation.
/// @param fire fire value consumed by this operation.
/// @param escape escape value consumed by this operation.
function setKeyboard(i, left, right, up, down, jump, fire, escape)
  i.left = left
  i.right = right
  i.up = up
  i.down = down
  i.jump = jump
  i.fire = fire
  i.escape = escape
end function

/// Returns whether down satisfies the required condition.
/// @param i i value consumed by this operation.
/// @param action action value consumed by this operation.
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

/// Performs the wasDown operation for the minipixels input input module.
/// @param i i value consumed by this operation.
/// @param action action value consumed by this operation.
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

/// Performs the pressed operation for the minipixels input input module.
/// @param i i value consumed by this operation.
/// @param action action value consumed by this operation.
function pressed(i, action)
  return isDown(i, action) and (wasDown(i, action) == false)
end function

/// Performs the released operation for the minipixels input input module.
/// @param i i value consumed by this operation.
/// @param action action value consumed by this operation.
function released(i, action)
  return (isDown(i, action) == false) and wasDown(i, action)
end function
