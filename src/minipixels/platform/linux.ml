// SPDX-License-Identifier: Apache-2.0

//! Provides the native X11 platform backend for MiniPixels on Linux x64.

package minipixels.platform.linux

import std.time as time
import minipixels.math.types as mt
import minipixels.input.input as inp

/// @internal
extern function mpPixelsRgbaToBgra(destination as bytes, destinationOffset as u64, source as bytes, sourceOffset as u64, pixelCount as int) from "./libminipixels_audio.so" returns void
/// @internal
extern function mpPixelsScaleIntegerBgra(destination as bytes, destinationWidth as int, destinationHeight as int, source as bytes, sourceWidth as int, sourceHeight as int, viewportX as int, viewportY as int, factor as int) from "./libminipixels_audio.so" returns i32
/// @internal
extern function mpPixelsScaleNearestBgra(destination as bytes, destinationWidth as int, destinationHeight as int, source as bytes, sourceWidth as int, sourceHeight as int, viewportX as int, viewportY as int, viewportWidth as int, viewportHeight as int) from "./libminipixels_audio.so" returns i32

/// @internal
extern function XOpenDisplay(name as ptr) from "libX11.so.6" returns ptr
/// @internal
extern function XDefaultScreen(display as ptr) from "libX11.so.6" returns int
/// @internal
extern function XRootWindow(display as ptr, screen as int) from "libX11.so.6" returns u64
/// @internal
extern function XBlackPixel(display as ptr, screen as int) from "libX11.so.6" returns u64
/// @internal
extern function XDefaultVisual(display as ptr, screen as int) from "libX11.so.6" returns ptr
/// @internal
extern function XDefaultDepth(display as ptr, screen as int) from "libX11.so.6" returns int
/// @internal
extern function XCreateSimpleWindow(display as ptr, parent as u64, x as int, y as int, width as u32, height as u32, borderWidth as u32, border as u64, background as u64) from "libX11.so.6" returns u64
/// @internal
extern function XStoreName(display as ptr, window as u64, title as cstr) from "libX11.so.6" returns int
/// @internal
extern function XSelectInput(display as ptr, window as u64, eventMask as i64) from "libX11.so.6" returns int
/// @internal
extern function XMapWindow(display as ptr, window as u64) from "libX11.so.6" returns int
/// @internal
extern function XFlush(display as ptr) from "libX11.so.6" returns int
/// @internal
extern function XPending(display as ptr) from "libX11.so.6" returns int
/// @internal
extern function XNextEvent(display as ptr, event as bytes) from "libX11.so.6" returns int
/// @internal
extern function XLookupKeysym(event as bytes, index as int) from "libX11.so.6" returns u64
/// @internal
extern function XCreateGC(display as ptr, drawable as u64, valueMask as u64, values as ptr) from "libX11.so.6" returns ptr
/// @internal
extern function XFreeGC(display as ptr, gc as ptr) from "libX11.so.6" returns int
/// @internal
extern function XDestroyWindow(display as ptr, window as u64) from "libX11.so.6" returns int
/// @internal
extern function XCloseDisplay(display as ptr) from "libX11.so.6" returns int
/// @internal
extern function XInternAtom(display as ptr, name as cstr, onlyIfExists as bool) from "libX11.so.6" returns u64
/// @internal
extern function XSetWMProtocols(display as ptr, window as u64, protocols as bytes, count as int) from "libX11.so.6" returns int
/// @internal
extern function XCreateImage(display as ptr, visual as ptr, depth as u32, format as int, offset as int, data as ptr, width as u32, height as u32, bitmapPad as int, bytesPerLine as int) from "libX11.so.6" returns ptr
/// @internal
extern function XPutImage(display as ptr, drawable as u64, gc as ptr, image as ptr, srcX as int, srcY as int, destX as int, destY as int, width as u32, height as u32) from "libX11.so.6" returns int
/// @internal
extern function XFree(value as ptr) from "libX11.so.6" returns int
/// @internal
extern function XkbSetDetectableAutoRepeat(display as ptr, detectable as bool, supported as bytes) from "libX11.so.6" returns bool

