// SPDX-License-Identifier: Apache-2.0

//! Provides legacy WAV playback and a buffered multi-voice WAV/MP3 mixer.

package minipixels.audio.audio

import std.bytes as by
import std.fs as fs
import minipixels.math.types as mt

#if TARGET_OS == "windows"
/// Opens an in-memory MP3 decoder retained by the native audio bridge.
/// @param data Complete MP3 bytes retained for the lifetime of the decoder.
/// @param size Byte length of the MP3 source.
/// @returns Native decoder handle, or zero when the input is unsupported.
extern function mpAudioMp3Open(data as bytes, size as u64) from "minipixels_audio.dll" returns ptr
/// Returns the decoded source channel count.
/// @param handle Open native MP3 decoder.
/// @returns One for mono or two for stereo.
extern function mpAudioMp3Channels(handle as ptr) from "minipixels_audio.dll" returns i32
/// Returns the decoded source sample rate.
/// @param handle Open native MP3 decoder.
/// @returns Source frames per second.
extern function mpAudioMp3SampleRate(handle as ptr) from "minipixels_audio.dll" returns i32
/// Returns the decoded PCM frame count.
/// @param handle Open native MP3 decoder.
/// @returns Total interleaved source frames.
extern function mpAudioMp3FrameCount(handle as ptr) from "minipixels_audio.dll" returns u64
/// Decodes sequential signed-16 PCM frames.
/// @param handle Open native MP3 decoder.
/// @param output Destination byte buffer sized for frames times block alignment.
/// @param frames Maximum source frames to decode.
/// @returns Number of decoded frames written.
extern function mpAudioMp3Read(handle as ptr, output as bytes, frames as u64) from "minipixels_audio.dll" returns u64
/// Seeks an MP3 decoder to an absolute PCM frame.
/// @param handle Open native MP3 decoder.
/// @param frame Zero-based source frame.
/// @returns One on success, otherwise zero.
extern function mpAudioMp3Seek(handle as ptr, frame as u64) from "minipixels_audio.dll" returns i32
/// Releases an MP3 decoder handle.
/// @param handle Open native MP3 decoder.
extern function mpAudioMp3Close(handle as ptr) from "minipixels_audio.dll" returns void
/// Clears reusable double-precision PCM accumulation storage.
extern function mpAudioMixClear(destination as bytes, size as u64) from "minipixels_audio.dll" returns void
/// Accumulates a bounded PCM segment and returns its advanced source cursor.
/// Result is an eight-byte output containing the number of destination frames.
extern function mpAudioMixPcm(destination as bytes, mixBytes as u64, outputFrame as u64, source as bytes, sourceBytes as u64, sourceStart as u64, sourceFrames as u64, channels as i32, bits as i32, blockAlign as i32, cursor as double, step as double, leftGain as double, rightGain as double, result as bytes) from "minipixels_audio.dll" returns double
/// Floors, clips and writes a complete stereo signed-16 output buffer.
extern function mpAudioMixFinish(source as bytes, sourceBytes as u64, destination as bytes, destinationBytes as u64, frames as u64) from "minipixels_audio.dll" returns i32
/// Optional smooth peak limiter; ordinary levels remain bit-identical.
extern function mpAudioMixFinishLimited(source as bytes, sourceBytes as u64, destination as bytes, destinationBytes as u64, frames as u64) from "minipixels_audio.dll" returns i32
/// Independent PCM output owns copied samples; worker threads never touch managed data.
extern function mpAudioOutputCreate(rate as u32, voices as u32) from "minipixels_audio.dll" returns ptr
extern function mpAudioOutputAddClip(handle as ptr, data as bytes, size as u64, frames as u64, rate as u32, channels as u32, bits as u32, align as u32) from "minipixels_audio.dll" returns u32
extern function mpAudioOutputSync(handle as ptr, commands as bytes, commandBytes as u64, states as bytes, stateBytes as u64) from "minipixels_audio.dll" returns i32
extern function mpAudioOutputStart(handle as ptr, mode as u32) from "minipixels_audio.dll" returns i32
extern function mpAudioOutputStats(handle as ptr, output as bytes, size as u64) from "minipixels_audio.dll" returns i32
extern function mpAudioOutputRender(handle as ptr, output as bytes, size as u64, frames as u32) from "minipixels_audio.dll" returns i32
extern function mpAudioOutputClose(handle as ptr) from "minipixels_audio.dll" returns void

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
#else
/// Opens an in-memory MP3 decoder retained by the native audio bridge.
extern function mpAudioMp3Open(data as bytes, size as u64) from "$ORIGIN/libminipixels_audio.so" returns ptr
extern function mpAudioMp3Channels(handle as ptr) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioMp3SampleRate(handle as ptr) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioMp3FrameCount(handle as ptr) from "$ORIGIN/libminipixels_audio.so" returns u64
extern function mpAudioMp3Read(handle as ptr, output as bytes, frames as u64) from "$ORIGIN/libminipixels_audio.so" returns u64
extern function mpAudioMp3Seek(handle as ptr, frame as u64) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioMp3Close(handle as ptr) from "$ORIGIN/libminipixels_audio.so" returns void
/// Clears reusable double-precision PCM accumulation storage.
extern function mpAudioMixClear(destination as bytes, size as u64) from "$ORIGIN/libminipixels_audio.so" returns void
/// Accumulates a bounded PCM segment and returns its advanced source cursor.
/// Result is an eight-byte output containing the number of destination frames.
extern function mpAudioMixPcm(destination as bytes, mixBytes as u64, outputFrame as u64, source as bytes, sourceBytes as u64, sourceStart as u64, sourceFrames as u64, channels as i32, bits as i32, blockAlign as i32, cursor as double, step as double, leftGain as double, rightGain as double, result as bytes) from "$ORIGIN/libminipixels_audio.so" returns double
/// Floors, clips and writes a complete stereo signed-16 output buffer.
extern function mpAudioMixFinish(source as bytes, sourceBytes as u64, destination as bytes, destinationBytes as u64, frames as u64) from "$ORIGIN/libminipixels_audio.so" returns i32
/// Optional smooth peak limiter; ordinary levels remain bit-identical.
extern function mpAudioMixFinishLimited(source as bytes, sourceBytes as u64, destination as bytes, destinationBytes as u64, frames as u64) from "$ORIGIN/libminipixels_audio.so" returns i32
/// Independent PCM output owns copied samples; worker threads never touch managed data.
extern function mpAudioOutputCreate(rate as u32, voices as u32) from "$ORIGIN/libminipixels_audio.so" returns ptr
extern function mpAudioOutputAddClip(handle as ptr, data as bytes, size as u64, frames as u64, rate as u32, channels as u32, bits as u32, align as u32) from "$ORIGIN/libminipixels_audio.so" returns u32
extern function mpAudioOutputSync(handle as ptr, commands as bytes, commandBytes as u64, states as bytes, stateBytes as u64) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioOutputStart(handle as ptr, mode as u32) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioOutputStats(handle as ptr, output as bytes, size as u64) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioOutputRender(handle as ptr, output as bytes, size as u64, frames as u32) from "$ORIGIN/libminipixels_audio.so" returns i32
extern function mpAudioOutputClose(handle as ptr) from "$ORIGIN/libminipixels_audio.so" returns void

