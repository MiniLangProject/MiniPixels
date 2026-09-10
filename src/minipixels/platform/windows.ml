// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels platform windows facilities for this project.

package minipixels.platform.windows

import minipixels.input.input as inp
import minipixels.math.types as mt

/// Defines the wm destroy constant used by the minipixels platform windows module.
const WM_DESTROY = 0x0002
/// Defines the wm size constant used to invalidate retained presentation.
const WM_SIZE = 0x0005
/// Defines the wm paint constant used to invalidate retained presentation.
const WM_PAINT = 0x000F
/// Defines the wm close constant used by the minipixels platform windows module.
const WM_CLOSE = 0x0010
/// Defines the mouse-wheel message consumed by the input provider.
const WM_MOUSEWHEEL = 0x020A
/// Defines the pm remove constant used by the minipixels platform windows module.
const PM_REMOVE = 0x0001
/// Defines the cs owndc constant used by the minipixels platform windows module.
const CS_OWNDC = 0x0020
/// Defines the ws overlappedwindow constant used by the minipixels platform windows module.
const WS_OVERLAPPEDWINDOW = 0x00CF0000
/// Defines the ws visible constant used by the minipixels platform windows module.
const WS_VISIBLE = 0x10000000
/// Defines the cw usedefault constant used by the minipixels platform windows module.
const CW_USEDEFAULT = 0x80000000
/// Defines the idc arrow constant used by the minipixels platform windows module.
const IDC_ARROW = 32512
/// Defines the sw hide constant used by the minipixels platform windows module.
const SW_HIDE = 0
/// Defines the dib rgb colors constant used by the minipixels platform windows module.
const DIB_RGB_COLORS = 0
/// Defines the bi bitfields constant used by the minipixels platform windows module.
const BI_BITFIELDS = 3
/// Defines the srccopy constant used by the minipixels platform windows module.
const SRCCOPY = 0x00CC0020
/// Defines the pfd doublebuffer constant used by the minipixels platform windows module.
const PFD_DOUBLEBUFFER = 0x00000001
/// Defines the pfd draw to window constant used by the minipixels platform windows module.
const PFD_DRAW_TO_WINDOW = 0x00000004
/// Defines the pfd support opengl constant used by the minipixels platform windows module.
const PFD_SUPPORT_OPENGL = 0x00000020
/// Defines the pfd type rgba constant used by the minipixels platform windows module.
const PFD_TYPE_RGBA = 0
/// Defines the pfd main plane constant used by the minipixels platform windows module.
const PFD_MAIN_PLANE = 0
/// Defines the gl texture 2 d constant used by the minipixels platform windows module.
const GL_TEXTURE_2D = 0x0DE1
/// Defines the gl rgba constant used by the minipixels platform windows module.
const GL_RGBA = 0x1908
/// Defines the gl unsigned byte constant used by the minipixels platform windows module.
const GL_UNSIGNED_BYTE = 0x1401
/// Defines the gl texture mag filter constant used by the minipixels platform windows module.
const GL_TEXTURE_MAG_FILTER = 0x2800
/// Defines the gl texture min filter constant used by the minipixels platform windows module.
const GL_TEXTURE_MIN_FILTER = 0x2801
/// Defines the gl texture wrap s constant used by the minipixels platform windows module.
const GL_TEXTURE_WRAP_S = 0x2802
/// Defines the gl texture wrap t constant used by the minipixels platform windows module.
const GL_TEXTURE_WRAP_T = 0x2803
/// Defines the gl nearest constant used by the minipixels platform windows module.
const GL_NEAREST = 0x2600
/// Defines the gl clamp constant used by the minipixels platform windows module.
const GL_CLAMP = 0x2900
/// Defines the gl unpack alignment constant used by the minipixels platform windows module.
const GL_UNPACK_ALIGNMENT = 0x0CF5
/// Defines source row length for partial texture uploads.
const GL_UNPACK_ROW_LENGTH = 0x0CF2
/// Defines source rows skipped for partial texture uploads.
const GL_UNPACK_SKIP_ROWS = 0x0CF3
/// Defines source pixels skipped for partial texture uploads.
const GL_UNPACK_SKIP_PIXELS = 0x0CF4
/// Defines the gl quads constant used by the minipixels platform windows module.
const GL_QUADS = 0x0007
/// Defines the blackness constant used by the minipixels platform windows module.
const BLACKNESS = 0x00000042