const KEY_PRESS = 2
const KEY_RELEASE = 3
const BUTTON_PRESS = 4
const BUTTON_RELEASE = 5
const MOTION_NOTIFY = 6
const ENTER_NOTIFY = 7
const LEAVE_NOTIFY = 8
const FOCUS_IN = 9
const FOCUS_OUT = 10
const EXPOSE = 12
const DESTROY_NOTIFY = 17
const CONFIGURE_NOTIFY = 22
const CLIENT_MESSAGE = 33

const KEY_PRESS_MASK = 0x000001
const KEY_RELEASE_MASK = 0x000002
const BUTTON_PRESS_MASK = 0x000004
const BUTTON_RELEASE_MASK = 0x000008
const ENTER_WINDOW_MASK = 0x000010
const LEAVE_WINDOW_MASK = 0x000020
const POINTER_MOTION_MASK = 0x000040
const STRUCTURE_NOTIFY_MASK = 0x020000
const FOCUS_CHANGE_MASK = 0x200000
const EXPOSURE_MASK = 0x008000
const ZPIXMAP = 2

windowRunning = false

/// Holds one X11 window and its retained presenter/input state.
struct Window
  display
  id
  gc
  visual
  depth
  image
  presentPixels
  logicalWidth
  logicalHeight
  clientWidth
  clientHeight
  scale
  title
  renderer
  fallbackReason
  scaleMode
  smoothing
  event
  keyStates
  pointerX
  pointerY
  pointerInside
  wheel
  focused
  alive
  wmDelete
  needsPresent
end struct

/// @internal
function getU32(buffer, offset)
  return buffer[offset] | (buffer[offset + 1] << 8) | (buffer[offset + 2] << 16) | (buffer[offset + 3] << 24)
end function

/// @internal
function getI32(buffer, offset)
  value = getU32(buffer, offset)
  if value >= 2147483648 then return value - 4294967296 end if
  return value
end function

/// @internal
function getU64(buffer, offset)
  return getU32(buffer, offset) + (getU32(buffer, offset + 4) << 32)
end function

/// @internal
function putU64(buffer, offset, value)
  for index = 0 to 7
    buffer[offset + index] = (value >> (index * 8)) & 255
  end for
end function

/// @internal
function normalizeScaleMode(value)
  if value == "fit" then return "fit" end if
  if value == "integer" or value == "pixel-perfect" then return "integer" end if
  return "stretch"
end function