/// Opens an ALSA PCM stream.
extern function snd_pcm_open(handle as bytes, name as cstr, stream as int, mode as int) from "libasound.so.2" returns i32
/// Configures a simple interleaved PCM stream.
extern function snd_pcm_set_params(handle as ptr, format as int, access as int, channels as u32, rate as u32, softResample as int, latencyUs as u32) from "libasound.so.2" returns i32
/// Returns the number of sample frames currently accepted by the stream.
extern function snd_pcm_avail_update(handle as ptr) from "libasound.so.2" returns i64
/// Writes interleaved sample frames without blocking.
extern function snd_pcm_writei(handle as ptr, data as ptr, frames as u64) from "libasound.so.2" returns i64
/// Recovers from underruns and suspended streams.
extern function snd_pcm_recover(handle as ptr, code as int, silent as int) from "libasound.so.2" returns i32
/// Stops the current PCM stream immediately.
extern function snd_pcm_drop(handle as ptr) from "libasound.so.2" returns i32
/// Prepares a stopped PCM stream for more output.
extern function snd_pcm_prepare(handle as ptr) from "libasound.so.2" returns i32
/// Closes an ALSA PCM stream.
extern function snd_pcm_close(handle as ptr) from "libasound.so.2" returns i32
#endif

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
/// ALSA playback stream selector.
const SND_PCM_STREAM_PLAYBACK = 0
/// ALSA non-blocking open flag.
const SND_PCM_NONBLOCK = 1
/// ALSA signed 16-bit little-endian sample format.
const SND_PCM_FORMAT_S16_LE = 2
/// ALSA read/write interleaved access mode.
const SND_PCM_ACCESS_RW_INTERLEAVED = 3
/// Default mixer sample rate.
const MIXER_SAMPLE_RATE = 44100
/// Number of stereo frames in one queued mixer buffer.
const MIXER_BUFFER_FRAMES = 1024
/// Number of buffers retained in the output queue.
const MIXER_BUFFER_COUNT = 3
/// Number of decoded source frames retained by one streaming MP3 voice.
const MP3_STREAM_FRAMES = 4096
/// Safety limit for complete sound-effect decoding.
const MAX_DECODED_AUDIO_BYTES = 536870912

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

/// Represents a WAV or MP3 clip and its lazily prepared payload.
struct AudioClip
  /// Optional source path.
  path
  /// Stable clip name.
  name
  /// Clip volume percentage.
  volume
  /// Whether playback loops after the final frame.
  looping
  /// Original WAV or MP3 file bytes, when loaded in memory.
  data
  /// Whether format preparation has been attempted.
  prepared
  /// Whether the parsed format is supported.
  valid
  /// Source format identifier.
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
  /// Normalized source codec name (`wav` or `mp3`).
  codec
  /// Whether an MP3 should be decoded incrementally while playing.
  streaming

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
  /// Native MP3 decoder handle, or zero for memory PCM.
  decoder
  /// Reusable interleaved signed-16 streaming buffer.
  streamData
  /// Absolute source frame represented by the first buffered frame.
  streamStart
  /// Number of valid source frames in the streaming buffer.
  streamFrames
  /// Explicit start identity; equal clips can be retriggered on a reused channel.
  generation
end struct

