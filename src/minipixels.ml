package minipixels

import minipixels.math.types as mt
import minipixels.graphics.canvas as cv
import minipixels.graphics.sprite as sp
import minipixels.graphics.font as font
import minipixels.input.input as inp
import minipixels.core.time as tm
import minipixels.platform.windows as win
import minipixels.assets.assets as ast
import minipixels.scene.scene as scn
import minipixels.debug.debug as dbg
import minipixels.animation.animation as anim
import minipixels.world.camera as cam
import minipixels.world.tilemap as tile
import minipixels.audio.audio as aud

struct GameConfig
  title
  width
  height
  scale
  updatesPerSecond
  maxFrameSeconds
  maxCatchUpUpdates
  debug
  headlessFrames
  renderer
  scaleMode
  smoothing
end struct

struct Game
  config
  canvas
  input
  time
  assets
  audio
  scenes
  running
  window
  debug

  function quit()
    this.running = false
  end function
end struct

function createConfig(title, width, height, scale)
  if width <= 0 then width = 320 end if
  if height <= 0 then height = 180 end if
  if scale <= 0 then scale = 4 end if
  return GameConfig(title, width, height, scale, 60, 0.25, 5, false, 120, "auto", "stretch", false)
end function

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

function version() return "0.5.0" end function
function setRenderer(cfg, renderer)
  if cfg is GameConfig then cfg.renderer = renderer end if
  return cfg
end function
function useGpuRenderer(cfg) return setRenderer(cfg, "opengl") end function
function useCpuRenderer(cfg) return setRenderer(cfg, "gdi") end function
function setScaleMode(cfg, mode)
  if cfg is GameConfig then cfg.scaleMode = mode end if
  return cfg
end function
function useStretchScale(cfg) return setScaleMode(cfg, "stretch") end function
function useFitScale(cfg) return setScaleMode(cfg, "fit") end function
function useIntegerScale(cfg) return setScaleMode(cfg, "integer") end function
function setSmoothing(cfg, enabled)
  if cfg is GameConfig then cfg.smoothing = enabled end if
  return cfg
end function
function activeRenderer(game)
  if game is Game and game.window != void then return win.rendererName(game.window) end if
  if game is Game then return game.config.renderer end if
  return "none"
end function
function isGpuRenderer(game)
  if game is Game and game.window != void then return win.isGpuRenderer(game.window) end if
  return false
end function
function rendererFallbackReason(game)
  if game is Game and game.window != void then return win.rendererFallbackReason(game.window) end if
  return ""
end function
function rgb(r, g, b) return mt.rgb(r, g, b) end function
function rgba(r, g, b, a) return mt.rgba(r, g, b, a) end function
function vec2(x, y) return mt.vec2(x, y) end function
function recti(x, y, w, h) return mt.recti(x, y, w, h) end function
function random(seed) return mt.randomCreate(seed) end function
function timer(seconds, repeat) return mt.timerCreate(seconds, repeat) end function
function image(width, height, pixels, name) return sp.newImage(width, height, pixels, name) end function
function solidImage(width, height, color, name) return sp.solidImage(width, height, color, name) end function
function spriteFromImage(img, name) return sp.spriteFromImage(img, name) end function
function spriteSheet(img, fw, fh, spacing, margin) return sp.spriteSheet(img, fw, fh, spacing, margin) end function
function animation(maxFrames) return anim.create(maxFrames) end function
function animationFromSheet(sheet, start, count, duration) return anim.fromSheet(sheet, start, count, duration) end function
function camera(width, height) return cam.create(width, height) end function
function tileset(sheet) return tile.Tileset(sheet) end function
function tilemap(tileWidth, tileHeight, width, height, tileset, maxLayers) return tile.create(tileWidth, tileHeight, width, height, tileset, maxLayers) end function
function tileLayer(name, width, height, data, visible, collision, px, py) return tile.layer(name, width, height, data, visible, collision, px, py) end function
function tileMoveAndCollide(map, rect, vx, vy) return tile.moveAndCollide(map, rect, vx, vy) end function
function fillRectWorld(canvas, camera, x, y, w, h, color) return cv.fillRectWorld(canvas, camera, x, y, w, h, color) end function
function drawRectWorld(canvas, camera, x, y, w, h, color) return cv.drawRectWorld(canvas, camera, x, y, w, h, color) end function
function drawSpriteWorld(canvas, camera, sprite, x, y) return cv.drawSpriteWorld(canvas, camera, sprite, x, y) end function
function drawSpriteWorldEx(canvas, camera, sprite, x, y, flipX, flipY, scale, tint) return cv.drawSpriteWorldEx(canvas, camera, sprite, x, y, flipX, flipY, scale, tint) end function
function inputDown(input, action) return inp.isDown(input, action) end function
function inputPressed(input, action) return inp.pressed(input, action) end function
function inputReleased(input, action) return inp.released(input, action) end function
function drawText(canvas, text, x, y, scale, color) return font.drawText(canvas, text, x, y, scale, color) end function
function drawTextCentered(canvas, text, y, scale, color) return font.drawTextCentered(canvas, text, y, scale, color) end function
function textWidth(text, scale) return font.textWidth(text, scale) end function
function playSound(path) return aud.playSound(path) end function
function playSoundSync(path) return aud.playSoundSync(path) end function
function playSoundLoop(path) return aud.playSoundLoop(path) end function
function playMusic(path) return aud.playMusic(path) end function
function stopSound() return aud.stopSound() end function
function audioState() return aud.create() end function
function playSfx(audio, path) return aud.playSfx(audio, path) end function
function playMusicWithState(audio, path) return aud.playMusicWithState(audio, path) end function
function audioClip(path, name) return aud.clip(path, name) end function
function musicClip(path, name) return aud.musicClip(path, name) end function
function playAudio(audio, clip) return aud.playClip(audio, clip) end function
function audioMixer(maxChannels) return aud.mixer(maxChannels) end function
function mixerPlaySfx(mixer, clip) return aud.mixerPlaySfx(mixer, clip) end function
function mixerPlayMusic(mixer, clip) return aud.mixerPlayMusic(mixer, clip) end function
function mixerStopAll(mixer) return aud.mixerStopAll(mixer) end function
function audioBackend() return aud.backendName() end function
function audioSupportsMultipleSfx() return aud.supportsMultipleSfx() end function
function audioSupportsVolumeControl() return aud.supportsVolumeControl() end function
function frameHash(canvas) return dbg.captureHash(canvas) end function

function callIfFunction(fn, a)
  if typeof(fn) == "function" then return fn(a) end if
end function

function callUpdate(fn, game, dt)
  if typeof(fn) == "function" then return fn(game, dt) end if
end function

function callRender(fn, game, canvas)
  if typeof(fn) == "function" then return fn(game, canvas) end if
end function

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
    win.setTitle(w, cfg.title + " FPS " + mt.floorInt(game.time.fps) + " " + win.rendererName(w))
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
    win.sleepMs(1)
  end while

  callIfFunction(shutdown, game)
  win.close(w)
  return 0
end function
