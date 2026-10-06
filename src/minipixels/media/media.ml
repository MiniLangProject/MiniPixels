// SPDX-License-Identifier: Apache-2.0

//! Streams file-backed MPX audio and video through std.audio/std.video.

package minipixels.media.media

import minipixels.assets.pack as packs
import std.audio as nativeAudio
import std.video as nativeVideo

const MEDIA_ERR = 9310

#if TARGET_OS == "windows"
/// Opens a native loopback source for one MPX media range.
/// @internal
/// @param path MPX file path.
/// @param offset Stored payload offset.
/// @param storedSize Stored payload size.
/// @param logicalSize Plain media size.
/// @param codec MPX payload codec.
/// @param key AES key for protected media.
/// @param keySize AES key size.
/// @param nonce Base nonce for protected media.
/// @param nonceSize Base nonce size.
/// @param hashes Ciphertext SHA-256 digests from the verified signed index.
/// @param hashesSize Size of the digest table in bytes.
/// @param mime HTTP response content type.
/// @param suffix Decoder filename suffix.
/// @param urlOutput Destination buffer for the loopback URL.
/// @param urlCapacity Destination buffer capacity.
/// @returns Opaque native source handle, or zero on failure.
extern function _streamOpen(path as cstr, offset as u64, storedSize as u64, logicalSize as u64, codec as int, key as bytes, keySize as u64, nonce as bytes, nonceSize as u64, hashes as bytes, hashesSize as u64, mime as cstr, suffix as cstr, urlOutput as bytes, urlCapacity as int) from "minipixels_audio.dll" symbol "mpMediaStreamOpenV6" returns ptr
/// Closes a native loopback media source.
/// @internal
/// @param handle Native source handle.
extern function _streamClose(handle as ptr) from "minipixels_audio.dll" symbol "mpMediaStreamClose" returns void
#else
/// Opens a native loopback source for one MPX media range.
/// @internal
/// @param path MPX file path.
/// @param offset Stored payload offset.
/// @param storedSize Stored payload size.
/// @param logicalSize Plain media size.
/// @param codec MPX payload codec.
/// @param key AES key for protected media.
/// @param keySize AES key size.
/// @param nonce Base nonce for protected media.
/// @param nonceSize Base nonce size.
/// @param hashes Ciphertext SHA-256 digests from the verified signed index.
/// @param hashesSize Size of the digest table in bytes.
/// @param mime HTTP response content type.
/// @param suffix Decoder filename suffix.
/// @param urlOutput Destination buffer for the loopback URL.
/// @param urlCapacity Destination buffer capacity.
/// @returns Opaque native source handle, or zero on failure.
extern function _streamOpen(path as cstr, offset as u64, storedSize as u64, logicalSize as u64, codec as int, key as bytes, keySize as u64, nonce as bytes, nonceSize as u64, hashes as bytes, hashesSize as u64, mime as cstr, suffix as cstr, urlOutput as bytes, urlCapacity as int) from "$ORIGIN/libminipixels_audio.so" symbol "mpMediaStreamOpenV6" returns ptr
/// Closes a native loopback media source.
/// @internal
/// @param handle Native source handle.
extern function _streamClose(handle as ptr) from "$ORIGIN/libminipixels_audio.so" symbol "mpMediaStreamClose" returns void
#endif

/// Creates a media-module error.
/// @internal
/// @param message Human-readable error text.
function _error(message)
  return error(MEDIA_ERR, message)
end function

/// Native loopback range source owned by one media player.
struct PackedMediaSource
  handle
  url
  closed

  /// Closes the loopback source and releases its native resources.
  function close()
    if this.closed then return true end if
    handle = this.handle
    this.handle = 0
    this.closed = true
    _streamClose(handle)
    return true
  end function
end struct

