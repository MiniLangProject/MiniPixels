package minipixels.assets.assets

struct AssetRegistry
  names
  values
  count

  function add(name, value)
    return minipixels.assets.assets.add(this, name, value)
  end function

  function get(name)
    return minipixels.assets.assets.get(this, name)
  end function

  function getSprite(name)
    return minipixels.assets.assets.get(this, name)
  end function
end struct

function create(capacity)
  if capacity < 1 then capacity = 16 end if
  return AssetRegistry(array(capacity), array(capacity), 0)
end function

function add(reg, name, value)
  if reg.count >= len(reg.names) then return false end if
  reg.names[reg.count] = name
  reg.values[reg.count] = value
  reg.count = reg.count + 1
  return true
end function

function get(reg, name)
  for i = 0 to reg.count - 1
    if reg.names[i] == name then return reg.values[i] end if
  end for
  return void
end function
