# MiniPixels 0.13.0

MiniPixels 0.13.0 makes asset packs substantially smaller without changing how a
game accesses its assets. Compression, audio conversion, deduplication, encryption,
authentication, lazy loading, and caching remain transparent to game code.

## Compact asset pipeline

Compatible source PNG files are now preserved byte-for-byte instead of being decoded
and rebuilt with uncompressed Deflate blocks. Generated PNG files use real Deflate.
Text, JSON, constants, and arbitrary file payloads select Deflate, dependency-free RLE,
or raw storage according to the resulting size.

Identical stored payloads occupy only one data block. Multiple asset identifiers can
reference that block directly in both unprotected MPX1 and protected MPX3 packs. The
asset report now shows source, logical, stored, container, and deduplicated byte counts,
plus the codec and transformation selected for every entry.

## Automatic WAV-to-MP3 conversion

PCM WAV assets are automatically encoded as MP3 when the encoded result is smaller.
The default bitrate is 96 kbit/s for mono and 128 kbit/s for stereo. Projects can use
`mp3Bitrate` and `mp3Quality` per asset, or disable conversion with `transcode: false`.
Original MP3 assets remain supported and packed without unnecessary recompression.

## Streamlined protected format

Protected packs use MPX3 format version 4. Compression and deduplication happen before
AES-256-GCM encryption. The signed encrypted index authenticates each block's codec,
logical and stored sizes, range, nonce, and tag. Assets are authenticated, decrypted,
and decompressed only on first access, then served from the existing slot cache.

Legacy MPX2 and MPX3 version-3 loading has been removed intentionally. Games must
rebuild protected packs with MiniPixels 0.13.0; no application code changes are needed.

## Verification

The complete Windows x64 and Linux x64 suites cover adaptive compression, RLE and
Deflate decoding, deduplication, automatic MP3 conversion, protected random access,
tamper rejection, decompression bounds, and explicit rejection of MPX2 and MPX3 v3.
The committed MiniDoc HTML and Markdown references are generated in strict mode with
zero warnings.
