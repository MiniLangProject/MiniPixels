// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels facilities for this project.

package minipixels

import minipixels.math.types as mt
import minipixels.graphics.canvas as cv
import minipixels.graphics.sprite as sp
import minipixels.graphics.font as font
import minipixels.input.input as inp
import minipixels.core.time as tm
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif
import minipixels.assets.assets as ast
import minipixels.assets.pack as pack
import minipixels.assets.png as png
import minipixels.assets.text as textAssets
import minipixels.scene.scene as scn
import minipixels.debug.debug as dbg
import minipixels.animation.animation as anim
import minipixels.world.camera as cam
import minipixels.world.tilemap as tile
import minipixels.collision.collision as col
import minipixels.audio.audio as aud
import std.math as math

/// Represents the game config data used by the minipixels module.
struct GameConfig
  /// Stores the title value associated with game config.
  title
  /// Stores the width value associated with game config.
  width
  /// Stores the height value associated with game config.
  height
  /// Stores the scale value associated with game config.
  scale
  /// Stores the updates per second value associated with game config.
  updatesPerSecond
  /// Stores the max frame seconds value associated with game config.
  maxFrameSeconds
  /// Stores the max catch up updates value associated with game config.
  maxCatchUpUpdates
  /// Stores the debug value associated with game config.
  debug
  /// Stores the headless frames value associated with game config.
  headlessFrames
  /// Stores the renderer value associated with game config.
  renderer
  /// Stores the scale mode value associated with game config.
  scaleMode
  /// Stores the smoothing value associated with game config.
  smoothing
  /// Maximum rendered frames per second, or zero for uncapped rendering.
  maxFps
  /// Whether simulation updates pause while the game window lacks focus.
  pauseWhenUnfocused
  /// Render-size policy: fixed, native, or scaled.
  renderMode
  /// Fraction of the native client size used by scaled rendering.
  renderScale
  /// Safety limit for dynamically allocated framebuffer pixels.
  maxRenderPixels
  /// Optional coordinate-system reference width exposed to game code.
  designWidth
  /// Optional coordinate-system reference height exposed to game code.
  designHeight
end struct

/// Represents the game data used by the minipixels module.
struct Game
  /// Stores the config value associated with game.
  config
  /// Stores the canvas value associated with game.
  canvas
  /// Stores the input value associated with game.
  input
  /// Stores the time value associated with game.
  time
  /// Stores the assets value associated with game.
  assets
  /// Stores the audio value associated with game.
  audio
  /// Stores the scenes value associated with game.
  scenes
  /// Stores the running value associated with game.
  running
  /// Stores the window value associated with game.
  window
  /// Stores the debug value associated with game.
  debug
  /// Current framebuffer width in physical render pixels.
  renderWidth
  /// Current framebuffer height in physical render pixels.
  renderHeight
  /// Coordinate-system reference width selected by the developer.
  designWidth
  /// Coordinate-system reference height selected by the developer.
  designHeight
  /// Horizontal ratio from design coordinates to render pixels.
  renderScaleX
  /// Vertical ratio from design coordinates to render pixels.
  renderScaleY
  /// True during a frame in which the main framebuffer changed size.
  resolutionChanged

  /// Performs the quit operation for the minipixels game module.
  function quit()
    this.running = false
  end function
end struct

/// Creates config for the minipixels module.
/// @param title Human-readable title presented to the user.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param scale scale value consumed by this operation.
function createConfig(title, width, height, scale)
  if width <= 0 then width = 320 end if
  if height <= 0 then height = 180 end if
  if scale <= 0 then scale = 4 end if
  return GameConfig(title, width, height, scale, 60, 0.25, 5, false, 120, "auto", "stretch", false, 60, true, "fixed", 1.0, 33554432, width, height)
end function

/// Creates game for the minipixels module.
/// @param cfg Configuration used by the operation.
function createGame(cfg)
  return Game(
    cfg,
    cv.create(cfg.width, cfg.height),
    inp.create(),
    tm.create(cfg.updatesPerSecond),
    ast.create(64),
    aud.mixer(16),
    scn.create(16),
    true,
    void,
    cfg.debug,
    cfg.width,
    cfg.height,
    cfg.designWidth,
    cfg.designHeight,
    cfg.width / (cfg.designWidth * 1.0),
    cfg.height / (cfg.designHeight * 1.0),
    false
  )
end function

/// Performs the version operation for the minipixels module.
function version() return "0.13.0" end function
/// Updates renderer maintained by the minipixels module.
/// @param cfg Configuration used by the operation.
/// @param renderer renderer value consumed by this operation.
function setRenderer(cfg, renderer)
  if cfg is GameConfig then cfg.renderer = renderer end if
  return cfg
