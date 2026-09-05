// SPDX-License-Identifier: Apache-2.0

//! Provides a growable, indexed, optionally lazy MiniPixels asset registry.

package minipixels.assets.assets

import std.ds.hashmap as hm

/// Represents an indexed asset registry with optional lazy factories.
struct AssetRegistry
  /// Registered names retained for deterministic iteration.
  names
  /// Cached asset values.
  values
  /// Number of registered assets.
  count
  /// Allocated registry capacity.
  capacity
  /// Hash index mapping names to slots.
  index
  /// Optional zero-argument factory associated with each slot.
  loaders
  /// Whether each slot currently contains a cached value.
  loaded

  /// Adds or replaces an eagerly available asset.
  /// @param name Stable asset name.
  /// @param value Asset value to cache.
  function add(name, value)
    return minipixels.assets.assets.add(this, name, value)
  end function

  /// Adds or replaces an asset created on first access.
  /// @param name Stable asset name.
  /// @param loader Zero-argument factory returning the asset value.
  function addLazy(name, loader)
    return minipixels.assets.assets.addLazy(this, name, loader)
  end function

  /// Returns an asset, invoking its lazy factory at most once after success.
  /// @param name Stable asset name.
  function get(name)
    return minipixels.assets.assets.get(this, name)
  end function

  /// Returns a sprite asset.
  /// @param name Stable sprite name.
  function getSprite(name)
    return minipixels.assets.assets.get(this, name)
  end function

  /// Returns whether an asset name is registered.
  /// @param name Stable asset name.
  function has(name)
    return minipixels.assets.assets.has(this, name)
  end function

  /// Drops a cached lazy value so the next access recreates it.
  /// @param name Stable asset name.
  function unload(name)
    return minipixels.assets.assets.unload(this, name)
  end function
end struct

/// Creates a growable asset registry.
/// @param capacity Initial registry capacity.
function create(capacity)
  if typeof(capacity) != "int" or capacity < 1 then capacity = 16 end if
  return AssetRegistry(
    array(capacity), array(capacity), 0, capacity,
    hm.HashMap.withCapacity(capacity * 2), array(capacity, false), array(capacity, false)
  )
end function

/// Grows registry storage when full.
/// @param reg Registry to resize.
function ensureCapacity(reg)
  if reg.count < reg.capacity then return end if
  nextCapacity = reg.capacity * 2
  names = array(nextCapacity)
  values = array(nextCapacity)
  loaders = array(nextCapacity)
  loaded = array(nextCapacity, false)
  copyArray(names, 0, reg.names, 0, reg.count)
  copyArray(values, 0, reg.values, 0, reg.count)
  copyArray(loaders, 0, reg.loaders, 0, reg.count)
  copyArray(loaded, 0, reg.loaded, 0, reg.count)
  reg.names = names
  reg.values = values
  reg.loaders = loaders
  reg.loaded = loaded
  reg.capacity = nextCapacity
end function

/// Returns a registered slot or -1.
/// @param reg Registry to inspect.
/// @param name Stable asset name.
function slotOf(reg, name)
  if typeof(name) != "string" then return -1 end if
  slot = reg.index.get(name)
  if typeof(slot) != "int" then return -1 end if
  return slot
end function

/// Allocates a slot for a new name or returns its existing slot.
/// @param reg Registry to mutate.
/// @param name Stable asset name.
function ensureSlot(reg, name)
  slot = slotOf(reg, name)
  if slot >= 0 then return slot end if
  if typeof(name) != "string" or len(name) <= 0 then return -1 end if
  ensureCapacity(reg)
  slot = reg.count
  reg.names[slot] = name
  reg.loaders[slot] = false
  reg.loaded[slot] = false
  reg.index.set(name, slot)
  reg.count = slot + 1
  return slot
end function

/// Adds or replaces an eager asset.
/// @param reg Registry to mutate.
/// @param name Stable asset name.
/// @param value Asset value to cache.
function add(reg, name, value)
  slot = ensureSlot(reg, name)
  if slot < 0 then return false end if
  reg.values[slot] = value
  reg.loaders[slot] = false
  reg.loaded[slot] = true
  return true
end function

/// Adds or replaces a lazily created asset.
/// @param reg Registry to mutate.
/// @param name Stable asset name.
/// @param loader Zero-argument factory returning the asset value.
function addLazy(reg, name, loader)
  if typeof(loader) != "function" then return false end if
  slot = ensureSlot(reg, name)
  if slot < 0 then return false end if
  reg.values[slot] = false
  reg.loaders[slot] = loader
  reg.loaded[slot] = false
  return true
end function

/// Returns whether an asset name is registered.
/// @param reg Registry to inspect.
/// @param name Stable asset name.
function has(reg, name)
  return slotOf(reg, name) >= 0
end function

/// Returns an asset and caches a successful lazy result.
/// @param reg Registry to inspect.
/// @param name Stable asset name.
function get(reg, name)
  slot = slotOf(reg, name)
  if slot < 0 then return void end if
  value = reg.values[slot]
  if reg.loaded[slot] then return value end if
  loader = reg.loaders[slot]
  if typeof(loader) != "function" then return void end if
  value = loader()
  if typeof(value) != "error" then
    reg.values[slot] = value
    reg.loaded[slot] = true
  end if
  return value
end function

/// Drops a cached lazy value while retaining its factory.
/// @param reg Registry to mutate.
/// @param name Stable asset name.
function unload(reg, name)
  slot = slotOf(reg, name)
  if slot < 0 or typeof(reg.loaders[slot]) != "function" then return false end if
  reg.values[slot] = false
  reg.loaded[slot] = false
  return true
end function

/// Clears all cached lazy values while retaining registrations.
/// @param reg Registry to mutate.
function unloadAll(reg)
  if reg.count <= 0 then return end if
  for slot = 0 to reg.count - 1
    if typeof(reg.loaders[slot]) == "function" then
      reg.values[slot] = false
      reg.loaded[slot] = false
    end if
  end for
end function
