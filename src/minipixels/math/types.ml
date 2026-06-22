package minipixels.math.types

struct Vector2
  x
  y
end struct

struct Vector2Int
  x
  y
end struct

struct Size
  width
  height
end struct

struct Rectangle
  x
  y
  width
  height
end struct

struct RectangleInt
  x
  y
  width
  height
end struct

struct Transform2D
  x
  y
  scaleX
  scaleY
end struct

struct Timer
  duration
  elapsed
  running
  repeat

  function start()
    this.elapsed = 0
    this.running = true
  end function

  function stop()
    this.running = false
  end function

  function reset()
    this.elapsed = 0
  end function

  function update(dt)
    return timerUpdate(this, dt)
  end function

  function finished()
    return this.running == false and this.elapsed >= this.duration
  end function
end struct

struct Random
  seed

  function nextInt(minValue, maxValue)
    return randomNextInt(this, minValue, maxValue)
  end function

  function nextFloat()
    return randomNextFloat(this)
  end function

  function chance(percent)
    return this.nextInt(0, 99) < percent
  end function
end struct

function vec2(x, y)
  return Vector2(x, y)
end function

function vec2i(x, y)
  return Vector2Int(x, y)
end function

function rect(x, y, w, h)
  return Rectangle(x, y, w, h)
end function

function recti(x, y, w, h)
  return RectangleInt(floorInt(x), floorInt(y), floorInt(w), floorInt(h))
end function

function transform2d(x, y)
  return Transform2D(x, y, 1, 1)
end function

function floorInt(v)
  if typeof(v) == "int" then return v end if
  whole = v - (v % 1)
  if v < 0 and whole != v then
    whole = whole - 1
  end if
  return whole
end function

function clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

function abs(v)
  if v < 0 then return 0 - v end if
  return v
end function

function vector2Add(a, b)
  return Vector2(a.x + b.x, a.y + b.y)
end function

function vector2Subtract(a, b)
  return Vector2(a.x - b.x, a.y - b.y)
end function

function vector2Multiply(a, s)
  return Vector2(a.x * s, a.y * s)
end function

function vector2Length(a)
  return ((a.x * a.x) + (a.y * a.y)) / 1.0
end function

function vector2Normalize(a)
  l = vector2Length(a)
  if l == 0 then return Vector2(0, 0) end if
  return Vector2(a.x / l, a.y / l)
end function

function rectangleContainsPoint(r, x, y)
  return x >= r.x and y >= r.y and x < r.x + r.width and y < r.y + r.height
end function

function rectangleIntersects(a, b)
  if a.x + a.width <= b.x then return false end if
  if b.x + b.width <= a.x then return false end if
  if a.y + a.height <= b.y then return false end if
  if b.y + b.height <= a.y then return false end if
  return true
end function

function rgba(r, g, b, a)
  r = clamp(r, 0, 255)
  g = clamp(g, 0, 255)
  b = clamp(b, 0, 255)
  a = clamp(a, 0, 255)
  return (r << 24) | (g << 16) | (b << 8) | a
end function

function rgb(r, g, b)
  return rgba(r, g, b, 255)
end function

function colorR(c)
  return (c >> 24) & 255
end function

function colorG(c)
  return (c >> 16) & 255
end function

function colorB(c)
  return (c >> 8) & 255
end function

function colorA(c)
  return c & 255
end function

function tintChannel(src, tint)
  return (src * tint) / 255
end function

function tintColor(c, tint)
  return rgba(
    tintChannel(colorR(c), colorR(tint)),
    tintChannel(colorG(c), colorG(tint)),
    tintChannel(colorB(c), colorB(tint)),
    tintChannel(colorA(c), colorA(tint))
  )
end function

function alphaBlend(dst, src)
  sa = colorA(src)
  if sa <= 0 then return dst end if
  if sa >= 255 then return src end if
  inv = 255 - sa
  r = ((colorR(src) * sa) + (colorR(dst) * inv)) / 255
  g = ((colorG(src) * sa) + (colorG(dst) * inv)) / 255
  b = ((colorB(src) * sa) + (colorB(dst) * inv)) / 255
  return rgba(r, g, b, 255)
end function

function timerCreate(seconds, repeat)
  return Timer(seconds, 0, false, repeat)
end function

function timerUpdate(t, dt)
  if t.running == false then return false end if
  t.elapsed = t.elapsed + dt
  if t.elapsed >= t.duration then
    if t.repeat then
      t.elapsed = t.elapsed - t.duration
    else
      t.running = false
    end if
    return true
  end if
  return false
end function

function randomCreate(seed)
  if typeof(seed) != "int" then seed = 1 end if
  if seed == 0 then seed = 1 end if
  return Random(seed)
end function

function randomStep(r)
  r.seed = ((r.seed * 1103515245) + 12345) & 0x7FFFFFFF
  return r.seed
end function

function randomNextInt(r, minValue, maxValue)
  if maxValue < minValue then
    tmp = minValue
    minValue = maxValue
    maxValue = tmp
  end if
  span = maxValue - minValue + 1
  return minValue + (randomStep(r) % span)
end function

function randomNextFloat(r)
  return randomStep(r) / 2147483647.0
end function
