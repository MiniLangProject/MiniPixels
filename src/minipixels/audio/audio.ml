// SPDX-License-Identifier: Apache-2.0

//! Provides legacy sound playback and a buffered multi-voice PCM mixer.

package minipixels.audio.audio

import std.bytes as by
import std.fs as fs
import minipixels.math.types as mt

/// Invokes the legacy PlaySoundW file entry point.
/// @param path UTF-16 WAV file path.
/// @param module Optional resource module handle.
/// @param flags WinMM playback flags.
/// @returns Whether playback started.
extern function PlaySoundW(path as wstr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
/// Invokes the legacy PlaySoundW memory entry point.
/// @param data Pointer to complete WAV bytes.
/// @param module Optional resource module handle.
/// @param flags WinMM playback flags.
/// @returns Whether playback started.
extern function PlaySoundMemory(data as ptr, module as ptr, flags as int) from "winmm.dll" symbol "PlaySoundW" returns bool
/// Opens a waveform output device.
/// @param handle Destination for the opened device handle.
/// @param device Waveform device selector.
/// @param format PCM WAVEFORMATEX bytes.
/// @param callback Optional callback pointer.
/// @param instance Optional callback instance.
/// @param flags Open flags.
/// @returns Multimedia-system result code.
extern function waveOutOpen(handle as bytes, device as u32, format as bytes, callback as ptr, instance as ptr, flags as u32) from "winmm.dll" returns u32
/// Prepares one waveform output header.
/// @param handle Open waveform output handle.
/// @param header WAVEHDR bytes.
/// @param size Native WAVEHDR size.
/// @returns Multimedia-system result code.
extern function waveOutPrepareHeader(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
/// Queues one prepared waveform output header.
/// @param handle Open waveform output handle.
/// @param header Prepared WAVEHDR bytes.
/// @param size Native WAVEHDR size.
/// @returns Multimedia-system result code.
extern function waveOutWrite(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
/// Unprepares one waveform output header.
/// @param handle Open waveform output handle.
/// @param header Completed WAVEHDR bytes.
/// @param size Native WAVEHDR size.
/// @returns Multimedia-system result code.
extern function waveOutUnprepareHeader(handle as ptr, header as bytes, size as u32) from "winmm.dll" returns u32
/// Stops playback and returns queued headers to the application.
/// @param handle Open waveform output handle.
/// @returns Multimedia-system result code.
extern function waveOutReset(handle as ptr) from "winmm.dll" returns u32
/// Closes a waveform output device.
/// @param handle Open waveform output handle.
/// @returns Multimedia-system result code.
extern function waveOutClose(handle as ptr) from "winmm.dll" returns u32

/// Legacy synchronous playback flag.
const SND_SYNC = 0x0000
/// Legacy asynchronous playback flag.
const SND_ASYNC = 0x0001
/// Legacy no-default-sound flag.
const SND_NODEFAULT = 0x0002
/// Legacy memory playback flag.
const SND_MEMORY = 0x0004
/// Legacy looping flag.
const SND_LOOP = 0x0008
/// Legacy purge flag.
const SND_PURGE = 0x0040
/// Legacy filename playback flag.
const SND_FILENAME = 0x00020000
/// Default waveform output device selector.
const WAVE_MAPPER = 0xFFFFFFFF
/// PCM waveform format identifier.
const WAVE_FORMAT_PCM = 1
/// Successful multimedia-system result.
const MMSYSERR_NOERROR = 0
/// Header flag set after an output buffer finishes.
const WHDR_DONE = 0x00000001
/// Native WAVEHDR size on x64 Windows.
const WAVEHDR_SIZE = 48
/// Default mixer sample rate.
const MIXER_SAMPLE_RATE = 44100
/// Number of stereo frames in one queued mixer buffer.
const MIXER_BUFFER_FRAMES = 1024
/// Number of buffers retained in the output queue.
const MIXER_BUFFER_COUNT = 3

/// Represents legacy state used by direct PlaySound-compatible helpers.
struct AudioState
  /// Master volume percentage.
  masterVolume
  /// Sound-effect bus volume percentage.
  sfxVolume
  /// Music bus volume percentage.
  musicVolume
  /// Whether playback is muted.
  muted
  /// Last legacy music path.
  musicPath

  /// Sets master volume.
  /// @param value Percentage from 0 through 100.
  function setMasterVolume(value)
    this.masterVolume = minipixels.audio.audio.normalizeVolume(value)
  end function
  /// Sets sound-effect volume.
  /// @param value Percentage from 0 through 100.
  function setSfxVolume(value)
    this.sfxVolume = minipixels.audio.audio.normalizeVolume(value)
  end function
  /// Sets music volume.
  /// @param value Percentage from 0 through 100.
  function setMusicVolume(value)
    this.musicVolume = minipixels.audio.audio.normalizeVolume(value)
  end function
  /// Mutes legacy playback.
  function mute()
    this.muted = true
    return minipixels.audio.audio.stopSound()
  end function
  /// Unmutes legacy playback.
  function unmute()
    this.muted = false
  end function
  /// Plays a legacy sound effect from a file.
  /// @param path WAV file path.
  function playSfx(path)
    return minipixels.audio.audio.playSfx(this, path)
  end function
  /// Plays looping legacy music from a file.
  /// @param path WAV file path.
  function playMusic(path)
    return minipixels.audio.audio.playMusicWithState(this, path)
  end function
  /// Stops legacy playback.
  function stop()
    this.musicPath = ""
    return minipixels.audio.audio.stopSound()
  end function
end struct

/// Represents a WAV clip and its lazily parsed PCM payload.
struct AudioClip
  /// Optional source path.
  path
  /// Stable clip name.
  name
  /// Clip volume percentage.
  volume
  /// Whether playback loops after the final frame.
  looping
  /// Original WAV file bytes, when loaded in memory.
  data
  /// Whether WAV parsing has been attempted.
  prepared
  /// Whether the parsed format is supported.
  valid
  /// WAV format identifier.
  formatTag
  /// Source channel count.
  channels
  /// Source sample rate.
  sampleRate
  /// Source bits per sample.
  bitsPerSample
  /// Source bytes per interleaved frame.
  blockAlign
  /// Detached PCM sample payload.
  sampleData
  /// Number of source sample frames.
  frameCount

  /// Sets clip volume.
  /// @param value Percentage from 0 through 100.
  function setVolume(value)
    this.volume = minipixels.audio.audio.normalizeVolume(value)
  end function
  /// Sets looping behavior.
  /// @param value Whether playback should loop.
  function setLooping(value)
    this.looping = value == true
  end function
  /// Plays this clip through an AudioState or AudioMixer.
  /// @param audio Destination audio state or mixer.
  function play(audio)
    return minipixels.audio.audio.playClip(audio, this)
  end function
end struct

/// Represents one independently mixed sound-effect voice.
struct AudioChannel
  /// Stable channel identifier.
  id
  /// Active clip.
  clip
  /// Whether this voice is active.
  playing
  /// Channel volume percentage.
  volume
  /// Channel pan from -100 (left) to 100 (right).
  pan
  /// Fractional source-frame cursor.
  cursor
end struct

/// Represents a software PCM mixer backed by WinMM waveOut.
struct AudioMixer
  /// Shared bus volume and mute state.
  audio
  /// Sound-effect voices.
  channels
  /// Number of sound-effect voices.
  channelCount
  /// Round-robin replacement cursor.
  nextChannel
  /// Active music clip retained for compatibility.
  music
  /// Dedicated music voice.
  musicChannel
  /// Output sample rate.
  sampleRate
  /// Native waveOut handle.
  handle
  /// Native handle output storage.
  handleStorage
  /// Native PCM WAVEFORMATEX storage.
  format
  /// Retained output byte buffers.
  buffers
  /// Retained native WAVEHDR structures.
  headers
  /// Stereo sample frames per buffer.
  bufferFrames
  /// Number of queued buffers.
  bufferCount
  /// Reusable left-channel mixing accumulator.
  mixLeft
  /// Reusable right-channel mixing accumulator.
  mixRight
  /// Whether the waveOut backend is open.
  ready
  /// Last multimedia-system error code.
  lastError

  /// Sets master volume for subsequently mixed samples.
  /// @param value Percentage from 0 through 100.
  function setMasterVolume(value)
    this.audio.setMasterVolume(value)
    return minipixels.audio.audio.refreshMixer(this)
  end function
  /// Sets sound-effect bus volume for subsequently mixed samples.
  /// @param value Percentage from 0 through 100.
  function setSfxVolume(value)
    this.audio.setSfxVolume(value)
    return minipixels.audio.audio.refreshMixer(this)
  end function
  /// Sets music bus volume for subsequently mixed samples.
  /// @param value Percentage from 0 through 100.
  function setMusicVolume(value)
    this.audio.setMusicVolume(value)
    return minipixels.audio.audio.refreshMixer(this)
  end function
  /// Mutes all buses for subsequently mixed samples.
  function mute()
    this.audio.muted = true
    return minipixels.audio.audio.refreshMixer(this)
  end function
  /// Unmutes all buses for subsequently mixed samples.
  function unmute()
    this.audio.muted = false
    return minipixels.audio.audio.refreshMixer(this)
  end function
  /// Starts a sound-effect voice.
  /// @param clip PCM WAV clip.
  function playSfx(clip)
    return minipixels.audio.audio.mixerPlaySfx(this, clip)
  end function
  /// Starts or replaces the dedicated music voice.
  /// @param clip PCM WAV clip.
  function playMusic(clip)
    return minipixels.audio.audio.mixerPlayMusic(this, clip)
  end function
  /// Refills completed output buffers.
  function update()
    return minipixels.audio.audio.updateMixer(this)
  end function
  /// Stops every active voice.
  function stopAll()
    return minipixels.audio.audio.mixerStopAll(this)
  end function
  /// Stops one sound-effect channel.
  /// @param id Zero-based channel identifier.
  function stopChannel(id)
    return minipixels.audio.audio.stopChannel(this, id)
  end function
  /// Sets volume and pan for one sound-effect channel.
  /// @param id Zero-based channel identifier.
  /// @param volume Percentage from 0 through 100.
  /// @param pan Pan from -100 through 100.
  function setChannel(id, volume, pan)
    return minipixels.audio.audio.setChannel(this, id, volume, pan)
  end function
  /// Releases the native output device.
  function close()
    return minipixels.audio.audio.closeMixer(this)
  end function
end struct

/// Normalizes a percentage volume into the inclusive 0..100 range.
/// @param value Candidate volume.
function normalizeVolume(value)
  if typeof(value) != "int" then value = 100 end if
  if value < 0 then return 0 end if
  if value > 100 then return 100 end if
  return value
end function

/// Normalizes pan into the inclusive -100..100 range.
/// @param value Candidate pan.
function normalizePan(value)
  if typeof(value) != "int" then return 0 end if
  if value < -100 then return -100 end if
  if value > 100 then return 100 end if
  return value
end function

/// Creates legacy direct-playback state.
function create()
  return AudioState(100, 100, 100, false, "")
end function

/// Creates a file-backed audio clip.
/// @param path WAV file path.
/// @param name Stable clip name.
function clip(path, name)
  if typeof(path) != "string" then path = "" end if
  if typeof(name) != "string" then name = path end if
  return AudioClip(path, name, 100, false, void, false, false, 0, 0, 0, 0, 0, void, 0)
end function

/// Creates an in-memory WAV audio clip.
/// @param data Complete WAV file bytes.
/// @param name Stable clip name.
function clipFromBytes(data, name)
  if typeof(name) != "string" then name = "memory" end if
  if typeof(data) != "bytes" then data = void end if
  return AudioClip("", name, 100, false, data, false, false, 0, 0, 0, 0, 0, void, 0)
end function

/// Creates a looping file-backed music clip.
/// @param path WAV file path.
/// @param name Stable clip name.
function musicClip(path, name)
  value = clip(path, name)
  value.looping = true
  return value
end function

/// Creates an inactive mixer channel.
/// @param id Stable channel identifier.
function channel(id)
  return AudioChannel(id, void, false, 100, 0, 0.0)
end function

/// Creates a lazily opened multi-voice PCM mixer.
/// @param maxChannels Maximum simultaneous sound-effect voices.
function mixer(maxChannels)
  if typeof(maxChannels) != "int" or maxChannels <= 0 then maxChannels = 8 end if
  channels = array(maxChannels)
  for index = 0 to maxChannels - 1
    channels[index] = channel(index)
  end for
  frames = MIXER_BUFFER_FRAMES
  return AudioMixer(
    create(), channels, maxChannels, 0, void, channel(-1), MIXER_SAMPLE_RATE,
    0, bytes(8, 0), bytes(18, 0), array(MIXER_BUFFER_COUNT), array(MIXER_BUFFER_COUNT),
    frames, MIXER_BUFFER_COUNT, array(frames, 0), array(frames, 0), false, 0
  )
end function

/// Returns effective state/channel volume before clip-specific scaling.
/// @param audio Shared audio state.
/// @param channelVolume Bus or channel volume percentage.
function effectiveVolume(audio, channelVolume)
  if audio.muted then return 0 end if
  return (normalizeVolume(audio.masterVolume) * normalizeVolume(channelVolume)) / 100
end function

/// Returns effective state/channel/clip volume.
/// @param audio Shared audio state.
/// @param channelVolume Bus or channel volume percentage.
/// @param clipVolume Clip volume percentage.
function effectiveClipVolume(audio, channelVolume, clipVolume)
  return (effectiveVolume(audio, channelVolume) * normalizeVolume(clipVolume)) / 100
end function

/// Returns the primary advanced audio backend name.
function backendName()
  return "waveout-pcm"
end function

/// Returns whether the mixer supports simultaneous sound effects.
function supportsMultipleSfx()
  return true
end function

/// Returns whether the mixer applies per-bus, per-channel, and per-clip volume.
function supportsVolumeControl()
  return true
end function

/// Plays one WAV file through the legacy operating-system helper.
/// @param path WAV file path.
function playSound(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_FILENAME | SND_NODEFAULT)
end function

/// Plays one WAV file synchronously through the legacy helper.
/// @param path WAV file path.
function playSoundSync(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_SYNC | SND_FILENAME | SND_NODEFAULT)
end function

/// Plays one looping WAV file through the legacy helper.
/// @param path WAV file path.
function playSoundLoop(path)
  if typeof(path) != "string" then return false end if
  return PlaySoundW(path, 0, SND_ASYNC | SND_LOOP | SND_FILENAME | SND_NODEFAULT)
end function

/// Plays WAV file bytes through the legacy helper.
/// @param data Complete WAV file bytes.
function playSoundBytes(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return false end if
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_ASYNC | SND_MEMORY | SND_NODEFAULT)
end function

/// Plays WAV file bytes synchronously through the legacy helper.
/// @param data Complete WAV file bytes.
function playSoundBytesSync(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return false end if
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_SYNC | SND_MEMORY | SND_NODEFAULT)
end function

/// Stops legacy direct playback.
function stopSound()
  return PlaySoundW("", 0, SND_PURGE)
end function

/// Plays looping legacy music from a path.
/// @param path WAV file path.
function playMusic(path)
  return playSoundLoop(path)
end function

/// Plays a path as either legacy state playback or mixer playback.
/// @param audio Destination audio state or mixer.
/// @param path WAV file path.
function playSfx(audio, path)
  if typeof(path) != "string" then return false end if
  if audio is AudioMixer then return mixerPlaySfx(audio, clip(path, path)) end if
  if effectiveVolume(audio, audio.sfxVolume) <= 0 then return false end if
  return playSound(path)
end function

/// Plays looping music through legacy state or the advanced mixer.
/// @param audio Destination audio state or mixer.
/// @param path WAV file path.
function playMusicWithState(audio, path)
  if typeof(path) != "string" then return false end if
  if audio is AudioMixer then return mixerPlayMusic(audio, musicClip(path, path)) end if
  audio.musicPath = path
  if effectiveVolume(audio, audio.musicVolume) <= 0 then return false end if
  return playSoundLoop(path)
end function

/// Plays a clip through legacy state or the advanced mixer.
/// @param audio Destination audio state or mixer.
/// @param value Audio clip to play.
function playClip(audio, value)
  if audio is AudioMixer then
    if value.looping then return mixerPlayMusic(audio, value) end if
    return mixerPlaySfx(audio, value)
  end if
  hasData = typeof(value.data) == "bytes"
  if value.looping then
    if effectiveClipVolume(audio, audio.musicVolume, value.volume) <= 0 then return false end if
    if hasData then return false end if
    return playMusicWithState(audio, value.path)
  end if
  if effectiveClipVolume(audio, audio.sfxVolume, value.volume) <= 0 then return false end if
  if hasData then return playSoundBytes(value.data) end if
  return playSfx(audio, value.path)
end function

/// Writes a little-endian 32-bit value to a native structure buffer.
/// @param buffer Destination byte buffer.
/// @param offset Starting byte offset.
/// @param value Integer value to encode.
function putU32(buffer, offset, value)
  if value < 0 then value = value + 4294967296 end if
  buffer[offset] = value & 255
  buffer[offset + 1] = (value >> 8) & 255
  buffer[offset + 2] = (value >> 16) & 255
  buffer[offset + 3] = (value >> 24) & 255
end function

/// Writes a little-endian 64-bit value to a native structure buffer.
/// @param buffer Destination byte buffer.
/// @param offset Starting byte offset.
/// @param value Integer value to encode.
function putU64(buffer, offset, value)
  putU32(buffer, offset, value & 0xFFFFFFFF)
  putU32(buffer, offset + 4, (value >> 32) & 0xFFFFFFFF)
end function

/// Reads a little-endian unsigned 32-bit value.
/// @param buffer Source byte buffer.
/// @param offset Starting byte offset.
function getU32(buffer, offset)
  return buffer[offset] + (buffer[offset + 1] << 8) + (buffer[offset + 2] << 16) + (buffer[offset + 3] << 24)
end function

/// Reads a little-endian unsigned 64-bit value.
/// @param buffer Source byte buffer.
/// @param offset Starting byte offset.
function getU64(buffer, offset)
  return getU32(buffer, offset) + (getU32(buffer, offset + 4) << 32)
end function

/// Returns whether a byte range is available.
/// @param data Byte buffer to inspect.
/// @param offset Starting byte offset.
/// @param size Required byte count.
function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

/// Returns whether four bytes match an ASCII chunk identifier.
/// @param data WAV byte buffer.
/// @param offset Starting byte offset.
/// @param a First identifier byte.
/// @param b Second identifier byte.
/// @param c Third identifier byte.
/// @param d Fourth identifier byte.
function chunkIs(data, offset, a, b, c, d)
  if not hasRange(data, offset, 4) then return false end if
  return data[offset] == a and data[offset + 1] == b and data[offset + 2] == c and data[offset + 3] == d
end function

/// Loads and parses a PCM WAV clip on first use.
/// @param value Audio clip to prepare.
function prepareClip(value)
  if value.prepared then return value.valid end if
  value.prepared = true
  data = value.data
  if typeof(data) != "bytes" then
    if typeof(value.path) != "string" or len(value.path) <= 0 then return false end if
    data = try(fs.readAllBytes(value.path))
    if typeof(data) == "error" then return false end if
    value.data = data
  end if
  if not hasRange(data, 0, 12) then return false end if
  if not chunkIs(data, 0, 82, 73, 70, 70) or not chunkIs(data, 8, 87, 65, 86, 69) then return false end if
  formatFound = false
  samplesFound = false
  sampleOffset = 0
  sampleSize = 0
  position = 12
  while position + 8 <= len(data)
    size = by.readU32LE(data, position + 4)
    payload = position + 8
    if typeof(size) != "int" or size < 0 or not hasRange(data, payload, size) then return false end if
    if chunkIs(data, position, 102, 109, 116, 32) then
      if size < 16 then return false end if
      value.formatTag = by.readU16LE(data, payload)
      value.channels = by.readU16LE(data, payload + 2)
      value.sampleRate = by.readU32LE(data, payload + 4)
      value.blockAlign = by.readU16LE(data, payload + 12)
      value.bitsPerSample = by.readU16LE(data, payload + 14)
      formatFound = true
    end if
    if chunkIs(data, position, 100, 97, 116, 97) then
      sampleOffset = payload
      sampleSize = size
      samplesFound = true
    end if
    position = payload + size + (size & 1)
  end while
  if not formatFound or not samplesFound then return false end if
  if value.formatTag != WAVE_FORMAT_PCM then return false end if
  if value.channels < 1 or value.channels > 2 then return false end if
  if value.sampleRate <= 0 or value.blockAlign <= 0 then return false end if
  if value.bitsPerSample != 8 and value.bitsPerSample != 16 and value.bitsPerSample != 24 and value.bitsPerSample != 32 then return false end if
  expectedBlockAlign = value.channels * (value.bitsPerSample / 8)
  if value.blockAlign != expectedBlockAlign or sampleSize % value.blockAlign != 0 then return false end if
  value.sampleData = slice(data, sampleOffset, sampleSize)
  value.frameCount = sampleSize / value.blockAlign
  value.valid = value.frameCount > 0
  return value.valid
end function

/// Reads one source sample and converts it to signed 16-bit amplitude.
/// @param value Prepared audio clip.
/// @param frame Zero-based sample frame.
/// @param side Source side, zero for left and one for right.
function sampleAt(value, frame, side)
  if frame < 0 or frame >= value.frameCount then return 0 end if
  sourceChannel = side
  if value.channels == 1 then sourceChannel = 0 end if
  bytesPerSample = value.bitsPerSample / 8
  offset = (frame * value.blockAlign) + (sourceChannel * bytesPerSample)
  data = value.sampleData
  if value.bitsPerSample == 8 then return (data[offset] - 128) * 256 end if
  if value.bitsPerSample == 16 then
    sample = data[offset] + (data[offset + 1] << 8)
    if sample >= 32768 then sample = sample - 65536 end if
    return sample
  end if
  if value.bitsPerSample == 24 then
    sample = data[offset] + (data[offset + 1] << 8) + (data[offset + 2] << 16)
    if sample >= 8388608 then sample = sample - 16777216 end if
    return sample / 256
  end if
  sample = getU32(data, offset)
  if sample >= 2147483648 then sample = sample - 4294967296 end if
  return sample / 65536
end function

/// Chooses an idle channel or a deterministic round-robin replacement.
/// @param value Mixer whose channels are inspected.
function chooseChannel(value)
  for index = 0 to value.channelCount - 1
    if value.channels[index].playing == false then return index end if
  end for
  index = value.nextChannel
  value.nextChannel = (value.nextChannel + 1) % value.channelCount
  return index
end function

/// Accumulates one voice into reusable stereo mix arrays and returns its new state.
/// @param value Destination mixer.
/// @param voice Voice to advance.
/// @param busVolume Bus volume percentage.
function mixVoice(value, voice, busVolume)
  if voice.playing == false or voice.clip is not AudioClip then return voice end if
  source = voice.clip
  gain = effectiveClipVolume(value.audio, busVolume, (voice.volume * source.volume) / 100)
  pan = normalizePan(voice.pan)
  leftGain = gain
  rightGain = gain
  if pan < 0 then rightGain = (rightGain * (100 + pan)) / 100 end if
  if pan > 0 then leftGain = (leftGain * (100 - pan)) / 100 end if
  frame = 0
  while frame < value.bufferFrames and voice.playing
    sourceFrame = mt.floorInt(voice.cursor)
    if sourceFrame >= source.frameCount then
      if source.looping then
        voice.cursor = voice.cursor % source.frameCount
        sourceFrame = mt.floorInt(voice.cursor)
      else
        voice.playing = false
        break
      end if
    end if
    left = sampleAt(source, sourceFrame, 0)
    right = sampleAt(source, sourceFrame, 1)
    value.mixLeft[frame] = value.mixLeft[frame] + ((left * leftGain) / 100)
    value.mixRight[frame] = value.mixRight[frame] + ((right * rightGain) / 100)
    voice.cursor = voice.cursor + (source.sampleRate / value.sampleRate)
    frame = frame + 1
  end while
  return voice
end function

/// Mixes active voices into one interleaved stereo 16-bit output buffer.
/// @param value Source mixer.
/// @param output Destination interleaved PCM buffer.
function mixBuffer(value, output)
  for frame = 0 to value.bufferFrames - 1
    value.mixLeft[frame] = 0
    value.mixRight[frame] = 0
  end for
  for index = 0 to value.channelCount - 1
    voice = value.channels[index]
    if voice.playing then value.channels[index] = mixVoice(value, voice, value.audio.sfxVolume) end if
  end for
  if value.musicChannel.playing then
    value.musicChannel = mixVoice(value, value.musicChannel, value.audio.musicVolume)
    if value.musicChannel.playing == false then value.music = void end if
  end if
  for frame = 0 to value.bufferFrames - 1
    left = mt.clamp(mt.floorInt(value.mixLeft[frame]), -32768, 32767)
    right = mt.clamp(mt.floorInt(value.mixRight[frame]), -32768, 32767)
    offset = frame * 4
    if left < 0 then left = left + 65536 end if
    if right < 0 then right = right + 65536 end if
    output[offset] = left & 255
    output[offset + 1] = (left >> 8) & 255
    output[offset + 2] = right & 255
    output[offset + 3] = (right >> 8) & 255
  end for
  return output
end function

/// Initializes and fills the native PCM format structure.
/// @param value Mixer to initialize.
function prepareMixerFormat(value)
  format = value.format
  by.writeU16LE(format, 0, WAVE_FORMAT_PCM)
  by.writeU16LE(format, 2, 2)
  by.writeU32LE(format, 4, value.sampleRate)
  by.writeU32LE(format, 8, value.sampleRate * 4)
  by.writeU16LE(format, 12, 4)
  by.writeU16LE(format, 14, 16)
  by.writeU16LE(format, 16, 0)
end function

/// Opens waveOut and queues the initial retained buffers.
/// @param value Mixer to open.
function ensureBackend(value)
  if value.ready then return true end if
  prepareMixerFormat(value)
  result = waveOutOpen(value.handleStorage, WAVE_MAPPER, value.format, 0, 0, 0)
  if result != MMSYSERR_NOERROR then
    value.lastError = result
    return false
  end if
  value.handle = getU64(value.handleStorage, 0)
  for index = 0 to value.bufferCount - 1
    output = bytes(value.bufferFrames * 4, 0)
    header = bytes(WAVEHDR_SIZE, 0)
    value.buffers[index] = output
    value.headers[index] = header
    mixBuffer(value, output)
    putU64(header, 0, nativeBytesPtr(output))
    putU32(header, 8, len(output))
    result = waveOutPrepareHeader(value.handle, header, WAVEHDR_SIZE)
    if result != MMSYSERR_NOERROR then
      value.lastError = result
      closeMixer(value)
      return false
    end if
    result = waveOutWrite(value.handle, header, WAVEHDR_SIZE)
    if result != MMSYSERR_NOERROR then
      value.lastError = result
      closeMixer(value)
      return false
    end if
  end for
  value.ready = true
  value.lastError = 0
  return true
end function

/// Starts a sound-effect voice without interrupting other voices.
/// @param value Destination mixer.
/// @param source Prepared or lazy audio clip.
function mixerPlaySfx(value, source)
  if source is not AudioClip then return false end if
  if effectiveClipVolume(value.audio, value.audio.sfxVolume, source.volume) <= 0 then return false end if
  if prepareClip(source) == false then return false end if
  index = chooseChannel(value)
  voice = value.channels[index]
  voice.clip = source
  voice.playing = true
  voice.volume = 100
  voice.pan = 0
  voice.cursor = 0.0
  value.channels[index] = voice
  if ensureBackend(value) == false then
    voice.playing = false
    value.channels[index] = voice
    return false
  end if
  return true
end function

/// Starts or replaces the dedicated music voice.
/// @param value Destination mixer.
/// @param source Prepared or lazy audio clip.
function mixerPlayMusic(value, source)
  if source is not AudioClip then return false end if
  if effectiveClipVolume(value.audio, value.audio.musicVolume, source.volume) <= 0 then return false end if
  if prepareClip(source) == false then return false end if
  source.looping = true
  voice = value.musicChannel
  voice.clip = source
  voice.playing = true
  voice.volume = 100
  voice.pan = 0
  voice.cursor = 0.0
  value.musicChannel = voice
  value.music = source
  if ensureBackend(value) == false then
    voice.playing = false
    value.musicChannel = voice
    value.music = void
    return false
  end if
  return true
end function

/// Refills every completed native output header.
/// @param value Mixer to update.
function updateMixer(value)
  if value is not AudioMixer or value.ready == false then return false end if
  wrote = false
  for index = 0 to value.bufferCount - 1
    header = value.headers[index]
    if (getU32(header, 24) & WHDR_DONE) != 0 then
      mixBuffer(value, value.buffers[index])
      result = waveOutWrite(value.handle, header, WAVEHDR_SIZE)
      if result != MMSYSERR_NOERROR then
        value.lastError = result
        return false
      end if
      wrote = true
    end if
  end for
  return wrote
end function

/// Applies a volume or mute change to subsequently mixed buffers.
/// @param value Mixer to refresh.
function refreshMixer(value)
  return value is AudioMixer
end function

/// Stops every mixer voice and replaces queued output with silence.
/// @param value Mixer to stop.
function mixerStopAll(value)
  for index = 0 to value.channelCount - 1
    voice = value.channels[index]
    voice.playing = false
    voice.clip = void
    voice.cursor = 0.0
    value.channels[index] = voice
  end for
  value.musicChannel.playing = false
  value.musicChannel.clip = void
  value.musicChannel.cursor = 0.0
  value.music = void
  if value.ready then
    waveOutReset(value.handle)
    updateMixer(value)
  end if
  return true
end function

/// Stops one sound-effect channel.
/// @param value Mixer owning the channel.
/// @param id Zero-based channel identifier.
function stopChannel(value, id)
  if typeof(id) != "int" or id < 0 or id >= value.channelCount then return false end if
  voice = value.channels[id]
  voice.playing = false
  voice.clip = void
  value.channels[id] = voice
  return true
end function

/// Sets one sound-effect channel's volume and pan.
/// @param value Mixer owning the channel.
/// @param id Zero-based channel identifier.
/// @param volume Percentage from 0 through 100.
/// @param pan Pan from -100 through 100.
function setChannel(value, id, volume, pan)
  if typeof(id) != "int" or id < 0 or id >= value.channelCount then return false end if
  voice = value.channels[id]
  voice.volume = normalizeVolume(volume)
  voice.pan = normalizePan(pan)
  value.channels[id] = voice
  return refreshMixer(value)
end function

/// Releases retained headers and closes the native waveform output device.
/// @param value Mixer to close.
function closeMixer(value)
  if value is not AudioMixer or value.handle == 0 then
    if value is AudioMixer then value.ready = false end if
    return true
  end if
  waveOutReset(value.handle)
  for index = 0 to value.bufferCount - 1
    header = value.headers[index]
    if typeof(header) == "bytes" then waveOutUnprepareHeader(value.handle, header, WAVEHDR_SIZE) end if
  end for
  result = waveOutClose(value.handle)
  value.handle = 0
  value.ready = false
  if result != MMSYSERR_NOERROR then
    value.lastError = result
    return false
  end if
  return true
end function

/// Updates an advanced mixer while accepting legacy audio state values.
/// @param audio Audio state or mixer.
function update(audio)
  if audio is AudioMixer then return updateMixer(audio) end if
  return false
end function

/// Closes an advanced mixer while accepting legacy audio state values.
/// @param audio Audio state or mixer.
function close(audio)
  if audio is AudioMixer then return closeMixer(audio) end if
  return true
end function
