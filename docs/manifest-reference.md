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

Assets with `sheet` metadata also get generated helpers such as `gen.sheet_player()`.

Both generators write `build/assets.mpx`; the Python build additionally copies it next to the executable. The runtime accepts ordinary non-interlaced grayscale, RGB, indexed, grayscale-alpha, and RGBA PNGs. Audio entries are loaded as bytes and can be mixed as in-memory PCM clips.

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
