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
| `image` | 8-bit RGB/RGBA PNG image asset | stores PNG-profile payload in `assets.mpx` and generates loader functions | emits a compileable placeholder sprite until native asset-pack generation is added |
| `procedural` | generated checker/player/tile sprite data from manifest fields | embeds generated pixels | embeds generated pixels |
| `audio` | runtime audio file, usually WAV | stores payload in `assets.mpx` and generates memory-clip helpers | validates only |
| `file` | runtime data file | stores payload in `assets.mpx` | validates only |

Assets with `sheet` metadata also get generated helpers such as `gen.sheet_player()`.

The Python build writes `build/assets.mpx` and copies it next to the executable. Image entries are transcoded to the MiniPixels PNG profile so MiniLang runtime code can decode them without embedding large pixel arrays into generated source. Audio entries are loaded from the pack as bytes and can be played as in-memory SFX clips.

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

When using the Python build pipeline, `levels.path` may also point to a Tiled JSON/TMJ map. MiniPixels imports one Tiled map as one generated level. The native MiniLang generator validates the manifest but currently writes a level stub for Tiled/TMJ maps; native Tiled import is a follow-up migration step.

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
