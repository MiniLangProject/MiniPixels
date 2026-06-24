# Create Your First MiniPixels Game

This guide assumes `MiniPixels` and `MiniLangCompilerPy` are sibling folders.

## 1. Create a Project

```powershell
python tools\minipixels.py new MyGame
```

Project layout:

```text
MyGame/
  minipixels.json
  src/
    main.ml
  assets/
```

## 2. Add a Sprite

Put a small 8-bit RGB/RGBA PNG at:

```text
MyGame/assets/player.png
```

Then add it to `MyGame/minipixels.json`:

```json
{
  "id": "player",
  "type": "image",
  "path": "assets/player.png",
  "sheet": {
    "frameWidth": 16,
    "frameHeight": 16,
    "spacing": 0,
    "margin": 0
  }
}
```

## 3. Write Game Code

```ml
import minipixels as mp
import generated.assets as gen

x = 40
y = 40
player = void

function initialize(game)
  game.assets = gen.registry()
  player = game.assets.getSprite("player")
end function

function update(game, dt)
  global x, y
  speed = 90 * dt
  if game.input.left then x = x - speed end if
  if game.input.right then x = x + speed end if
  if game.input.up then y = y - speed end if
  if game.input.down then y = y + speed end if
end function

function render(game, canvas)
  canvas.clear(mp.rgb(20, 24, 32))
  canvas.drawSprite(player, x, y)
  mp.drawText(canvas, "MINIPIXELS " + mp.version(), 8, 8, 1, mp.rgb(255, 255, 255))
end function

function main(args)
  cfg = mp.createConfig("My First MiniPixels Game", 320, 180, 4)
  return mp.run(cfg, initialize, update, render, void)
end function
```

## 4. Build and Run

```powershell
python tools\minipixels.py run MyGame\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

The Python build creates generated MiniLang assets, compiles a native Windows executable, copies runtime assets, and writes an `asset-report.json` next to the executable. The native MiniLang CLI can already validate the manifest and generate importable modules, but full build/run still uses the Python CLI.
