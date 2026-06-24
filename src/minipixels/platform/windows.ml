package minipixels.platform.windows

import minipixels.input.input as inp

const WM_DESTROY = 0x0002
const WM_CLOSE = 0x0010
const PM_REMOVE = 0x0001
const CS_OWNDC = 0x0020
const WS_OVERLAPPEDWINDOW = 0x00CF0000
const WS_VISIBLE = 0x10000000
const CW_USEDEFAULT = 0x80000000
const IDC_ARROW = 32512
const SW_HIDE = 0
const DIB_RGB_COLORS = 0
const SRCCOPY = 0x00CC0020
const PFD_DOUBLEBUFFER = 0x00000001
const PFD_DRAW_TO_WINDOW = 0x00000004
const PFD_SUPPORT_OPENGL = 0x00000020
const PFD_TYPE_RGBA = 0
const PFD_MAIN_PLANE = 0
const GL_TEXTURE_2D = 0x0DE1
const GL_RGBA = 0x1908
const GL_UNSIGNED_BYTE = 0x1401
const GL_TEXTURE_MAG_FILTER = 0x2800
const GL_TEXTURE_MIN_FILTER = 0x2801
const GL_TEXTURE_WRAP_S = 0x2802
const GL_TEXTURE_WRAP_T = 0x2803
const GL_NEAREST = 0x2600
const GL_CLAMP = 0x2900
const GL_UNPACK_ALIGNMENT = 0x0CF5
const GL_QUADS = 0x0007
const BLACKNESS = 0x00000042

extern function GetModuleHandleW(name as ptr) from "kernel32.dll" returns ptr
extern function GetConsoleWindow() from "kernel32.dll" returns ptr
extern function GetTickCount64() from "kernel32.dll" returns u64
extern function Sleep(ms as int) from "kernel32.dll" returns void

