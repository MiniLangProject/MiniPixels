# Native MP3 decoder bridge

`audio_decoder.c` exposes the minimal in-memory decoder ABI used by the MiniPixels mixer. `tools/build_audio_runtime.py` downloads `dr_mp3.h` from the pinned `dr_libs` revision recorded in that script, verifies its SHA-256 digest, and builds `minipixels_audio.dll` or `libminipixels_audio.so` for the selected game target.

`dr_mp3` is offered under a choice of public-domain or MIT-0 terms; the downloaded header contains both complete license statements. MiniPixels uses it under MIT-0. The implementation is based on `minimp3`, whose CC0 notice is also included in the downloaded header.
