package minipixels.audio.audio

extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool

const SND_SYNC = 0x0000
const SND_ASYNC = 0x0001
const SND_NODEFAULT = 0x0002
const SND_LOOP = 0x0008
const SND_PURGE = 0x0040
const SND_FILENAME = 0x00020000

struct AudioState
  masterVolume
  sfxVolume
  musicVolume
  muted
  musicPath

  function setMasterVolume(value)
    this.masterVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  function setSfxVolume(value)
    this.sfxVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  function setMusicVolume(value)
    this.musicVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  function mute()
    this.muted = true
    return minipixels.audio.audio.stopSound()
  end function

  function unmute()
    this.muted = false
  end function

  function playSfx(path)
    return minipixels.audio.audio.playSfx(this, path)
  end function

  function playMusic(path)
    return minipixels.audio.audio.playMusicWithState(this, path)
  end function

  function stop()
    this.musicPath = ""
    return minipixels.audio.audio.stopSound()
  end function
end struct

function normalizeVolume(value)
  if typeof(value) != "int" then value = 100 end if
  if value < 0 then return 0 end if
  if value > 100 then return 100 end if
  return value
end function

function create()
  return AudioState(100, 100, 100, false, "")
end function

function effectiveVolume(audio, channelVolume)
  if audio.muted then return 0 end if
  return (normalizeVolume(audio.masterVolume) * normalizeVolume(channelVolume)) / 100
end function

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

function playSfx(audio, path)
  if typeof(path) != "string" then return false end if
  if effectiveVolume(audio, audio.sfxVolume) <= 0 then return false end if
  return playSound(path)
end function

function playMusicWithState(audio, path)
  if typeof(path) != "string" then return false end if
  audio.musicPath = path
  if effectiveVolume(audio, audio.musicVolume) <= 0 then return false end if
  return playSoundLoop(path)
end function