extern function RegisterClassExW(wndClass as bytes) from "user32.dll" returns u32
extern function CreateWindowExW(exStyle as int, className as ptr, windowName as ptr, style as int, x as int, y as int, w as int, h as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" returns ptr
extern function DefWindowProcW(hwnd as ptr, msg as u32, wParam as ptr, lParam as ptr) from "user32.dll" returns ptr
extern function DestroyWindow(hwnd as ptr) from "user32.dll" returns bool
extern function PostQuitMessage(exitCode as int) from "user32.dll" returns void
extern function LoadCursorW(instance as ptr, cursorName as ptr) from "user32.dll" returns ptr
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" returns bool
extern function UpdateWindow(hwnd as ptr) from "user32.dll" returns bool
extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" returns bool
extern function SetWindowTextW(hwnd as ptr, title as wstr) from "user32.dll" returns bool
extern function PeekMessageW(msg as bytes, hwnd as ptr, minFilter as u32, maxFilter as u32, removeMsg as u32) from "user32.dll" returns bool
extern function TranslateMessage(msg as bytes) from "user32.dll" returns bool
extern function DispatchMessageW(msg as bytes) from "user32.dll" returns ptr
extern function GetAsyncKeyState(key as int) from "user32.dll" returns i32
extern function GetForegroundWindow() from "user32.dll" returns ptr
extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" returns bool
extern function GetDC(hwnd as ptr) from "user32.dll" returns ptr
extern function ReleaseDC(hwnd as ptr, dc as ptr) from "user32.dll" returns int
extern function StretchDIBits(dc as ptr, xDest as int, yDest as int, destW as int, destH as int, xSrc as int, ySrc as int, srcW as int, srcH as int, bits as bytes, bmi as bytes, usage as int, rop as int) from "gdi32.dll" returns int
extern function SetStretchBltMode(dc as ptr, mode as int) from "gdi32.dll" returns int
extern function PatBlt(dc as ptr, x as int, y as int, width as int, height as int, rop as int) from "gdi32.dll" returns bool
extern function ChoosePixelFormat(dc as ptr, pfd as bytes) from "gdi32.dll" returns int
extern function SetPixelFormat(dc as ptr, pixelFormat as int, pfd as bytes) from "gdi32.dll" returns bool
extern function SwapBuffers(dc as ptr) from "gdi32.dll" returns bool
extern function wglCreateContext(dc as ptr) from "opengl32.dll" returns ptr
extern function wglMakeCurrent(dc as ptr, rc as ptr) from "opengl32.dll" returns bool
extern function wglDeleteContext(rc as ptr) from "opengl32.dll" returns bool
extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" returns void
extern function glEnable(cap as int) from "opengl32.dll" returns void
extern function glDisable(cap as int) from "opengl32.dll" returns void
extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" returns void
extern function glPixelStorei(name as int, param as int) from "opengl32.dll" returns void
extern function glGenTextures(count as int, textures as bytes) from "opengl32.dll" returns void
extern function glBindTexture(target as int, texture as u32) from "opengl32.dll" returns void
extern function glTexParameteri(target as int, name as int, param as int) from "opengl32.dll" returns void
extern function glTexImage2D(target as int, level as int, internalFormat as int, width as int, height as int, border as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
extern function glTexSubImage2D(target as int, level as int, xoffset as int, yoffset as int, width as int, height as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
extern function glBegin(mode as int) from "opengl32.dll" returns void
extern function glEnd() from "opengl32.dll" returns void
extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" returns void
extern function glVertex2i(x as int, y as int) from "opengl32.dll" returns void

windowRunning = true
registeredClassName = void

struct Window
  hwnd
  logicalWidth
  logicalHeight
  scale
  scaledWidth
  scaledHeight
  bgra
  bmi
  msg
  rect
  title
  className
  renderer
  dc
  glrc
  texture
  texWidth
  texHeight
  textureData
  gpuReady
  scaleMode
  smoothing
  fallbackReason
  viewport
end struct

function putU32(buf, off, v)
  if v < 0 then v = 4294967296 + v end if
  buf[off] = v & 255
  buf[off + 1] = (v >> 8) & 255
  buf[off + 2] = (v >> 16) & 255
  buf[off + 3] = (v >> 24) & 255
end function

function putI32(buf, off, v)
  putU32(buf, off, v)
end function

function putU64(buf, off, v)
  if v < 0 then v = 0 end if
  putU32(buf, off, v & 0xFFFFFFFF)
  putU32(buf, off + 4, (v >> 32) & 0xFFFFFFFF)
end function

function getU32(buf, off)
  return buf[off] + (buf[off + 1] << 8) + (buf[off + 2] << 16) + (buf[off + 3] << 24)
end function

function utf16z(s)
  n = len(s)
  b = bytes((n + 1) * 2, 0)
  i = 0
  while i < n
    ch = s[i]
    code = 0
    if ch == "A" then code = 65 else if ch == "B" then code = 66 else if ch == "C" then code = 67 else if ch == "D" then code = 68
    else if ch == "E" then code = 69 else if ch == "F" then code = 70 else if ch == "G" then code = 71 else if ch == "H" then code = 72
    else if ch == "I" then code = 73 else if ch == "J" then code = 74 else if ch == "K" then code = 75 else if ch == "L" then code = 76
    else if ch == "M" then code = 77 else if ch == "N" then code = 78 else if ch == "O" then code = 79 else if ch == "P" then code = 80
    else if ch == "Q" then code = 81 else if ch == "R" then code = 82 else if ch == "S" then code = 83 else if ch == "T" then code = 84
    else if ch == "U" then code = 85 else if ch == "V" then code = 86 else if ch == "W" then code = 87 else if ch == "X" then code = 88
    else if ch == "Y" then code = 89 else if ch == "Z" then code = 90
    else if ch == "a" then code = 97 else if ch == "b" then code = 98 else if ch == "c" then code = 99 else if ch == "d" then code = 100
    else if ch == "e" then code = 101 else if ch == "f" then code = 102 else if ch == "g" then code = 103 else if ch == "h" then code = 104
    else if ch == "i" then code = 105 else if ch == "j" then code = 106 else if ch == "k" then code = 107 else if ch == "l" then code = 108
    else if ch == "m" then code = 109 else if ch == "n" then code = 110 else if ch == "o" then code = 111 else if ch == "p" then code = 112
    else if ch == "q" then code = 113 else if ch == "r" then code = 114 else if ch == "s" then code = 115 else if ch == "t" then code = 116
    else if ch == "u" then code = 117 else if ch == "v" then code = 118 else if ch == "w" then code = 119 else if ch == "x" then code = 120
    else if ch == "y" then code = 121 else if ch == "z" then code = 122
    else if ch == "0" then code = 48 else if ch == "1" then code = 49 else if ch == "2" then code = 50 else if ch == "3" then code = 51
    else if ch == "4" then code = 52 else if ch == "5" then code = 53 else if ch == "6" then code = 54 else if ch == "7" then code = 55
    else if ch == "8" then code = 56 else if ch == "9" then code = 57 else if ch == " " then code = 32 else if ch == "-" then code = 45 else if ch == "_" then code = 95
    else code = 63 end if
    b[i * 2] = code & 255
    b[(i * 2) + 1] = (code >> 8) & 255
    i = i + 1
  end while
  return b
end function

function wndProc(hwnd, msg, wParam, lParam)
  global windowRunning
  if msg == WM_CLOSE then
    windowRunning = false
    DestroyWindow(hwnd)
    return 0
  end if
  if msg == WM_DESTROY then
    windowRunning = false
    PostQuitMessage(0)
    return 0
  end if
  return DefWindowProcW(hwnd, msg, wParam, lParam)
end function

function registerWindowClass()
  global registeredClassName
  if typeof(registeredClassName) == "bytes" then return registeredClassName end if
  instance = GetModuleHandleW(0)
  className = utf16z("MiniPixelsWindow")
  wc = bytes(80, 0)
  putU32(wc, 0, 80)
  putU32(wc, 4, CS_OWNDC)
  putU64(wc, 8, nativeCallback(wndProc, "wndproc"))
  putU64(wc, 24, instance)
  putU64(wc, 40, LoadCursorW(0, IDC_ARROW))
  putU64(wc, 64, nativeBytesPtr(className))
  RegisterClassExW(wc)
  registeredClassName = className
  return className
end function

function createBitmapInfo(width, height)
  bmi = bytes(40, 0)
  putU32(bmi, 0, 40)
  putI32(bmi, 4, width)
  putI32(bmi, 8, 0 - height)
  bmi[12] = 1
  bmi[14] = 32
  putU32(bmi, 16, 0)
  putU32(bmi, 20, width * height * 4)
  return bmi
end function

function createPixelFormatDescriptor()
  pfd = bytes(40, 0)
  pfd[0] = 40
  pfd[2] = 1
  putU32(pfd, 4, PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER)
  pfd[8] = PFD_TYPE_RGBA
  pfd[9] = 32
  pfd[23] = 0
  pfd[24] = 0
  pfd[25] = 0
  pfd[26] = PFD_MAIN_PLANE
  return pfd
end function

function nextPow2(n)
  p = 1
  while p < n
    p = p * 2
  end while
  return p
end function

function normalizeRenderer(renderer)
  if renderer == "gpu" then return "opengl" end if
  if renderer == "opengl" then return "opengl" end if
  if renderer == "gdi" then return "gdi" end if
  if renderer == "cpu" then return "gdi" end if
  return "auto"
end function

function normalizeScaleMode(scaleMode)
  if scaleMode == "fit" then return "fit" end if
  if scaleMode == "integer" then return "integer" end if
  if scaleMode == "pixel-perfect" then return "integer" end if
  return "stretch"
end function

function open(title, width, height, scale, renderer, scaleMode, smoothing)
  global windowRunning
  windowRunning = true
  console = GetConsoleWindow()
  if console != 0 then ShowWindow(console, SW_HIDE) end if
  className = registerWindowClass()
  titleBuf = utf16z(title)
  sw = width * scale
  sh = height * scale
  hwnd = CreateWindowExW(0, nativeBytesPtr(className), nativeBytesPtr(titleBuf), WS_OVERLAPPEDWINDOW | WS_VISIBLE, 100, 100, sw + 16, sh + 39, 0, 0, GetModuleHandleW(0), 0)
  if hwnd == 0 then
    return error(7001, "MiniPixels could not create the Win32 window.")
  end if
  ShowWindow(hwnd, 5)
  UpdateWindow(hwnd)
  SetForegroundWindow(hwnd)
  mode = normalizeRenderer(renderer)
  w = Window(hwnd, width, height, scale, sw, sh, bytes(width * height * 4, 0), createBitmapInfo(width, height), bytes(48, 0), bytes(16, 0), titleBuf, className, "gdi", 0, 0, 0, width, height, bytes(4, 0), false, normalizeScaleMode(scaleMode), smoothing, "", bytes(16, 0))
  if mode == "auto" or mode == "opengl" then
    if initOpenGL(w) then
      w.renderer = "opengl"
    else
      w.renderer = "gdi"
      w.fallbackReason = "opengl-init-failed"
    end if
  end if
  return w
end function

function running()
  global windowRunning
  return windowRunning
end function

function close(w)
  global windowRunning
  windowRunning = false
  if w is Window then
    if w.glrc != 0 then
      wglMakeCurrent(0, 0)
      wglDeleteContext(w.glrc)
      w.glrc = 0
    end if
    if w.dc != 0 then
      ReleaseDC(w.hwnd, w.dc)
      w.dc = 0
    end if
    if w.hwnd != 0 then DestroyWindow(w.hwnd) end if
  end if
end function

function rendererName(w)
  if w is not Window then return "none" end if
  return w.renderer
end function

function isGpuRenderer(w)
  if w is not Window then return false end if
  return w.renderer == "opengl"
end function

function rendererFallbackReason(w)
  if w is not Window then return "none" end if
  return w.fallbackReason
end function

function setTitle(w, title)
  if w is not Window then return false end if
  return SetWindowTextW(w.hwnd, title)
end function

function pollEvents(w)
  while PeekMessageW(w.msg, 0, 0, 0, PM_REMOVE)
    TranslateMessage(w.msg)
    DispatchMessageW(w.msg)
  end while
end function

function keyDown(vk)
  return GetAsyncKeyState(vk) < 0
end function

function hasFocus(w)
  if w is not Window then return false end if
  return GetForegroundWindow() == w.hwnd
end function

function updateInputForWindow(w, input)
  input.beginFrame()
  if hasFocus(w) == false then
    inp.setKeyboard(input, false, false, false, false, false, false, false)
    return
  end if
  inp.setKeyboard(
    input,
    keyDown(0x25) or keyDown(0x41),
    keyDown(0x27) or keyDown(0x44),
    keyDown(0x26) or keyDown(0x57),
    keyDown(0x28) or keyDown(0x53),
    keyDown(0x20),
    keyDown(0x5A) or keyDown(0x58),
    keyDown(0x1B)
  )
end function

function updateInput(input)
  input.beginFrame()
  inp.setKeyboard(input, false, false, false, false, false, false, false)
end function

function clientWidth(w)
  clientW = w.scaledWidth
  if GetClientRect(w.hwnd, w.rect) then
    clientW = getU32(w.rect, 8) - getU32(w.rect, 0)
  end if
  if clientW < 1 then clientW = 1 end if
  return clientW
end function

function clientHeight(w)
  clientH = w.scaledHeight
  if GetClientRect(w.hwnd, w.rect) then
    clientH = getU32(w.rect, 12) - getU32(w.rect, 4)
  end if
  if clientH < 1 then clientH = 1 end if
  return clientH
end function

function minInt(a, b)
  if a < b then return a end if
  return b
end function

function maxInt(a, b)
  if a > b then return a end if
  return b
end function

function updateViewport(w)
  cw = clientWidth(w)
  ch = clientHeight(w)
  dx = 0
  dy = 0
  dw = cw
  dh = ch
  if w.scaleMode == "fit" or w.scaleMode == "integer" then
    if (cw * w.logicalHeight) <= (ch * w.logicalWidth) then
      dw = cw
      dh = (cw * w.logicalHeight) / w.logicalWidth
    else
      dh = ch
      dw = (ch * w.logicalWidth) / w.logicalHeight
    end if
    if w.scaleMode == "integer" then
      s = minInt(cw / w.logicalWidth, ch / w.logicalHeight)
      s = maxInt(1, s)
      dw = w.logicalWidth * s
      dh = w.logicalHeight * s
    end if
    dx = (cw - dw) / 2
    dy = (ch - dh) / 2
  end if
  putU32(w.viewport, 0, dx)
  putU32(w.viewport, 4, dy)
  putU32(w.viewport, 8, dw)
  putU32(w.viewport, 12, dh)
  return w.viewport
end function

function viewportX(w) return getU32(w.viewport, 0) end function
function viewportY(w) return getU32(w.viewport, 4) end function
function viewportW(w) return getU32(w.viewport, 8) end function
function viewportH(w) return getU32(w.viewport, 12) end function

function applyTextureFilter(w)
  filter = GL_NEAREST
  if w.smoothing then filter = 0x2601 end if
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter)
end function

function initOpenGL(w)
  dc = GetDC(w.hwnd)
  if dc == 0 then return false end if
  pfd = createPixelFormatDescriptor()
  pf = ChoosePixelFormat(dc, pfd)
  if pf <= 0 then
    ReleaseDC(w.hwnd, dc)
    return false
  end if
  if SetPixelFormat(dc, pf, pfd) == false then
    ReleaseDC(w.hwnd, dc)
    return false
  end if
  rc = wglCreateContext(dc)
  if rc == 0 then
    ReleaseDC(w.hwnd, dc)
    return false
  end if
  if wglMakeCurrent(dc, rc) == false then
    wglDeleteContext(rc)
    ReleaseDC(w.hwnd, dc)
    return false
  end if
  w.dc = dc
  w.glrc = rc
  w.texWidth = nextPow2(w.logicalWidth)
  w.texHeight = nextPow2(w.logicalHeight)
  w.textureData = bytes(w.texWidth * w.texHeight * 4, 0)
  tex = bytes(4, 0)
  glEnable(GL_TEXTURE_2D)
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4)
  glGenTextures(1, tex)
  w.texture = getU32(tex, 0)
  if w.texture == 0 then
    wglMakeCurrent(0, 0)
    wglDeleteContext(rc)
    ReleaseDC(w.hwnd, dc)
    w.dc = 0
    w.glrc = 0
    return false
  end if
  glBindTexture(GL_TEXTURE_2D, w.texture)
  applyTextureFilter(w)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w.texWidth, w.texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, w.textureData)
  w.gpuReady = true
  return true