/// Audio player whose encoded bytes remain inside its MPX file.
struct PackedAudio
  source
  player
  closed

  /// Starts or resumes playback.
  function play() return this.player.play() end function
  /// Pauses playback.
  function pause() return this.player.pause() end function
  /// Stops playback and rewinds the player.
  function stop() return this.player.stop() end function
  /// Seeks to a media timestamp.
  /// @param milliseconds Target timestamp in milliseconds.
  function seek(milliseconds) return this.player.seek(milliseconds) end function
  /// Returns the current playback timestamp.
  function position() return this.player.position() end function
  /// Returns the media duration.
  function duration() return this.player.duration() end function
  /// Returns the current player state.
  function state() return this.player.state() end function
  /// Returns whether the media exposes an audio track.
  function hasAudio() return this.player.hasAudio() end function
  /// Sets playback volume.
  /// @param volume Volume accepted by `std.audio`.
  function setVolume(volume) return this.player.setVolume(volume) end function
  /// Enables or disables muting.
  /// @param muted True to mute playback.
  function setMuted(muted) return this.player.setMuted(muted) end function
  /// Sets the playback speed multiplier.
  /// @param rate Playback speed accepted by `std.audio`.
  function setPlaybackRate(rate) return this.player.setPlaybackRate(rate) end function
  /// Enables or disables looping.
  /// @param enabled True to loop playback.
  function setLoop(enabled) return this.player.setLoop(enabled) end function
  /// Returns the next queued media event.
  function pollEvent() return this.player.pollEvent() end function

  /// Closes the player before releasing its MPX range source.
  function close()
    if this.closed then return true end if
    result = try(this.player.close())
    this.source.close()
    this.closed = true
    if typeof(result) == "error" then return result end if
    return true
  end function
end struct

/// Video player whose encoded bytes remain inside its MPX file.
struct PackedVideo
  source
  player
  closed

  /// Attaches video output to a native window.
  /// @param windowHandle Win32 HWND or X11 window id.
  function attach(windowHandle) return this.player.attach(windowHandle) end function
  /// Starts or resumes playback.
  function play() return this.player.play() end function
  /// Pauses playback.
  function pause() return this.player.pause() end function
  /// Stops playback and rewinds the player.
  function stop() return this.player.stop() end function
  /// Seeks to a media timestamp.
  /// @param milliseconds Target timestamp in milliseconds.
  function seek(milliseconds) return this.player.seek(milliseconds) end function
  /// Returns the current playback timestamp.
  function position() return this.player.position() end function
  /// Returns the media duration.
  function duration() return this.player.duration() end function
  /// Returns the current player state.
  function state() return this.player.state() end function
  /// Returns whether the media exposes an audio track.
  function hasAudio() return this.player.hasAudio() end function
  /// Returns whether the media exposes a video track.
  function hasVideo() return this.player.hasVideo() end function
  /// Returns the decoded video width.
  function videoWidth() return this.player.videoWidth() end function
  /// Returns the decoded video height.
  function videoHeight() return this.player.videoHeight() end function
  /// Sets playback volume.
  /// @param volume Volume accepted by `std.video`.
  function setVolume(volume) return this.player.setVolume(volume) end function
  /// Enables or disables muting.
  /// @param muted True to mute playback.
  function setMuted(muted) return this.player.setMuted(muted) end function
  /// Sets the playback speed multiplier.
  /// @param rate Playback speed accepted by `std.video`.
  function setPlaybackRate(rate) return this.player.setPlaybackRate(rate) end function
  /// Enables or disables looping.
  /// @param enabled True to loop playback.
  function setLoop(enabled) return this.player.setLoop(enabled) end function
  /// Returns the next queued media event.
  function pollEvent() return this.player.pollEvent() end function

  /// Closes the player before releasing its MPX range source.
  function close()
    if this.closed then return true end if
    result = try(this.player.close())
    this.source.close()
    this.closed = true
    if typeof(result) == "error" then return result end if
    return true
  end function
end struct

