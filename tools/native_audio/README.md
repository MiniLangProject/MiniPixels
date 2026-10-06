# Native runtime bridge

`audio_decoder.c` exposes the in-memory decoder ABI used by the MiniPixels mixer. The same dependency-free bridge also accelerates XImage RGBA-to-BGRA conversion and nearest/integer scaling on Linux, avoiding per-pixel dynamic MiniLang work. `tools/build_audio_runtime.py` downloads `dr_mp3.h` from the pinned `dr_libs` revision recorded in that script, verifies its SHA-256 digest, and builds `minipixels_audio.dll` or `libminipixels_audio.so` for the selected game target.

`dr_mp3` is offered under a choice of public-domain or MIT-0 terms; the downloaded header contains both complete license statements. MiniPixels uses it under MIT-0. The implementation is based on `minimp3`, whose CC0 notice is also included in the downloaded header.

`media_stream.c` supplies the loopback HTTP range transport for MPX audio/video. Protected MPX3 version-6 sources use `mpMediaStreamOpenV6`, whose additional `signed_hashes` pointer/size arguments contain the ciphertext SHA-256 table from the ECDSA-verified index. The bridge copies that table and checks each requested 256 KiB chunk against its trusted digest before GCM decryption. Supplying hashes read from the untrusted payload would defeat the integrity boundary. Unprotected sources pass an empty table. Rebuild the runtime and game together when upgrading; the old open symbol is deliberately not exported.

The bridge uses Windows CNG or Linux OpenSSL for cryptography, plus native sockets/threads for the transport. Linux builds link against libcrypto and pthread; the final `.so` belongs beside the executable and is loaded through `$ORIGIN`.