end function

function presentOpenGL(w, canvas)
  if w.gpuReady == false then return false end if
  if wglMakeCurrent(w.dc, w.glrc) == false then return false end if
  cw = clientWidth(w)
  ch = clientHeight(w)
  updateViewport(w)
  glViewport(0, 0, cw, ch)
  glDisable(GL_TEXTURE_2D)
  glColor3ub(0, 0, 0)
  glBegin(GL_QUADS)
  glVertex2i(-1, -1)
  glVertex2i(1, -1)
  glVertex2i(1, 1)
  glVertex2i(-1, 1)
  glEnd()
  glViewport(viewportX(w), ch - viewportY(w) - viewportH(w), viewportW(w), viewportH(w))
  glEnable(GL_TEXTURE_2D)
  glColor3ub(255, 255, 255)
  glBindTexture(GL_TEXTURE_2D, w.texture)
  applyTextureFilter(w)
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, canvas.width, canvas.height, GL_RGBA, GL_UNSIGNED_BYTE, canvas.pixels)
  u = canvas.width / w.texWidth
  v = canvas.height / w.texHeight
  glBegin(GL_QUADS)
  glTexCoord2d(0.0, v)
  glVertex2i(-1, -1)
  glTexCoord2d(u, v)
  glVertex2i(1, -1)
  glTexCoord2d(u, 0.0)
  glVertex2i(1, 1)
  glTexCoord2d(0.0, 0.0)
  glVertex2i(-1, 1)
  glEnd()
  return SwapBuffers(w.dc)
