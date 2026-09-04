// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels core time facilities for this project.

package minipixels.core.time

/// Represents the time state data used by the minipixels core time module.
struct TimeState
  /// Stores the delta value associated with time state.
  delta
  /// Stores the fixed delta value associated with time state.
  fixedDelta
  /// Stores the elapsed value associated with time state.
  elapsed
  /// Stores the frame number value associated with time state.
  frameNumber
  /// Stores the update number value associated with time state.
  updateNumber
  /// Stores the fps value associated with time state.
  fps
  /// Stores the ups value associated with time state.
  ups
end struct

/// Creates create for the minipixels core time module.
/// @param updatesPerSecond updatesPerSecond value consumed by this operation.
function create(updatesPerSecond)
  if updatesPerSecond <= 0 then updatesPerSecond = 60 end if
  return TimeState(0, 1.0 / updatesPerSecond, 0, 0, 0, 0, updatesPerSecond)
end function

/// Performs the beginFrame operation for the minipixels core time module.
/// @param t t value consumed by this operation.
/// @param delta delta value consumed by this operation.
function beginFrame(t, delta)
  t.delta = delta
  t.elapsed = t.elapsed + delta
  t.frameNumber = t.frameNumber + 1
  if delta > 0 then
    t.fps = 1.0 / delta
  end if
end function

/// Performs the countUpdate operation for the minipixels core time module.
/// @param t t value consumed by this operation.
function countUpdate(t)
  t.updateNumber = t.updateNumber + 1
end function
