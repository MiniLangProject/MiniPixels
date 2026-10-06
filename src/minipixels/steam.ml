// SPDX-License-Identifier: Apache-2.0
//! Optional Steam client integration. All calls and callbacks run on the game thread.
package minipixels.steam

import std.bytes as by
import std.fs as fs
import std.process as process
import std.string as str
import minipixels.tools.fsutil as dirs

#if defined(MINIPIXELS_STEAM)
import generated.steam_config as generatedSteam
#if TARGET_OS == "windows"
extern function nativeCall(op as i32, text as cstr, value as i64, output as bytes, capacity as i32) from "minipixels_steam.dll" symbol "mpSteamCall" returns i64
#else
extern function nativeCall(op as i32, text as cstr, value as i64, output as bytes, capacity as i32) from "$ORIGIN/libminipixels_steam.so" symbol "mpSteamCall" returns i64
#endif
#endif

#if TARGET_OS == "windows"
/// @internal
extern function replaceSave(source as wstr, destination as wstr, flags as u32) from "kernel32.dll" symbol "MoveFileExW" returns bool
#else
/// @internal
extern function renameSave(source as cstr, destination as cstr) from "libc.so.6" symbol "rename" returns i32
#endif

/// Startup policy and overlay behavior for an opt-in Steam build.
struct SteamConfig
  enabled
  appId
  required
  restartThroughSteam
  pauseOnOverlay
end struct

/// Game-thread Steam identity, callback state and asynchronous persistence status.
struct SteamSession
  config
  backend
  available
  restartRequested
  overlayActive
  wasOverlayActive
  userId
  userName
  language
  lastError
  storeStatus
  dirty
  retrySeconds
  closed
  overlaySupported
  scratch
end struct

/// Configure optional/required Steam startup. A running offline client is allowed.
/// @param appId Positive uint32 Steam application identifier.
/// @param required Fail startup instead of falling back when Steam is unavailable.
function config(appId, required)
  return SteamConfig(true, appId, required, required, true)
end function

/// Build-generated settings; ordinary direct compiler builds have no Steam dependency.
function defaults()
#if defined(MINIPIXELS_STEAM)
  return SteamConfig(true, generatedSteam.appId(), generatedSteam.required(), generatedSteam.restartThroughSteam(), generatedSteam.pauseOnOverlay())
#else
  return SteamConfig(false, 0, false, false, true)
#endif
end function

/// @internal
function nativeBackend(op, text, value, output)
#if defined(MINIPIXELS_STEAM)
  return nativeCall(op, text, value, output, len(output))
#else
  return 0
#endif
end function

/// Injectable backend is intended for deterministic tests, never exported game builds.
/// @param cfg Steam startup configuration.
/// @param backend Game-thread callback accepting opcode, text, integer and output bytes.
function session(cfg, backend)
  return SteamSession(cfg, backend, false, false, false, false, "", "", "", "", "idle", false, 0, false, false, bytes(1, 0))
end function

/// @internal
function invoke(s, op, text, value)
  return s.backend(op, text, value, s.scratch)
end function

/// @internal
function readString(s, op)
  output = bytes(2048, 0)
  if s.backend(op, "", 0, output) <= 0 then return "" end if
  return by.decodeUtf8Z(output)
end function

/// Must run before graphics-device/window creation. Headless mode never contacts Steam.
/// @param s Session whose identity is initialized once.
/// @param headless Skip all backend calls when true.
function start(s, headless)
  if s.closed then return error(1, "Steam session is closed") end if
  if s.available or s.restartRequested then return true end if
  if headless or s.config.enabled == false then return true end if
  if typeof(s.config.appId) != "int" or s.config.appId <= 0 or s.config.appId > 4294967295 then return error(1, "Steam requires a uint32 AppID") end if
  if s.config.restartThroughSteam and invoke(s, 2, "", s.config.appId) == 1 then
    s.restartRequested = true
    return true
  end if
  s.available = invoke(s, 1, "", s.config.appId) == 1
  if s.available == false then
    s.lastError = readString(s, 17)
    if s.lastError == "" then s.lastError = "Steam backend/client unavailable" end if
    if s.config.required then return error(1, s.lastError) end if
    return true
  end if
  s.userId = readString(s, 8)
  s.userName = readString(s, 7)
  s.language = readString(s, 9)
  return true