end function

function presentGDI(w, canvas)
  dst = w.bgra
  y = 0
  while y < canvas.height
    x = 0
    while x < canvas.width
      src = ((y * canvas.width) + x) * 4
      r = canvas.pixels[src]
      g = canvas.pixels[src + 1]
      b = canvas.pixels[src + 2]
      a = canvas.pixels[src + 3]
      di = ((y * canvas.width) + x) * 4
      dst[di] = b
      dst[di + 1] = g
      dst[di + 2] = r
      dst[di + 3] = a
      x = x + 1
    end while
    y = y + 1
  end while
  dc = GetDC(w.hwnd)
  clientW = clientWidth(w)
  clientH = clientHeight(w)
  updateViewport(w)
  SetStretchBltMode(dc, 3)
  PatBlt(dc, 0, 0, clientW, clientH, BLACKNESS)
  StretchDIBits(dc, viewportX(w), viewportY(w), viewportW(w), viewportH(w), 0, 0, canvas.width, canvas.height, w.bgra, w.bmi, DIB_RGB_COLORS, SRCCOPY)
  ReleaseDC(w.hwnd, dc)
end function

function present(w, canvas)
  if w.renderer == "opengl" then
    if presentOpenGL(w, canvas) then return end if
    w.renderer = "gdi"
  end if
  presentGDI(w, canvas)
end function

function ticks()
  return GetTickCount64()
end function

function sleepMs(ms)
  Sleep(ms)
end function
