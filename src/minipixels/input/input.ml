// SPDX-License-Identifier: Apache-2.0

//! Provides buffered action, keyboard, and pointer input for MiniPixels.

package minipixels.input.input

import std.ds.hashmap as hm

/// Initial number of action slots allocated for an input state.
const DEFAULT_ACTION_CAPACITY = 16

/// Represents the input state consumed by fixed simulation updates.
struct InputState
  /// Legacy state for the built-in left action.
  left
  /// Legacy state for the built-in right action.
  right
  /// Legacy state for the built-in up action.
  up
  /// Legacy state for the built-in down action.
  down
  /// Legacy state for the built-in jump action.
  jump
  /// Legacy state for the built-in fire action.
  fire
  /// Legacy state for the built-in escape action.
  escape
  /// Pointer x position in logical canvas coordinates.
  mouseX
  /// Pointer y position in logical canvas coordinates.
  mouseY
  /// Previous polled state for the built-in left action.
  prevLeft
  /// Previous polled state for the built-in right action.
  prevRight
  /// Previous polled state for the built-in up action.
  prevUp
  /// Previous polled state for the built-in down action.
  prevDown
  /// Previous polled state for the built-in jump action.
  prevJump
  /// Previous polled state for the built-in fire action.
  prevFire
  /// Previous polled state for the built-in escape action.
  prevEscape
  /// Pointer movement consumed by the active simulation update.
  mouseDeltaX
  /// Pointer movement consumed by the active simulation update.
  mouseDeltaY
  /// Mouse-wheel delta consumed by the active simulation update.
  mouseWheel
  /// Whether the pointer is inside the rendered viewport.
  mouseInside
  /// Current left mouse-button state.
  mouseLeft
  /// Current right mouse-button state.
  mouseRight
  /// Current middle mouse-button state.
  mouseMiddle
  /// Whether a pointer position has already been sampled.
  mouseInitialized
  /// Pointer movement waiting for a simulation update.
  pendingMouseDeltaX
  /// Pointer movement waiting for a simulation update.
  pendingMouseDeltaY
  /// Mouse-wheel movement waiting for a simulation update.
  pendingMouseWheel
  /// Registered action names.
  actionNames
  /// Primary virtual-key binding for each action.
  primaryKeys
  /// Secondary virtual-key binding for each action.
  secondaryKeys
  /// Current state for each action.
  actionDown
  /// Press edges waiting for a simulation update.
  pendingPressed
  /// Release edges waiting for a simulation update.
  pendingReleased
  /// Press edges visible to the active simulation update.
  stepPressed
  /// Release edges visible to the active simulation update.
  stepReleased
  /// Number of registered actions.
  actionCount
  /// Allocated action capacity.
  actionCapacity
  /// Hash index mapping action names to slots.
  actionIndex

  /// Starts a platform input poll without consuming pending edges.
  function beginFrame()
    return minipixels.input.input.beginPoll(this)
  end function

  /// Makes buffered edges visible to one fixed simulation update.
  function beginUpdate()
    return minipixels.input.input.beginUpdate(this)
  end function

  /// Finishes one fixed simulation update and clears its edge snapshot.
  function endUpdate()
    return minipixels.input.input.endUpdate(this)
  end function

  /// Returns whether an action is currently held.
  /// @param action Name of the action to inspect.
  function isDown(action)
    return minipixels.input.input.isDown(this, action)
  end function

  /// Returns whether an action became held for the active update.
  /// @param action Name of the action to inspect.
  function pressed(action)
    return minipixels.input.input.pressed(this, action)
  end function

  /// Returns whether an action became released for the active update.
  /// @param action Name of the action to inspect.
  function released(action)
    return minipixels.input.input.released(this, action)
  end function

  /// Binds one virtual key to an action.
  /// @param action Name of the action to configure.
  /// @param key Win32 virtual-key code used as the primary binding.
  function bindKey(action, key)
    return minipixels.input.input.bindKeys(this, action, key, -1)
  end function

  /// Binds two alternative virtual keys to an action.
  /// @param action Name of the action to configure.
  /// @param primary Primary Win32 virtual-key code.
  /// @param secondary Secondary Win32 virtual-key code, or -1.
  function bindKeys(action, primary, secondary)
    return minipixels.input.input.bindKeys(this, action, primary, secondary)
  end function
end struct

/// Creates an input state with conventional keyboard and mouse bindings.
function create()
  capacity = DEFAULT_ACTION_CAPACITY
  state = InputState(
    false, false, false, false, false, false, false,
    0, 0,
    false, false, false, false, false, false, false,
    0, 0, 0, false,
    false, false, false, false,
    0, 0, 0,
    array(capacity), array(capacity, -1), array(capacity, -1),
    array(capacity, false), array(capacity, false), array(capacity, false),
    array(capacity, false), array(capacity, false),
    0, capacity, hm.HashMap.withCapacity(capacity * 2)
  )
  bindKeys(state, "left", 0x25, 0x41)
  bindKeys(state, "right", 0x27, 0x44)
  bindKeys(state, "up", 0x26, 0x57)
  bindKeys(state, "down", 0x28, 0x53)
  bindKeys(state, "jump", 0x20, -1)
  bindKeys(state, "fire", 0x5A, 0x58)
  bindKeys(state, "escape", 0x1B, -1)
  bindKeys(state, "mouse_left", 0x01, -1)
  bindKeys(state, "mouse_right", 0x02, -1)
  bindKeys(state, "mouse_middle", 0x04, -1)
  return state
