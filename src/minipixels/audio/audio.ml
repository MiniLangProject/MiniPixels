package minipixels.audio.audio

extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool

const SND_SYNC = 0x0000
const SND_ASYNC = 0x0001
const SND_NODEFAULT = 0x0002
const SND_LOOP = 0x0008
const SND_PURGE = 0x0040
const SND_FILENAME = 0x00020000

function playSound(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_FILENAME | SND_NODEFAULT)
end function

function playSoundSync(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_SYNC | SND_FILENAME | SND_NODEFAULT)
end function

function playSoundLoop(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_LOOP | SND_FILENAME | SND_NODEFAULT)
end function

function stopSound()
  return PlaySoundW("", 0, SND_PURGE)
end function

function playMusic(path)
  return playSoundLoop(path)
end function
