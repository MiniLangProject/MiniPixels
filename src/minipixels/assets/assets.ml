// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels assets assets facilities for this project.

package minipixels.assets.assets

/// Represents the asset registry data used by the minipixels assets assets module.
struct AssetRegistry
  /// Stores the names value associated with asset registry.
  names
  /// Stores the values value associated with asset registry.
  values
  /// Stores the count value associated with asset registry.
  count

  /// Adds add to the state managed by the minipixels assets assets module.
  /// @param name Name of the affected item.
  /// @param value Value consumed or transformed by the operation.
  function add(name, value)
    return minipixels.assets.assets.add(this, name, value)
  end function

  /// Returns get maintained by the minipixels assets assets module.
  /// @param name Name of the affected item.
  function get(name)
    return minipixels.assets.assets.get(this, name)
  end function

  /// Returns sprite maintained by the minipixels assets assets module.
  /// @param name Name of the affected item.
  function getSprite(name)
    return minipixels.assets.assets.get(this, name)
  end function
end struct

/// Creates create for the minipixels assets assets module.
/// @param capacity capacity value consumed by this operation.
function create(capacity)
  if capacity < 1 then capacity = 16 end if
  return AssetRegistry(array(capacity), array(capacity), 0)
end function

/// Adds add to the state managed by the minipixels assets assets module.
/// @param reg reg value consumed by this operation.
/// @param name Name of the affected item.
/// @param value Value consumed or transformed by the operation.
function add(reg, name, value)
  if reg.count >= len(reg.names) then return false end if
  reg.names[reg.count] = name
  reg.values[reg.count] = value
  reg.count = reg.count + 1
  return true
end function

/// Returns get maintained by the minipixels assets assets module.
/// @param reg reg value consumed by this operation.
/// @param name Name of the affected item.
function get(reg, name)
  for i = 0 to reg.count - 1
    if reg.names[i] == name then return reg.values[i] end if
  end for
  return void
end function
