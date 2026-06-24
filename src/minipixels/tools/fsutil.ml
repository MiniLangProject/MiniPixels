package minipixels.tools.fsutil

import std.fs as fs
import std.string as str

extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

function mkdir(path)
  if fs.exists(path) then return fs.isDir(path) end if
  return CreateDirectoryW(path, 0)
end function

function maxInt(a, b)
  if a > b then return a end if
  return b
end function

function dirname(path)
  lastSlash = str.lastIndexOf(path, "\\")
  lastForward = str.lastIndexOf(path, "/")
  last = maxInt(lastSlash, lastForward)
  if last < 0 then return "." end if
  if last == 0 then return str.substr(path, 0, 1) end if
  return str.substr(path, 0, last)
end function

function ensureDir(path)
  if path == "" or path == "." then return true end if
  if fs.exists(path) then return fs.isDir(path) end if
  parent = dirname(path)
  if parent != path and parent != "." then
    if ensureDir(parent) == false then return false end if
  end if
  return mkdir(path)
end function

function writeText(path, text)
  dir = dirname(path)
  if ensureDir(dir) == false then return error(9200, "could not create directory: " + dir) end if
  r = try(fs.writeAllText(path, text))
  if typeof(r) == "error" then return r end if
  return true
end function
