// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools fsutil facilities for this project.

package minipixels.tools.fsutil

import std.fs as fs
import std.string as str

/// Invokes the native CreateDirectoryW entry point used by the minipixels tools fsutil module.
/// @param path Path of the file or directory used by the operation.
/// @param security security value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

/// Performs the mkdir operation for the minipixels tools fsutil module.
/// @param path Path of the file or directory used by the operation.
function mkdir(path)
  if fs.exists(path) then return fs.isDir(path) end if
  return CreateDirectoryW(path, 0)
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

/// Writes text for the minipixels tools fsutil workflow.
/// @param path Path of the file or directory used by the operation.
/// @param text Text consumed by the operation.
function writeText(path, text)
  dir = dirname(path)
  if ensureDir(dir) == false then return error(9200, "could not create directory: " + dir) end if
  r = try(fs.writeAllText(path, text))
  if typeof(r) == "error" then return r end if
  return true
end function