/// Opens an X11 window. Linux currently uses the CPU XImage presenter.
/// @param title Human-readable window title.
/// @param width Logical framebuffer width.
/// @param height Logical framebuffer height.
/// @param scale Initial integer window scale.
/// @param renderer Requested renderer name.
/// @param scaleMode Stretch, fit, or integer presentation mode.
/// @param smoothing Smoothing preference retained for renderer compatibility.
function open(title, width, height, scale, renderer, scaleMode, smoothing)
  global windowRunning
  display = XOpenDisplay(0)
  if display == 0 then return error(7001, "MiniPixels could not open the X11 display.") end if
  screen = XDefaultScreen(display)
  root = XRootWindow(display, screen)
  black = XBlackPixel(display, screen)
  clientWidth = width * scale
  clientHeight = height * scale
  id = XCreateSimpleWindow(display, root, 100, 100, clientWidth, clientHeight, 0, black, black)
  if id == 0 then
    XCloseDisplay(display)
    return error(7001, "MiniPixels could not create the X11 window.")
  end if
  mask = KEY_PRESS_MASK | KEY_RELEASE_MASK | BUTTON_PRESS_MASK | BUTTON_RELEASE_MASK | ENTER_WINDOW_MASK | LEAVE_WINDOW_MASK | POINTER_MOTION_MASK | STRUCTURE_NOTIFY_MASK | FOCUS_CHANGE_MASK | EXPOSURE_MASK
  XSelectInput(display, id, mask)
  XStoreName(display, id, title)
  wmDelete = XInternAtom(display, "WM_DELETE_WINDOW", false)
  protocols = bytes(8, 0)
  putU64(protocols, 0, wmDelete)
  XSetWMProtocols(display, id, protocols, 1)
  gc = XCreateGC(display, id, 0, 0)
  if gc == 0 then
    XDestroyWindow(display, id)
    XCloseDisplay(display)
    return error(7001, "MiniPixels could not create the X11 graphics context.")
  end if
  XkbSetDetectableAutoRepeat(display, true, bytes(4, 0))
  XMapWindow(display, id)
  XFlush(display)
  fallback = ""
  if renderer == "opengl" or renderer == "gpu" then fallback = "opengl-unavailable-linux" end if
  windowRunning = true
  return Window(
    display, id, gc, XDefaultVisual(display, screen), XDefaultDepth(display, screen),
    0, void, width, height, clientWidth, clientHeight, scale, title, "x11", fallback,
    normalizeScaleMode(scaleMode), smoothing, bytes(192, 0), array(256, false),
    0, 0, false, 0, true, true, wmDelete, true
  )
end function

/// Returns whether the active Linux window remains open.
function running()
  global windowRunning
  return windowRunning
end function

/// Releases one X11 window and its native resources.
/// @param w Window to close.
function close(w)
  global windowRunning
  windowRunning = false
  if w is not Window or w.display == 0 then return end if
  w.alive = false
  if w.image != 0 then
    XFree(w.image)
    w.image = 0
  end if
  if w.gc != 0 then
    XFreeGC(w.display, w.gc)
    w.gc = 0
  end if
  if w.id != 0 then
    XDestroyWindow(w.display, w.id)
    w.id = 0
  end if
  XCloseDisplay(w.display)
  w.display = 0
end function

/// Returns the active native renderer name.
/// @param w Window to inspect.
function rendererName(w)
  if w is not Window then return "none" end if
  return w.renderer
end function

/// Returns whether the active Linux presenter is GPU-accelerated.
/// @param w Window to inspect.
function isGpuRenderer(w)
  return false
end function

/// Returns the renderer fallback reason, if any.
/// @param w Window to inspect.
function rendererFallbackReason(w)
  if w is not Window then return "none" end if
  return w.fallbackReason
end function

/// Updates the native window title.
/// @param w Window to update.
/// @param title New human-readable title.
function setTitle(w, title)
  if w is not Window or w.display == 0 then return false end if
  w.title = title
  return XStoreName(w.display, w.id, title) != 0
end function

/// @internal
function keysymToVirtualKey(sym)
  if sym >= 0x61 and sym <= 0x7A then return sym - 0x20 end if
  if sym >= 0x20 and sym <= 0x5A then return sym end if
  if sym == 0xFF08 then return 0x08 end if
  if sym == 0xFF09 then return 0x09 end if
  if sym == 0xFF0D then return 0x0D end if
  if sym == 0xFF1B then return 0x1B end if
  if sym == 0xFF50 then return 0x24 end if
  if sym == 0xFF51 then return 0x25 end if
  if sym == 0xFF52 then return 0x26 end if
  if sym == 0xFF53 then return 0x27 end if
  if sym == 0xFF54 then return 0x28 end if
  if sym == 0xFF55 then return 0x21 end if
  if sym == 0xFF56 then return 0x22 end if
  if sym == 0xFF57 then return 0x23 end if
  if sym == 0xFF63 then return 0x2D end if
  if sym == 0xFFFF then return 0x2E end if
  if sym == 0xFFE1 or sym == 0xFFE2 then return 0x10 end if
  if sym == 0xFFE3 or sym == 0xFFE4 then return 0x11 end if
  if sym == 0xFFE9 or sym == 0xFFEA then return 0x12 end if
  if sym >= 0xFFBE and sym <= 0xFFC9 then return 0x70 + (sym - 0xFFBE) end if
  return -1
