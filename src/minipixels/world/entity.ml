// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels world entity facilities for this project.

package minipixels.world.entity

/// Represents the entity data used by the minipixels world entity module.
struct Entity
  /// Stores the id value associated with entity.
  id
  /// Stores the name value associated with entity.
  name
  /// Stores the tag value associated with entity.
  tag
  /// Stores the x value associated with entity.
  x
  /// Stores the y value associated with entity.
  y
  /// Stores the width value associated with entity.
  width
  /// Stores the height value associated with entity.
  height
  /// Stores the vx value associated with entity.
  vx
  /// Stores the vy value associated with entity.
  vy
  /// Stores the visible value associated with entity.
  visible
  /// Stores the active value associated with entity.
  active
  /// Stores the layer value associated with entity.
  layer
  /// Stores the order value associated with entity.
  order
  /// Stores the sprite value associated with entity.
  sprite
end struct

/// Creates create for the minipixels world entity module.
/// @param id Stable identifier of the affected item.
/// @param name Name of the affected item.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
function create(id, name, x, y, w, h)
  return Entity(id, name, "", x, y, w, h, 0, 0, true, true, 0, id, void)
end function
