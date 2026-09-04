// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels math types facilities for this project.

package minipixels.math.types

/// Represents the vector2 data used by the minipixels math types module.
struct Vector2
  /// Stores the x value associated with vector2.
  x
  /// Stores the y value associated with vector2.
  y
end struct

/// Represents the vector2 int data used by the minipixels math types module.
struct Vector2Int
  /// Stores the x value associated with vector2 int.
  x
  /// Stores the y value associated with vector2 int.
  y
end struct

/// Represents the size data used by the minipixels math types module.
struct Size
  /// Stores the width value associated with size.
  width
  /// Stores the height value associated with size.
  height
end struct

/// Represents the rectangle data used by the minipixels math types module.
struct Rectangle
  /// Stores the x value associated with rectangle.
  x
  /// Stores the y value associated with rectangle.
  y
  /// Stores the width value associated with rectangle.
  width
  /// Stores the height value associated with rectangle.
  height
end struct

/// Represents the rectangle int data used by the minipixels math types module.
struct RectangleInt
  /// Stores the x value associated with rectangle int.
  x
  /// Stores the y value associated with rectangle int.
  y
  /// Stores the width value associated with rectangle int.
  width
  /// Stores the height value associated with rectangle int.
  height
end struct

/// Represents the transform2 d data used by the minipixels math types module.
struct Transform2D
  /// Stores the x value associated with transform2 d.
  x
  /// Stores the y value associated with transform2 d.
  y
  /// Stores the scale x value associated with transform2 d.
  scaleX
  /// Stores the scale y value associated with transform2 d.
  scaleY
end struct

/// Represents the timer data used by the minipixels math types module.
struct Timer
  /// Stores the duration value associated with timer.
  duration
  /// Stores the elapsed value associated with timer.
  elapsed
  /// Stores the running value associated with timer.
  running
  /// Stores the repeat value associated with timer.
  repeat

  /// Starts start for the minipixels math types workflow.
  function start()
    this.elapsed = 0
    this.running = true
  end function

  /// Stops stop for the minipixels math types workflow.
  function stop()
    this.running = false
  end function

  /// Performs the reset operation for the minipixels math types timer module.
  function reset()
    this.elapsed = 0
  end function

  /// Updates update for the minipixels math types workflow.
  /// @param dt dt value consumed by this operation.
  function update(dt)
    return timerUpdate(this, dt)
  end function

  /// Performs the finished operation for the minipixels math types timer module.
  function finished()
    return this.running == false and this.elapsed >= this.duration
  end function
end struct

/// Represents the random data used by the minipixels math types module.
struct Random
  /// Stores the seed value associated with random.
  seed

  /// Performs the nextInt operation for the minipixels math types random module.
  /// @param minValue minValue value consumed by this operation.
  /// @param maxValue maxValue value consumed by this operation.
  function nextInt(minValue, maxValue)
    return randomNextInt(this, minValue, maxValue)
  end function

  /// Performs the nextFloat operation for the minipixels math types random module.
  function nextFloat()
    return randomNextFloat(this)
  end function

  /// Performs the chance operation for the minipixels math types random module.
  /// @param percent percent value consumed by this operation.
  function chance(percent)
    return this.nextInt(0, 99) < percent
  end function
end struct

/// Performs the vec2 operation for the minipixels math types module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function vec2(x, y)
  return Vector2(x, y)
end function

/// Performs the vec2i operation for the minipixels math types module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function vec2i(x, y)
  return Vector2Int(x, y)
end function

/// Performs the rect operation for the minipixels math types module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
function rect(x, y, w, h)
  return Rectangle(x, y, w, h)
end function

/// Performs the recti operation for the minipixels math types module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param w w value consumed by this operation.
/// @param h h value consumed by this operation.
function recti(x, y, w, h)
  return RectangleInt(floorInt(x), floorInt(y), floorInt(w), floorInt(h))
end function

/// Performs the transform2d operation for the minipixels math types module.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function transform2d(x, y)
  return Transform2D(x, y, 1, 1)
end function

/// Performs the floorInt operation for the minipixels math types module.
/// @param v v value consumed by this operation.
function floorInt(v)
  if typeof(v) == "int" then return v end if
  whole = v - (v % 1)
  if v < 0 and whole != v then
    whole = whole - 1
  end if
  return whole
end function

/// Performs the clamp operation for the minipixels math types module.
/// @param v v value consumed by this operation.
/// @param lo lo value consumed by this operation.
/// @param hi hi value consumed by this operation.
function clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/// Performs the abs operation for the minipixels math types module.
/// @param v v value consumed by this operation.
function abs(v)
  if v < 0 then return 0 - v end if
  return v
end function

/// Performs the vector2Add operation for the minipixels math types module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function vector2Add(a, b)
  return Vector2(a.x + b.x, a.y + b.y)
end function

/// Performs the vector2Subtract operation for the minipixels math types module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function vector2Subtract(a, b)
  return Vector2(a.x - b.x, a.y - b.y)
end function

/// Performs the vector2Multiply operation for the minipixels math types module.
/// @param a a value consumed by this operation.
/// @param s s value consumed by this operation.
function vector2Multiply(a, s)
  return Vector2(a.x * s, a.y * s)
end function

/// Performs the vector2Length operation for the minipixels math types module.
/// @param a a value consumed by this operation.
function vector2Length(a)
  return ((a.x * a.x) + (a.y * a.y)) / 1.0