end function
/// Performs the useGpuRenderer operation for the minipixels module.
/// @param cfg Configuration used by the operation.
function useGpuRenderer(cfg) return setRenderer(cfg, "opengl") end function
/// Performs the useCpuRenderer operation for the minipixels module.
/// @param cfg Configuration used by the operation.
function useCpuRenderer(cfg) return setRenderer(cfg, "gdi") end function
/// Updates scale mode maintained by the minipixels module.
/// @param cfg Configuration used by the operation.
/// @param mode Mode selecting the requested behavior.
function setScaleMode(cfg, mode)
  if cfg is GameConfig then cfg.scaleMode = mode end if
  return cfg
end function
/// Performs the useStretchScale operation for the minipixels module.
/// @param cfg Configuration used by the operation.
function useStretchScale(cfg) return setScaleMode(cfg, "stretch") end function
/// Performs the useFitScale operation for the minipixels module.
/// @param cfg Configuration used by the operation.
function useFitScale(cfg) return setScaleMode(cfg, "fit") end function
/// Performs the useIntegerScale operation for the minipixels module.
/// @param cfg Configuration used by the operation.
function useIntegerScale(cfg) return setScaleMode(cfg, "integer") end function
/// Select a fixed framebuffer size independent of later window resizes.
/// @param cfg Configuration to update.
/// @param width Framebuffer width in pixels.
/// @param height Framebuffer height in pixels.
function useFixedRenderResolution(cfg, width, height)
  if cfg is GameConfig and typeof(width) == "int" and typeof(height) == "int" and width > 0 and height > 0 then
    cfg.width = width
    cfg.height = height
    cfg.renderMode = "fixed"
  end if
  return cfg
end function
/// Make the framebuffer match the current native window client size.
/// @param cfg Configuration to update.
function useNativeRenderResolution(cfg)
  if cfg is GameConfig then
    cfg.renderMode = "native"
    cfg.renderScale = 1.0
  end if
  return cfg
end function
/// Render at a fraction or multiple of the native window client size.
/// Values below one improve fill-rate; values above one enable supersampling.
/// @param cfg Configuration to update.
/// @param scale Positive native-resolution multiplier.
function useScaledRenderResolution(cfg, scale)
  if cfg is GameConfig and typeof(scale) != "void" and scale > 0 then
    cfg.renderMode = "scaled"
    cfg.renderScale = scale / 1.0
  end if
  return cfg
end function
/// Set the coordinate-system reference size exposed through Game scaling fields.
/// Rendering APIs continue to consume framebuffer pixels unless the developer applies these ratios.
/// @param cfg Configuration to update.
/// @param width Design-coordinate width.
/// @param height Design-coordinate height.
function setDesignResolution(cfg, width, height)
  if cfg is GameConfig and typeof(width) == "int" and typeof(height) == "int" and width > 0 and height > 0 then
    cfg.designWidth = width
    cfg.designHeight = height
  end if
  return cfg
end function
/// Limit dynamic framebuffer allocation to a positive number of pixels.
/// @param cfg Configuration to update.
/// @param pixels Maximum framebuffer pixel count.
function setMaxRenderPixels(cfg, pixels)
  if cfg is GameConfig and typeof(pixels) == "int" and pixels > 0 then cfg.maxRenderPixels = pixels end if
  return cfg
end function
/// Calculates the framebuffer size for a native client area without allocating it.
/// Dynamic sizes retain the client aspect ratio when maxRenderPixels applies.
/// @param cfg Configuration containing the render-size policy.
/// @param clientWidth Native client width in pixels.
/// @param clientHeight Native client height in pixels.
function renderSizeForClient(cfg, clientWidth, clientHeight)
  width = mt.floorInt(clientWidth)
  height = mt.floorInt(clientHeight)
  if width < 1 then width = 1 end if
  if height < 1 then height = 1 end if
  if cfg.renderMode == "fixed" then
    width = cfg.width
    height = cfg.height
  else if cfg.renderMode == "scaled" then
    width = mt.floorInt(width * cfg.renderScale)
    height = mt.floorInt(height * cfg.renderScale)
    if width < 1 then width = 1 end if
    if height < 1 then height = 1 end if
  end if
  pixels = width * height
  if cfg.renderMode != "fixed" and cfg.maxRenderPixels > 0 and pixels > cfg.maxRenderPixels then
    factor = math.sqrt(cfg.maxRenderPixels / (pixels * 1.0))
    width = mt.floorInt(width * factor)
    height = mt.floorInt(height * factor)
    if width < 1 then width = 1 end if
    if height < 1 then height = 1 end if
  end if
  result = array(2)
  result[0] = width
  result[1] = height
  return result
