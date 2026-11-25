// SPDX-License-Identifier: Apache-2.0
//! Finite orthogonal visual Tiled maps. Deliberately independent of collision.
package minipixels.world.visualmap

import minipixels.tools.json as json
import minipixels.graphics.sprite as sp
import minipixels.graphics.canvas as cv
import minipixels.math.types as mt

/// A validated single-layer visual map with cached sprite descriptors.
struct VisualMap
  /// Number of tile columns.
  width as int
  /// Number of tile rows.
  height as int
  /// Width of one tile in pixels.
  tileWidth as int
  /// Height of one tile in pixels.
  tileHeight as int
  /// Supplied sprite atlas, prewarmed for rendering.
  sheet
  /// Zero-based atlas frames, or -1 for empty cells.
  frames
  /// Bit zero: horizontal flip; bit one: vertical flip.
  flips as bytes
  /// Whether the layer is visible.
  visible as bool
end struct

/// Validate and decode a single unsigned Tiled GID.
/// @param gid Unsigned 32-bit tile ID including Tiled flags.
/// @param first First global ID assigned to the embedded tileset.
/// @param count Number of usable tiles in the supplied atlas.
/// @returns Pair of frame index and flip bits, or an error.
function decodeGid(gid, first, count)
  if typeof(gid) != "int" or typeof(first) != "int" or typeof(count) != "int" then return error(9120, "visualmap: expected integer GID and tileset bounds") end if
  if gid < 0 or gid > 0xffffffff or first < 1 or first > 0x0fffffff or count < 1 or count > 0x10000000 - first then return error(9120, "visualmap: invalid GID or tileset range") end if
  if gid == 0 then return [-1, 0] end if
  // Reject diagonal transforms and the hexagonal rotation flag. Never
  // silently strip them or clamp an invalid GID to the last sprite.
  if (gid & 0x30000000) != 0 then return error(9120, "visualmap: diagonal/hexagonal transforms unsupported") end if
  id = gid & 0x0fffffff
  if id < first or id - first >= count then return error(9120, "visualmap: GID outside embedded tileset") end if
  flags = 0
  if (gid & 0x80000000) != 0 then flags = flags | 1 end if
  if (gid & 0x40000000) != 0 then flags = flags | 2 end if
  return [id - first, flags]
end function

