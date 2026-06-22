package minipixels.core.time

struct TimeState
  delta
  fixedDelta
  elapsed
  frameNumber
  updateNumber
  fps
  ups
end struct

function create(updatesPerSecond)
  if updatesPerSecond <= 0 then updatesPerSecond = 60 end if
  return TimeState(0, 1.0 / updatesPerSecond, 0, 0, 0, 0, updatesPerSecond)
end function

function beginFrame(t, delta)
  t.delta = delta
  t.elapsed = t.elapsed + delta
  t.frameNumber = t.frameNumber + 1
  if delta > 0 then
    t.fps = 1.0 / delta
  end if
end function

function countUpdate(t)
  t.updateNumber = t.updateNumber + 1
end function