end function
/// Converts a horizontal design coordinate to a framebuffer coordinate.
/// @param game Game providing the active resolution ratios.
/// @param value Horizontal design coordinate.
function designToRenderX(game, value) return value * game.renderScaleX end function
/// Converts a vertical design coordinate to a framebuffer coordinate.
/// @param game Game providing the active resolution ratios.
/// @param value Vertical design coordinate.
function designToRenderY(game, value) return value * game.renderScaleY end function
/// Converts a horizontal framebuffer coordinate to a design coordinate.
/// @param game Game providing the active resolution ratios.
/// @param value Horizontal framebuffer coordinate.
function renderToDesignX(game, value) return value / game.renderScaleX end function
/// Converts a vertical framebuffer coordinate to a design coordinate.
/// @param game Game providing the active resolution ratios.
/// @param value Vertical framebuffer coordinate.
function renderToDesignY(game, value) return value / game.renderScaleY end function

/// @internal
function syncRenderResolution(game)
  game.resolutionChanged = false
  if typeof(game.window) == "void" then return false end if
  clientW = win.clientWidth(game.window)
  clientH = win.clientHeight(game.window)
  // Minimized native windows commonly report a zero-sized client area. The
  // backends clamp that to one for safe input math; do not thrash the canvas.
  if game.config.renderMode != "fixed" and (clientW <= 1 or clientH <= 1) then return false end if
  size = renderSizeForClient(game.config, clientW, clientH)
  width = size[0]
  height = size[1]
  game.designWidth = game.config.designWidth
  game.designHeight = game.config.designHeight
  game.renderScaleX = width / (game.designWidth * 1.0)
  game.renderScaleY = height / (game.designHeight * 1.0)
  if width == game.canvas.width and height == game.canvas.height then return false end if
  cv.resize(game.canvas, width, height)
  win.setRenderSize(game.window, width, height)
  game.renderWidth = width
  game.renderHeight = height
  game.resolutionChanged = true
  return true
end function
/// Updates smoothing maintained by the minipixels module.
/// @param cfg Configuration used by the operation.
/// @param enabled enabled value consumed by this operation.
function setSmoothing(cfg, enabled)
  if cfg is GameConfig then cfg.smoothing = enabled end if
  return cfg
end function
/// Sets the rendered-frame limit, using zero for an uncapped loop.
/// @param cfg Configuration to update.
/// @param maxFps Maximum rendered frames per second.
function setMaxFps(cfg, maxFps)
  if cfg is GameConfig then
    if typeof(maxFps) != "int" or maxFps < 0 then maxFps = 0 end if
    cfg.maxFps = maxFps
  end if
  return cfg
end function
/// Configures whether simulation pauses when the window loses focus.
/// @param cfg Configuration to update.
/// @param enabled Whether focus loss pauses simulation updates.
function setPauseWhenUnfocused(cfg, enabled)
  if cfg is GameConfig then cfg.pauseWhenUnfocused = enabled == true end if
  return cfg
end function
/// Performs the activeRenderer operation for the minipixels module.
/// @param game game value consumed by this operation.
function activeRenderer(game)
  if game is Game and game.window != void then return win.rendererName(game.window) end if
  if game is Game then return game.config.renderer end if
  return "none"
end function
/// Returns whether gpu renderer satisfies the required condition.
/// @param game game value consumed by this operation.
function isGpuRenderer(game)
  if game is Game and game.window != void then return win.isGpuRenderer(game.window) end if
  return false
end function
/// Performs the rendererFallbackReason operation for the minipixels module.
/// @param game game value consumed by this operation.
function rendererFallbackReason(game)
  if game is Game and game.window != void then return win.rendererFallbackReason(game.window) end if
  return ""
