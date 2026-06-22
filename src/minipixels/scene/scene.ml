package minipixels.scene.scene

struct SceneStack
  names
  scenes
  count
  top

  function register(name, scene)
    return minipixels.scene.scene.register(this, name, scene)
  end function

  function change(name)
    return minipixels.scene.scene.change(this, name)
  end function

  function current()
    return minipixels.scene.scene.current(this)
  end function
end struct

function create(capacity)
  return SceneStack(array(capacity), array(capacity), 0, -1)
end function

function register(s, name, scene)
  if s.count >= len(s.names) then return false end if
  s.names[s.count] = name
  s.scenes[s.count] = scene
  s.count = s.count + 1
  return true
end function

function find(s, name)
  for i = 0 to s.count - 1
    if s.names[i] == name then return i end if
  end for
  return -1
end function

function change(s, name)
  idx = find(s, name)
  if idx < 0 then return false end if
  s.top = idx
  return true
end function

function current(s)
  if s.top < 0 then return void end if
  return s.scenes[s.top]
end function