/// Invokes the native GetModuleHandleW entry point used by the minipixels platform windows module.
/// @param name Name of the affected item.
/// @returns Native ptr result produced by the call.
extern function GetModuleHandleW(name as ptr) from "kernel32.dll" returns ptr
/// Invokes the native GetConsoleWindow entry point used by the minipixels platform windows module.
/// @returns Native ptr result produced by the call.
extern function GetConsoleWindow() from "kernel32.dll" returns ptr
/// Invokes the native GetTickCount64 entry point used by the minipixels platform windows module.
/// @returns Native u64 result produced by the call.
extern function GetTickCount64() from "kernel32.dll" returns u64
/// Reads the high-resolution performance counter.
/// @param value Eight-byte destination receiving the counter value.
/// @returns Whether the counter was available.
extern function QueryPerformanceCounter(value as bytes) from "kernel32.dll" returns bool
/// Reads the high-resolution performance-counter frequency.
/// @param value Eight-byte destination receiving ticks per second.
/// @returns Whether the counter was available.
extern function QueryPerformanceFrequency(value as bytes) from "kernel32.dll" returns bool
/// Invokes the native Sleep entry point used by the minipixels platform windows module.
/// @param ms ms value consumed by this operation.
extern function Sleep(ms as int) from "kernel32.dll" returns void