end function

/// Pump once per outer frame, including paused frames; never once per physics tick.
/// @param s Active Steam session.
/// @param dt Elapsed real frame time in seconds, before simulation pause is applied.
function update(s, dt)
  if s.closed or s.available == false then
    s.wasOverlayActive = false
    return
  end if
  s.wasOverlayActive = s.overlayActive
  invoke(s, 3, "", 0)
  if invoke(s, 6, "", 0) != 1 then
    invoke(s, 4, "", 0)
    s.available = false
    s.overlayActive = false
    if s.storeStatus == "pending" then s.storeStatus = "failed" end if
    s.lastError = "Steam session ended"
    return
  end if
  s.overlayActive = invoke(s, 5, "", 0) == 1
  if s.storeStatus == "pending" then
    status = invoke(s, 16, "", 0)
    if status == 2 then s.storeStatus = "confirmed" end if
    if status < 0 then
      s.storeStatus = "failed"
      s.lastError = readString(s, 17)
      s.dirty = true
      s.retrySeconds = 5
    end if
  end if
  s.retrySeconds = s.retrySeconds - dt
  if s.dirty and s.retrySeconds <= 0 and s.storeStatus != "pending" then flush(s) end if
end function

/// Returns acceptance, not remote persistence. Inspect storeStatus after flush.
/// @param s Active Steam session.
/// @param name Published Steamworks achievement API name.
function unlockAchievement(s, name)
  if s.closed or s.available == false or name == "" then return false end if
  if invoke(s, 11, name, 0) != 1 then return false end if
  s.dirty = true
  return true
end function

/// Returns 1 unlocked, 0 locked, -1 unavailable or unknown achievement.
/// @param s Active Steam session.
/// @param name Published achievement API name to query.
function achievement(s, name)
  if s.closed or s.available == false then return -1 end if
  return invoke(s, 12, name, 0)
end function

/// Set an integer Steam stat. Float/average-rate stats are not part of this API.
/// @param s Active Steam session.
/// @param name Published integer stat API name.
/// @param value Signed 32-bit integer value; out-of-range values are rejected.
function setStat(s, name, value)
  if s.closed or s.available == false then return false end if
  if typeof(value) != "int" or value < -2147483648 or value > 2147483647 then return false end if
  if invoke(s, 13, name, value) != 1 then return false end if
  s.dirty = true
  return true
end function

/// Read a cached signed integer Steam stat, or return an error when unavailable.
/// @param s Active Steam session.
/// @param name Published integer stat API name to query.
function stat(s, name)
  if s.closed or s.available == false then return error(1, "Steam unavailable") end if
  result = invoke(s, 14, name, 0)
  if result == -2147483649 then return error(1, "Unknown or unavailable integer stat: " + name) end if
  return result
end function

/// Non-blocking store. Confirmation arrives via subsequent update calls.
/// @param s Session with pending local changes to persist.
function flush(s)
  if s.closed or s.available == false or s.storeStatus == "pending" then return false end if
  s.retrySeconds = 5
  if invoke(s, 15, "", 0) != 1 then
    s.storeStatus = "failed"
    s.lastError = readString(s, 17)
    return false
  end if
  s.dirty = false
  s.storeStatus = "pending"
  return true
end function

/// Request a Steam overlay dialog; false means the request was unavailable.
/// @param s Session with an overlay-capable presenter.
/// @param dialog Supported Steam dialog, such as friends or achievements.
function openOverlay(s, dialog)
  if s.closed or s.available == false or s.overlaySupported == false then return false end if
  return invoke(s, 10, dialog, 0) == 1
