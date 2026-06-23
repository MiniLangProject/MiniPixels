# API Overview

## Game Loop

```ml
cfg = mp.createConfig("Title", 320, 180, 4)
mp.run(cfg, initialize, update, render, shutdown)
```

Callbacks:

- `initialize(game)`
- `update(game, dt)`
- `render(game, canvas)`
- `shutdown(game)`

The game loop runs on the main thread. Input is sampled only when the game window has focus. The window title includes the current FPS.

## Canvas

```ml
canvas.clear(mp.rgb(20, 20, 30))
canvas.setPixel(10, 10, mp.rgb(255, 0, 0))
canvas.fillRect(20, 20, 32, 16, mp.rgba(255, 128, 0, 200))
canvas.drawSprite(sprite, x, y)
mp.drawSpriteWorld(canvas, camera, sprite, worldX, worldY)
```

Coordinates are snapped to integer pixels. Out-of-bounds pixel writes are ignored safely.
`drawSpriteEx` supports clipping, horizontal/vertical flips, integer scale, tint, and alpha blending. World helpers subtract a camera position without mutating canvas state.

## Colors

Colors use packed straight-alpha RGBA8888:

```ml
red = mp.rgb(255, 0, 0)
semi = mp.rgba(255, 255, 255, 128)
```

Canvas memory stores bytes as `R, G, B, A`. The Win32 renderer converts to BGRA for DIB presentation.

## Assets

The CLI reads image assets at build time and generates MiniLang code:

```ml
import generated.assets as gen

function initialize(game)
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function
```

Supported embedded PNGs are 8-bit RGB/RGBA. Assets with `type: "audio"` or `type: "file"` are copied next to the executable instead of being embedded as image code.

```json
{
  "id": "player",
  "type": "image",
  "path": "assets/sprites/player_sheet.png",
  "sheet": {
    "frameWidth": 28,
    "frameHeight": 32,
    "spacing": 0,
    "margin": 0
  }
}
```

For sheet metadata the generated module exposes helpers such as:

```ml
sheet = gen.sheet_player()
```

Each build also writes `asset-report.json` next to the executable with embedded/runtime asset sizes and sheet metadata.

## Text

MiniPixels includes a small 5x7 bitmap font for menus, HUDs, and debug labels:

```ml
mp.drawText(canvas, "COINS 03", 8, 8, 1, mp.rgb(255, 255, 255))
mp.drawTextCentered(canvas, "SKYLINE RUN", 44, 3, mp.rgb(78, 205, 196))
width = mp.textWidth("READY", 2)
```

## Input

The `game.input` state exposes booleans like `left`, `right`, `jump`, and `escape`. The facade also has edge helpers:

```ml
if mp.inputPressed(game.input, "jump") then
  mp.playSound("assets\\audio\\jump.wav")
end if
if mp.inputReleased(game.input, "fire") then
  mp.stopSound()
end if
```

Input is sampled only when the game window has focus.

## Animation

```ml
sheet = mp.spriteSheet(playerSprite.image, 32, 32, 0, 0)
run = mp.animationFromSheet(sheet, 2, 4, 0.08)
run.setPingPong(false)
run.play()
run.update(dt)
canvas.drawSprite(run.currentSprite(), x, y)
```

Animations support `play`, `pause`, `stop`, `reset`, looping, ping-pong playback, per-frame durations, and speed scaling.

## Audio

The first audio layer uses the WinMM backend on Windows:

```ml
mp.playSound("assets\\audio\\coin.wav")
mp.playSoundSync("assets\\audio\\intro.wav")
mp.playSoundLoop("assets\\audio\\theme.wav")
mp.playMusic("assets\\audio\\theme.wav")
mp.stopSound()
```

Games also get `game.audio`, a small state layer for SFX/music volume and mute handling:

```ml
game.audio.setMasterVolume(90)
game.audio.setSfxVolume(75)
mp.playSfx(game.audio, "assets\\audio\\coin.wav")
mp.playMusicWithState(game.audio, "assets\\audio\\theme.wav")
game.audio.mute()
```

The current backend is still WinMM, so this is a control layer rather than a multi-voice mixer. It keeps game code stable for a future mixer backend.

## Tilemaps

```ml
sheet = mp.spriteSheet(tileSprite.image, 16, 16, 0, 0)
map = mp.tilemap(16, 16, 80, 20, mp.tileset(sheet), 2)
map.addLayer(mp.tileLayer("world", 80, 20, data, true, false, 1, 1))
map.addLayer(mp.tileLayer("collision", 80, 20, data, false, true, 1, 1))
```

Collision:

```ml
rect = mp.recti(player.x, player.y, 12, 15)
res = mp.tileMoveAndCollide(map, rect, vx, vy)
```

The collider resolves X and Y separately and clamps bodies to world bounds.