end function
/// Performs the rgb operation for the minipixels module.
/// @param r r value consumed by this operation.
/// @param g g value consumed by this operation.
/// @param b b value consumed by this operation.
function rgb(r, g, b) return mt.rgb(r, g, b) end function
/// Performs the rgba operation for the minipixels module.
/// @param r r value consumed by this operation.
/// @param g g value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param a a value consumed by this operation.
function rgba(r, g, b, a) return mt.rgba(r, g, b, a) end function
/// Performs the vec2 operation for the minipixels module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function vec2(x, y) return mt.vec2(x, y) end function
/// Performs the recti operation for the minipixels module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
function recti(x, y, w, h) return mt.recti(x, y, w, h) end function
/// Performs the random operation for the minipixels module.
/// @param seed seed value consumed by this operation.
function random(seed) return mt.randomCreate(seed) end function
/// Performs the timer operation for the minipixels module.
/// @param seconds seconds value consumed by this operation.
/// @param repeat repeat value consumed by this operation.
function timer(seconds, repeat) return mt.timerCreate(seconds, repeat) end function
/// Performs the image operation for the minipixels module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param pixels pixels value consumed by this operation.
/// @param name Name of the affected item.
function image(width, height, pixels, name) return sp.newImage(width, height, pixels, name) end function
/// Performs the solidImage operation for the minipixels module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param color color value consumed by this operation.
/// @param name Name of the affected item.
function solidImage(width, height, color, name) return sp.solidImage(width, height, color, name) end function
/// Performs the spriteFromImage operation for the minipixels module.
/// @param img img value consumed by this operation.
/// @param name Name of the affected item.
function spriteFromImage(img, name) return sp.spriteFromImage(img, name) end function
/// Performs the spriteSheet operation for the minipixels module.
/// @param img img value consumed by this operation.
/// @param fw fw value consumed by this operation.
/// @param fh fh value consumed by this operation.
/// @param spacing spacing value consumed by this operation.
/// @param margin margin value consumed by this operation.
function spriteSheet(img, fw, fh, spacing, margin) return sp.spriteSheet(img, fw, fh, spacing, margin) end function
/// Creates an off-screen CPU render target.
/// @param width Render-target width.
/// @param height Render-target height.
function renderTarget(width, height) return cv.create(width, height) end function
/// Draws an off-screen render target onto another canvas.
/// @param canvas Destination canvas.
/// @param source Source render target.
/// @param x Destination x coordinate.
/// @param y Destination y coordinate.
function drawRenderTarget(canvas, source, x, y) return cv.drawCanvas(canvas, source, x, y) end function
/// Draws a sprite rotated around its configured pivot.
/// @param canvas Destination canvas.
/// @param sprite Sprite to draw.
/// @param x Pivot x coordinate.
/// @param y Pivot y coordinate.
/// @param radians Clockwise rotation in radians.
/// @param scale Positive integer scale.
/// @param tint Multiplicative RGBA tint.
function drawSpriteRotated(canvas, sprite, x, y, radians, scale, tint) return cv.drawSpriteRotated(canvas, sprite, x, y, radians, scale, tint) end function
/// Opens asset pack for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function openAssetPack(path) return pack.open(path) end function
/// Opens a signed and AES-256-GCM encrypted MPX3 version-4 asset pack.
/// Generated MiniPixels asset modules call this automatically for protected builds.
/// @param path Path to the protected pack.
/// @param key Per-build 32-byte AES key.
/// @param publicKey Embedded P-256 public verification key.
/// @param keyId Embedded public-key fingerprint prefix.
function openProtectedAssetPack(path, key, publicKey, keyId) return pack.openProtected(path, key, publicKey, keyId) end function
/// Loads bytes from pack for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function loadBytesFromPack(assetPack, name) return pack.getBytes(assetPack, name) end function
/// Resolves a dynamic asset name to a stable numeric slot, or -1.
/// @param assetPack Open asset pack.
/// @param name Stable asset name.
function assetSlotFromPack(assetPack, name) return pack.find(assetPack, name) end function
/// Loads bytes from a pre-resolved asset slot without a string lookup.
/// @param assetPack Open asset pack.
/// @param slot Pre-resolved entry slot.
function loadBytesFromPackSlot(assetPack, slot) return pack.getBytesAt(assetPack, slot) end function
/// Releases cached raw bytes for a pre-resolved slot while keeping decoded objects.
/// @param assetPack Open asset pack.
/// @param slot Pre-resolved entry slot.
function releasePackedAssetBytesSlot(assetPack, slot) return pack.dropPayloadAt(assetPack, slot) end function
/// Performs the assetKindFromPack operation for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function assetKindFromPack(assetPack, name) return pack.getKind(assetPack, name) end function
/// Returns the type code for a pre-resolved asset slot.
/// @param assetPack Open asset pack.
/// @param slot Pre-resolved entry slot.
function assetKindFromPackSlot(assetPack, slot) return pack.getKindAt(assetPack, slot) end function
/// Loads a UTF-8 localization catalog from a packed text asset.
/// @param assetPack Open asset pack.
/// @param name Packed text asset id.
/// @param locale Locale assigned to the decoded catalog.
function loadTextCatalogFromPack(assetPack, name, locale) return textAssets.load(assetPack, name, locale) end function
/// Loads a UTF-8 localization catalog from a pre-resolved asset slot.
/// @param assetPack Open asset pack.
/// @param slot Pre-resolved entry slot.
/// @param locale Locale assigned to the decoded catalog.
function loadTextCatalogFromPackSlot(assetPack, slot, locale) return textAssets.loadAt(assetPack, slot, locale) end function
/// Creates a locale service with language-region fallback and a default locale.
/// @param defaultLocale Locale used when a requested catalog or key is absent.
function localization(defaultLocale) return textAssets.create(defaultLocale) end function
/// Loads png from pack for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function loadPngFromPack(assetPack, name) return pack.loadPng(assetPack, name) end function
/// Loads a PNG from a pre-resolved asset slot without a string lookup.
/// @param assetPack Open asset pack.
/// @param slot Pre-resolved entry slot.
function loadPngFromPackSlot(assetPack, slot) return pack.loadPngAt(assetPack, slot) end function
/// Loads a common non-interlaced PNG file directly from disk.
/// @param path PNG file path.
function loadPng(path) return png.load(path) end function
/// Saves a canvas as a deterministic RGBA PNG screenshot.
/// @param canvas Canvas to save.
/// @param path Destination PNG path.
function saveCanvasPng(canvas, path) return png.saveRgba(path, canvas.width, canvas.height, canvas.pixels) end function
/// Drops cached payload and decoded-image data for one packed asset.
/// @param assetPack Asset pack to mutate.
/// @param name Registered packed asset name.
function unloadPackedAsset(assetPack, name) return pack.unload(assetPack, name) end function
/// Clears every cached payload and decoded image retained by an asset pack.
/// @param assetPack Asset pack to mutate.
function clearAssetPackCache(assetPack) return pack.clearCache(assetPack) end function
/// Returns asset-pack cache and lazy-I/O counters.
/// @param assetPack Open asset pack.
function assetPackStats(assetPack) return pack.stats(assetPack) end function
/// Closes an asset pack and wipes a retained MPX3 decryption key.
/// @param assetPack Open asset pack.
function closeAssetPack(assetPack) return pack.close(assetPack) end function
/// Performs the animation operation for the minipixels module.
/// @param maxFrames maxFrames value consumed by this operation.
function animation(maxFrames) return anim.create(maxFrames) end function
/// Performs the animationFromSheet operation for the minipixels module.
/// @param sheet sheet value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param count Number of items or units to process.
/// @param duration duration value consumed by this operation.
function animationFromSheet(sheet, start, count, duration) return anim.fromSheet(sheet, start, count, duration) end function
/// Performs the camera operation for the minipixels module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function camera(width, height) return cam.create(width, height) end function
/// Performs the tileset operation for the minipixels module.
/// @param sheet sheet value consumed by this operation.
function tileset(sheet) return tile.Tileset(sp.cacheFrames(sheet)) end function
/// Performs the tilemap operation for the minipixels module.
/// @param tileWidth tileWidth value consumed by this operation.
/// @param tileHeight tileHeight value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param tileset tileset value consumed by this operation.
/// @param maxLayers maxLayers value consumed by this operation.
function tilemap(tileWidth, tileHeight, width, height, tileset, maxLayers) return tile.create(tileWidth, tileHeight, width, height, tileset, maxLayers) end function
/// Performs the tileLayer operation for the minipixels module.
/// @param name Name of the affected item.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param data Input data consumed by the operation.
/// @param visible visible value consumed by this operation.
/// @param collision collision value consumed by this operation.
/// @param px px value consumed by this operation.
/// @param py py value consumed by this operation.
function tileLayer(name, width, height, data, visible, collision, px, py) return tile.layer(name, width, height, data, visible, collision, px, py) end function
/// Performs the tileMoveAndCollide operation for the minipixels module.
/// @param map map value consumed by this operation.
/// @param rect rect value consumed by this operation.
/// @param vx vx value consumed by this operation.
/// @param vy vy value consumed by this operation.
function tileMoveAndCollide(map, rect, vx, vy) return tile.moveAndCollide(map, rect, vx, vy) end function
/// Returns whether a point lies inside a rectangle.
/// @param x Point x coordinate.
/// @param y Point y coordinate.
/// @param rectangle Rectangle to test.
function pointRect(x, y, rectangle) return col.pointRect(x, y, rectangle) end function
/// Returns whether two rectangles overlap.
/// @param first First rectangle.
/// @param second Second rectangle.
function rectRect(first, second) return col.rectRect(first, second) end function
/// Returns whether a line segment intersects a rectangle.
/// @param x1 Segment start x coordinate.
/// @param y1 Segment start y coordinate.
/// @param x2 Segment end x coordinate.
/// @param y2 Segment end y coordinate.
/// @param rectangle Rectangle to test.
function lineRect(x1, y1, x2, y2, rectangle) return col.lineRect(x1, y1, x2, y2, rectangle) end function
/// Creates a scene with optional lifecycle callbacks.
/// @param name Stable scene name.
/// @param state User-owned scene state.
/// @param onEnter Callback invoked as onEnter(game, scene).
/// @param onExit Callback invoked as onExit(game, scene).
/// @param update Callback invoked as update(game, scene, dt).
/// @param render Callback invoked as render(game, scene, canvas).
/// @param onPause Callback invoked when another scene is pushed.
/// @param onResume Callback invoked after the scene above is popped.
/// @param renderBelow Whether scenes underneath remain visible.
function scene(name, state = void, onEnter = void, onExit = void, update = void, render = void, onPause = void, onResume = void, renderBelow = false)
  return scn.scene(name, state, onEnter, onExit, update, render, onPause, onResume, renderBelow)
