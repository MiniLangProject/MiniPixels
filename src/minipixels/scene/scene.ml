// SPDX-License-Identifier: Apache-2.0

//! Provides registered scenes, stack transitions, and lifecycle dispatch.

package minipixels.scene.scene

import std.ds.hashmap as hm

/// Represents one scene and its optional lifecycle callbacks.
struct Scene
  /// Stable scene name used by stack transitions.
  name
  /// User-owned state associated with the scene.
  state
  /// Callback invoked as onEnter(game, scene).
  onEnter
  /// Callback invoked as onExit(game, scene).
  onExit
  /// Callback invoked as onPause(game, scene).
  onPause
  /// Callback invoked as onResume(game, scene).
  onResume
  /// Callback invoked as update(game, scene, dt).
  update
  /// Callback invoked as render(game, scene, canvas).
  render
  /// Whether this scene receives fixed updates while it is on top.
  enabled
  /// Whether scenes below this scene remain visible.
  renderBelow
end struct

/// Represents a growable registry and active stack of scenes.
struct SceneStack
  /// Registered scene names retained for compatibility and iteration.
  names
  /// Registered scene objects retained for compatibility and iteration.
  scenes
  /// Number of registered scenes.
  count
  /// Registry index of the active top scene, or -1.
  top
  /// Hash index mapping registered names to registry slots.
  index
  /// Allocated registry capacity.
  capacity
  /// Registry indices making up the active scene stack.
  stack
  /// Number of active stack entries.
  stackCount
  /// Allocated active-stack capacity.
  stackCapacity

  /// Registers or replaces a named scene.
  /// @param name Stable scene name.
  /// @param scene Scene value or arbitrary compatibility value.
  function register(name, scene)
    return minipixels.scene.scene.register(this, name, scene)
  end function

  /// Replaces the active scene.
  /// @param name Registered scene name.
  /// @param game Game passed to lifecycle callbacks.
  function change(name, game = void)
    return minipixels.scene.scene.change(this, name, game)
  end function

  /// Pushes a scene above the current scene.
  /// @param name Registered scene name.
  /// @param game Game passed to lifecycle callbacks.
  function push(name, game = void)
    return minipixels.scene.scene.push(this, name, game)
  end function

  /// Removes the current scene and resumes the scene below it.
  /// @param game Game passed to lifecycle callbacks.
  function pop(game = void)
    return minipixels.scene.scene.pop(this, game)
  end function

  /// Returns the active top scene.
  function current()
    return minipixels.scene.scene.current(this)
  end function

  /// Returns the number of active stack entries.
  function depth()
    return this.stackCount
  end function
end struct

/// Creates a scene from optional lifecycle callbacks.
/// @param name Stable scene name.
/// @param state User-owned scene state.
/// @param onEnter Callback invoked when the scene becomes active.
/// @param onExit Callback invoked when the scene leaves the stack.
/// @param update Callback invoked for fixed simulation updates.
/// @param render Callback invoked for rendering.
/// @param onPause Callback invoked when another scene is pushed above this one.
/// @param onResume Callback invoked after the scene above is popped.
/// @param renderBelow Whether scenes underneath remain visible.
function scene(name, state = void, onEnter = void, onExit = void, update = void, render = void, onPause = void, onResume = void, renderBelow = false)
  return Scene(name, state, onEnter, onExit, onPause, onResume, update, render, true, renderBelow == true)
end function

/// Creates an empty growable scene registry and active stack.
/// @param capacity Initial registry and stack capacity.
function create(capacity)
  if typeof(capacity) != "int" or capacity < 1 then capacity = 8 end if
  return SceneStack(
    array(capacity), array(capacity), 0, -1,
    hm.HashMap.withCapacity(capacity * 2), capacity,
    array(capacity, -1), 0, capacity
  )
end function

/// Grows the scene registry when full.
/// @param s Scene stack to resize.
function ensureRegistryCapacity(s)
  if s.count < s.capacity then return end if
  nextCapacity = s.capacity * 2
  names = array(nextCapacity)
  scenes = array(nextCapacity)
  copyArray(names, 0, s.names, 0, s.count)
  copyArray(scenes, 0, s.scenes, 0, s.count)
  s.names = names
  s.scenes = scenes
  s.capacity = nextCapacity
end function

/// Grows the active scene stack when full.
/// @param s Scene stack to resize.
function ensureStackCapacity(s)
  if s.stackCount < s.stackCapacity then return end if
  nextCapacity = s.stackCapacity * 2
  entries = array(nextCapacity, -1)
  copyArray(entries, 0, s.stack, 0, s.stackCount)
  s.stack = entries
  s.stackCapacity = nextCapacity
end function

/// Registers or replaces a named scene.
/// @param s Scene stack to mutate.
/// @param name Stable scene name.
/// @param value Scene value or arbitrary compatibility value.
function register(s, name, value)
  if typeof(name) != "string" or len(name) <= 0 then return false end if
  idx = find(s, name)
  if idx >= 0 then
    s.scenes[idx] = value
    return true
  end if
  ensureRegistryCapacity(s)
  idx = s.count
  s.names[idx] = name
  s.scenes[idx] = value
  s.index.set(name, idx)
  s.count = idx + 1
  return true
end function

/// Finds a registered scene index in constant expected time.
/// @param s Scene stack to inspect.
/// @param name Registered scene name.
function find(s, name)
  if typeof(name) != "string" then return -1 end if
  idx = s.index.get(name)
  if typeof(idx) != "int" then return -1 end if
  return idx
end function