end function

/// @internal
function setKeyState(w, virtualKey, down)
  if virtualKey >= 0 and virtualKey < len(w.keyStates) then w.keyStates[virtualKey] = down end if
end function

/// @internal
function clearKeyStates(w)
  for index = 0 to len(w.keyStates) - 1
    w.keyStates[index] = false
  end for
end function

/// @internal
function processEvent(w)
  global windowRunning
  typ = getI32(w.event, 0)
  if typ == KEY_PRESS or typ == KEY_RELEASE then
    key = keysymToVirtualKey(XLookupKeysym(w.event, 0))
    setKeyState(w, key, typ == KEY_PRESS)
  else if typ == BUTTON_PRESS or typ == BUTTON_RELEASE then
    button = getU32(w.event, 84)
    down = typ == BUTTON_PRESS
    if button == 1 then setKeyState(w, 0x01, down) end if
    if button == 2 then setKeyState(w, 0x04, down) end if
    if button == 3 then setKeyState(w, 0x02, down) end if
    if down and button == 4 then w.wheel = w.wheel + 1 end if
    if down and button == 5 then w.wheel = w.wheel - 1 end if
    w.pointerX = getI32(w.event, 64)
    w.pointerY = getI32(w.event, 68)
    w.pointerInside = true
  else if typ == MOTION_NOTIFY then
    w.pointerX = getI32(w.event, 64)
    w.pointerY = getI32(w.event, 68)
    w.pointerInside = true
  else if typ == ENTER_NOTIFY then
    w.pointerX = getI32(w.event, 64)
    w.pointerY = getI32(w.event, 68)
    w.pointerInside = true
  else if typ == LEAVE_NOTIFY then
    w.pointerInside = false
  else if typ == FOCUS_IN then
    w.focused = true
  else if typ == FOCUS_OUT then
    w.focused = false
    w.pointerInside = false
    clearKeyStates(w)
  else if typ == CONFIGURE_NOTIFY then
    width = getI32(w.event, 56)
    height = getI32(w.event, 60)
    if width > 0 and width != w.clientWidth then
      w.clientWidth = width
      w.needsPresent = true
    end if
    if height > 0 and height != w.clientHeight then
      w.clientHeight = height
      w.needsPresent = true
    end if
  else if typ == EXPOSE then
    w.needsPresent = true
  else if typ == CLIENT_MESSAGE and getU64(w.event, 56) == w.wmDelete then
    w.alive = false
    windowRunning = false
  else if typ == DESTROY_NOTIFY then
    w.alive = false
    w.id = 0
    windowRunning = false
  end if
end function

/// Drains pending X11 events into retained window state.
/// @param w Window whose event queue is polled.
function pollEvents(w)
  if w is not Window or w.display == 0 then return end if
  while XPending(w.display) > 0
    XNextEvent(w.display, w.event)
    processEvent(w)
  end while
end function

/// Returns whether the window currently owns keyboard focus.
/// @param w Window to inspect.
function hasFocus(w)
  if w is not Window then return false end if
  return w.focused and w.alive
end function

/// Returns the current native client width.
/// @param w Window to inspect.
function clientWidth(w)
  if w is not Window or w.clientWidth < 1 then return 1 end if
  return w.clientWidth
end function

/// Returns the current native client height.
/// @param w Window to inspect.
function clientHeight(w)
  if w is not Window or w.clientHeight < 1 then return 1 end if
  return w.clientHeight
end function

