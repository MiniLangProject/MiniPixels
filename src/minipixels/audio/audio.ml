// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels audio audio facilities for this project.

package minipixels.audio.audio

/// Invokes the native PlaySoundW entry point used by the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
/// @param module module value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @returns Native bool result produced by the call.
extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
/// Invokes the native PlaySoundMemory entry point used by the minipixels audio audio module.
/// @param data Input data consumed by the operation.
/// @param module module value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @returns Native bool result produced by the call.
extern function PlaySoundMemory(data as ptr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool

/// Defines the snd sync constant used by the minipixels audio audio module.
const SND_SYNC = 0x0000
/// Defines the snd async constant used by the minipixels audio audio module.
const SND_ASYNC = 0x0001
/// Defines the snd nodefault constant used by the minipixels audio audio module.
const SND_NODEFAULT = 0x0002
/// Defines the snd loop constant used by the minipixels audio audio module.
const SND_LOOP = 0x0008
/// Defines the snd purge constant used by the minipixels audio audio module.
const SND_PURGE = 0x0040
/// Defines the snd memory constant used by the minipixels audio audio module.
const SND_MEMORY = 0x0004
/// Defines the snd filename constant used by the minipixels audio audio module.
const SND_FILENAME = 0x00020000

/// Represents the audio state data used by the minipixels audio audio module.
struct AudioState
  /// Stores the master volume value associated with audio state.
  masterVolume
  /// Stores the sfx volume value associated with audio state.
  sfxVolume
  /// Stores the music volume value associated with audio state.
  musicVolume
  /// Stores the muted value associated with audio state.
  muted
  /// Stores the music path value associated with audio state.
  musicPath

  /// Updates master volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setMasterVolume(value)
    this.masterVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  /// Updates sfx volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setSfxVolume(value)
    this.sfxVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  /// Updates music volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setMusicVolume(value)
    this.musicVolume = minipixels.audio.audio.normalizeVolume(value)
  end function

  /// Performs the mute operation for the minipixels audio audio audio state module.
  function mute()
    this.muted = true
    return minipixels.audio.audio.stopSound()
  end function

  /// Performs the unmute operation for the minipixels audio audio audio state module.
  function unmute()
    this.muted = false
  end function

  /// Performs the playSfx operation for the minipixels audio audio audio state module.
  /// @param path Path of the file or directory used by the operation.
  function playSfx(path)
    return minipixels.audio.audio.playSfx(this, path)
  end function

  /// Performs the playMusic operation for the minipixels audio audio audio state module.
  /// @param path Path of the file or directory used by the operation.
  function playMusic(path)
    return minipixels.audio.audio.playMusicWithState(this, path)
  end function

  /// Stops stop for the minipixels audio audio workflow.
  function stop()
    this.musicPath = ""
    return minipixels.audio.audio.stopSound()
  end function
end struct

/// Represents the audio clip data used by the minipixels audio audio module.
struct AudioClip
  /// Stores the path value associated with audio clip.
  path
  /// Stores the name value associated with audio clip.
  name
  /// Stores the volume value associated with audio clip.
  volume
  /// Stores the looping value associated with audio clip.
  looping
  /// Stores the data value associated with audio clip.
  data

  /// Updates volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setVolume(value)
    this.volume = minipixels.audio.audio.normalizeVolume(value)
  end function

  /// Updates looping maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setLooping(value)
    this.looping = value
  end function

  /// Performs the play operation for the minipixels audio audio audio clip module.
  /// @param audio audio value consumed by this operation.
  function play(audio)
    return minipixels.audio.audio.playClip(audio, this)
  end function
end struct

/// Represents the audio channel data used by the minipixels audio audio module.
struct AudioChannel
  /// Stores the id value associated with audio channel.
  id
  /// Stores the clip value associated with audio channel.
  clip
  /// Stores the playing value associated with audio channel.
  playing
  /// Stores the volume value associated with audio channel.
  volume
end struct

/// Represents the audio mixer data used by the minipixels audio audio module.
struct AudioMixer
  /// Stores the audio value associated with audio mixer.
  audio
  /// Stores the channels value associated with audio mixer.
  channels
  /// Stores the channel count value associated with audio mixer.
  channelCount
  /// Stores the next channel value associated with audio mixer.
  nextChannel
  /// Stores the music value associated with audio mixer.
  music

  /// Updates master volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setMasterVolume(value)
    this.audio.setMasterVolume(value)
  end function

  /// Updates sfx volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setSfxVolume(value)
    this.audio.setSfxVolume(value)
  end function

  /// Updates music volume maintained by the minipixels audio audio module.
  /// @param value Value consumed or transformed by the operation.
  function setMusicVolume(value)
    this.audio.setMusicVolume(value)
  end function

  /// Performs the mute operation for the minipixels audio audio audio mixer module.
  function mute()
    return this.audio.mute()
  end function

  /// Performs the unmute operation for the minipixels audio audio audio mixer module.
  function unmute()
    return this.audio.unmute()
  end function

  /// Performs the playSfx operation for the minipixels audio audio audio mixer module.
  /// @param clip clip value consumed by this operation.
  function playSfx(clip)
    return minipixels.audio.audio.mixerPlaySfx(this, clip)
  end function

  /// Performs the playMusic operation for the minipixels audio audio audio mixer module.
  /// @param clip clip value consumed by this operation.
  function playMusic(clip)
    return minipixels.audio.audio.mixerPlayMusic(this, clip)
  end function

  /// Stops all for the minipixels audio audio workflow.
  function stopAll()
    return minipixels.audio.audio.mixerStopAll(this)
  end function
end struct

/// Normalizes volume for the minipixels audio audio workflow.
/// @param value Value consumed or transformed by the operation.
function normalizeVolume(value)
  if typeof(value) != "int" then value = 100 end if
  if value < 0 then return 0 end if
  if value > 100 then return 100 end if
  return value
end function

/// Creates create for the minipixels audio audio module.
function create()
  return AudioState(100, 100, 100, false, "")
end function

/// Performs the clip operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
/// @param name Name of the affected item.
function clip(path, name)
  if typeof(path) != "string" then path = "" end if
  if typeof(name) != "string" then name = path end if
  return AudioClip(path, name, 100, false, void)
end function

/// Performs the clipFromBytes operation for the minipixels audio audio module.
/// @param data Input data consumed by the operation.
/// @param name Name of the affected item.
function clipFromBytes(data, name)
  if typeof(name) != "string" then name = "memory" end if
  c = AudioClip("", name, 100, false, data)
  if typeof(data) != "bytes" then c.data = void end if
  return c
end function

/// Performs the musicClip operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
/// @param name Name of the affected item.
function musicClip(path, name)
  c = clip(path, name)
  c.looping = true
  return c
end function

/// Performs the channel operation for the minipixels audio audio module.
/// @param id Stable identifier of the affected item.
function channel(id)
  return AudioChannel(id, void, false, 100)
end function

/// Performs the mixer operation for the minipixels audio audio module.
/// @param maxChannels maxChannels value consumed by this operation.
function mixer(maxChannels)
  if typeof(maxChannels) != "int" or maxChannels <= 0 then maxChannels = 4 end if
  channels = array(maxChannels)
  i = 0
  while i < maxChannels
    channels[i] = channel(i)
    i = i + 1
  end while
  return AudioMixer(create(), channels, maxChannels, 0, void)
end function

/// Performs the effectiveVolume operation for the minipixels audio audio module.
/// @param audio audio value consumed by this operation.
/// @param channelVolume channelVolume value consumed by this operation.
function effectiveVolume(audio, channelVolume)
  if audio.muted then return 0 end if
  return (normalizeVolume(audio.masterVolume) * normalizeVolume(channelVolume)) / 100
end function

/// Performs the effectiveClipVolume operation for the minipixels audio audio module.
/// @param audio audio value consumed by this operation.
/// @param channelVolume channelVolume value consumed by this operation.
/// @param clipVolume clipVolume value consumed by this operation.
function effectiveClipVolume(audio, channelVolume, clipVolume)
  return (effectiveVolume(audio, channelVolume) * normalizeVolume(clipVolume)) / 100
end function

/// Performs the backendName operation for the minipixels audio audio module.
function backendName()
  return "winmm"
end function

/// Performs the supportsMultipleSfx operation for the minipixels audio audio module.
function supportsMultipleSfx()
  return false
end function

/// Performs the supportsVolumeControl operation for the minipixels audio audio module.
function supportsVolumeControl()
  return false
end function

/// Performs the playSound operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
function playSound(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_FILENAME | SND_NODEFAULT)
end function

/// Performs the playSoundSync operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
function playSoundSync(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_SYNC | SND_FILENAME | SND_NODEFAULT)
end function

/// Performs the playSoundLoop operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
function playSoundLoop(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_LOOP | SND_FILENAME | SND_NODEFAULT)
end function

/// Performs the playSoundBytes operation for the minipixels audio audio module.
/// @param data Input data consumed by the operation.
function playSoundBytes(data)
  if typeof(data) != "bytes" then return false end if
  if len(data) <= 0 then return false end if
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_ASYNC | SND_MEMORY | SND_NODEFAULT)
end function