end function

/// Grows the parallel action arrays when another slot is required.
/// @param i Input state to resize.
function ensureActionCapacity(i)
  if i.actionCount < i.actionCapacity then return end if
  oldCapacity = i.actionCapacity
  newCapacity = oldCapacity * 2
  names = array(newCapacity)
  primary = array(newCapacity, -1)
  secondary = array(newCapacity, -1)
  downs = array(newCapacity, false)
  pendingDown = array(newCapacity, false)
  pendingUp = array(newCapacity, false)
  stepDown = array(newCapacity, false)
  stepUp = array(newCapacity, false)
  copyArray(names, 0, i.actionNames, 0, oldCapacity)
  copyArray(primary, 0, i.primaryKeys, 0, oldCapacity)
  copyArray(secondary, 0, i.secondaryKeys, 0, oldCapacity)
  copyArray(downs, 0, i.actionDown, 0, oldCapacity)
  copyArray(pendingDown, 0, i.pendingPressed, 0, oldCapacity)
  copyArray(pendingUp, 0, i.pendingReleased, 0, oldCapacity)
  copyArray(stepDown, 0, i.stepPressed, 0, oldCapacity)
  copyArray(stepUp, 0, i.stepReleased, 0, oldCapacity)
  i.actionNames = names
  i.primaryKeys = primary
  i.secondaryKeys = secondary
  i.actionDown = downs
  i.pendingPressed = pendingDown
  i.pendingReleased = pendingUp
  i.stepPressed = stepDown
  i.stepReleased = stepUp
  i.actionCapacity = newCapacity
end function

/// Finds an existing action slot.
/// @param i Input state to inspect.
/// @param action Name of the action to find.
function actionSlot(i, action)
  if typeof(action) != "string" then return -1 end if
  slot = i.actionIndex.get(action)
  if typeof(slot) != "int" then return -1 end if
  return slot
end function

/// Finds or creates an action slot.
/// @param i Input state to mutate.
/// @param action Name of the action to register.
function ensureAction(i, action)
  slot = actionSlot(i, action)
  if slot >= 0 then return slot end if
  if typeof(action) != "string" or len(action) <= 0 then return -1 end if
  ensureActionCapacity(i)
  slot = i.actionCount
  i.actionNames[slot] = action
  i.primaryKeys[slot] = -1
  i.secondaryKeys[slot] = -1
  i.actionDown[slot] = false
  i.pendingPressed[slot] = false
  i.pendingReleased[slot] = false
  i.stepPressed[slot] = false
  i.stepReleased[slot] = false
  i.actionIndex.set(action, slot)
  i.actionCount = slot + 1
  return slot
end function

/// Assigns primary and secondary virtual-key bindings to an action.
/// @param i Input state to configure.
/// @param action Name of the action to configure.
/// @param primary Primary Win32 virtual-key code.
/// @param secondary Secondary Win32 virtual-key code, or -1.
function bindKeys(i, action, primary, secondary)
  if typeof(primary) != "int" then return false end if
  if typeof(secondary) != "int" then secondary = -1 end if
  slot = ensureAction(i, action)
  if slot < 0 then return false end if
  i.primaryKeys[slot] = primary
  i.secondaryKeys[slot] = secondary
  return true
end function

/// Removes all virtual-key bindings from an action while retaining its state slot.
/// @param i Input state to configure.
/// @param action Name of the action to unbind.
function unbind(i, action)
  slot = actionSlot(i, action)
  if slot < 0 then return false end if
  i.primaryKeys[slot] = -1
  i.secondaryKeys[slot] = -1
  setActionState(i, action, false)
  return true
end function

/// Synchronizes backward-compatible named fields after an action change.
/// @param i Input state to mutate.
/// @param action Name of the changed action.
/// @param down Whether the action is held.
function syncLegacyAction(i, action, down)
  if action == "left" then i.left = down end if
  if action == "right" then i.right = down end if
  if action == "up" then i.up = down end if
  if action == "down" then i.down = down end if
  if action == "jump" then i.jump = down end if
  if action == "fire" then i.fire = down end if
  if action == "escape" then i.escape = down end if
  if action == "mouse_left" then i.mouseLeft = down end if
  if action == "mouse_right" then i.mouseRight = down end if
  if action == "mouse_middle" then i.mouseMiddle = down end if
end function