end function

/// Record presenter capability; software GDI/XImage presentation cannot host the overlay.
/// @param s Session associated with the game window.
/// @param renderer Actual platform renderer name, not the originally requested mode.
function setRenderer(s, renderer)
  s.overlaySupported = renderer == "opengl" or renderer == "opengl-scene"
end function

/// Flush dirty stats best-effort and release the active Steam session once.
/// @param s Session to close; repeated calls are harmless.
function close(s)
  if s.closed then return end if
  if s.available then
    if s.dirty then flush(s) end if
    invoke(s, 4, "", 0)
  end if
  s.available = false
  s.overlayActive = false
  s.wasOverlayActive = false
  s.overlaySupported = false
  s.closed = true
end function

/// Reject path traversal and non-portable save filenames before filesystem access.
/// @param name Local save basename, without directories.
function safeSaveName(name)
  if typeof(name) != "string" or len(name) == 0 or len(name) > 100 then return false end if
  if str.contains(name, "..") or str.contains(name, "/") or str.contains(name, "\\") or str.contains(name, ":") then return false end if
  // Portable names, including Windows device-name avoidance via a fixed prefix.
  raw = bytes(name)
  if raw[len(raw) - 1] == 46 then return false end if
  for i = 0 to len(raw) - 1
    c = raw[i]
    if (c < 48 or c > 57) and (c < 65 or c > 90) and (c < 97 or c > 122) and c != 45 and c != 95 and c != 46 then return false end if
  end for
  return true
end function

/// User-separated Auto-Cloud path. Local fallback saves are not migrated to Steam users.
/// @param s Session providing AppID and optional decimal Steam user identity.
/// @param name Portable save basename; the save- prefix is added automatically.
function savePath(s, name)
  if safeSaveName(name) == false then return error(1, "Invalid save name") end if
  if typeof(s.config.appId) != "int" or s.config.appId <= 0 or s.config.appId > 4294967295 then return error(1, "Save path requires a uint32 AppID") end if
#if TARGET_OS == "windows"
  root = process.environment("LOCALAPPDATA")
#else
  root = process.environment("XDG_DATA_HOME")
  if typeof(root) != "string" or root == "" then
    root = process.environment("HOME")
    if typeof(root) == "string" then root = fs.joinPath(root, ".local/share") end if
  end if
#endif
  if typeof(root) != "string" or root == "" then return error(1, "User data directory unavailable") end if
  user = s.userId
  if user == "" then user = "local" end if
  if safeSaveName(user) == false then return error(1, "Invalid Steam user ID") end if
  folder = fs.joinPath(root, "MiniPixels/" + s.config.appId + "/" + user)
  if dirs.ensureDir(folder) == false then return error(1, "Cannot create save directory") end if
  return fs.joinPath(folder, "save-" + name)
end function

/// Atomic local replacement, suitable for Steam Auto-Cloud. Call from the game thread.
/// @param s Session selecting the application and user directory.
/// @param name Portable save basename, such as slot1.json.
/// @param data Complete serialized save contents as bytes.
function writeSave(s, name, data)
  if typeof(data) != "bytes" then return error(1, "Save data must be bytes") end if
  path = savePath(s, name)
  if typeof(path) == "error" then return path end if
  temporary = path + "." + process.id() + ".tmp"
  written = fs.writeAllBytes(temporary, data)
  if typeof(written) == "error" then return written end if
#if TARGET_OS == "windows"
  ok = replaceSave(temporary, path, 9)
#else
  ok = renameSave(temporary, path) == 0
#endif
  if ok == false then return error(1, "Atomic save replacement failed") end if
  return true
end function

/// Read a local account-specific save as bytes, or return a filesystem error.
/// @param s Session selecting the application and user directory.
/// @param name Portable save basename previously used with writeSave.
function readSave(s, name)
  path = savePath(s, name)
  if typeof(path) == "error" then return path end if
  return fs.readAllBytes(path)
end function