/// Performs the playSoundBytesSync operation for the minipixels audio audio module.
/// @param data Input data consumed by the operation.
function playSoundBytesSync(data)
  if typeof(data) != "bytes" then return false end if
  if len(data) <= 0 then return false end if
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_SYNC | SND_MEMORY | SND_NODEFAULT)
end function

/// Stops sound for the minipixels audio audio workflow.
function stopSound()
  return PlaySoundW("", 0, SND_PURGE)
end function

/// Performs the playMusic operation for the minipixels audio audio module.
/// @param path Path of the file or directory used by the operation.
function playMusic(path)
  return playSoundLoop(path)
end function

/// Performs the playSfx operation for the minipixels audio audio module.
/// @param audio audio value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function playSfx(audio, path)
  if typeof(path) != "string" then return false end if
  if effectiveVolume(audio, audio.sfxVolume) <= 0 then return false end if
  return playSound(path)
end function

/// Performs the playMusicWithState operation for the minipixels audio audio module.
/// @param audio audio value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function playMusicWithState(audio, path)
  if typeof(path) != "string" then return false end if
  audio.musicPath = path
  if effectiveVolume(audio, audio.musicVolume) <= 0 then return false end if
  return playSoundLoop(path)
end function

/// Performs the playClip operation for the minipixels audio audio module.
/// @param audio audio value consumed by this operation.
/// @param c c value consumed by this operation.
function playClip(audio, c)
  hasData = (typeof(c.data) == "bytes")
  if c.looping then
    if effectiveClipVolume(audio, audio.musicVolume, c.volume) <= 0 then return false end if
    if hasData then return false end if
    return playMusicWithState(audio, c.path)
  end if
  if effectiveClipVolume(audio, audio.sfxVolume, c.volume) <= 0 then return false end if
  if hasData then return playSoundBytes(c.data) end if
  return playSfx(audio, c.path)