/// Updates an action and buffers any resulting edge until a simulation update.
/// @param i Input state to mutate.
/// @param action Name of the action to update.
/// @param down Whether the action is held.
function setActionState(i, action, down)
  slot = ensureAction(i, action)
  if slot < 0 then return false end if
  down = down == true
  previous = i.actionDown[slot]
  if previous != down then
    if down then
      i.pendingPressed[slot] = true
    else
      i.pendingReleased[slot] = true
    end if
    i.actionDown[slot] = down
  end if
  syncLegacyAction(i, action, down)
  return true
end function

/// Starts one platform poll while preserving unconsumed input edges.
/// @param i Input state to update.
function beginPoll(i)
  i.prevLeft = i.left
  i.prevRight = i.right
  i.prevUp = i.up
  i.prevDown = i.down
  i.prevJump = i.jump
  i.prevFire = i.fire
  i.prevEscape = i.escape
end function

/// Publishes buffered edges and pointer deltas to one simulation update.
/// @param i Input state to update.
function beginUpdate(i)
  n = i.actionCount
  if n > 0 then
    for slot = 0 to n - 1
      i.stepPressed[slot] = i.pendingPressed[slot]
      i.stepReleased[slot] = i.pendingReleased[slot]
      i.pendingPressed[slot] = false
      i.pendingReleased[slot] = false
    end for
  end if
  i.mouseDeltaX = i.pendingMouseDeltaX
  i.mouseDeltaY = i.pendingMouseDeltaY
  i.mouseWheel = i.pendingMouseWheel
  i.pendingMouseDeltaX = 0
  i.pendingMouseDeltaY = 0
  i.pendingMouseWheel = 0
end function

/// Clears edges after one simulation update so catch-up updates cannot replay them.
/// @param i Input state to update.
function endUpdate(i)
  n = i.actionCount
  if n > 0 then
    for slot = 0 to n - 1
      i.stepPressed[slot] = false
      i.stepReleased[slot] = false
    end for
  end if
  i.mouseDeltaX = 0
  i.mouseDeltaY = 0
  i.mouseWheel = 0
end function

/// Updates the conventional keyboard actions for tests and non-Windows providers.
/// @param i Input state to update.
/// @param left Whether left is held.
/// @param right Whether right is held.
/// @param up Whether up is held.
/// @param down Whether down is held.
/// @param jump Whether jump is held.
/// @param fire Whether fire is held.
/// @param escape Whether escape is held.
function setKeyboard(i, left, right, up, down, jump, fire, escape)
  setActionState(i, "left", left)
  setActionState(i, "right", right)
  setActionState(i, "up", up)
  setActionState(i, "down", down)
  setActionState(i, "jump", jump)
  setActionState(i, "fire", fire)
  setActionState(i, "escape", escape)
end function

/// Releases every registered action, buffering release edges where needed.
/// @param i Input state to update.
function releaseAll(i)
  if i.actionCount <= 0 then return end if
  for slot = 0 to i.actionCount - 1
    setActionState(i, i.actionNames[slot], false)
  end for
end function

/// Records a pointer sample in logical canvas coordinates.
/// @param i Input state to update.
/// @param x Logical x coordinate.
/// @param y Logical y coordinate.
/// @param inside Whether the pointer lies inside the viewport.
function setMousePosition(i, x, y, inside)
  if i.mouseInitialized then
    i.pendingMouseDeltaX = i.pendingMouseDeltaX + (x - i.mouseX)
    i.pendingMouseDeltaY = i.pendingMouseDeltaY + (y - i.mouseY)
  end if
  i.mouseX = x
  i.mouseY = y
  i.mouseInside = inside == true
  i.mouseInitialized = true
end function

/// Adds a platform wheel delta to the pending simulation input.
/// @param i Input state to update.
/// @param delta Signed wheel-step delta, including fractional high-resolution input.
function addMouseWheel(i, delta)
  if typeof(delta) == "int" or typeof(delta) == "float" then i.pendingMouseWheel = i.pendingMouseWheel + delta end if
end function

/// Returns whether an action is currently held.
/// @param i Input state to inspect.
/// @param action Name of the action to inspect.
function isDown(i, action)
  slot = actionSlot(i, action)
  if slot < 0 then return false end if
  return i.actionDown[slot]
end function

/// Returns the previous platform-poll state for a built-in action.
/// @param i Input state to inspect.
/// @param action Name of the action to inspect.
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

/// Returns whether an action became held since the previous consumed update.
/// @param i Input state to inspect.
/// @param action Name of the action to inspect.
function pressed(i, action)
  slot = actionSlot(i, action)
  if slot < 0 then return false end if
  return i.stepPressed[slot] or i.pendingPressed[slot]
end function

/// Returns whether an action became released since the previous consumed update.
/// @param i Input state to inspect.
/// @param action Name of the action to inspect.
function released(i, action)
  slot = actionSlot(i, action)
  if slot < 0 then return false end if
  return i.stepReleased[slot] or i.pendingReleased[slot]
end function