/// Invokes the native RegisterClassExW entry point used by the minipixels platform windows module.
/// @param wndClass wndClass value consumed by this operation.
/// @returns Native u32 result produced by the call.
extern function RegisterClassExW(wndClass as bytes) from "user32.dll" returns u32
/// Invokes the native CreateWindowExW entry point used by the minipixels platform windows module.
/// @param exStyle exStyle value consumed by this operation.
/// @param className className value consumed by this operation.
/// @param windowName windowName value consumed by this operation.
/// @param style style value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
/// @param parent parent value consumed by this operation.
/// @param menu menu value consumed by this operation.
/// @param instance instance value consumed by this operation.
/// @param param param value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function CreateWindowExW(exStyle as int, className as ptr, windowName as wstr, style as int, x as int, y as int, w as int, h as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" returns ptr
/// Invokes the native DefWindowProcW entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param msg msg value consumed by this operation.
/// @param wParam wParam value consumed by this operation.
/// @param lParam lParam value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function DefWindowProcW(hwnd as ptr, msg as u32, wParam as ptr, lParam as ptr) from "user32.dll" returns ptr
/// Invokes the native DestroyWindow entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function DestroyWindow(hwnd as ptr) from "user32.dll" returns bool
/// Invokes the native PostQuitMessage entry point used by the minipixels platform windows module.
/// @param exitCode exitCode value consumed by this operation.
extern function PostQuitMessage(exitCode as int) from "user32.dll" returns void
/// Invokes the native LoadCursorW entry point used by the minipixels platform windows module.
/// @param instance instance value consumed by this operation.
/// @param cursorName cursorName value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function LoadCursorW(instance as ptr, cursorName as ptr) from "user32.dll" returns ptr
/// Invokes the native ShowWindow entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param cmdShow cmdShow value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" returns bool
/// Invokes the native UpdateWindow entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function UpdateWindow(hwnd as ptr) from "user32.dll" returns bool
/// Invokes the native SetForegroundWindow entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" returns bool
/// Invokes the native SetWindowTextW entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param title Human-readable title presented to the user.
/// @returns Native bool result produced by the call.
extern function SetWindowTextW(hwnd as ptr, title as wstr) from "user32.dll" returns bool
/// Invokes the native PeekMessageW entry point used by the minipixels platform windows module.
/// @param msg msg value consumed by this operation.
/// @param hwnd hwnd value consumed by this operation.
/// @param minFilter minFilter value consumed by this operation.
/// @param maxFilter maxFilter value consumed by this operation.
/// @param removeMsg removeMsg value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function PeekMessageW(msg as bytes, hwnd as ptr, minFilter as u32, maxFilter as u32, removeMsg as u32) from "user32.dll" returns bool
/// Invokes the native TranslateMessage entry point used by the minipixels platform windows module.
/// @param msg msg value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function TranslateMessage(msg as bytes) from "user32.dll" returns bool
/// Invokes the native DispatchMessageW entry point used by the minipixels platform windows module.
/// @param msg msg value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function DispatchMessageW(msg as bytes) from "user32.dll" returns ptr
/// Invokes the native GetAsyncKeyState entry point used by the minipixels platform windows module.
/// @param key key value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function GetAsyncKeyState(key as int) from "user32.dll" returns i32
/// Invokes the native GetForegroundWindow entry point used by the minipixels platform windows module.
/// @returns Native ptr result produced by the call.
extern function GetForegroundWindow() from "user32.dll" returns ptr
/// Invokes the native GetClientRect entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param rect rect value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" returns bool
/// Reads the current pointer position in screen coordinates.
/// @param point Eight-byte POINT destination.
/// @returns Whether the pointer position was read.
extern function GetCursorPos(point as bytes) from "user32.dll" returns bool
/// Converts a POINT from screen coordinates to client coordinates.
/// @param hwnd Window owning the client coordinate system.
/// @param point Eight-byte POINT value to convert in place.
/// @returns Whether the conversion succeeded.
extern function ScreenToClient(hwnd as ptr, point as bytes) from "user32.dll" returns bool
/// Invokes the native GetDC entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function GetDC(hwnd as ptr) from "user32.dll" returns ptr
/// Invokes the native ReleaseDC entry point used by the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param dc dc value consumed by this operation.
/// @returns Native int result produced by the call.
extern function ReleaseDC(hwnd as ptr, dc as ptr) from "user32.dll" returns int
/// Invokes the native StretchDIBits entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param xDest xDest value consumed by this operation.
/// @param yDest yDest value consumed by this operation.
/// @param destW destW value consumed by this operation.
/// @param destH destH value consumed by this operation.
/// @param xSrc xSrc value consumed by this operation.
/// @param ySrc ySrc value consumed by this operation.
/// @param srcW srcW value consumed by this operation.
/// @param srcH srcH value consumed by this operation.
/// @param bits bits value consumed by this operation.
/// @param bmi bmi value consumed by this operation.
/// @param usage usage value consumed by this operation.
/// @param rop rop value consumed by this operation.
/// @returns Native int result produced by the call.
extern function StretchDIBits(dc as ptr, xDest as int, yDest as int, destW as int, destH as int, xSrc as int, ySrc as int, srcW as int, srcH as int, bits as bytes, bmi as bytes, usage as int, rop as int) from "gdi32.dll" returns int
/// Invokes the native SetStretchBltMode entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param mode Mode selecting the requested behavior.
/// @returns Native int result produced by the call.
extern function SetStretchBltMode(dc as ptr, mode as int) from "gdi32.dll" returns int
/// Invokes the native PatBlt entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param rop rop value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function PatBlt(dc as ptr, x as int, y as int, width as int, height as int, rop as int) from "gdi32.dll" returns bool
/// Invokes the native ChoosePixelFormat entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param pfd pfd value consumed by this operation.
/// @returns Native int result produced by the call.
extern function ChoosePixelFormat(dc as ptr, pfd as bytes) from "gdi32.dll" returns int
/// Invokes the native SetPixelFormat entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param pixelFormat pixelFormat value consumed by this operation.
/// @param pfd pfd value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function SetPixelFormat(dc as ptr, pixelFormat as int, pfd as bytes) from "gdi32.dll" returns bool
/// Invokes the native SwapBuffers entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function SwapBuffers(dc as ptr) from "gdi32.dll" returns bool
/// Invokes the native wglCreateContext entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function wglCreateContext(dc as ptr) from "opengl32.dll" returns ptr
/// Invokes the native wglMakeCurrent entry point used by the minipixels platform windows module.
/// @param dc dc value consumed by this operation.
/// @param rc rc value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function wglMakeCurrent(dc as ptr, rc as ptr) from "opengl32.dll" returns bool
/// Invokes the native wglDeleteContext entry point used by the minipixels platform windows module.
/// @param rc rc value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function wglDeleteContext(rc as ptr) from "opengl32.dll" returns bool
/// Invokes the native glViewport entry point used by the minipixels platform windows module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" returns void
/// Invokes the native glEnable entry point used by the minipixels platform windows module.
/// @param cap cap value consumed by this operation.
extern function glEnable(cap as int) from "opengl32.dll" returns void
/// Invokes the native glDisable entry point used by the minipixels platform windows module.
/// @param cap cap value consumed by this operation.
extern function glDisable(cap as int) from "opengl32.dll" returns void
/// Invokes the native glColor3ub entry point used by the minipixels platform windows module.
/// @param r r value consumed by this operation.
/// @param g g value consumed by this operation.
/// @param b b value consumed by this operation.
extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" returns void
/// Invokes the native glPixelStorei entry point used by the minipixels platform windows module.
/// @param name Name of the affected item.
/// @param param param value consumed by this operation.
extern function glPixelStorei(name as int, param as int) from "opengl32.dll" returns void
/// Invokes the native glGenTextures entry point used by the minipixels platform windows module.
/// @param count Number of items or units to process.
/// @param textures textures value consumed by this operation.
extern function glGenTextures(count as int, textures as bytes) from "opengl32.dll" returns void
/// Invokes the native glBindTexture entry point used by the minipixels platform windows module.
/// @param target target value consumed by this operation.
/// @param texture texture value consumed by this operation.
extern function glBindTexture(target as int, texture as u32) from "opengl32.dll" returns void
/// Invokes the native glTexParameteri entry point used by the minipixels platform windows module.
/// @param target target value consumed by this operation.
/// @param name Name of the affected item.
/// @param param param value consumed by this operation.
extern function glTexParameteri(target as int, name as int, param as int) from "opengl32.dll" returns void
/// Invokes the native glTexImage2D entry point used by the minipixels platform windows module.
/// @param target target value consumed by this operation.
/// @param level level value consumed by this operation.
/// @param internalFormat internalFormat value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param border border value consumed by this operation.
/// @param format format value consumed by this operation.
/// @param typ typ value consumed by this operation.
/// @param pixels pixels value consumed by this operation.
extern function glTexImage2D(target as int, level as int, internalFormat as int, width as int, height as int, border as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
/// Invokes the native glTexSubImage2D entry point used by the minipixels platform windows module.
/// @param target target value consumed by this operation.
/// @param level level value consumed by this operation.
/// @param xoffset xoffset value consumed by this operation.
/// @param yoffset yoffset value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param format format value consumed by this operation.
/// @param typ typ value consumed by this operation.
/// @param pixels pixels value consumed by this operation.
extern function glTexSubImage2D(target as int, level as int, xoffset as int, yoffset as int, width as int, height as int, format as int, typ as int, pixels as bytes) from "opengl32.dll" returns void
/// Invokes the native glBegin entry point used by the minipixels platform windows module.
/// @param mode Mode selecting the requested behavior.
extern function glBegin(mode as int) from "opengl32.dll" returns void
/// Invokes the native glEnd entry point used by the minipixels platform windows module.
extern function glEnd() from "opengl32.dll" returns void
/// Invokes the native glTexCoord2d entry point used by the minipixels platform windows module.
/// @param s s value consumed by this operation.
/// @param t t value consumed by this operation.
extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" returns void
/// Invokes the native glVertex2i entry point used by the minipixels platform windows module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
extern function glVertex2i(x as int, y as int) from "opengl32.dll" returns void

/// Stores module-wide window running state for the minipixels platform windows module.
windowRunning = true
/// Stores module-wide registered class name state for the minipixels platform windows module.
registeredClassName = void
/// Stores wheel steps received by the window callback until input polling consumes them.
mouseWheelAccumulator = 0
/// Whether Win32 requested repainting of the retained framebuffer.
windowNeedsPresent = true
/// Reusable buffer for high-resolution counter queries.
performanceCounterBuffer = bytes(8, 0)
/// Cached high-resolution performance-counter frequency.
performanceFrequency = 0

/// Represents the window data used by the minipixels platform windows module.
struct Window
  /// Stores the hwnd value associated with window.
  hwnd
  /// Stores the logical width value associated with window.
  logicalWidth
  /// Stores the logical height value associated with window.
  logicalHeight
  /// Stores the scale value associated with window.
  scale
  /// Stores the scaled width value associated with window.
  scaledWidth
  /// Stores the scaled height value associated with window.
  scaledHeight
  /// Stores the bmi value associated with window.
  bmi
  /// Stores the msg value associated with window.
  msg
  /// Stores the rect value associated with window.
  rect
  /// Stores the title value associated with window.
  title
  /// Stores the class name value associated with window.
  className
  /// Stores the renderer value associated with window.
  renderer
  /// Stores the dc value associated with window.
  dc
  /// Stores the glrc value associated with window.
  glrc
  /// Stores the texture value associated with window.
  texture
  /// Stores the tex width value associated with window.
  texWidth
  /// Stores the tex height value associated with window.
  texHeight
  /// Stores the texture data value associated with window.
  textureData
  /// Stores the gpu ready value associated with window.
  gpuReady
  /// Stores the scale mode value associated with window.
  scaleMode
  /// Stores the smoothing value associated with window.
  smoothing
  /// Stores the fallback reason value associated with window.
  fallbackReason
  /// Stores the viewport value associated with window.
  viewport
  /// Resize-safe viewport values kept outside the native byte scratch buffer.
  viewportLeft
  viewportTop
  viewportWidth
  viewportHeight
  /// Stores a reusable Win32 POINT buffer for pointer polling.
  point
end struct

/// Performs the putU32 operation for the minipixels platform windows module.
/// @param buf buf value consumed by this operation.
/// @param off off value consumed by this operation.
/// @param v v value consumed by this operation.
function putU32(buf, off, v)
  if v < 0 then v = 4294967296 + v end if
  buf[off] = v & 255
  buf[off + 1] = (v >> 8) & 255
  buf[off + 2] = (v >> 16) & 255
  buf[off + 3] = (v >> 24) & 255
end function

/// Performs the putI32 operation for the minipixels platform windows module.
/// @param buf buf value consumed by this operation.
/// @param off off value consumed by this operation.
/// @param v v value consumed by this operation.
function putI32(buf, off, v)
  putU32(buf, off, v)
end function

/// Performs the putU64 operation for the minipixels platform windows module.
/// @param buf buf value consumed by this operation.
/// @param off off value consumed by this operation.
/// @param v v value consumed by this operation.
function putU64(buf, off, v)
  if v < 0 then v = 0 end if
  putU32(buf, off, v & 0xFFFFFFFF)
  putU32(buf, off + 4, (v >> 32) & 0xFFFFFFFF)
end function

/// Returns u32 maintained by the minipixels platform windows module.
/// @param buf buf value consumed by this operation.
/// @param off off value consumed by this operation.
function getU32(buf, off)
  return buf[off] + (buf[off + 1] << 8) + (buf[off + 2] << 16) + (buf[off + 3] << 24)
end function

/// Returns a signed 32-bit integer stored in a byte buffer.
/// @param buf Buffer containing the encoded integer.
/// @param off Byte offset of the encoded integer.
function getI32(buf, off)
  value = getU32(buf, off)
  if value >= 2147483648 then return value - 4294967296 end if
  return value
end function

/// Returns an unsigned 64-bit integer stored in a byte buffer.
/// @param buf Buffer containing the encoded integer.
/// @param off Byte offset of the encoded integer.
function getU64(buf, off)
  return getU32(buf, off) + (getU32(buf, off + 4) << 32)
end function

/// Performs the wndProc operation for the minipixels platform windows module.
/// @param hwnd hwnd value consumed by this operation.
/// @param msg msg value consumed by this operation.
/// @param wParam wParam value consumed by this operation.
/// @param lParam lParam value consumed by this operation.
function wndProc(hwnd, msg, wParam, lParam)
  global windowRunning
  global mouseWheelAccumulator
  global windowNeedsPresent
  if msg == WM_SIZE or msg == WM_PAINT then windowNeedsPresent = true end if
  if msg == WM_MOUSEWHEEL then
    delta = (wParam >> 16) & 0xFFFF
    if delta >= 0x8000 then delta = delta - 0x10000 end if
    mouseWheelAccumulator = mouseWheelAccumulator + (delta / 120)
    return 0
  end if
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

/// Performs the registerWindowClass operation for the minipixels platform windows module.
function registerWindowClass()
  global registeredClassName
  if typeof(registeredClassName) == "bytes" then return registeredClassName end if
  instance = GetModuleHandleW(0)
  className = fromHex("4D 00 69 00 6E 00 69 00 50 00 69 00 78 00 65 00 6C 00 73 00 57 00 69 00 6E 00 64 00 6F 00 77 00 00 00")
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

/// Creates bitmap info for the minipixels platform windows module.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function createBitmapInfo(width, height)
  bmi = bytes(52, 0)
  putU32(bmi, 0, 40)
  putI32(bmi, 4, width)
  putI32(bmi, 8, 0 - height)
  bmi[12] = 1
  bmi[14] = 32
  putU32(bmi, 16, BI_BITFIELDS)
  putU32(bmi, 20, width * height * 4)
  putU32(bmi, 40, 0x000000FF)
  putU32(bmi, 44, 0x0000FF00)
  putU32(bmi, 48, 0x00FF0000)
  return bmi
end function

/// Creates pixel format descriptor for the minipixels platform windows module.
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

/// Performs the nextPow2 operation for the minipixels platform windows module.
/// @param n n value consumed by this operation.
function nextPow2(n)
  p = 1
  while p < n
    p = p * 2
  end while
  return p
end function

/// Normalizes renderer for the minipixels platform windows workflow.
/// @param renderer renderer value consumed by this operation.
function normalizeRenderer(renderer)
  if renderer == "gpu" then return "opengl" end if
  if renderer == "opengl" then return "opengl" end if
  if renderer == "gdi" then return "gdi" end if
  if renderer == "cpu" then return "gdi" end if
  return "auto"
end function

/// Normalizes scale mode for the minipixels platform windows workflow.
/// @param scaleMode scaleMode value consumed by this operation.
function normalizeScaleMode(scaleMode)
  if scaleMode == "fit" then return "fit" end if
  if scaleMode == "integer" then return "integer" end if
  if scaleMode == "pixel-perfect" then return "integer" end if
  return "stretch"
end function

/// Opens open for the minipixels platform windows module.
/// @param title Human-readable title presented to the user.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param scale scale value consumed by this operation.
/// @param renderer renderer value consumed by this operation.
/// @param scaleMode scaleMode value consumed by this operation.
/// @param smoothing smoothing value consumed by this operation.
function open(title, width, height, scale, renderer, scaleMode, smoothing)
  global windowRunning
  global windowNeedsPresent
  windowRunning = true
  windowNeedsPresent = true
  console = GetConsoleWindow()
  if console != 0 then ShowWindow(console, SW_HIDE) end if
  className = registerWindowClass()
  sw = width * scale
  sh = height * scale
  hwnd = CreateWindowExW(0, nativeBytesPtr(className), title, WS_OVERLAPPEDWINDOW | WS_VISIBLE, 100, 100, sw + 16, sh + 39, 0, 0, GetModuleHandleW(0), 0)
  if hwnd == 0 then
    return error(7001, "MiniPixels could not create the Win32 window.")
  end if
  ShowWindow(hwnd, 5)
  UpdateWindow(hwnd)
  SetForegroundWindow(hwnd)
  mode = normalizeRenderer(renderer)
  w = Window(hwnd, width, height, scale, sw, sh, createBitmapInfo(width, height), bytes(48, 0), bytes(16, 0), title, className, "gdi", 0, 0, 0, width, height, bytes(4, 0), false, normalizeScaleMode(scaleMode), smoothing, "", bytes(16, 0), 0, 0, width, height, bytes(8, 0))
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

/// Performs the running operation for the minipixels platform windows module.
function running()
  global windowRunning
  return windowRunning
end function

/// Closes close owned by the minipixels platform windows module.
/// @param w w value consumed by this operation.
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

/// Performs the rendererName operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function rendererName(w)
  if w is not Window then return "none" end if
  return w.renderer
end function

/// Returns whether gpu renderer satisfies the required condition.
/// @param w w value consumed by this operation.
function isGpuRenderer(w)
  if w is not Window then return false end if
  return w.renderer == "opengl" or w.renderer == "opengl-scene"
end function

/// Performs the rendererFallbackReason operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function rendererFallbackReason(w)
  if w is not Window then return "none" end if
  return w.fallbackReason
end function

/// Updates title maintained by the minipixels platform windows module.
/// @param w w value consumed by this operation.
/// @param title Human-readable title presented to the user.
function setTitle(w, title)
  if w is not Window then return false end if
  return SetWindowTextW(w.hwnd, title)
end function

/// Performs the pollEvents operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function pollEvents(w)
  while PeekMessageW(w.msg, 0, 0, 0, PM_REMOVE)
    TranslateMessage(w.msg)
    DispatchMessageW(w.msg)
  end while
end function

/// Performs the keyDown operation for the minipixels platform windows module.
/// @param vk vk value consumed by this operation.
function keyDown(vk)
  return GetAsyncKeyState(vk) < 0
end function

/// Returns whether focus is available.
/// @param w w value consumed by this operation.
function hasFocus(w)
  if w is not Window then return false end if
  return GetForegroundWindow() == w.hwnd
end function

/// Updates input for window for the minipixels platform windows workflow.
/// @param w w value consumed by this operation.
/// @param input input value consumed by this operation.
function updateInputForWindow(w, input)
  input.beginFrame()
  if hasFocus(w) == false then
    inp.releaseAll(input)
    inp.setMousePosition(input, input.mouseX, input.mouseY, false)
    consumeMouseWheel()
    return
  end if
  if input.actionCount > 0 then
    for slot = 0 to input.actionCount - 1
      primary = input.primaryKeys[slot]
      secondary = input.secondaryKeys[slot]
      held = false
      if primary >= 0 and keyDown(primary) then held = true end if
      if secondary >= 0 and keyDown(secondary) then held = true end if
      inp.setActionState(input, input.actionNames[slot], held)
    end for
  end if
  updatePointerForWindow(w, input)
  wheel = consumeMouseWheel()
  if wheel != 0 then inp.addMouseWheel(input, wheel) end if
end function

/// Updates input for the minipixels platform windows workflow.
/// @param input input value consumed by this operation.
function updateInput(input)
  input.beginFrame()
  inp.releaseAll(input)
end function

/// Consumes wheel steps accumulated by the window callback.
function consumeMouseWheel()
  global mouseWheelAccumulator
  value = mouseWheelAccumulator
  mouseWheelAccumulator = 0
  return value
end function

/// Updates the logical pointer position for a window and its active viewport.
/// @param w Window whose client area is sampled.
/// @param input Input state receiving logical coordinates.
function updatePointerForWindow(w, input)
  if GetCursorPos(w.point) == false then return false end if
  if ScreenToClient(w.hwnd, w.point) == false then return false end if
  updateViewport(w)
  clientX = getI32(w.point, 0)
  clientY = getI32(w.point, 4)
  vx = viewportX(w)
  vy = viewportY(w)
  vw = viewportW(w)
  vh = viewportH(w)
  inside = clientX >= vx and clientY >= vy and clientX < vx + vw and clientY < vy + vh
  logicalX = 0
  logicalY = 0
  if vw > 0 then logicalX = mt.floorInt(((clientX - vx) * w.logicalWidth) / vw) end if
  if vh > 0 then logicalY = mt.floorInt(((clientY - vy) * w.logicalHeight) / vh) end if
  logicalX = mt.clamp(logicalX, 0, w.logicalWidth - 1)
  logicalY = mt.clamp(logicalY, 0, w.logicalHeight - 1)
  inp.setMousePosition(input, logicalX, logicalY, inside)
  return true
end function

/// Performs the clientWidth operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function clientWidth(w)
  clientW = w.scaledWidth
  if GetClientRect(w.hwnd, w.rect) then
    clientW = getU32(w.rect, 8) - getU32(w.rect, 0)
  end if
  if clientW < 1 then clientW = 1 end if
  return clientW
end function

/// Performs the clientHeight operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function clientHeight(w)
  clientH = w.scaledHeight
  if GetClientRect(w.hwnd, w.rect) then
    clientH = getU32(w.rect, 12) - getU32(w.rect, 4)
  end if
  if clientH < 1 then clientH = 1 end if
  return clientH
end function

/// Updates the logical source size used by presentation and pointer mapping.
/// @param w Window to update.
/// @param width New framebuffer width.
/// @param height New framebuffer height.
function setRenderSize(w, width, height)
  global windowNeedsPresent
  if w is not Window or width < 1 or height < 1 then return false end if
  width = mt.floorInt(width)
  height = mt.floorInt(height)
  if w.logicalWidth == width and w.logicalHeight == height then return false end if
  w.logicalWidth = width
  w.logicalHeight = height
  w.bmi = createBitmapInfo(width, height)
  windowNeedsPresent = true
  return true
end function

/// Performs the minInt operation for the minipixels platform windows module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function minInt(a, b)
  if a < b then return a end if
  return b
end function

/// Performs the maxInt operation for the minipixels platform windows module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function maxInt(a, b)
  if a > b then return a end if
  return b
end function

/// Updates viewport for the minipixels platform windows workflow.
/// @param w w value consumed by this operation.
function updateViewport(w)
  // Keep client geometry valid across minimize/maximize transitions.
  if typeof(w.rect) != "bytes" or len(w.rect) < 16 then w.rect = bytes(16, 0) end if
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
  dx = mt.floorInt(dx)
  dy = mt.floorInt(dy)
  dw = mt.floorInt(dw)
  dh = mt.floorInt(dh)
  if dw < 1 then dw = 1 end if
  if dh < 1 then dh = 1 end if
  // Plain fields avoid a native-runtime aliasing issue that invalidated the
  // former byte buffer while handling WM_SIZE and terminated maximized games.
  w.viewportLeft = dx
  w.viewportTop = dy
  w.viewportWidth = dw
  w.viewportHeight = dh
  return w
end function

/// Performs the viewportX operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function viewportX(w) return w.viewportLeft end function
/// Performs the viewportY operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function viewportY(w) return w.viewportTop end function
/// Performs the viewportW operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function viewportW(w) return w.viewportWidth end function
/// Performs the viewportH operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function viewportH(w) return w.viewportHeight end function

/// Performs the applyTextureFilter operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
function applyTextureFilter(w)
  filter = GL_NEAREST
  if w.smoothing then filter = 0x2601 end if
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter)
end function

