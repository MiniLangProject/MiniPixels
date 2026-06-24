package minipixels.tools.json

import std.array as arr
import std.string as str

struct JsonValue
  kind
  stringValue
  numberValue
  boolValue
  arrayItems
  objectKeys
  objectValues
end struct

struct Parser
  text
  pos
  failed
  message
end struct

function value(kind, s, n, b, items, keys, vals)
  return JsonValue(kind, s, n, b, items, keys, vals)
end function

function null() return value("null", "", 0, false, [], [], []) end function
function string(s) return value("string", s, 0, false, [], [], []) end function
function number(n) return value("number", "", n, false, [], [], []) end function
function bool(v) return value("bool", "", 0, v, [], [], []) end function
function array(items) return value("array", "", 0, false, items, [], []) end function
function object(keys, vals) return value("object", "", 0, false, [], keys, vals) end function

function parser(text)
  return Parser(text, 0, false, "")
end function

function isDigit(ch)
  return str.contains("0123456789", ch)
end function

function isHex(ch)
  return str.contains("0123456789abcdefABCDEF", ch)
end function

function atEnd(p)
  return p.pos >= len(p.text)
end function

function peek(p)
  if atEnd(p) then return "" end if
  return p.text[p.pos]
end function

function advance(p)
  ch = peek(p)
  p.pos = p.pos + 1
  return ch
end function

function setError(p, msg)
  if p.failed == false then
    p.failed = true
    p.message = msg
  end if
  return
end function

function skipWhitespace(p)
  while atEnd(p) == false
    ch = peek(p)
    if ch == " " or ch == "\t" or ch == "\r" or ch == "\n" then
      p.pos = p.pos + 1
    else
      return
    end if
  end while
end function

function lineCol(text, pos)
  line = 1
  col = 1
  i = 0
  while i < pos and i < len(text)
    if text[i] == "\n" then
      line = line + 1
      col = 1
    else
      col = col + 1
    end if
    i = i + 1
  end while
  return "line " + line + ", col " + col
end function

function parseError(p)
  return error(9100, p.message + " at " + lineCol(p.text, p.pos))
end function

function expect(p, ch, msg)
  if peek(p) != ch then
    setError(p, msg)
    return false
  end if
  p.pos = p.pos + 1
  return true
end function

function parseStringValue(p)
  if expect(p, "\"", "expected string") == false then return end if
  result = ""
  while atEnd(p) == false
    ch = advance(p)
    if ch == "\"" then
      return string(result)
    end if
    if ch == "\\" then
      if atEnd(p) then
        setError(p, "unterminated escape sequence")
        return
      end if
      esc = advance(p)
      if esc == "\"" then result = result + "\""
      else if esc == "\\" then result = result + "\\"
      else if esc == "/" then result = result + "/"
      else if esc == "b" then result = result + "?"
      else if esc == "f" then result = result + "?"
      else if esc == "n" then result = result + "\n"
      else if esc == "r" then result = result + "\r"
      else if esc == "t" then result = result + "\t"
      else if esc == "u" then
        for i = 0 to 3
          if atEnd(p) or isHex(peek(p)) == false then
            setError(p, "invalid unicode escape")
            return
          end if
          p.pos = p.pos + 1
        end for
        result = result + "?"
      else
        setError(p, "invalid escape sequence")
        return
      end if
    else
      result = result + ch
    end if
  end while
  setError(p, "unterminated string")
  return
end function

function matchLiteral(p, lit)
  n = len(lit)
  if p.pos + n > len(p.text) then return false end if
  if str.substr(p.text, p.pos, n) != lit then return false end if
  p.pos = p.pos + n
  return true
end function

function parseNumberValue(p)
  start = p.pos
  if peek(p) == "-" then p.pos = p.pos + 1 end if
  digits = 0
  while atEnd(p) == false and isDigit(peek(p))
    p.pos = p.pos + 1
    digits = digits + 1
  end while
  if digits == 0 then
    setError(p, "expected number digits")
    return
  end if
  if peek(p) == "." then
    p.pos = p.pos + 1
    frac = 0
    while atEnd(p) == false and isDigit(peek(p))
      p.pos = p.pos + 1
      frac = frac + 1
    end while
    if frac == 0 then
      setError(p, "expected fractional digits")
      return
    end if
  end if
  ch = peek(p)
  if ch == "e" or ch == "E" then
    p.pos = p.pos + 1
    sign = peek(p)
    if sign == "+" or sign == "-" then p.pos = p.pos + 1 end if
    exp = 0
    while atEnd(p) == false and isDigit(peek(p))
      p.pos = p.pos + 1
      exp = exp + 1
    end while
    if exp == 0 then
      setError(p, "expected exponent digits")
      return
    end if
  end if
  raw = str.substr(p.text, start, p.pos - start)
  n = toNumber(raw)
  if typeof(n) == "void" then
    setError(p, "invalid number")
    return
  end if
  return number(n)
