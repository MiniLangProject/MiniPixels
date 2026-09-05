// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools fsutil facilities for this project.

package minipixels.tools.fsutil

import std.fs as fs
import std.string as str

#if TARGET_OS == "windows"
/// Creates a directory through Win32.
/// @internal
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
#else
/// Creates a directory through POSIX, with permissions filtered by the process umask.
/// @internal
extern function PosixMkdir(path as cstr, mode as u32) from "libc.so.6" symbol "mkdir" returns i32
#endif

/// Performs the mkdir operation for the minipixels tools fsutil module.
/// @param path Path of the file or directory used by the operation.
function mkdir(path)
  if fs.exists(path) then return fs.isDir(path) end if
#if TARGET_OS == "windows"
  return CreateDirectoryW(path, 0)
#else
  return PosixMkdir(path, 0x1ED) == 0
#endif
end function

/// Performs the maxInt operation for the minipixels tools fsutil module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function maxInt(a, b)
  if a > b then return a end if
  return b
end function

/// Performs the dirname operation for the minipixels tools fsutil module.
/// @param path Path of the file or directory used by the operation.
function dirname(path)
  lastSlash = str.lastIndexOf(path, "\\")
  lastForward = str.lastIndexOf(path, "/")
  last = maxInt(lastSlash, lastForward)
  if last < 0 then return "." end if
  if last == 0 then return str.substr(path, 0, 1) end if
  return str.substr(path, 0, last)
end function

/// Ensures dir is available to the minipixels tools fsutil workflow.
/// @param path Path of the file or directory used by the operation.
function ensureDir(path)
  if path == "" or path == "." then return true end if
  if fs.exists(path) then return fs.isDir(path) end if
  parent = dirname(path)
  if parent != path and parent != "." then
    if ensureDir(parent) == false then return false end if
  end if
  return mkdir(path)
end function

/// Returns whether two byte buffers have identical contents.
/// @param first First byte buffer.
/// @param second Second byte buffer.
function bytesEqual(first, second)
  if typeof(first) != "bytes" or typeof(second) != "bytes" then return false end if
  if len(first) != len(second) then return false end if
  if len(first) <= 0 then return true end if
  for index = 0 to len(first) - 1
    if first[index] != second[index] then return false end if
  end for
  return true
end function

/// Writes bytes only when their contents differ from the existing file.
/// @param path Path of the file used by the operation.
/// @param data Byte payload to persist.
function writeBytes(path, data)
  if typeof(data) != "bytes" then return error(9200, "expected byte data for: " + path) end if
  dir = dirname(path)
  if ensureDir(dir) == false then return error(9200, "could not create directory: " + dir) end if
  if fs.exists(path) then
    current = try(fs.readAllBytes(path))
    if typeof(current) == "bytes" and bytesEqual(current, data) then return true end if
  end if
  r = try(fs.writeAllBytes(path, data))
  if typeof(r) == "error" then return r end if
  return true
end function

/// Writes text only when its contents differ from the existing file.
/// @param path Path of the file or directory used by the operation.
/// @param text Text consumed by the operation.
function writeText(path, text)
  dir = dirname(path)
  if ensureDir(dir) == false then return error(9200, "could not create directory: " + dir) end if
  if fs.exists(path) then
    current = try(fs.readAllText(path))
    if typeof(current) == "string" and current == text then return true end if
  end if
  r = try(fs.writeAllText(path, text))
  if typeof(r) == "error" then return r end if
  return true
end function
