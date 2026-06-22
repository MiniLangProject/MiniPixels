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
```

Coordinates are snapped to integer pixels. Out-of-bounds pixel writes are ignored safely.

## Colors

Colors use packed straight-alpha RGBA8888:

```ml
red = mp.rgb(255, 0, 0)
semi = mp.rgba(255, 255, 255, 128)
```

Canvas memory stores bytes as `R, G, B, A`. The Win32 renderer converts to BGRA for DIB presentation.

## Assets

The CLI reads PNG assets at build time and generates MiniLang code:

```ml
import generated.assets as gen

function initialize(game)
  game.assets = gen.registry()
  playerSprite = game.assets.getSprite("player")
end function
```

Supported first-version PNGs are 8-bit RGB/RGBA.

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