end function

/// Performs the chooseChannel operation for the minipixels audio audio module.
/// @param m m value consumed by this operation.
function chooseChannel(m)
  i = 0
  while i < m.channelCount
    ch = m.channels[i]
    if ch.playing == false then return i end if
    i = i + 1
  end while
  idx = m.nextChannel
  m.nextChannel = (m.nextChannel + 1) % m.channelCount
  return idx
end function

/// Performs the mixerPlaySfx operation for the minipixels audio audio module.
/// @param m m value consumed by this operation.
/// @param c c value consumed by this operation.
function mixerPlaySfx(m, c)
  if c.looping then c.looping = false end if
  if effectiveClipVolume(m.audio, m.audio.sfxVolume, c.volume) <= 0 then return false end if
  ok = false
  if typeof(c.data) == "bytes" then
    ok = playSoundBytes(c.data)
  else
    ok = playSfx(m.audio, c.path)
  end if
  if ok == false then return false end if
  idx = chooseChannel(m)
  ch = m.channels[idx]
  ch.clip = c
  ch.playing = true
  ch.volume = c.volume
  m.channels[idx] = ch
  return true
end function

/// Performs the mixerPlayMusic operation for the minipixels audio audio module.
/// @param m m value consumed by this operation.
/// @param c c value consumed by this operation.
function mixerPlayMusic(m, c)
  c.looping = true
  if effectiveClipVolume(m.audio, m.audio.musicVolume, c.volume) <= 0 then return false end if
  if typeof(c.data) == "bytes" then return false end if
  ok = playMusicWithState(m.audio, c.path)
  if ok == false then return false end if
  m.music = c
  return true
end function

/// Performs the mixerStopAll operation for the minipixels audio audio module.
/// @param m m value consumed by this operation.
function mixerStopAll(m)
  i = 0
  while i < m.channelCount
    ch = m.channels[i]
    ch.playing = false
    m.channels[i] = ch
    i = i + 1
  end while
  m.music = void
  return stopSound()
end function
