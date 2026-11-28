# Independent PCM output

`minipixels.audio.audio.enableIndependentOutput(mixer)` opts a closed Windows
mixer into device servicing on a native worker. The default WAV/streaming-MP3
software mixer and Linux ALSA path remain available. The opt-in path accepts
prepared in-memory PCM, including WAV and already-decoded effects; it rejects
streaming sources that have no PCM buffer. Call it before playing any voice.
MiniPinball uses this mode for its WAV effects and synchronized WAV music stems.

## Why this exists

The original Windows output queue held three 1,024-frame periods and required
`update()` on the application thread. At 44,100 Hz it covered 69.66 ms, so a
100–237-ms software-rendering stall could exhaust it. Increasing that queue to
cover long stalls would also postpone newly submitted effects. The independent
worker supplies four 512-frame periods while the application renders. Its
46.44-ms capacity is not a measured latency claim.

WinMM `CALLBACK_EVENT` signals a manual-reset event. One worker checks completed
headers in submission order, fills them, and submits them again. It also checks
on a bounded timeout. The device is paused while its initial queue is primed,
then restarted once the worker exists. No language callbacks run on the worker.
See Microsoft's [event callback guidance](https://learn.microsoft.com/en-us/windows/win32/multimedia/using-an-callback-to-process-driver-messages)
and [audio data block lifecycle](https://learn.microsoft.com/en-us/windows/win32/multimedia/audio-data-blocks).

## Ownership and command contract

`audio_output.c` owns a maximum of 128 immutable PCM copies, 256 voices and
512 MiB of copied PCM. Its fixed output periods and mixing state require no
steady-state allocations. A source upload copies before acquiring the worker
mutex. The managed registry retains source objects only for stable lookup; the
worker never reads a managed heap pointer or depends on garbage collection.

A bounded little-endian command snapshot describes the complete voice ensemble
and is validated before it changes any voice. Publication and returned cursor
states share one short critical section. Only source/generation changes restart
a voice. Repeated snapshots cannot replay a finished effect, and a reused
channel can explicitly retrigger the same clip by incrementing its generation.
The base music voice and additional layers start in one transaction; zero-gain
and muted loops continue advancing at the same sample rate. Native stats expose
rendered frames, whole-queue underruns, device errors and copied bytes.

Source gains, volume changes, stops and starts use 128-frame ramps. A stolen or
abruptly ending voice decays its final sample while a replacement fades in.
This bounds discontinuities without adding a long queued fade. PCM accumulation
uses double precision and emits clipped signed-16 stereo. Native tests cover
the actual ramped renderer separately from the older software PCM oracle.

Clients may additionally set `mixer.softLimit = true`. The shared optional
memoryless peak curve is unchanged through ±24,000 and approaches ±32,000
smoothly above that knee, with unity slope at the join. It prevents dense
effects/music mixtures from reaching the signed-16 hard-clipping boundary
without changing ordinary low-level samples or adding lookahead latency.
Both software `mixBuffer` and the independent renderer use this same curve;
the default remains off for existing clients.

Native startup failure destroys its context and clears the managed clip-ID
registry. Closing signals the worker, joins it, resets the device, unprepares
headers, closes handles and frees copied PCM. No native sample pointer survives
its output owner. The host must still call `update()` to publish changed gains
and synchronize managed voice completion/cursors; audio already queued by the
worker continues independently between those calls.

## Build and verification

`tools/build_audio_runtime.py` compiles `audio_output.c` with the existing runtime.
Windows builds link `winmm.lib` (MSVC) or `-lwinmm` (MinGW-w64). On a Linux cross
host, set `MINIPIXELS_MINGW_CC` to an x86-64 MinGW compiler or put it on `PATH`.
No additional redistributable runtime is required beyond the existing bridge.

The central test runner includes `audio_output_tests.ml` and
`native_output_tests.py`. Three MiniLang groups exercise the real command ABI,
gain/pan, one-copy caching, repeated-clip generations, phase through mute,
resource close/reopen and partial startup failure/retry. Portable native checks
cover ownership after caller memory changes, output guards, transaction rejection,
natural completion, ramps, and an actual 33-voice worker producing PCM while
the caller sleeps for 350 ms. Diagnostic mode 2 discards output instead of opening
a device and is deliberately identified as a headless timing test.

The current Linux-host verification includes real native execution and a complete
Windows DLL cross-build. It does not execute WinMM or establish speaker latency,
device compatibility or perceived listening quality; those require the Windows
playtest. Existing software mixer and streaming-MP3 tests remain applicable to
their unchanged default backend.