/// Updates the logical source size used by presentation and pointer mapping.
/// @param w Window to update.
/// @param width New framebuffer width.
/// @param height New framebuffer height.
function setRenderSize(w, width, height)
  if w is not Window or width < 1 or height < 1 then return false end if
  width = mt.floorInt(width)
  height = mt.floorInt(height)
  if w.logicalWidth == width and w.logicalHeight == height then return false end if
  w.logicalWidth = width
  w.logicalHeight = height
  w.needsPresent = true
  return true
end function

/// Publishes retained X11 keyboard and pointer state to an input frame.
/// @param w Source window.
/// @param input Destination input state.
function updateInputForWindow(w, input)
  input.beginFrame()
  if hasFocus(w) == false then
    inp.releaseAll(input)
    inp.setMousePosition(input, input.mouseX, input.mouseY, false)
    w.wheel = 0
    return
  end if
  if input.actionCount > 0 then
    for slot = 0 to input.actionCount - 1
      primary = input.primaryKeys[slot]
      secondary = input.secondaryKeys[slot]
      held = false
      if primary >= 0 and primary < len(w.keyStates) and w.keyStates[primary] then held = true end if
      if secondary >= 0 and secondary < len(w.keyStates) and w.keyStates[secondary] then held = true end if
      inp.setActionState(input, input.actionNames[slot], held)
    end for
  end if
  view = viewport(w, w.logicalWidth, w.logicalHeight)
  vx = view[0]
  vy = view[1]
  vw = view[2]
  vh = view[3]
  x = mt.floorInt(((w.pointerX - vx) * w.logicalWidth) / vw)
  y = mt.floorInt(((w.pointerY - vy) * w.logicalHeight) / vh)
  x = mt.clamp(x, 0, w.logicalWidth - 1)
  y = mt.clamp(y, 0, w.logicalHeight - 1)
  inside = w.pointerInside and w.pointerX >= vx and w.pointerY >= vy and w.pointerX < vx + vw and w.pointerY < vy + vh
  inp.setMousePosition(input, x, y, inside)
  if w.wheel != 0 then inp.addMouseWheel(input, w.wheel) end if
  w.wheel = 0
end function

/// Clears platform input for callers without an active window.
/// @param input Destination input state.
function updateInput(input)
  input.beginFrame()
  inp.releaseAll(input)
end function

/// @internal
function viewport(w, logicalWidth, logicalHeight)
  vx = 0
  vy = 0
  vw = w.clientWidth
  vh = w.clientHeight
  if w.scaleMode == "fit" or w.scaleMode == "integer" then
    sx = w.clientWidth / logicalWidth
    sy = w.clientHeight / logicalHeight
    factor = sx
    if sy < factor then factor = sy end if
    if w.scaleMode == "integer" then
      factor = mt.floorInt(factor)
      if factor < 1 then factor = 1 end if
    end if
    vw = mt.floorInt(logicalWidth * factor)
    vh = mt.floorInt(logicalHeight * factor)
    vx = mt.floorInt((w.clientWidth - vw) / 2)
    vy = mt.floorInt((w.clientHeight - vh) / 2)
  end if
  result = array(4)
  result[0] = vx
  result[1] = vy
  result[2] = vw
  result[3] = vh
  return result
end function

/// @internal
function ensureImage(w)
  expected = w.clientWidth * w.clientHeight * 4
  if typeof(w.presentPixels) == "bytes" and len(w.presentPixels) == expected and w.image != 0 then return true end if
  if w.image != 0 then XFree(w.image) end if
  w.presentPixels = bytes(expected, 0)
  w.image = XCreateImage(w.display, w.visual, w.depth, ZPIXMAP, 0, nativeBytesPtr(w.presentPixels), w.clientWidth, w.clientHeight, 32, w.clientWidth * 4)
  w.needsPresent = true
  return w.image != 0
end function

/// @internal
function convertNativeRegion(w, canvas, x0, y0, x1, y1)
  for y = y0 to y1 - 1
    source = (y * canvas.width + x0) * 4
    destination = (y * w.clientWidth + x0) * 4
    mpPixelsRgbaToBgra(w.presentPixels, destination, canvas.pixels, source, x1 - x0)
  end for
