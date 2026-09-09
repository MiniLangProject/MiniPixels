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
      "path": "assets/audio/coin.wav"
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
    }
  ]
}
```

Asset types:

| Type | Meaning | Python CLI | Native CLI `generate` |
| --- | --- | --- | --- |
| `image` | non-interlaced PNG image asset | stores deterministic RGBA PNG payload and generates lazy loader functions | stores source PNG payload and generates lazy loader functions |
| `procedural` | generated checker/player/tile sprite data from manifest fields | renders a PNG payload into `assets.mpx` and generates a loader | renders a deterministic PNG payload and generates a loader |
| `audio` | runtime audio file, usually PCM WAV | stores payload and generates a memory-clip helper | stores payload and generates a memory-clip helper |
| `file` | runtime data file | stores payload and generates pack access | stores payload and generates pack access |
| `text` | UTF-8 JSON translation catalog | validates keys/placeholders, encodes MPT1, and generates localization helpers | encodes MPT1 and generates a catalog helper |
| `data` | structured runtime JSON data | canonicalizes and stores UTF-8 JSON in the pack | stores UTF-8 JSON in the pack |
| `constants` | build-time game configuration | generates scalar constants plus a structured `data()` accessor | requires the Python build driver |

Assets with `sheet` metadata also get generated helpers such as `gen.sheet_player()`.

Both generators write `build/assets.mpx`; the Python build additionally copies it next to the executable. The runtime accepts ordinary non-interlaced grayscale, RGB, indexed, grayscale-alpha, and RGBA PNGs. Audio entries are loaded as bytes and can be mixed as in-memory PCM clips.

## Protected Asset Builds

Initialize a persistent signing identity once:

```powershell
python tools\minipixels.py security init path\to\game\minipixels.json
python tools\minipixels.py security status path\to\game\minipixels.json
```

`security init` creates an unencrypted P-256 PKCS#8 private PEM below `.minipixels`, writes the public PEM beside it, adds the private path to the game's `.gitignore`, and enables `assetProtection`. Subsequent `generate`, `pack`, `build`, and `run` commands create MPX2 automatically. In CI, supply the PEM through `MINIPIXELS_ASSET_SIGNING_KEY` or point `MINIPIXELS_ASSET_SIGNING_KEY_FILE` at a secret file. A protected build fails when the private key is unavailable.

MPX2 keeps only a fixed 64-byte transport header in clear text. The complete MPX1 stream—including names, entry table, kinds, sizes, and payloads—is encrypted with a fresh AES-256-GCM key. MiniPixels signs `header || ciphertext || tag` with ECDSA-P256-SHA256. Generated code embeds the public verification key, its key id, and a per-build masked/permuted AES key. The runtime verifies the signature before decrypting and never accepts MPX1 as a fallback for a protected generated module.

The embedded AES key is deliberate obfuscation against trivial extraction, not a hardware-backed secret. The signing private key is the actual modification boundary and is never emitted into generated code or the asset pack.

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