/// Calls a two-argument lifecycle callback when present.
/// @param callback Callback to invoke.
/// @param game Game passed to the callback.
/// @param value Scene passed to the callback.
function callLifecycle(callback, game, value)
  if typeof(callback) == "function" then return callback(game, value) end if
end function

/// Calls a scene enter hook when the registered value is a Scene.
/// @param value Registered scene value.
/// @param game Game passed to the hook.
function enter(value, game)
  if value is Scene then return callLifecycle(value.onEnter, game, value) end if
end function

/// Calls a scene exit hook when the registered value is a Scene.
/// @param value Registered scene value.
/// @param game Game passed to the hook.
function exitScene(value, game)
  if value is Scene then return callLifecycle(value.onExit, game, value) end if
end function

/// Calls a scene pause hook when the registered value is a Scene.
/// @param value Registered scene value.
/// @param game Game passed to the hook.
function pause(value, game)
  if value is Scene then return callLifecycle(value.onPause, game, value) end if
end function

/// Calls a scene resume hook when the registered value is a Scene.
/// @param value Registered scene value.
/// @param game Game passed to the hook.
function resume(value, game)
  if value is Scene then return callLifecycle(value.onResume, game, value) end if
end function

/// Pushes a registered scene above the active scene.
/// @param s Scene stack to mutate.
/// @param name Registered scene name.
/// @param game Game passed to lifecycle callbacks.
function push(s, name, game = void)
  idx = find(s, name)
  if idx < 0 then return false end if
  active = current(s)
  pauseResult = try(pause(active, game))
  if typeof(pauseResult) == "error" then return pauseResult end if
  ensureStackCapacity(s)
  s.stack[s.stackCount] = idx
  s.stackCount = s.stackCount + 1
  s.top = idx
  enterResult = try(enter(s.scenes[idx], game))
  if typeof(enterResult) == "error" then
    s.stackCount = s.stackCount - 1
    if s.stackCount > 0 then s.top = s.stack[s.stackCount - 1] else s.top = -1 end if
    rollbackResult = try(resume(active, game))
    return enterResult
  end if
  return true
end function

/// Removes the active scene and resumes the scene below it.
/// @param s Scene stack to mutate.
/// @param game Game passed to lifecycle callbacks.
function pop(s, game = void)
  if s.stackCount <= 0 then return false end if
  activeIndex = s.stack[s.stackCount - 1]
  exitResult = try(exitScene(s.scenes[activeIndex], game))
  if typeof(exitResult) == "error" then return exitResult end if
  s.stackCount = s.stackCount - 1
  s.stack[s.stackCount] = -1
  if s.stackCount > 0 then
    s.top = s.stack[s.stackCount - 1]
    resumeResult = try(resume(s.scenes[s.top], game))
    if typeof(resumeResult) == "error" then return resumeResult end if
  else
    s.top = -1
  end if
  return true
end function

/// Replaces the active scene with a registered scene.
/// @param s Scene stack to mutate.
/// @param name Registered scene name.
/// @param game Game passed to lifecycle callbacks.
function change(s, name, game = void)
  idx = find(s, name)
  if idx < 0 then return false end if
  if s.stackCount <= 0 then return push(s, name, game) end if
  oldIndex = s.stack[s.stackCount - 1]
  if oldIndex == idx then return true end if
  exitResult = try(exitScene(s.scenes[oldIndex], game))
  if typeof(exitResult) == "error" then return exitResult end if
  s.stack[s.stackCount - 1] = idx
  s.top = idx
  enterResult = try(enter(s.scenes[idx], game))
  if typeof(enterResult) == "error" then
    s.stack[s.stackCount - 1] = oldIndex
    s.top = oldIndex
    rollbackResult = try(enter(s.scenes[oldIndex], game))
    return enterResult
  end if
  return true
end function

/// Removes all active scenes from top to bottom.
/// @param s Scene stack to mutate.
/// @param game Game passed to lifecycle callbacks.
function clear(s, game = void)
  while s.stackCount > 0
    idx = s.stack[s.stackCount - 1]
    result = try(exitScene(s.scenes[idx], game))
    if typeof(result) == "error" then return result end if
    s.stackCount = s.stackCount - 1
    s.stack[s.stackCount] = -1
  end while
  s.top = -1
  return true
end function

/// Returns the active top scene.
/// @param s Scene stack to inspect.
function current(s)
  if s.stackCount <= 0 or s.top < 0 then return void end if
  return s.scenes[s.top]
end function

/// Dispatches a fixed update to the active top scene.
/// @param s Scene stack to update.
/// @param game Game passed to the scene.
/// @param dt Fixed simulation delta.
function updateCurrent(s, game, dt)
  active = current(s)
  if active is not Scene or active.enabled == false then return end if
  if typeof(active.update) == "function" then return active.update(game, active, dt) end if
end function

/// Renders the visible portion of the active scene stack.
/// @param s Scene stack to render.
/// @param game Game passed to scenes.
/// @param canvas Canvas receiving scene output.
function renderStack(s, game, canvas)
  if s.stackCount <= 0 then return end if
  first = s.stackCount - 1
  while first > 0
    value = s.scenes[s.stack[first]]
    if value is not Scene or value.renderBelow == false then break end if
    first = first - 1
  end while
  for stackIndex = first to s.stackCount - 1
    value = s.scenes[s.stack[stackIndex]]
    if value is Scene and typeof(value.render) == "function" then
      result = try(value.render(game, value, canvas))
      if typeof(result) == "error" then return result end if
    end if
  end for
end function