end function
/// Registers a scene on a game.
/// @param game Game owning the scene stack.
/// @param value Scene to register.
function registerScene(game, value)
  if game is not Game then return false end if
  return scn.register(game.scenes, value.name, value)
end function
/// Replaces the active game scene.
/// @param game Game owning the scene stack.
/// @param name Registered scene name.
function changeScene(game, name) return scn.change(game.scenes, name, game) end function
/// Pushes a registered game scene.
/// @param game Game owning the scene stack.
/// @param name Registered scene name.
function pushScene(game, name) return scn.push(game.scenes, name, game) end function
/// Pops the active game scene.
/// @param game Game owning the scene stack.
function popScene(game) return scn.pop(game.scenes, game) end function
/// Performs the fillRectWorld operation for the minipixels module.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function fillRectWorld(canvas, camera, x, y, w, h, color) return cv.fillRectWorld(canvas, camera, x, y, w, h, color) end function
/// Draws rect world through the minipixels rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param color color value consumed by this operation.
function drawRectWorld(canvas, camera, x, y, w, h, color) return cv.drawRectWorld(canvas, camera, x, y, w, h, color) end function
/// Draws sprite world through the minipixels rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param sprite sprite value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function drawSpriteWorld(canvas, camera, sprite, x, y) return cv.drawSpriteWorld(canvas, camera, sprite, x, y) end function
/// Draws sprite world ex through the minipixels rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param camera camera value consumed by this operation.
/// @param sprite sprite value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param flipX flipX value consumed by this operation.
/// @param flipY flipY value consumed by this operation.
/// @param scale scale value consumed by this operation.
/// @param tint tint value consumed by this operation.
function drawSpriteWorldEx(canvas, camera, sprite, x, y, flipX, flipY, scale, tint) return cv.drawSpriteWorldEx(canvas, camera, sprite, x, y, flipX, flipY, scale, tint) end function
/// Performs the inputDown operation for the minipixels module.
/// @param input input value consumed by this operation.
/// @param action action value consumed by this operation.
function inputDown(input, action) return inp.isDown(input, action) end function
/// Performs the inputPressed operation for the minipixels module.
/// @param input input value consumed by this operation.
/// @param action action value consumed by this operation.
function inputPressed(input, action) return inp.pressed(input, action) end function
/// Performs the inputReleased operation for the minipixels module.
/// @param input input value consumed by this operation.
/// @param action action value consumed by this operation.
function inputReleased(input, action) return inp.released(input, action) end function
/// Binds one virtual key to an input action.
/// @param input Input state to configure.
/// @param action Action name to configure.
/// @param key Win32 virtual-key code.
function bindKey(input, action, key) return inp.bindKeys(input, action, key, -1) end function
/// Binds two alternative virtual keys to an input action.
/// @param input Input state to configure.
/// @param action Action name to configure.
/// @param primary Primary Win32 virtual-key code.
/// @param secondary Secondary Win32 virtual-key code, or -1.
function bindKeys(input, action, primary, secondary) return inp.bindKeys(input, action, primary, secondary) end function
/// Removes virtual-key bindings from an input action.
/// @param input Input state to configure.
/// @param action Action name to unbind.
function unbindAction(input, action) return inp.unbind(input, action) end function
/// Draws text through the minipixels rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function drawText(canvas, text, x, y, scale, color) return font.drawText(canvas, text, x, y, scale, color) end function
/// Draws text centered through the minipixels rendering path.
/// @param canvas canvas value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param scale scale value consumed by this operation.
/// @param color color value consumed by this operation.
function drawTextCentered(canvas, text, y, scale, color) return font.drawTextCentered(canvas, text, y, scale, color) end function
/// Performs the textWidth operation for the minipixels module.
/// @param text Text consumed by the operation.
/// @param scale scale value consumed by this operation.
function textWidth(text, scale) return font.textWidth(text, scale) end function
/// Performs the playSound operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function playSound(path) return aud.playSound(path) end function
/// Performs the playSoundSync operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function playSoundSync(path) return aud.playSoundSync(path) end function
/// Performs the playSoundLoop operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function playSoundLoop(path) return aud.playSoundLoop(path) end function
/// Performs the playMusic operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function playMusic(path) return aud.playMusic(path) end function
/// Stops sound for the minipixels workflow.
function stopSound() return aud.stopSound() end function
/// Performs the audioState operation for the minipixels module.
function audioState() return aud.create() end function
/// Performs the playSfx operation for the minipixels module.
/// @param audio audio value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function playSfx(audio, path) return aud.playSfx(audio, path) end function
/// Performs the playMusicWithState operation for the minipixels module.
/// @param audio audio value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function playMusicWithState(audio, path) return aud.playMusicWithState(audio, path) end function
/// Performs the audioClip operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
/// @param name Name of the affected item.
function audioClip(path, name) return aud.clip(path, name) end function
/// Performs the audioClipFromBytes operation for the minipixels module.
/// @param data Input data consumed by the operation.
/// @param name Name of the affected item.
function audioClipFromBytes(data, name) return aud.clipFromBytes(data, name) end function
/// Performs the musicClip operation for the minipixels module.
/// @param path Path of the file or directory used by the operation.
/// @param name Name of the affected item.
function musicClip(path, name) return aud.musicClip(path, name) end function
/// Creates a streaming-capable music clip from complete WAV or MP3 bytes.
/// @param data Complete audio file bytes.
/// @param name Stable clip name.
function musicClipFromBytes(data, name) return aud.musicClipFromBytes(data, name) end function
/// Performs the playAudio operation for the minipixels module.
/// @param audio audio value consumed by this operation.
/// @param clip clip value consumed by this operation.
function playAudio(audio, clip) return aud.playClip(audio, clip) end function
/// Performs the audioMixer operation for the minipixels module.
/// @param maxChannels maxChannels value consumed by this operation.
function audioMixer(maxChannels) return aud.mixer(maxChannels) end function
/// Performs the mixerPlaySfx operation for the minipixels module.
/// @param mixer mixer value consumed by this operation.
/// @param clip clip value consumed by this operation.
function mixerPlaySfx(mixer, clip) return aud.mixerPlaySfx(mixer, clip) end function
/// Performs the mixerPlayMusic operation for the minipixels module.
/// @param mixer mixer value consumed by this operation.
/// @param clip clip value consumed by this operation.
function mixerPlayMusic(mixer, clip) return aud.mixerPlayMusic(mixer, clip) end function
/// Performs the mixerStopAll operation for the minipixels module.
/// @param mixer mixer value consumed by this operation.
function mixerStopAll(mixer) return aud.mixerStopAll(mixer) end function
/// Performs the audioBackend operation for the minipixels module.
function audioBackend() return aud.backendName() end function
/// Performs the audioSupportsMultipleSfx operation for the minipixels module.
function audioSupportsMultipleSfx() return aud.supportsMultipleSfx() end function
/// Performs the audioSupportsVolumeControl operation for the minipixels module.
function audioSupportsVolumeControl() return aud.supportsVolumeControl() end function
/// Returns whether the advanced mixer supports MP3 input.
function audioSupportsMp3() return aud.supportsMp3() end function
/// Returns whether the advanced mixer preserves stereo input.
function audioSupportsStereo() return aud.supportsStereo() end function
/// Performs the frameHash operation for the minipixels module.
/// @param canvas canvas value consumed by this operation.
function frameHash(canvas) return dbg.captureHash(canvas) end function