/// Represents a software PCM mixer backed by WinMM waveOut or ALSA.
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
  /// Native waveOut or ALSA PCM handle.
  handle
  /// Native handle output storage.
  handleStorage
  /// Native PCM WAVEFORMATEX storage used on Windows.
  format
  /// Retained output byte buffers.
  buffers
  /// Retained native WAVEHDR structures used on Windows.
  headers
  /// Stereo sample frames per buffer.
  bufferFrames
  /// Number of queued buffers.
  bufferCount
  /// Legacy left-channel scratch array, retained for source compatibility.
  mixLeft
  /// Legacy right-channel scratch array, retained for source compatibility.
  mixRight
  /// Whether the native PCM backend is open.
  ready
  /// Last native audio error code.
  lastError
  /// Unwritten ALSA frames retained after a partial/non-blocking write.
  pendingFrames
  /// First unwritten frame in the retained ALSA buffer.
  pendingOffset
  /// Reusable interleaved float64 accumulator, owned by the managed mixer.
  nativeMix
  /// Reusable native result storage; never retained by the native bridge.
  mixResult
  /// Dedicated additional music voices, independent of sound-effect stealing.
  musicLayers
  /// Opt-in independently serviced PCM backend (Windows; software mixing unchanged).
  independentOutput
  nativeOutput
  nativeClips
  nativeClipCount
  nativeCommands
  nativeStates
  nativeStats
  /// Optional smooth peak limiting for dense effect mixtures; off by default.
  softLimit

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
  /// @param clip WAV or MP3 clip.
  function playSfx(clip)
    return minipixels.audio.audio.mixerPlaySfx(this, clip)
  end function
  /// Starts or replaces the dedicated music voice.
  /// @param clip WAV or MP3 clip.
  function playMusic(clip)
    return minipixels.audio.audio.mixerPlayMusic(this, clip)
  end function
  /// Queues an additional music voice without opening an output device.
  /// @param id Layer index from 0 through 7.
  /// @param clip Prepared or lazy audio clip.
  /// @param volume Voice volume percentage.
  /// @param pan Stereo pan percentage.
  /// @param cursor Initial source-frame cursor for phase alignment.
  function queueMusicLayer(id, clip, volume, pan, cursor)
    return minipixels.audio.audio.queueMusicLayer(this, id, clip, volume, pan, cursor)
  end function
  /// Stops and releases one additional music layer.
  /// @param id Layer index from 0 through 7.
  function stopMusicLayer(id)
    return minipixels.audio.audio.stopMusicLayer(this, id)
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
/// @param path WAV or MP3 file path.
/// @param name Stable clip name.
function clip(path, name)
  if typeof(path) != "string" then path = "" end if
  if typeof(name) != "string" then name = path end if
  return AudioClip(path, name, 100, false, void, false, false, 0, 0, 0, 0, 0, void, 0, "", false)
end function

/// Creates an in-memory WAV or MP3 audio clip.
/// @param data Complete WAV or MP3 file bytes.
/// @param name Stable clip name.
function clipFromBytes(data, name)
  if typeof(name) != "string" then name = "memory" end if
  if typeof(data) != "bytes" then data = void end if
  return AudioClip("", name, 100, false, data, false, false, 0, 0, 0, 0, 0, void, 0, "", false)
end function

/// Creates a looping file-backed music clip. MP3 data streams while playing.
/// @param path WAV or MP3 file path.
/// @param name Stable clip name.
function musicClip(path, name)
  value = clip(path, name)
  value.looping = true
  value.streaming = true
  return value
end function

/// Creates a looping in-memory music clip. MP3 data streams while playing.
/// @param data Complete WAV or MP3 file bytes.
/// @param name Stable clip name.
function musicClipFromBytes(data, name)
  value = clipFromBytes(data, name)
  value.looping = true
  value.streaming = true
  return value
end function

/// Creates an inactive mixer channel.
/// @param id Stable channel identifier.
function channel(id)
  return AudioChannel(id, void, false, 100, 0, 0.0, 0, void, 0, 0, 0)
end function

