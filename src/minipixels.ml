// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels facilities for this project.

package minipixels

import minipixels.math.types as mt
import minipixels.graphics.canvas as cv
import minipixels.graphics.sprite as sp
import minipixels.graphics.font as font
import minipixels.input.input as inp
import minipixels.core.time as tm
import minipixels.platform.windows as win
import minipixels.assets.assets as ast
import minipixels.assets.pack as pack
import minipixels.scene.scene as scn
import minipixels.debug.debug as dbg
import minipixels.animation.animation as anim
import minipixels.world.camera as cam
import minipixels.world.tilemap as tile
import minipixels.audio.audio as aud

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
  return GameConfig(title, width, height, scale, 60, 0.25, 5, false, 120, "auto", "stretch", false)
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
    aud.create(),
    scn.create(16),
    true,
    void,
    cfg.debug
  )
end function

/// Performs the version operation for the minipixels module.
function version() return "0.7.0" end function
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
/// Updates smoothing maintained by the minipixels module.
/// @param cfg Configuration used by the operation.
/// @param enabled enabled value consumed by this operation.
function setSmoothing(cfg, enabled)
  if cfg is GameConfig then cfg.smoothing = enabled end if
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
/// Opens asset pack for the minipixels module.
/// @param path Path of the file or directory used by the operation.
function openAssetPack(path) return pack.open(path) end function
/// Loads bytes from pack for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function loadBytesFromPack(assetPack, name) return pack.getBytes(assetPack, name) end function
/// Performs the assetKindFromPack operation for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function assetKindFromPack(assetPack, name) return pack.getKind(assetPack, name) end function
/// Loads png from pack for the minipixels module.
/// @param assetPack assetPack value consumed by this operation.
/// @param name Name of the affected item.
function loadPngFromPack(assetPack, name) return pack.loadPng(assetPack, name) end function
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
function tileset(sheet) return tile.Tileset(sheet) end function
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
  callIfFunction(initialize, game)
  frame = 0
  while game.running and frame < cfg.headlessFrames
    game.input.beginFrame()
    tm.beginFrame(game.time, game.time.fixedDelta)
    callUpdate(update, game, game.time.fixedDelta)
    tm.countUpdate(game.time)
    cv.resetStats(game.canvas)
    callRender(render, game, game.canvas)
    frame = frame + 1
  end while
  callIfFunction(shutdown, game)
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
  callIfFunction(initialize, game)

  lastTicks = win.ticks()
  accumulator = 0.0
  while game.running and win.running()
    now = win.ticks()
    elapsedMs = now - lastTicks
    lastTicks = now
    dt = elapsedMs / 1000.0
    if dt > cfg.maxFrameSeconds then dt = cfg.maxFrameSeconds end if

    win.pollEvents(w)
    win.updateInputForWindow(w, game.input)
    if game.input.escape then game.running = false end if

    tm.beginFrame(game.time, dt)
    if game.time.frameNumber % 15 == 1 then
      win.setTitle(w, cfg.title + " FPS " + mt.floorInt(game.time.fps) + " " + win.rendererName(w))
    end if
    accumulator = accumulator + dt
    updates = 0
    while accumulator >= game.time.fixedDelta and updates < cfg.maxCatchUpUpdates
      callUpdate(update, game, game.time.fixedDelta)
      tm.countUpdate(game.time)
      accumulator = accumulator - game.time.fixedDelta
      updates = updates + 1
    end while
    if updates >= cfg.maxCatchUpUpdates then accumulator = 0 end if

    cv.resetStats(game.canvas)
    callRender(render, game, game.canvas)
    if game.debug then dbg.drawStats(game, game.canvas) end if
    win.present(w, game.canvas)
    win.sleepMs(0)
  end while

  callIfFunction(shutdown, game)
  win.close(w)
  return 0
end function