end function

/// Performs the vector2Normalize operation for the minipixels math types module.
/// @param a a value consumed by this operation.
function vector2Normalize(a)
  l = vector2Length(a)
  if l == 0 then return Vector2(0, 0) end if
  return Vector2(a.x / l, a.y / l)
end function

/// Performs the rectangleContainsPoint operation for the minipixels math types module.
/// @param r r value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
function rectangleContainsPoint(r, x, y)
  return x >= r.x and y >= r.y and x < r.x + r.width and y < r.y + r.height
end function

/// Performs the rectangleIntersects operation for the minipixels math types module.
/// @param a a value consumed by this operation.
/// @param b b value consumed by this operation.
function rectangleIntersects(a, b)
  if a.x + a.width <= b.x then return false end if
  if b.x + b.width <= a.x then return false end if
  if a.y + a.height <= b.y then return false end if
  if b.y + b.height <= a.y then return false end if
  return true
end function

/// Performs the rgba operation for the minipixels math types module.
/// @param r r value consumed by this operation.
/// @param g g value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param a a value consumed by this operation.
function rgba(r, g, b, a)
  if typeof(r) != "int" then r = 0 end if
  if typeof(g) != "int" then g = 0 end if
  if typeof(b) != "int" then b = 0 end if
  if typeof(a) != "int" then a = 0 end if
  r = clamp(r, 0, 255)
  g = clamp(g, 0, 255)
  b = clamp(b, 0, 255)
  a = clamp(a, 0, 255)
  return (r << 24) | (g << 16) | (b << 8) | a
end function

/// Performs the rgb operation for the minipixels math types module.
/// @param r r value consumed by this operation.
/// @param g g value consumed by this operation.
/// @param b b value consumed by this operation.
function rgb(r, g, b)
  return rgba(r, g, b, 255)
end function

/// Performs the colorR operation for the minipixels math types module.
/// @param c c value consumed by this operation.
function inline colorR(c)
  return (c >> 24) & 255
end function

/// Performs the colorG operation for the minipixels math types module.
/// @param c c value consumed by this operation.
function inline colorG(c)
  return (c >> 16) & 255
end function

/// Performs the colorB operation for the minipixels math types module.
/// @param c c value consumed by this operation.
function inline colorB(c)
  return (c >> 8) & 255
end function

/// Performs the colorA operation for the minipixels math types module.
/// @param c c value consumed by this operation.
function inline colorA(c)
  return c & 255
end function

/// Performs the tintChannel operation for the minipixels math types module.
/// @param src src value consumed by this operation.
/// @param tint tint value consumed by this operation.
function tintChannel(src, tint)
  return (src * tint) / 255
end function

/// Performs the tintColor operation for the minipixels math types module.
/// @param c c value consumed by this operation.
/// @param tint tint value consumed by this operation.
function tintColor(c, tint)
  return rgba(
    tintChannel(colorR(c), colorR(tint)),
    tintChannel(colorG(c), colorG(tint)),
    tintChannel(colorB(c), colorB(tint)),
    tintChannel(colorA(c), colorA(tint))
  )
end function

/// Performs the alphaBlend operation for the minipixels math types module.
/// @param dst dst value consumed by this operation.
/// @param src src value consumed by this operation.
function alphaBlend(dst, src)
  sa = colorA(src)
  if sa <= 0 then return dst end if
  if sa >= 255 then return src end if
  inv = 255 - sa
  r = floorInt(((colorR(src) * sa) + (colorR(dst) * inv)) / 255)
  g = floorInt(((colorG(src) * sa) + (colorG(dst) * inv)) / 255)
  b = floorInt(((colorB(src) * sa) + (colorB(dst) * inv)) / 255)
  return rgba(r, g, b, 255)
end function

/// Performs the timerCreate operation for the minipixels math types module.
/// @param seconds seconds value consumed by this operation.
/// @param repeat repeat value consumed by this operation.
function timerCreate(seconds, repeat)
  return Timer(seconds, 0, false, repeat)
end function

/// Performs the timerUpdate operation for the minipixels math types module.
/// @param t t value consumed by this operation.
/// @param dt dt value consumed by this operation.
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

/// Performs the randomCreate operation for the minipixels math types module.
/// @param seed seed value consumed by this operation.
function randomCreate(seed)
  if typeof(seed) != "int" then seed = 1 end if
  if seed == 0 then seed = 1 end if
  return Random(seed)
end function

/// Performs the randomStep operation for the minipixels math types module.
/// @param r r value consumed by this operation.
function randomStep(r)
  r.seed = ((r.seed * 1103515245) + 12345) & 0x7FFFFFFF
  return r.seed
end function

/// Performs the randomNextInt operation for the minipixels math types module.
/// @param r r value consumed by this operation.
/// @param minValue minValue value consumed by this operation.
/// @param maxValue maxValue value consumed by this operation.
function randomNextInt(r, minValue, maxValue)
  if maxValue < minValue then
    tmp = minValue
    minValue = maxValue
    maxValue = tmp
  end if
  span = maxValue - minValue + 1
  return minValue + (randomStep(r) % span)
end function

/// Performs the randomNextFloat operation for the minipixels math types module.
/// @param r r value consumed by this operation.
function randomNextFloat(r)
  return randomStep(r) / 2147483647.0
end function