/// Performs the initOpenGL operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
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

/// @internal
function ensureOpenGLTexture(w, canvas)
  requiredWidth = nextPow2(canvas.width)
  requiredHeight = nextPow2(canvas.height)
  if w.texWidth == requiredWidth and w.texHeight == requiredHeight then return true end if
  w.texWidth = requiredWidth
  w.texHeight = requiredHeight
  w.textureData = bytes(w.texWidth * w.texHeight * 4, 0)
  glBindTexture(GL_TEXTURE_2D, w.texture)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w.texWidth, w.texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, w.textureData)
  canvas.dirty = true
  canvas.dirtyX0 = 0
  canvas.dirtyY0 = 0
  canvas.dirtyX1 = canvas.width
  canvas.dirtyY1 = canvas.height
  return true
end function

/// Performs the presentOpenGL operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
function presentOpenGL(w, canvas)
  if w.gpuReady == false then return false end if
  if wglMakeCurrent(w.dc, w.glrc) == false then return false end if
  ensureOpenGLTexture(w, canvas)
  cw = clientWidth(w)
  ch = clientHeight(w)
  updateViewport(w)
  // A full-client opaque texture already replaces every pixel. Only clear
  // when letterboxing leaves pixels outside the image viewport.
  if viewportX(w) != 0 or viewportY(w) != 0 or viewportW(w) != cw or viewportH(w) != ch then
    glViewport(0, 0, cw, ch)
    glDisable(GL_TEXTURE_2D)
    glColor3ub(0, 0, 0)
    glBegin(GL_QUADS)
    glVertex2i(-1, -1)
    glVertex2i(1, -1)
    glVertex2i(1, 1)
    glVertex2i(-1, 1)
    glEnd()
  end if
  glViewport(viewportX(w), ch - viewportY(w) - viewportH(w), viewportW(w), viewportH(w))
  glEnable(GL_TEXTURE_2D)
  glColor3ub(255, 255, 255)
  glBindTexture(GL_TEXTURE_2D, w.texture)
  applyTextureFilter(w)
  if canvas.dirty then
    uploadX = canvas.dirtyX0
    uploadY = canvas.dirtyY0
    uploadW = canvas.dirtyX1 - uploadX
    uploadH = canvas.dirtyY1 - uploadY
    glPixelStorei(GL_UNPACK_ROW_LENGTH, canvas.width)
    glPixelStorei(GL_UNPACK_SKIP_PIXELS, uploadX)
    glPixelStorei(GL_UNPACK_SKIP_ROWS, uploadY)
    glTexSubImage2D(GL_TEXTURE_2D, 0, uploadX, uploadY, uploadW, uploadH, GL_RGBA, GL_UNSIGNED_BYTE, canvas.pixels)
    glPixelStorei(GL_UNPACK_ROW_LENGTH, 0)
    glPixelStorei(GL_UNPACK_SKIP_PIXELS, 0)
    glPixelStorei(GL_UNPACK_SKIP_ROWS, 0)
    canvas.dirty = false
  end if
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

