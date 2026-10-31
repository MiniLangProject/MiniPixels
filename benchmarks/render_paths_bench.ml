import minipixels as mp
import minipixels.graphics.canvas as cv
import minipixels.graphics.sprite as sp
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif

function main(args)
  canvas = cv.create(320, 180)
  image = sp.solidImage(16, 16, mp.rgba(180, 90, 40, 180), "render-paths")
  sprite = sp.spriteFromImage(image, "render-paths")
  opaqueImage = sp.solidImage(16, 16, mp.rgb(180, 90, 40), "render-paths-opaque")
  opaqueSprite = sp.spriteFromImage(opaqueImage, "render-paths-opaque")
  tint = mp.rgba(220, 190, 255, 210)
  alpha = mp.rgba(24, 130, 210, 120)

  canvas.clear(mp.rgb(8, 12, 20))
  start = win.seconds()
  for i = 0 to 5999
    canvas.drawSpriteRotated(sprite, (i * 37) % 320, (i * 19) % 180, 0.37, 1, tint)
  end for
  print "rotated ms=" + ((win.seconds() - start) * 1000) + " hash=" + mp.frameHash(canvas)

  canvas.clear(mp.rgb(8, 12, 20))
  start = win.seconds()
  for i = 0 to 5999
    canvas.drawSpriteRotated(opaqueSprite, (i * 37) % 320, (i * 19) % 180, 0.37, 1, mp.rgba(255, 255, 255, 255))
  end for
  print "rotatedOpaque ms=" + ((win.seconds() - start) * 1000) + " hash=" + mp.frameHash(canvas)

  canvas.clear(mp.rgb(8, 12, 20))
  start = win.seconds()
  for i = 0 to 2999
    canvas.fillRect((i * 37) % 320, (i * 19) % 180, 64, 32, alpha)
  end for
  print "alphaRect ms=" + ((win.seconds() - start) * 1000) + " hash=" + mp.frameHash(canvas)

  canvas.clear(mp.rgb(8, 12, 20))
  start = win.seconds()
  for i = 0 to 7999
    canvas.drawLine((i * 37) % 320, (i * 19) % 180, ((i * 37) % 320) + 180, ((i * 19) % 180) + 40, alpha)
  end for
  print "line ms=" + ((win.seconds() - start) * 1000) + " hash=" + mp.frameHash(canvas)
  return 0
end function