/// Opens the local range source for one already-validated pack entry.
/// @internal
/// @param info File-backed stream metadata returned by the pack module.
/// @param mime HTTP content type advertised to the media backend.
/// @param suffix Filename suffix used for decoder selection.
function _openSource(info, mime, suffix)
  if typeof(info) != "struct" then return _error("invalid packed media source") end if
  if typeof(mime) != "string" or len(mime) == 0 then mime = "application/octet-stream" end if
  if typeof(suffix) != "string" or len(suffix) == 0 then suffix = ".bin" end if
  urlBuffer = bytes(192, 0)
  handle = _streamOpen(
    info.path,
    info.offset,
    info.storedSize,
    info.logicalSize,
    info.codec,
    info.key,
    len(info.key),
    info.nonce,
    len(info.nonce),
    info.hashes,
    len(info.hashes),
    mime,
    suffix,
    urlBuffer,
    len(urlBuffer))
  if handle == 0 then return _error("could not open the MPX media range stream") end if
  url = decodeZ(urlBuffer)
  if typeof(url) != "string" or len(url) == 0 then
    _streamClose(handle)
    return _error("native MPX media stream returned no URL")
  end if
  return PackedMediaSource(handle, url, false)
end function

/// Opens streamed audio by pre-resolved MPX slot.
/// @param pack Open asset pack.
/// @param slot Pre-resolved audio entry slot.
/// @param mime HTTP content type advertised to the audio backend.
/// @param suffix Filename suffix used for decoder selection.
/// @param options Optional `std.audio.PlayerOptions`.
function openAudioAt(pack, slot, mime = "audio/mpeg", suffix = ".mp3", options = void)
  info = packs.streamInfoAt(pack, slot)
  if typeof(info) == "error" then return info end if
  source = _openSource(info, mime, suffix)
  if typeof(source) == "error" then return source end if
  actual = options
  if actual is void then actual = nativeAudio.PlayerOptions.defaults() end if
  if typeof(actual) != "struct" then source.close(); return _error("audio options must be std.audio.PlayerOptions") end if
  localOptions = nativeAudio.PlayerOptions(true, actual.loopEnabled, actual.volume, actual.muted, actual.playbackRate)
  player = try(nativeAudio.Player.open(source.url, localOptions))
  if typeof(player) == "error" then source.close(); return player end if
  return PackedAudio(source, player, false)
end function

/// Opens streamed audio by stable MPX asset name.
/// @param pack Open asset pack.
/// @param name Stable audio asset name.
/// @param mime HTTP content type advertised to the audio backend.
/// @param suffix Filename suffix used for decoder selection.
/// @param options Optional `std.audio.PlayerOptions`.
function openAudio(pack, name, mime = "audio/mpeg", suffix = ".mp3", options = void)
  slot = packs.find(pack, name)
  if slot < 0 then return _error("asset not found: " + name) end if
  return openAudioAt(pack, slot, mime, suffix, options)
end function

/// Opens streamed video by pre-resolved MPX slot.
/// @param pack Open asset pack.
/// @param slot Pre-resolved video entry slot.
/// @param mime HTTP content type advertised to the video backend.
/// @param suffix Filename suffix used for decoder selection.
/// @param options Optional `std.video.PlayerOptions`.
function openVideoAt(pack, slot, mime = "video/mp4", suffix = ".mp4", options = void)
  info = packs.streamInfoAt(pack, slot)
  if typeof(info) == "error" then return info end if
  source = _openSource(info, mime, suffix)
  if typeof(source) == "error" then return source end if
  actual = options
  if actual is void then actual = nativeVideo.PlayerOptions.defaults() end if
  if typeof(actual) != "struct" then source.close(); return _error("video options must be std.video.PlayerOptions") end if
  localOptions = nativeVideo.PlayerOptions(true, actual.loopEnabled, actual.volume, actual.muted, actual.playbackRate)
  player = try(nativeVideo.Player.open(source.url, localOptions))
  if typeof(player) == "error" then source.close(); return player end if
  return PackedVideo(source, player, false)
end function

/// Opens streamed video by stable MPX asset name.
/// @param pack Open asset pack.
/// @param name Stable video asset name.
/// @param mime HTTP content type advertised to the video backend.
/// @param suffix Filename suffix used for decoder selection.
/// @param options Optional `std.video.PlayerOptions`.
function openVideo(pack, name, mime = "video/mp4", suffix = ".mp4", options = void)
  slot = packs.find(pack, name)
  if slot < 0 then return _error("asset not found: " + name) end if
  return openVideoAt(pack, slot, mime, suffix, options)
end function