/// Creates a lazily opened multi-voice PCM mixer.
/// @param maxChannels Maximum simultaneous sound-effect voices.
function mixer(maxChannels)
  if typeof(maxChannels) != "int" or maxChannels <= 0 then maxChannels = 8 end if
  channels = array(maxChannels)
  for index = 0 to maxChannels - 1
    channels[index] = channel(index)
  end for
  layers = array(8)
  for index = 0 to len(layers) - 1
    layers[index] = channel(-2 - index)
  end for
  frames = MIXER_BUFFER_FRAMES
  return AudioMixer(
    create(), channels, maxChannels, 0, void, channel(-1), MIXER_SAMPLE_RATE,
    0, bytes(8, 0), bytes(18, 0), array(MIXER_BUFFER_COUNT), array(MIXER_BUFFER_COUNT),
    frames, MIXER_BUFFER_COUNT, array(frames, 0), array(frames, 0), false, 0, 0, 0, bytes(frames * 16, 0), bytes(8, 0), layers, false, 0, array(128), 0, bytes((maxChannels + 9) * 40, 0), bytes((maxChannels + 9) * 16, 0), bytes(24, 0), false
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
#if TARGET_OS == "windows"
  return "waveout-pcm"
#else
  return "alsa-pcm"
#endif
end function

/// Returns whether the mixer supports simultaneous sound effects.
function supportsMultipleSfx()
  return true
end function

/// Returns whether the mixer applies per-bus, per-channel, and per-clip volume.
function supportsVolumeControl()
  return true
end function

/// Returns whether the advanced mixer can decode MP3 clips.
function supportsMp3()
  return true
end function

/// Returns whether independent left/right source channels are preserved.
function supportsStereo()
  return true
end function

/// Plays one WAV file through the legacy operating-system helper.
/// @param path WAV file path.
function playSound(path)
  if typeof(path) != "string" then return false end if
#if TARGET_OS == "windows"
  return PlaySoundW(path, 0, SND_ASYNC | SND_FILENAME | SND_NODEFAULT)
#else
  return false
#endif
end function

/// Plays one WAV file synchronously through the legacy helper.
/// @param path WAV file path.
function playSoundSync(path)
  if typeof(path) != "string" then return false end if
#if TARGET_OS == "windows"
  return PlaySoundW(path, 0, SND_SYNC | SND_FILENAME | SND_NODEFAULT)
#else
  return false
#endif
end function

/// Plays one looping WAV file through the legacy helper.
/// @param path WAV file path.
function playSoundLoop(path)
  if typeof(path) != "string" then return false end if
#if TARGET_OS == "windows"
  return PlaySoundW(path, 0, SND_ASYNC | SND_LOOP | SND_FILENAME | SND_NODEFAULT)
#else
  return false
#endif
end function

/// Plays WAV file bytes through the legacy helper.
/// @param data Complete WAV file bytes.
function playSoundBytes(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return false end if
#if TARGET_OS == "windows"
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_ASYNC | SND_MEMORY | SND_NODEFAULT)
#else
  return false
#endif
end function

/// Plays WAV file bytes synchronously through the legacy helper.
/// @param data Complete WAV file bytes.
function playSoundBytesSync(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return false end if
#if TARGET_OS == "windows"
  return PlaySoundMemory(nativeBytesPtr(data), 0, SND_SYNC | SND_MEMORY | SND_NODEFAULT)
#else
  return false
#endif
end function

/// Stops legacy direct playback.
function stopSound()
#if TARGET_OS == "windows"
  return PlaySoundW("", 0, SND_PURGE)
#else
  return false
#endif
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

/// Returns whether bytes begin with an ID3 tag or MPEG audio frame sync.
/// @param data Complete candidate audio bytes.
function isMp3(data)
  if not hasRange(data, 0, 2) then return false end if
  if hasRange(data, 0, 3) and data[0] == 73 and data[1] == 68 and data[2] == 51 then return true end if
  return data[0] == 255 and (data[1] & 224) == 224
end function

/// Reads source metadata from the native MP3 decoder and optionally decodes all PCM.
/// @param value Audio clip to prepare.
/// @param data Complete MP3 file bytes.
function prepareMp3(value, data)
  decoder = mpAudioMp3Open(data, len(data))
  if decoder == 0 then return false end if
  value.channels = mpAudioMp3Channels(decoder)
  value.sampleRate = mpAudioMp3SampleRate(decoder)
  value.frameCount = mpAudioMp3FrameCount(decoder)
  value.formatTag = 85
  value.bitsPerSample = 16
  value.blockAlign = value.channels * 2
  value.codec = "mp3"
  if value.channels < 1 or value.channels > 2 or value.sampleRate <= 0 or value.frameCount <= 0 then
    mpAudioMp3Close(decoder)
    return false
  end if
  if value.streaming then
    mpAudioMp3Close(decoder)
    value.valid = true
    return true
  end if
  decodedBytes = value.frameCount * value.blockAlign
  if decodedBytes <= 0 or decodedBytes > MAX_DECODED_AUDIO_BYTES then
    mpAudioMp3Close(decoder)
    return false
  end if
  value.sampleData = bytes(decodedBytes, 0)
  frames = mpAudioMp3Read(decoder, value.sampleData, value.frameCount)
  mpAudioMp3Close(decoder)
  if frames <= 0 then
    value.sampleData = void
    return false
  end if
  value.frameCount = frames
  if frames * value.blockAlign < len(value.sampleData) then value.sampleData = slice(value.sampleData, 0, frames * value.blockAlign) end if
  value.valid = true
  return true
end function

/// Parses an uncompressed PCM WAV payload.
/// @param value Audio clip to prepare.
/// @param data Complete WAV file bytes.
function prepareWav(value, data)
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
  value.codec = "wav"
  value.valid = value.frameCount > 0
  return value.valid
end function

/// Loads and prepares a WAV or MP3 clip on first use.
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
  if isMp3(data) then return prepareMp3(value, data) end if
  return prepareWav(value, data)
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

/// Releases the decoder and buffered data owned by one mixer voice.
/// @param voice Voice to reset.
function closeVoiceDecoder(voice)
  if voice.decoder != 0 then mpAudioMp3Close(voice.decoder) end if
  voice.decoder = 0
  voice.streamData = void
  voice.streamStart = 0
  voice.streamFrames = 0
  return voice
end function

/// Opens an independent streaming decoder for one MP3 voice.
/// @param voice Destination voice.
function openVoiceDecoder(voice)
  voice = closeVoiceDecoder(voice)
  source = voice.clip
  if source is not AudioClip or source.codec != "mp3" or not source.streaming then return voice end if
  voice.decoder = mpAudioMp3Open(source.data, len(source.data))
  if voice.decoder == 0 then
    voice.playing = false
    return voice
  end if
  voice.streamData = bytes(MP3_STREAM_FRAMES * source.blockAlign, 0)
  return voice
end function

/// Refills a streaming voice so it contains the requested source frame.
/// @param voice Streaming voice to advance.
/// @param sourceFrame Absolute source frame needed by the mixer.
function refillVoiceStream(voice, sourceFrame)
  source = voice.clip
  // Silent voices advance without decoding. Seek once when they become audible.
  if voice.streamFrames < 0 then
    if mpAudioMp3Seek(voice.decoder, sourceFrame) == 0 then voice.playing = false return voice end if
    voice.streamStart = sourceFrame
    voice.streamFrames = 0
  end if
  while voice.playing and (voice.streamFrames <= 0 or sourceFrame < voice.streamStart or sourceFrame >= voice.streamStart + voice.streamFrames)
    if voice.streamFrames > 0 then voice.streamStart = voice.streamStart + voice.streamFrames end if
    voice.streamFrames = mpAudioMp3Read(voice.decoder, voice.streamData, MP3_STREAM_FRAMES)
    if voice.streamFrames <= 0 then
      if source.looping and mpAudioMp3Seek(voice.decoder, 0) != 0 then
        voice.cursor = voice.cursor % source.frameCount
        sourceFrame = mt.floorInt(voice.cursor)
        voice.streamStart = 0
        voice.streamFrames = mpAudioMp3Read(voice.decoder, voice.streamData, MP3_STREAM_FRAMES)
      else
        voice.playing = false
      end if
    end if
    if voice.streamFrames <= 0 then voice.playing = false end if
  end while
  return voice
end function

/// Reads one signed-16 sample from a streaming MP3 buffer.
/// @param voice Prepared streaming voice.
/// @param sourceFrame Absolute source frame.
/// @param side Destination side, zero for left and one for right.
function streamSampleAt(voice, sourceFrame, side)
  sourceChannel = side
  if voice.clip.channels == 1 then sourceChannel = 0 end if
  offset = ((sourceFrame - voice.streamStart) * voice.clip.blockAlign) + (sourceChannel * 2)
  sample = voice.streamData[offset] + (voice.streamData[offset + 1] << 8)
  if sample >= 32768 then sample = sample - 65536 end if
  return sample
end function

/// Accumulates one voice in bounded native batches, retaining language-owned state.
/// Sample decoding, gain multiplication and cursor steps keep their original order.
/// Silent voices still reach clip endings and loop boundaries without reading PCM.
/// @param value Destination mixer with reusable native accumulation storage.
/// @param voice Voice to advance.
/// @param busVolume Bus volume percentage.
function mixVoice(value, voice, busVolume)
  if voice.playing == false or voice.clip is not AudioClip then return voice end if
  source = voice.clip
  if source.frameCount <= 0 or source.sampleRate <= 0 or value.sampleRate <= 0 then
    voice.playing = false
    return closeVoiceDecoder(voice)
  end if
  // Normalize the public percentages before multiplication. Normalizing their
  // fractional product would incorrectly replace e.g. 33% * 20% with 100%.
  gain = (effectiveVolume(value.audio, busVolume) * normalizeVolume(voice.volume) * normalizeVolume(source.volume)) / 10000
  pan = normalizePan(voice.pan)
  leftGain = gain
  rightGain = gain
  if pan < 0 then rightGain = (rightGain * (100 + pan)) / 100 end if
  if pan > 0 then leftGain = (leftGain * (100 - pan)) / 100 end if
  silent = leftGain == 0 and rightGain == 0
  step = source.sampleRate / value.sampleRate
  frame = 0
  while frame < value.bufferFrames and voice.playing
    sourceFrame = mt.floorInt(voice.cursor)
    if sourceFrame >= source.frameCount then
      if source.looping then
        voice.cursor = voice.cursor % source.frameCount
        sourceFrame = mt.floorInt(voice.cursor)
        if voice.decoder != 0 then voice.streamFrames = -1 end if
      else
        voice.playing = false
        break
      end if
    end if
    data = source.sampleData
    start = 0
    count = source.frameCount
    bits = source.bitsPerSample
    if silent then
      // The native kernel skips all sample reads for zero gain. A small retained
      // buffer supplies a valid ABI pointer even for a streaming MP3 source.
      data = value.mixResult
      if voice.decoder != 0 then voice.streamFrames = -1 end if
    else if voice.decoder != 0 then
      voice = refillVoiceStream(voice, sourceFrame)
      if not voice.playing then break end if
      data = voice.streamData
      start = voice.streamStart
      count = voice.streamFrames
      if count > source.frameCount - start then count = source.frameCount - start end if
      bits = 16
    end if
    voice.cursor = mpAudioMixPcm(value.nativeMix, len(value.nativeMix), frame, data, len(data), start, count, source.channels, bits, source.blockAlign, voice.cursor, step, leftGain, rightGain, value.mixResult)
    mixed = getU32(value.mixResult, 0)
    if mixed <= 0 then voice.playing = false break end if
    frame = frame + mixed
  end while
  if not voice.playing then voice = closeVoiceDecoder(voice) end if
  return voice
end function

/// Mixes active voices into one interleaved stereo 16-bit output buffer.
/// Native storage grows only when the configured buffer size changes.
/// @param value Source mixer.
/// @param output Destination interleaved PCM buffer.
function mixBuffer(value, output)
  required = value.bufferFrames * 16
  if len(value.nativeMix) != required then value.nativeMix = bytes(required, 0) end if
  mpAudioMixClear(value.nativeMix, len(value.nativeMix))
  for index = 0 to value.channelCount - 1
    voice = value.channels[index]
    if voice.playing then value.channels[index] = mixVoice(value, voice, value.audio.sfxVolume) end if
  end for
  if value.musicChannel.playing then
    value.musicChannel = mixVoice(value, value.musicChannel, value.audio.musicVolume)
    if value.musicChannel.playing == false then value.music = void end if
  end if
  for index = 0 to len(value.musicLayers) - 1
    voice = value.musicLayers[index]
    if voice.playing then value.musicLayers[index] = mixVoice(value, voice, value.audio.musicVolume) end if
  end for
  if value.softLimit then
    mpAudioMixFinishLimited(value.nativeMix, len(value.nativeMix), output, len(output), value.bufferFrames)
  else
    mpAudioMixFinish(value.nativeMix, len(value.nativeMix), output, len(output), value.bufferFrames)
  end if
  return output
end function

/// Queues an additional music-bus voice without opening a playback device.
/// This software operation works for both offline mixing and an already-open
/// live mixer. Call ensureBackend once after queueing a complete live ensemble.
/// Muted/zero-volume layers still advance; sound effects cannot steal them.
/// @param value Destination mixer.
/// @param id Layer index from 0 through 7.
/// @param source Prepared or lazy audio clip; looping is retained.
/// @param volume Voice volume percentage.
/// @param pan Stereo pan percentage.
/// @param cursor Initial source-frame cursor, normalized to the clip length.
function queueMusicLayer(value, id, source, volume = 100, pan = 0, cursor = 0.0)
  if value is not AudioMixer then return false end if
  if typeof(id) != "int" or id < 0 or id >= len(value.musicLayers) then return false end if
  if source is not AudioClip then return false end if
  if typeof(cursor) != "int" and typeof(cursor) != "float" then return false end if
  if cursor < 0 or cursor > 9007199254740991 or cursor != cursor then return false end if
  if not prepareClip(source) or source.frameCount <= 0 then return false end if
  voice = closeVoiceDecoder(value.musicLayers[id])
  voice.clip = source
  voice.playing = true
  voice.volume = normalizeVolume(volume)
  voice.pan = normalizePan(pan)
  voice.cursor = cursor % source.frameCount
  voice.generation = voice.generation + 1
  voice = openVoiceDecoder(voice)
  // An MP3 layer may start at a nonzero ensemble cursor. Request its own seek
  // before the first audible decode rather than reusing another voice state.
  if voice.decoder != 0 and voice.cursor > 0 then voice.streamFrames = -1 end if
  value.musicLayers[id] = voice
  return voice.playing
end function

/// Stops and releases one dedicated music layer without affecting other buses.
/// @param value Mixer whose layer is stopped.
/// @param id Layer index from 0 through 7.
function stopMusicLayer(value, id)
  if value is not AudioMixer then return false end if
  if typeof(id) != "int" or id < 0 or id >= len(value.musicLayers) then return false end if
  voice = closeVoiceDecoder(value.musicLayers[id])
  voice.playing = false
  voice.clip = void
  voice.cursor = 0.0
  value.musicLayers[id] = voice
  return true
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

/// Opts a still-closed PCM mixer into independently serviced Windows output.
/// WAV PCM clips are copied once into native ownership. Streaming MP3 clients
/// retain the default software/backend path; this choice is explicit.
function enableIndependentOutput(value)
  if value is not AudioMixer or value.ready or value.channelCount > 247 then return false end if
#if TARGET_OS == "windows"
  value.independentOutput = true
  return true
#else
  return false
#endif
end function

function independentVoice(value, index)
  if index < value.channelCount then return value.channels[index] end if
  if index == value.channelCount then return value.musicChannel end if
  return value.musicLayers[index - value.channelCount - 1]
end function

function setIndependentVoice(value, index, voice)
  if index < value.channelCount then
    value.channels[index] = voice
  else if index == value.channelCount then
    value.musicChannel = voice
  else
    value.musicLayers[index - value.channelCount - 1] = voice
  end if
end function

/// The registry retains managed source objects for stable identity, while the
/// worker exclusively reads its own copy. Uploads never hold its rendering lock.
function independentClip(value, source)
  if source is not AudioClip or not prepareClip(source) then return 0 end if
  if typeof(source.sampleData) != "bytes" then return 0 end if
  pointer = nativeBytesPtr(source.sampleData)
  index = 0
  while index < value.nativeClipCount
    clip = value.nativeClips[index]
    if nativeBytesPtr(clip.sampleData) == pointer then return index + 1 end if
    index = index + 1
  end while
  if value.nativeClipCount >= len(value.nativeClips) then return 0 end if
  id = mpAudioOutputAddClip(value.nativeOutput, source.sampleData, len(source.sampleData), source.frameCount, source.sampleRate, source.channels, source.bitsPerSample, source.blockAlign)
  if id != value.nativeClipCount + 1 then return 0 end if
  value.nativeClips[value.nativeClipCount] = source
  value.nativeClipCount = value.nativeClipCount + 1
  return id
end function

/// Publishes a whole voice ensemble atomically, retaining native timing and
/// generation-based starts through delayed host frames and repeated snapshots.
function syncIndependentOutput(value)
  if value.nativeOutput == 0 then return false end if
  limited = 0
  if value.softLimit then limited = 1 end if
  putU32(value.nativeCommands, 32, limited)
  for index = 0 to value.channelCount + 8
    voice = independentVoice(value, index)
    offset = index * 40
    id = 0
    if voice.playing then
      id = independentClip(value, voice.clip)
      if id == 0 then value.lastError = -2 return false end if
    end if
    bus = value.audio.musicVolume
    if index < value.channelCount then bus = value.audio.sfxVolume end if
    gain = 0.0
    if id > 0 then gain = effectiveVolume(value.audio, bus) * normalizeVolume(voice.volume) * normalizeVolume(voice.clip.volume) / 1000000.0 end if
    pan = normalizePan(voice.pan)
    left = gain
    right = gain
    if pan < 0 then right = right * (100 + pan) / 100 end if
    if pan > 0 then left = left * (100 - pan) / 100 end if
    putU32(value.nativeCommands, offset, id)
    putU32(value.nativeCommands, offset + 4, voice.generation)
    playing = 0
    looping = 0
    if voice.playing then playing = 1 end if
    if voice.clip is AudioClip and voice.clip.looping then looping = 1 end if
    putU32(value.nativeCommands, offset + 8, playing)
    putU32(value.nativeCommands, offset + 12, looping)
    putU64(value.nativeCommands, offset + 16, mt.floorInt(voice.cursor))
    putU32(value.nativeCommands, offset + 24, mt.floorInt(left * 1000000.0 + 0.5))
    putU32(value.nativeCommands, offset + 28, mt.floorInt(right * 1000000.0 + 0.5))
  end for
  if mpAudioOutputSync(value.nativeOutput, value.nativeCommands, len(value.nativeCommands), value.nativeStates, len(value.nativeStates)) == 0 then
    value.lastError = -3
    return false
  end if
  for index = 0 to value.channelCount + 8
    voice = independentVoice(value, index)
    if voice.playing then
      voice.cursor = getU64(value.nativeStates, index * 16)
      voice.playing = getU32(value.nativeStates, index * 16 + 8) != 0
      setIndependentVoice(value, index, voice)
    end if
  end for
  if mpAudioOutputStats(value.nativeOutput, value.nativeStats, len(value.nativeStats)) == 0 then return false end if
  value.lastError = getU32(value.nativeStats, 12)
  return value.lastError == 0
end function

/// Opens the platform PCM device and prepares retained output buffers.
/// @param value Mixer to open.
function ensureBackend(value)
  if value.ready then
    if value.independentOutput then return syncIndependentOutput(value) end if
    return true
  end if
  if value.independentOutput then
    value.nativeOutput = mpAudioOutputCreate(value.sampleRate, value.channelCount + 9)
    if value.nativeOutput == 0 then value.lastError = -1 return false end if
    if not syncIndependentOutput(value) then
      mpAudioOutputClose(value.nativeOutput)
      value.nativeOutput = 0
      value.nativeClipCount = 0
      value.nativeClips = array(128)
      return false
    end if
    if mpAudioOutputStart(value.nativeOutput, 1) == 0 then
      mpAudioOutputStats(value.nativeOutput, value.nativeStats, len(value.nativeStats))
      value.lastError = getU32(value.nativeStats, 12)
      if value.lastError == 0 then value.lastError = -4 end if
      mpAudioOutputClose(value.nativeOutput)
      value.nativeOutput = 0
      value.nativeClipCount = 0
      value.nativeClips = array(128)
      return false
    end if
    value.ready = true
    return true
  end if
#if TARGET_OS == "windows"
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
#else
  result = snd_pcm_open(value.handleStorage, "default", SND_PCM_STREAM_PLAYBACK, SND_PCM_NONBLOCK)
  if result < 0 then
    value.lastError = result
    return false
  end if
  value.handle = getU64(value.handleStorage, 0)
  result = snd_pcm_set_params(value.handle, SND_PCM_FORMAT_S16_LE, SND_PCM_ACCESS_RW_INTERLEAVED, 2, value.sampleRate, 1, 50000)
  if result < 0 then
    value.lastError = result
    snd_pcm_close(value.handle)
    value.handle = 0
    return false
  end if
  value.buffers[0] = bytes(value.bufferFrames * 4, 0)
#endif
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
  voice = closeVoiceDecoder(value.channels[index])
  voice.clip = source
  voice.playing = true
  voice.volume = 100
  voice.pan = 0
  voice.cursor = 0.0
  voice.generation = voice.generation + 1
  voice = openVoiceDecoder(voice)
  if not voice.playing then
    value.channels[index] = voice
    return false
  end if
  value.channels[index] = voice
  if ensureBackend(value) == false then
    voice = closeVoiceDecoder(voice)
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
  source.streaming = true
  if prepareClip(source) == false then return false end if
  source.looping = true
  voice = closeVoiceDecoder(value.musicChannel)
  voice.clip = source
  voice.playing = true
  voice.volume = 100
  voice.pan = 0
  voice.cursor = 0.0
  voice.generation = voice.generation + 1
  voice = openVoiceDecoder(voice)
  if not voice.playing then
    value.musicChannel = voice
    value.music = void
    return false
  end if
  value.musicChannel = voice
  value.music = source
  if ensureBackend(value) == false then
    voice = closeVoiceDecoder(voice)
    voice.playing = false
    value.musicChannel = voice
    value.music = void
    return false
  end if
  return true
end function

/// Refills completed Windows headers or an available ALSA period.
/// @param value Mixer to update.
function updateMixer(value)
  if value is not AudioMixer or value.ready == false then return false end if
  if value.independentOutput then return syncIndependentOutput(value) end if
#if TARGET_OS == "windows"
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
#else
  available = snd_pcm_avail_update(value.handle)
  if available < 0 then
    result = snd_pcm_recover(value.handle, available, 1)
    if result < 0 then
      value.lastError = result
      return false
    end if
    available = snd_pcm_avail_update(value.handle)
  end if
  wrote = false
  // Fill the device's available capacity, but bound work per game frame.
  // Three periods cover the configured 50 ms queue, including 30 FPS games.
  attempts = 0
  while available > 0 and attempts < value.bufferCount * 2
    if value.pendingFrames == 0 then
      if available < value.bufferFrames then break end if
      mixBuffer(value, value.buffers[0])
      value.pendingFrames = value.bufferFrames
      value.pendingOffset = 0
    end if
    count = value.pendingFrames
    if count > available then count = available end if
    pointer = nativeBytesPtr(value.buffers[0]) + value.pendingOffset * 4
    written = snd_pcm_writei(value.handle, pointer, count)
    attempts = attempts + 1
    if written == 0 or written == -11 then break end if
    if written < 0 then
      result = snd_pcm_recover(value.handle, written, 1)
      if result < 0 then value.lastError = result end if
      // Keep the unsent PCM; recovery/EAGAIN must not advance voices again.
      break
    end if
    value.pendingFrames = value.pendingFrames - written
    value.pendingOffset = value.pendingOffset + written
    available = available - written
    wrote = true
  end while
  return wrote
#endif
end function

/// Applies a volume or mute change to subsequently mixed buffers.
/// @param value Mixer to refresh.
function refreshMixer(value)
  if value is AudioMixer and value.ready and value.independentOutput then return syncIndependentOutput(value) end if
  return value is AudioMixer
end function

/// Stops every mixer voice and replaces queued output with silence.
/// @param value Mixer to stop.
function mixerStopAll(value)
  value.pendingFrames = 0
  value.pendingOffset = 0
  for index = 0 to value.channelCount - 1
    voice = closeVoiceDecoder(value.channels[index])
    voice.playing = false
    voice.clip = void
    voice.cursor = 0.0
    value.channels[index] = voice
  end for
  value.musicChannel = closeVoiceDecoder(value.musicChannel)
  value.musicChannel.playing = false
  value.musicChannel.clip = void
  value.musicChannel.cursor = 0.0
  value.music = void
  for index = 0 to len(value.musicLayers) - 1
    stopMusicLayer(value, index)
  end for
  if value.ready then
    if value.independentOutput then return syncIndependentOutput(value) end if
#if TARGET_OS == "windows"
    waveOutReset(value.handle)
    updateMixer(value)
#else
    snd_pcm_drop(value.handle)
    snd_pcm_prepare(value.handle)
#endif
  end if
  return true
end function

/// Stops one sound-effect channel.
/// @param value Mixer owning the channel.
/// @param id Zero-based channel identifier.
function stopChannel(value, id)
  if typeof(id) != "int" or id < 0 or id >= value.channelCount then return false end if
  voice = closeVoiceDecoder(value.channels[id])
  voice.playing = false
  voice.clip = void
  value.channels[id] = voice
  if value.ready and value.independentOutput then return syncIndependentOutput(value) end if
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

/// Releases retained buffers and closes the native PCM output device.
/// @param value Mixer to close.
function closeMixer(value)
  if value is not AudioMixer then return true end if
  if value.nativeOutput != 0 then
    mpAudioOutputClose(value.nativeOutput)
    value.nativeOutput = 0
    value.nativeClipCount = 0
    value.nativeClips = array(128)
  end if
  value.pendingFrames = 0
  value.pendingOffset = 0
  for index = 0 to value.channelCount - 1
    value.channels[index] = closeVoiceDecoder(value.channels[index])
    value.channels[index].playing = false
  end for
  value.musicChannel = closeVoiceDecoder(value.musicChannel)
  value.musicChannel.playing = false
  value.music = void
  for index = 0 to len(value.musicLayers) - 1
    stopMusicLayer(value, index)
  end for
  if value.handle == 0 then
    value.ready = false
    return true
  end if
#if TARGET_OS == "windows"
  waveOutReset(value.handle)
  for index = 0 to value.bufferCount - 1
    header = value.headers[index]
    if typeof(header) == "bytes" then waveOutUnprepareHeader(value.handle, header, WAVEHDR_SIZE) end if
  end for
  result = waveOutClose(value.handle)
#else
  snd_pcm_drop(value.handle)
  result = snd_pcm_close(value.handle)
#endif
  value.handle = 0
  value.ready = false
#if TARGET_OS == "windows"
  if result != MMSYSERR_NOERROR then
#else
  if result < 0 then
#endif
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
