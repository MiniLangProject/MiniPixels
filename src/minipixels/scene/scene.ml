// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels scene scene facilities for this project.

package minipixels.scene.scene

/// Represents the scene stack data used by the minipixels scene scene module.
struct SceneStack
  /// Stores the names value associated with scene stack.
  names
  /// Stores the scenes value associated with scene stack.
  scenes
  /// Stores the count value associated with scene stack.
  count
  /// Stores the top value associated with scene stack.
  top

  /// Performs the register operation for the minipixels scene scene scene stack module.
  /// @param name Name of the affected item.
  /// @param scene scene value consumed by this operation.
  function register(name, scene)
    return minipixels.scene.scene.register(this, name, scene)
  end function

  /// Performs the change operation for the minipixels scene scene scene stack module.
  /// @param name Name of the affected item.
  function change(name)
    return minipixels.scene.scene.change(this, name)
  end function

  /// Performs the current operation for the minipixels scene scene scene stack module.
  function current()
    return minipixels.scene.scene.current(this)
  end function
end struct

/// Creates create for the minipixels scene scene module.
/// @param capacity capacity value consumed by this operation.
function create(capacity)
  return SceneStack(array(capacity), array(capacity), 0, -1)
end function

/// Performs the register operation for the minipixels scene scene module.
/// @param s s value consumed by this operation.
/// @param name Name of the affected item.
/// @param scene scene value consumed by this operation.
function register(s, name, scene)
  if s.count >= len(s.names) then return false end if
  s.names[s.count] = name
  s.scenes[s.count] = scene
  s.count = s.count + 1
  return true
end function

/// Finds find used by the minipixels scene scene module.
/// @param s s value consumed by this operation.
/// @param name Name of the affected item.
function find(s, name)
  for i = 0 to s.count - 1
    if s.names[i] == name then return i end if
  end for
  return -1
end function

/// Performs the change operation for the minipixels scene scene module.
/// @param s s value consumed by this operation.
/// @param name Name of the affected item.
function change(s, name)
  idx = find(s, name)
  if idx < 0 then return false end if
  s.top = idx
  return true
end function

/// Performs the current operation for the minipixels scene scene module.
/// @param s s value consumed by this operation.
function current(s)
  if s.top < 0 then return void end if
  return s.scenes[s.top]
end function