/// Performs the presentGDI operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
function presentGDI(w, canvas)
  global windowNeedsPresent
  dc = GetDC(w.hwnd)
  clientW = clientWidth(w)
  clientH = clientHeight(w)
  updateViewport(w)
  SetStretchBltMode(dc, 3)
  // Avoid an extra full-window GDI operation (and a visible black interframe).
  // On resize/expose the letterbox must still be repainted.
  if windowNeedsPresent and (viewportX(w) != 0 or viewportY(w) != 0 or viewportW(w) != clientW or viewportH(w) != clientH) then
    PatBlt(dc, 0, 0, clientW, clientH, BLACKNESS)
  end if
  StretchDIBits(dc, viewportX(w), viewportY(w), viewportW(w), viewportH(w), 0, 0, canvas.width, canvas.height, canvas.pixels, w.bmi, DIB_RGB_COLORS, SRCCOPY)
  ReleaseDC(w.hwnd, dc)
  canvas.dirty = false
  return true
end function

/// Performs the present operation for the minipixels platform windows module.
/// @param w w value consumed by this operation.
/// @param canvas canvas value consumed by this operation.
function present(w, canvas)
  global windowNeedsPresent
  // An optional scene backend has already drawn the backbuffer. Never upload
  // the CPU canvas over it. Presentation and window lifetime remain centralized.
  if w.renderer == "opengl-scene" then
    windowNeedsPresent = false
    return SwapBuffers(w.dc)
  end if
  if canvas.dirty == false and windowNeedsPresent == false then return true end if
  if w.renderer == "opengl" then
    if presentOpenGL(w, canvas) then
      windowNeedsPresent = false
      return true
    end if
    w.renderer = "gdi"
  end if
  presentGDI(w, canvas)
  windowNeedsPresent = false
  return true
