package minipixels.audio.audio

extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool

const SND_ASYNC = 0x0001
const SND_FILENAME = 0x00020000

function playSound(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_FILENAME)
end function

function playMusic(path)
  return playSound(path)
end function