end function

function parseArrayValue(p)
  expect(p, "[", "expected array")
  items = []
  skipWhitespace(p)
  if peek(p) == "]" then
    p.pos = p.pos + 1
    return array(items)
  end if
  while p.failed == false
    item = parseValue(p)
    if p.failed then return end if
    items = arr.append(items, item)
    skipWhitespace(p)
    ch = peek(p)
    if ch == "]" then
      p.pos = p.pos + 1
      return array(items)
    end if
    if ch != "," then
      setError(p, "expected ',' or ']'")
      return
    end if
    p.pos = p.pos + 1
    skipWhitespace(p)
  end while
  return
end function

function parseObjectValue(p)
  expect(p, "{", "expected object")
  keys = []
  vals = []
  skipWhitespace(p)
  if peek(p) == "}" then
    p.pos = p.pos + 1
    return object(keys, vals)
  end if
  while p.failed == false
    key = parseStringValue(p)
    if p.failed then return end if
    skipWhitespace(p)
    if expect(p, ":", "expected ':' after object key") == false then return end if
    skipWhitespace(p)
    val = parseValue(p)
    if p.failed then return end if
    keys = arr.append(keys, key.stringValue)
    vals = arr.append(vals, val)
    skipWhitespace(p)
    ch = peek(p)
    if ch == "}" then
      p.pos = p.pos + 1
      return object(keys, vals)
    end if
    if ch != "," then
      setError(p, "expected ',' or '}'")
      return
    end if
    p.pos = p.pos + 1
    skipWhitespace(p)
  end while
  return
end function

function parseValue(p)
  skipWhitespace(p)
  ch = peek(p)
  if ch == "\"" then return parseStringValue(p) end if
  if ch == "{" then return parseObjectValue(p) end if
  if ch == "[" then return parseArrayValue(p) end if
  if ch == "-" or isDigit(ch) then return parseNumberValue(p) end if
  if matchLiteral(p, "true") then return bool(true) end if
  if matchLiteral(p, "false") then return bool(false) end if
  if matchLiteral(p, "null") then return null() end if
  setError(p, "expected JSON value")
  return
end function

function parse(text)
  if typeof(text) != "string" then return error(9100, "parse: expected string") end if
  p = parser(text)
  v = parseValue(p)
  if p.failed then return parseError(p) end if
  skipWhitespace(p)
  if p.pos != len(p.text) then
    setError(p, "unexpected trailing characters")
    return parseError(p)
  end if
  return v
end function

function get(obj, key)
  if obj is not JsonValue then return end if
  if obj.kind != "object" then return end if
  if len(obj.objectKeys) <= 0 then return end if
  for i = 0 to len(obj.objectKeys) - 1
    if obj.objectKeys[i] == key then return obj.objectValues[i] end if
  end for
  return
end function

function has(obj, key)
  return typeof(get(obj, key)) != "void"
end function

function at(v, index)
  if v is not JsonValue then return end if
  if v.kind != "array" then return end if
  if index < 0 or index >= len(v.arrayItems) then return end if
  return v.arrayItems[index]
end function

function asString(v, fallback)
  if v is JsonValue and v.kind == "string" then return v.stringValue end if
  return fallback
end function

function asNumber(v, fallback)
  if v is JsonValue and v.kind == "number" then return v.numberValue end if
  return fallback
end function

function asBool(v, fallback)
  if v is JsonValue and v.kind == "bool" then return v.boolValue end if
  return fallback
end function

function lenOf(v)
  if v is not JsonValue then return 0 end if
  if v.kind == "array" then return len(v.arrayItems) end if
  if v.kind == "object" then return len(v.objectKeys) end if
  return 0
end function