end function

/// Performs the ticks operation for the minipixels platform windows module.
function ticks()
  return GetTickCount64()
end function

/// Returns a high-resolution monotonic time value in seconds.
function seconds()
  global performanceCounterBuffer
  global performanceFrequency
  if performanceFrequency <= 0 then
    if QueryPerformanceFrequency(performanceCounterBuffer) then
      performanceFrequency = getU64(performanceCounterBuffer, 0)
    end if
  end if
  if performanceFrequency <= 0 then return GetTickCount64() / 1000.0 end if
  if QueryPerformanceCounter(performanceCounterBuffer) == false then return GetTickCount64() / 1000.0 end if
  return getU64(performanceCounterBuffer, 0) / performanceFrequency
end function

/// Waits until a high-resolution deadline while leaving time for other threads.
/// @param deadline Absolute value previously obtained from seconds().
function waitUntil(deadline)
  now = seconds()
  while now < deadline
    remainingMs = mt.floorInt((deadline - now) * 1000)
    if remainingMs > 1 then
      Sleep(remainingMs - 1)
    else
      Sleep(0)
    end if
    now = seconds()
  end while
end function

/// Performs the sleepMs operation for the minipixels platform windows module.
/// @param ms ms value consumed by this operation.
function sleepMs(ms)
  Sleep(ms)
end function
