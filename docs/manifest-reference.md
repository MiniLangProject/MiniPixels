# Manifest and Level Reference

MiniPixels projects are described by `minipixels.json`.

## Project Manifest

```json
{
  "name": "my-game",
  "main": "src/main.ml",
  "window": {
    "title": "My Game",
    "width": 320,
    "height": 180,
    "scale": 4
  },
  "levels": {
    "path": "assets/levels/levels.json"
  },
  "assetProtection": {
    "enabled": true,
    "signingKey": ".minipixels/asset-signing-key.pem"
  },
  "assetLoading": {
    "mode": "lazy",
    "compression": "auto",
    "batchBytes": 16777216
  },
  "localization": {
    "defaultLocale": "de"
  },
  "assets": [
    {
      "id": "player",
      "type": "image",
      "path": "assets/sprites/player.png",
      "sheet": {
        "frameWidth": 32,
        "frameHeight": 32,
        "spacing": 0,
        "margin": 0
      }
    },
    {
      "id": "coinSound",
      "type": "audio",
      "path": "assets/audio/coin.wav",
      "mp3Bitrate": 96,
      "mp3Quality": 2
    },
    {
      "id": "theme",
      "type": "audio",
      "path": "assets/audio/theme.mp3",
      "stream": true
    },
    {
      "id": "intro",
      "type": "video",
      "path": "assets/video/intro.mp4"
    },
    {
      "id": "de",
      "type": "text",
      "locale": "de",
      "path": "assets/i18n/de.json"
    },
    {
      "id": "balance",
      "type": "constants",
      "path": "assets/data/balance.json"
    },
    {
      "id": "world_1",
      "type": "file",
      "path": "assets/data/world_1.sprites",
      "preload": "level-1",
      "compression": "fast"
    }
  ]
}
```

Asset types:

| Type | Meaning | Python CLI | Native CLI `generate` |
| --- | --- | --- | --- |
| `image` | non-interlaced PNG image asset | validates and preserves source PNG bytes | stores source PNG bytes |
| `procedural` | generated checker/player/tile sprite data from manifest fields | renders a Deflate-compressed PNG | renders a deterministic PNG and applies pack LZ4/RLE when useful |
| `audio` | runtime PCM WAV or MP3 file | transcodes WAV to MP3 when smaller; `stream: true` generates a seekable file-backed player instead of a memory clip | same behavior without WAV transcoding |
| `video` | encoded media, normally MP4 | generates a seekable file-backed `std.video` player | same behavior |
| `file` | runtime data file | selects Deflate/RLE by default or LZ4 with `fast` | selects LZ4/RLE when useful |
| `text` | UTF-8 JSON translation catalog | validates, encodes MPT1, and compresses when useful | encodes MPT1 and applies LZ4/RLE when useful |
| `data` | structured runtime JSON data | canonicalizes JSON and compresses when useful | stores JSON and applies LZ4/RLE when useful |
| `constants` | build-time game configuration | generates scalar constants plus a structured `data()` accessor | requires the Python build driver |

Assets with `sheet` metadata also get generated helpers such as `gen.sheet_player()`.

Both generators write `build/assets.mpx`; the Python build additionally copies it next to the executable. The runtime accepts ordinary non-interlaced grayscale, RGB, indexed, grayscale-alpha, and RGBA PNGs. Compression and identical-payload deduplication are transparent to generated code. Python builds convert PCM WAV entries to MP3 only when the encoded result is smaller. `mp3Bitrate` accepts 32–320 kbit/s, `mp3Quality` accepts 0–9, and `"transcode": false` preserves WAV bytes. `stream` is a boolean valid only for audio; video always streams.

`assetLoading.mode` is `lazy` by default. `resident` reads and decompresses every non-streaming payload into the slot cache when the generated module first opens the pack. Streamed audio and video always remain file-backed. `batchBytes` bounds each physical read and coalesced multi-entry batch and defaults to 16 MiB; accepted values range from 64 KiB to 512 MiB. Gaps between requested blocks are never read. An oversized single entry is filled with multiple bounded reads directly into its storage buffer, reused as the final cache for raw unprotected entries. This is not a total memory limit: final payloads and codec/authentication buffers can exceed `batchBytes`. Temporary bulk buffers are released after decoding; the entire stored MPX representation is not retained as a second copy.

`assetLoading.compression` sets the default for packable assets, while an asset-level `compression` overrides it. In Python builds, `auto` uses LZ4 for `.sprites`/`.rgba` file assets of at least 64 KiB and the smallest worthwhile Deflate/RLE representation otherwise; `fast` uses a standard LZ4 block in an MPX size envelope and falls back to raw bytes when compression is not worthwhile; `small` accepts any saving from maximum Deflate/RLE compression; `none` stores the logical bytes directly. Python builds apply this outer compression to `file`, `text`, and `data`; PNG, MP3, and video payloads already carry their own compression. The native generator chooses LZ4/RLE for `auto`/`small`, LZ4 for `fast`, or raw for `none`. Existing Deflate/RLE packs still load; the LZ4 decoder requires MiniLang Compiler 1.2.11 or newer. Protected MPX3 packs authenticate the selected representation.