/// Decode a bounded Tiled JSON document using a caller-supplied sprite sheet.
/// @param text JSON text for a finite orthogonal, single-tile-layer map.
/// @param sheet Sprite sheet corresponding to the single embedded tileset.
/// @returns VisualMap or an error; no external image paths are opened.
function parse(text, sheet)
  if typeof(text) != "string" or len(text) > 16777216 then return error(9120, "visualmap: invalid or oversized JSON") end if
  if sheet is not sp.SpriteSheet then return error(9120, "visualmap: expected sprite sheet") end if
  root = try(json.parse(text))
  if typeof(root) == "error" then return root end if
  if json.asString(json.get(root, "type"), "") != "map" or json.asString(json.get(root, "orientation"), "") != "orthogonal" then return error(9120, "visualmap: expected orthogonal Tiled map") end if
  if json.asBool(json.get(root, "infinite"), true) then return error(9120, "visualmap: infinite maps unsupported") end if
  if json.asString(json.get(root, "renderorder"), "right-down") != "right-down" then return error(9120, "visualmap: render order unsupported") end if
  w = json.asNumber(json.get(root, "width"), -1)
  h = json.asNumber(json.get(root, "height"), -1)
  tw = json.asNumber(json.get(root, "tilewidth"), -1)
  th = json.asNumber(json.get(root, "tileheight"), -1)
  if typeof(w) != "int" or typeof(h) != "int" or typeof(tw) != "int" or typeof(th) != "int" then return error(9120, "visualmap: noninteger geometry") end if
  if w < 1 or h < 1 or w > 4096 or h > 4096 or w*h > 1048576 or tw < 1 or th < 1 or tw > 4096 or th > 4096 then return error(9120, "visualmap: geometry outside limits") end if
  if sheet.frameWidth != tw or sheet.frameHeight != th then return error(9120, "visualmap: sheet tile size differs") end if

  sets = json.get(root, "tilesets")
  layers = json.get(root, "layers")
  if json.lenOf(sets) != 1 or json.lenOf(layers) != 1 then return error(9120, "visualmap: one embedded tileset and one tile layer required") end if
  ts = json.at(sets, 0)
  layer = json.at(layers, 0)
  if json.has(ts, "source") or json.has(ts, "tileoffset") or json.has(ts, "tiles") then return error(9120, "visualmap: external/custom tilesets unsupported") end if
  first = json.asNumber(json.get(ts, "firstgid"), -1)
  count = json.asNumber(json.get(ts, "tilecount"), -1)
  if typeof(first) != "int" or typeof(count) != "int" then return error(9120, "visualmap: tileset IDs must be integers") end if
  if first < 1 or first > 0x0fffffff or count < 1 or count > 0x10000000 - first or count > sheet.frameCount then return error(9120, "visualmap: invalid tileset count") end if
  if json.asNumber(json.get(ts, "tilewidth"), -1) != tw or json.asNumber(json.get(ts, "tileheight"), -1) != th or json.asNumber(json.get(ts, "columns"), -1) != sheet.columns then return error(9120, "visualmap: mismatched tileset geometry") end if
  if json.asNumber(json.get(ts, "margin"), 0) != sheet.margin or json.asNumber(json.get(ts, "spacing"), 0) != sheet.spacing then return error(9120, "visualmap: mismatched atlas spacing") end if
  if json.asNumber(json.get(ts, "imagewidth"), -1) != sheet.image.width or json.asNumber(json.get(ts, "imageheight"), -1) != sheet.image.height then return error(9120, "visualmap: mismatched atlas image size") end if
  if json.asString(json.get(layer, "type"), "") != "tilelayer" or json.asNumber(json.get(layer, "width"), -1) != w or json.asNumber(json.get(layer, "height"), -1) != h then return error(9120, "visualmap: mismatched tile layer") end if
  if json.asNumber(json.get(layer, "x"), 0) != 0 or json.asNumber(json.get(layer, "y"), 0) != 0 or json.asNumber(json.get(layer, "offsetx"), 0) != 0 or json.asNumber(json.get(layer, "offsety"), 0) != 0 then return error(9120, "visualmap: layer offsets unsupported") end if
  if json.asNumber(json.get(layer, "opacity"), 1) != 1 or json.asNumber(json.get(layer, "parallaxx"), 1) != 1 or json.asNumber(json.get(layer, "parallaxy"), 1) != 1 or json.has(layer, "tintcolor") then return error(9120, "visualmap: custom layer blending/parallax unsupported") end if
  if json.asString(json.get(layer, "encoding"), "csv") != "csv" or json.asString(json.get(layer, "compression"), "") != "" or json.has(layer, "chunks") then return error(9120, "visualmap: expected uncompressed numeric data") end if
  data = json.get(layer, "data")
  if json.lenOf(data) != w*h then return error(9120, "visualmap: wrong tile data length") end if
  frames = array(w*h, -1)
  flips = bytes(w*h, 0)
  for i = 0 to w*h-1
    gid = json.asNumber(json.at(data, i), -1)
    cell = try(decodeGid(gid, first, count))
    if typeof(cell) == "error" then return cell end if
    frames[i] = cell[0]
    flips[i] = cell[1]
  end for
  sp.cacheFrames(sheet)
  return VisualMap(w, h, tw, th, sheet, frames, flips, json.asBool(json.get(layer, "visible"), true))
end function

/// Draw only the tiles intersecting the camera, preserving Tiled H/V flips.
/// @param map Validated visual map.
/// @param canvas Target canvas, with the viewport matching its dimensions.
/// @param camera Camera in world pixel coordinates.
function draw(map, canvas, camera)
  if not map.visible then return end if
  ox = mt.floorInt(camera.x)
  oy = mt.floorInt(camera.y)
  firstX = mt.clamp(mt.floorInt(ox / map.tileWidth), 0, map.width)
  firstY = mt.clamp(mt.floorInt(oy / map.tileHeight), 0, map.height)
  lastX = mt.clamp(mt.floorInt((ox + canvas.width - 1) / map.tileWidth), -1, map.width - 1)
  lastY = mt.clamp(mt.floorInt((oy + canvas.height - 1) / map.tileHeight), -1, map.height - 1)
  if firstX > lastX or firstY > lastY then return end if
  for y = firstY to lastY
    for x = firstX to lastX
      cell = y * map.width + x
      frame = map.frames[cell]
      if frame >= 0 then
        sprite = map.sheet.frames[frame]
        px = x * map.tileWidth - ox
        py = y * map.tileHeight - oy
        flags = map.flips[cell]
        if flags == 0 then
          cv.drawSprite(canvas, sprite, px, py)
        else
          cv.drawSpriteEx(canvas, sprite, px, py, (flags & 1) != 0, (flags & 2) != 0, 1, mt.rgba(255,255,255,255))
        end if
        canvas.tileCount = canvas.tileCount + 1
      end if
    end for
  end for
end function
