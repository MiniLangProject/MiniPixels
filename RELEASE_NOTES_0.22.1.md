# MiniPixels 0.22.1

## Audio mixing

PCM mixing now batches source samples through the existing native audio bridge.
The MiniLang mixer owns all source data, decoder handles, output queues and
reusable accumulation buffers; the native calls retain no managed pointers.
Nearest-source-frame resampling, channel order, per-voice gain/pan, ordered double
accumulation, floor conversion and signed-16 clipping are retained. WAV PCM
supports 8/16/24/32-bit mono and stereo, including padded source blocks.

Muted voices still advance, loop and finish. Streaming MP3 voices can advance
without decoding while silent and seek to their current cursor on unmute.
Channel and clip percentages are normalized before multiplication, fixing the
case where a fractional combined volume such as 33% of 20% became full volume.

**Rebuild `minipixels_audio.dll` or `libminipixels_audio.so` with the executable.**
The bridge adds `mpAudioMixClear`, `mpAudioMixPcm` and `mpAudioMixFinish`.
Existing bridge binaries do not provide those entry points.

## Straight-alpha compositing

An opaque pixel in a transparent render target uses the same exact integer blend
as a wholly opaque canvas. Partially transparent pixels retain full integer
coverage until RGB division. The previous early alpha rounding could produce
RGB greater than 255 and fail a byte write for low-alpha pixel pairs. Source
alpha zero, direct copies onto transparent pixels, and opaque-target results
retain their existing byte values.

## Explicit simulation debt

`setCatchUpPolicy(config, "retain")` queues elapsed wall time for future fixed
updates when a frame reaches `maxCatchUpUpdates`. `maxFrameSeconds` still bounds
presentation delta, while retained simulation time includes the full frame.
The default `"discard"` policy preserves the existing clamp/discard behavior.
Render interpolation remains between zero and one under either policy.
Applications with their own pause or menu should call `clearCatchUpDebt(game)`
on entering that state, so pre-pause debt cannot replay after resuming.

Inspect `game.time.backlogSeconds`, `droppedSeconds`, `catchUpLimitedFrames` and
`pausedBacklogSeconds`. Discard counters include frame-clamp and update-budget
losses. Focus/overlay pauses intentionally clear queued time and account it
separately; paused wall time is not queued for later replay. Retention makes debt
visible and recoverable when the configured update budget permits recovery; it
does not make an overloaded simulation run faster.

The native PCM oracle and device-independent MiniLang regressions cover source
formats/rates, pan, clipping, bounds, fractional volume, silent end/loop state,
streaming resume, mixed-alpha rows, 0.4/0.6-second stalls and backlog recovery.

Validation for this source update used MiniLangCompilerPy 1.3.12 and the Linux
x64 native bridge. The complete Linux suite and the added native PCM oracle
passed; source-level regression fixtures are included for repeatable validation.