Set `preload` to `true` for the generated `boot` group or to a group name such as `"level-1"`. `generated.assets.preloadGroup("level-1")` resolves that group's non-streaming slots, performs bounded file-order reads, and constructs the corresponding cached assets. `generated.assets.preload()` loads every non-streaming asset through the same bulk path. Media streams are excluded even if tagged.

## Protected Asset Builds

Initialize a persistent signing identity once:

```powershell
python tools\minipixels.py security init path\to\game\minipixels.json
python tools\minipixels.py security status path\to\game\minipixels.json
```

`security init` creates an unencrypted P-256 PKCS#8 private PEM below `.minipixels`, writes the public PEM beside it, adds the private path to the game's `.gitignore`, and enables `assetProtection`. Subsequent `generate`, `pack`, `build`, and `run` commands create MPX3 automatically. In CI, supply the PEM through `MINIPIXELS_ASSET_SIGNING_KEY` or point `MINIPIXELS_ASSET_SIGNING_KEY_FILE` at a secret file. A protected build fails when the private key is unavailable.

MPX3 version 5 keeps only a fixed 64-byte transport header in clear text. Names, kinds, codecs, logical/stored sizes, ranges, per-entry nonces and tags live in an AES-256-GCM encrypted index. Ordinary unique compressed/raw payloads are separate AES-256-GCM blocks. Audio and video payloads use an `MPS1` envelope with independently authenticated 256 KiB chunks so seeking decrypts only the requested region. MiniPixels signs `header || encrypted-index || index-tag` with ECDSA-P256-SHA256. The signed index authenticates every payload's GCM material; the stream nonce and chunk number additionally bind each media chunk against reordering or transplantation. Generated code embeds the public verification key, its key id, and a per-build masked/permuted AES key. The protected loader accepts only MPX3 version 5 and rejects MPX1, MPX2, and older MPX3 versions.

The embedded AES key is deliberate obfuscation against trivial extraction, not a hardware-backed secret. The signing private key is the actual modification boundary and is never emitted into generated code or the asset pack.

Generated accessors cache decoded sprites, short audio clips, text catalogs, localization state and JSON text. They use pre-resolved entry slots rather than hashing the asset id on every call. `audio_<id>()` returns a memory clip by default or a `PackedAudio` player when `stream` is true; `video_<id>()` returns a `PackedVideo` player. A packed player owns a loopback-only HTTP range source and must be closed before the generated asset pack is closed. No plaintext temporary file or complete media-sized RAM copy is created.

The transport accepts fragmented HTTP headers and case-insensitive single byte ranges (including suffix and open-ended ranges); invalid or multiple ranges return 416. Header size and idle waits are bounded, and closing cancels pending socket I/O. Failed chunk authentication never publishes plaintext or leaves a valid cache entry. On Linux, both streamed audio and video require GStreamer base/good plugins; install libav for MP3/H.264 decoding.

## Localization and Constants

Text assets are JSON objects containing string keys and values. Every locale must have the same keys and placeholders as `localization.defaultLocale`:

```json
{
  "menu.start": "Start",
  "game.coins": "Münzen: {0}"
}
```

Generated access is concise:

```ml
import generated.assets as gen

i18n = gen.localization()
i18n.setLocale("en-US")
label = i18n.text("menu.start")
counter = i18n.format("game.coins", [coinCount])
```

Constants JSON is compiled into `generated.constants.<asset-id>`. Nested scalar names are flattened to uppercase constants, while `data()` reconstructs arrays and maps:

```ml
import generated.constants.balance as balance

speed = balance.PLAYER_SPEED
waves = balance.data().get("waves")
```

## MiniPixels Level JSON

```json
{
  "levels": [
    {
      "width": 40,
      "height": 9,
      "spawn": { "x": 48, "y": 192 },
      "exit": { "x": 1184, "y": 160 },
      "platforms": [
        { "x": 0, "y": 7, "w": 40, "tile": 1 }
      ],
      "enemies": [
        { "x": 360, "y": 192, "minX": 320, "maxX": 480 }
      ],
      "coins": [
        { "x": 220, "y": 120 }
      ]
    }
  ]
}
```

Platform `x`, `y`, and `w` are measured in tiles. Spawn, exit, enemies, and coins are measured in pixels.

## Tiled JSON/TMJ Import

With either generator, `levels.path` may point to a finite CSV-encoded Tiled JSON/TMJ map. MiniPixels imports one Tiled map as one generated level.

Supported conventions:

- Solid tile layers are named `collision`, `collisions`, `solid`, or `ground`.
- If no solid layer name is found, all tile layers are imported.
- Non-zero tile GIDs become solid platform runs.
- Object layers may contain objects named or typed `spawn`, `exit`, `coin`, and `enemy`.
- Enemy objects may use custom properties `minX` and `maxX`.

Generated MiniLang modules are imported the same way regardless of which CLI produced them:

```ml
import generated.levels as lvl

data = lvl.tileData(levelIndex)
spawnX = lvl.spawnX(levelIndex)
coinCount = lvl.coinCount(levelIndex)
```
