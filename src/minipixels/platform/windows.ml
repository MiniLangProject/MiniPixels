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

function open(title, width, height, scale)
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
  return Window(hwnd, width, height, scale, sw, sh, bytes(width * height * 4, 0), createBitmapInfo(width, height), bytes(48, 0), bytes(16, 0), titleBuf, className)
end function

function running()
  global windowRunning
  return windowRunning
end function

function close(w)
  global windowRunning
  windowRunning = false
  if w is Window then
    if w.hwnd != 0 then DestroyWindow(w.hwnd) end if
  end if
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

function present(w, canvas)
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
  clientW = w.scaledWidth
  clientH = w.scaledHeight
  if GetClientRect(w.hwnd, w.rect) then
    clientW = getU32(w.rect, 8) - getU32(w.rect, 0)
    clientH = getU32(w.rect, 12) - getU32(w.rect, 4)
  end if
  if clientW < 1 then clientW = 1 end if
  if clientH < 1 then clientH = 1 end if
  SetStretchBltMode(dc, 3)
  StretchDIBits(dc, 0, 0, clientW, clientH, 0, 0, canvas.width, canvas.height, w.bgra, w.bmi, DIB_RGB_COLORS, SRCCOPY)
  ReleaseDC(w.hwnd, dc)
end function

function ticks()
  return GetTickCount64()
end function

function sleepMs(ms)
  Sleep(ms)
end function