/// Performs the callIfFunction operation for the minipixels module.
/// @param fn fn value consumed by this operation.
/// @param a a value consumed by this operation.
function callIfFunction(fn, a)
  if typeof(fn) == "function" then return fn(a) end if
end function

/// Performs the callUpdate operation for the minipixels module.
/// @param fn fn value consumed by this operation.
/// @param game game value consumed by this operation.
/// @param dt dt value consumed by this operation.
function callUpdate(fn, game, dt)
  if typeof(fn) == "function" then return fn(game, dt) end if
end function

/// Performs the callRender operation for the minipixels module.
/// @param fn fn value consumed by this operation.
/// @param game game value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
function callRender(fn, game, canvas)
  if typeof(fn) == "function" then return fn(game, canvas) end if
end function

/// Runs headless for the minipixels workflow.
/// @param cfg Configuration used by the operation.
/// @param initialize initialize value consumed by this operation.
/// @param update update value consumed by this operation.
/// @param render render value consumed by this operation.
/// @param shutdown shutdown value consumed by this operation.
function runHeadless(cfg, initialize, update, render, shutdown)
  game = createGame(cfg)
  failure = try(callIfFunction(initialize, game))
  frame = 0
  while game.running and frame < cfg.headlessFrames and typeof(failure) != "error"
    game.input.beginFrame()
    tm.beginFrame(game.time, game.time.fixedDelta)
    game.input.beginUpdate()
    failure = try(callUpdate(update, game, game.time.fixedDelta))
    if typeof(failure) != "error" then failure = try(scn.updateCurrent(game.scenes, game, game.time.fixedDelta)) end if
    game.input.endUpdate()
    if typeof(failure) != "error" then tm.countUpdate(game.time) end if
    tm.finishFrame(game.time, 0)
    aud.update(game.audio)
    cv.resetStats(game.canvas)
    if typeof(failure) != "error" then failure = try(scn.renderStack(game.scenes, game, game.canvas)) end if
    if typeof(failure) != "error" then failure = try(callRender(render, game, game.canvas)) end if
    frame = frame + 1
  end while
  sceneShutdownResult = try(scn.clear(game.scenes, game))
  if typeof(failure) != "error" and typeof(sceneShutdownResult) == "error" then failure = sceneShutdownResult end if
  shutdownResult = try(callIfFunction(shutdown, game))
  aud.close(game.audio)
  if typeof(failure) != "error" and typeof(shutdownResult) == "error" then failure = shutdownResult end if
  if typeof(failure) == "error" then return failure end if
  return game