end function

/// @internal
function scaleInteger(w, canvas, vx, vy, factor)
  if vx != 0 or vy != 0 or canvas.width * factor != w.clientWidth or canvas.height * factor != w.clientHeight then
    fillBytes(w.presentPixels, 0, len(w.presentPixels), 0)
  end if
  mpPixelsScaleIntegerBgra(w.presentPixels, w.clientWidth, w.clientHeight, canvas.pixels, canvas.width, canvas.height, vx, vy, factor)
end function

/// @internal
function scaleGeneric(w, canvas, vx, vy, vw, vh)
  mpPixelsScaleNearestBgra(w.presentPixels, w.clientWidth, w.clientHeight, canvas.pixels, canvas.width, canvas.height, vx, vy, vw, vh)
end function

/// Scales and presents an RGBA canvas through an X11 XImage.
/// @param w Destination window.
/// @param canvas Source logical framebuffer.
function present(w, canvas)
  if w is not Window or w.alive == false or ensureImage(w) == false then return false end if
  if canvas.dirty == false then
    if w.needsPresent == false then return true end if
    XPutImage(w.display, w.id, w.gc, w.image, 0, 0, 0, 0, w.clientWidth, w.clientHeight)
    XFlush(w.display)
    w.needsPresent = false
    return true
  end if
  view = viewport(w, canvas.width, canvas.height)
  vx = view[0]
  vy = view[1]
  vw = view[2]
  vh = view[3]
  nativeSize = vx == 0 and vy == 0 and vw == canvas.width and vh == canvas.height and canvas.width == w.clientWidth and canvas.height == w.clientHeight
  if nativeSize then
    x0 = mt.clamp(canvas.dirtyX0, 0, canvas.width)
    y0 = mt.clamp(canvas.dirtyY0, 0, canvas.height)
    x1 = mt.clamp(canvas.dirtyX1, 0, canvas.width)
    y1 = mt.clamp(canvas.dirtyY1, 0, canvas.height)
    convertNativeRegion(w, canvas, x0, y0, x1, y1)
    if w.needsPresent then
      XPutImage(w.display, w.id, w.gc, w.image, 0, 0, 0, 0, w.clientWidth, w.clientHeight)
    else
      XPutImage(w.display, w.id, w.gc, w.image, x0, y0, x0, y0, x1 - x0, y1 - y0)
    end if
    XFlush(w.display)
    canvas.dirty = false
    w.needsPresent = false
    return true
  end if
  factor = mt.floorInt(vw / canvas.width)
  integerFits = vx >= 0 and vy >= 0 and vx + vw <= w.clientWidth and vy + vh <= w.clientHeight
  if integerFits and factor >= 1 and vw == canvas.width * factor and vh == canvas.height * factor then
    scaleInteger(w, canvas, vx, vy, factor)
  else
    scaleGeneric(w, canvas, vx, vy, vw, vh)
  end if
  XPutImage(w.display, w.id, w.gc, w.image, 0, 0, 0, 0, w.clientWidth, w.clientHeight)
  XFlush(w.display)
  canvas.dirty = false
  w.needsPresent = false
  return true
end function

/// Returns monotonic milliseconds since system start.
function ticks()
  return time.ticks()
end function

/// Returns monotonic time in fractional seconds.
function seconds()
  return time.ticks() / 1000.0
end function

/// Waits until an absolute monotonic deadline.
/// @param deadline Absolute value previously returned by seconds().
function waitUntil(deadline)
  now = seconds()
  while now < deadline
    remaining = mt.floorInt((deadline - now) * 1000)
    if remaining > 1 then time.sleep(remaining - 1) else time.sleep(0) end if
    now = seconds()
  end while
end function

/// Sleeps for a number of milliseconds.
/// @param ms Milliseconds to sleep.
function sleepMs(ms)
  time.sleep(ms)
end function
