# MiniPixels 0.16.1

This release includes the [0.16.0 feature set](RELEASE_NOTES_0.16.0.md): seekable MPX audio/video streaming, authenticated media chunks, reliable cancellation and bounded asset preloading.

It additionally fixes a Windows CI edge case: oversized HTTP requests now receive their 431 response before bounded excess input is drained and the connection is closed. Tests exercise several oversized requests and a successful request afterward on both platforms.

The 0.16.0 tag did not publish an SDK because that regression blocked its release build. Use 0.16.1 for the streaming release. Rebuild protected assets as MPX3 version 5; earlier protected containers are not supported.
