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
  /// Fraction of the next fixed update used for render interpolation.
  alpha
  /// Accumulated wall time used for smoothed rate reporting.
  sampleElapsed
  /// Number of rendered frames in the active rate sample.
  sampleFrames
  /// Number of fixed updates in the active rate sample.
  sampleUpdates
  /// Fixed-update wall time still waiting to be simulated.
  backlogSeconds
  /// Wall time discarded by the explicit frame/catch-up limits, excluding pauses.
  droppedSeconds
  /// Number of rendered frames whose fixed-update budget was exhausted.
  catchUpLimitedFrames
  /// Queued simulation time intentionally cleared by focus/overlay pauses.
  pausedBacklogSeconds
end struct

/// Creates create for the minipixels core time module.
/// @param updatesPerSecond updatesPerSecond value consumed by this operation.
function create(updatesPerSecond)
  if updatesPerSecond <= 0 then updatesPerSecond = 60 end if
  return TimeState(0, 1.0 / updatesPerSecond, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
end function

/// Performs the beginFrame operation for the minipixels core time module.
/// @param t t value consumed by this operation.
/// @param delta delta value consumed by this operation.
function beginFrame(t, delta)
  t.delta = delta
  t.elapsed = t.elapsed + delta
  t.frameNumber = t.frameNumber + 1
  t.sampleElapsed = t.sampleElapsed + delta
  t.sampleFrames = t.sampleFrames + 1
end function

/// Performs the countUpdate operation for the minipixels core time module.
/// @param t t value consumed by this operation.
function countUpdate(t)
  t.updateNumber = t.updateNumber + 1
  t.sampleUpdates = t.sampleUpdates + 1
end function

/// Completes frame timing and updates interpolation and smoothed rates.
/// @param t Time state to update.
/// @param alpha Fraction of the next fixed update accumulated by the loop.
function finishFrame(t, alpha)
  if alpha < 0 then alpha = 0 end if
  if alpha > 1 then alpha = 1 end if
  t.alpha = alpha
  if t.sampleElapsed >= 0.5 then
    t.fps = t.sampleFrames / t.sampleElapsed
    t.ups = t.sampleUpdates / t.sampleElapsed
    t.sampleElapsed = 0
    t.sampleFrames = 0
    t.sampleUpdates = 0
  end if
end function

/// Queues a rendered frame's wall time under an explicit catch-up policy.
/// Retain preserves all time; discard retains the legacy max-frame clamp.
/// Rendering delta stays clamped under either policy, and FPS uses wall time.
function beginFixedFrame(t, delta, maxFrameSeconds, policy)
  if delta < 0 then delta = 0 end if
  beginFrame(t, delta)
  accepted = delta
  if maxFrameSeconds > 0 and t.delta > maxFrameSeconds then
    t.delta = maxFrameSeconds
    if policy != "retain" then accepted = maxFrameSeconds end if
  end if
  t.droppedSeconds = t.droppedSeconds + delta - accepted
  t.backlogSeconds = t.backlogSeconds + accepted
end function

/// Records one successful fixed update without losing the remaining debt.
function consumeFixedUpdate(t)
  countUpdate(t)
  t.backlogSeconds = t.backlogSeconds - t.fixedDelta
  if t.backlogSeconds < 0 then t.backlogSeconds = 0 end if
end function

/// Applies the explicit catch-up limit and clamps render interpolation.
function finishFixedFrame(t, updates, maxUpdates, policy)
  if updates >= maxUpdates and t.backlogSeconds >= t.fixedDelta then
    t.catchUpLimitedFrames = t.catchUpLimitedFrames + 1
    if policy != "retain" then
      t.droppedSeconds = t.droppedSeconds + t.backlogSeconds
      t.backlogSeconds = 0
    end if
  end if
  finishFrame(t, t.backlogSeconds / t.fixedDelta)
end function

/// A deliberate focus/overlay pause clears queued simulation time separately.
function pauseFixedUpdates(t)
  t.pausedBacklogSeconds = t.pausedBacklogSeconds + t.backlogSeconds
  t.backlogSeconds = 0
end function