end function

/// Runs run for the minipixels workflow.
/// @param cfg Configuration used by the operation.
/// @param initialize initialize value consumed by this operation.
/// @param update update value consumed by this operation.
/// @param render render value consumed by this operation.
/// @param shutdown shutdown value consumed by this operation.
function run(cfg, initialize, update, render, shutdown)
  game = createGame(cfg)
  w = win.open(cfg.title, cfg.width, cfg.height, cfg.scale, cfg.renderer, cfg.scaleMode, cfg.smoothing)
  if typeof(w) == "error" then return w end if
  game.window = w
  syncRenderResolution(game)
  failure = try(callIfFunction(initialize, game))

  lastTime = win.seconds()
  nextFrameTime = lastTime
  accumulator = 0.0
  while game.running and win.running() and typeof(failure) != "error"
    now = win.seconds()
    dt = now - lastTime
    lastTime = now
    if dt > cfg.maxFrameSeconds then dt = cfg.maxFrameSeconds end if

    win.pollEvents(w)
    syncRenderResolution(game)
    win.updateInputForWindow(w, game.input)
    if game.input.escape then game.running = false end if
    if cfg.pauseWhenUnfocused and win.hasFocus(w) == false then dt = 0 end if

    tm.beginFrame(game.time, dt)
    if game.time.frameNumber % 15 == 1 then
      win.setTitle(w, cfg.title + " FPS " + mt.floorInt(game.time.fps) + " " + win.rendererName(w))
    end if
    accumulator = accumulator + dt
    updates = 0
    while accumulator >= game.time.fixedDelta and updates < cfg.maxCatchUpUpdates
      game.input.beginUpdate()
      failure = try(callUpdate(update, game, game.time.fixedDelta))
      if typeof(failure) != "error" then failure = try(scn.updateCurrent(game.scenes, game, game.time.fixedDelta)) end if
      game.input.endUpdate()
      if typeof(failure) == "error" then break end if
      tm.countUpdate(game.time)
      accumulator = accumulator - game.time.fixedDelta
      updates = updates + 1
    end while
    if updates >= cfg.maxCatchUpUpdates and accumulator >= game.time.fixedDelta then accumulator = 0 end if
    tm.finishFrame(game.time, accumulator / game.time.fixedDelta)
    aud.update(game.audio)

    cv.resetStats(game.canvas)
    if typeof(failure) != "error" then failure = try(scn.renderStack(game.scenes, game, game.canvas)) end if
    if typeof(failure) != "error" then failure = try(callRender(render, game, game.canvas)) end if
    if typeof(failure) != "error" then
      if game.debug then dbg.drawStats(game, game.canvas) end if
      win.present(w, game.canvas)
    end if
    if cfg.maxFps > 0 then
      nextFrameTime = nextFrameTime + (1.0 / cfg.maxFps)
      currentTime = win.seconds()
      if nextFrameTime < currentTime then nextFrameTime = currentTime end if
      win.waitUntil(nextFrameTime)
    else
      win.sleepMs(0)
    end if
  end while

  sceneShutdownResult = try(scn.clear(game.scenes, game))
  if typeof(failure) != "error" and typeof(sceneShutdownResult) == "error" then failure = sceneShutdownResult end if
  shutdownResult = try(callIfFunction(shutdown, game))
  aud.close(game.audio)
  win.close(w)
  if typeof(failure) != "error" and typeof(shutdownResult) == "error" then failure = shutdownResult end if
  if typeof(failure) == "error" then return failure end if
  return 0
end function
