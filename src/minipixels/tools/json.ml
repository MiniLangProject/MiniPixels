// SPDX-License-Identifier: Apache-2.0

//! Provides minipixels tools json facilities for this project.

package minipixels.tools.json

import std.ds.list as list
import std.string as str
import std.string_builder as sb

/// Represents the json value data used by the minipixels tools json module.
struct JsonValue
  /// Stores the kind value associated with json value.
  kind
  /// Stores the string value value associated with json value.
  stringValue
  /// Stores the number value value associated with json value.
  numberValue
  /// Stores the bool value value associated with json value.
  boolValue
  /// Stores the array items value associated with json value.
  arrayItems
  /// Stores the object keys value associated with json value.
  objectKeys
  /// Stores the object values value associated with json value.
  objectValues
end struct

/// Represents the parser data used by the minipixels tools json module.
struct Parser
  /// Stores the text value associated with parser.
  text
  /// Stores the pos value associated with parser.
  pos
  /// Stores the failed value associated with parser.
  failed
  /// Stores the message value associated with parser.
  message
end struct

/// Performs the value operation for the minipixels tools json module.
/// @param kind kind value consumed by this operation.
/// @param s s value consumed by this operation.
/// @param n n value consumed by this operation.
/// @param b b value consumed by this operation.
/// @param items Items consumed or updated by the operation.
/// @param keys keys value consumed by this operation.
/// @param vals vals value consumed by this operation.
function value(kind, s, n, b, items, keys, vals)
  return JsonValue(kind, s, n, b, items, keys, vals)
end function

/// Performs the null operation for the minipixels tools json module.
function null() return value("null", "", 0, false, [], [], []) end function
/// Performs the string operation for the minipixels tools json module.
/// @param s s value consumed by this operation.
function string(s) return value("string", s, 0, false, [], [], []) end function
/// Performs the number operation for the minipixels tools json module.
/// @param n n value consumed by this operation.
function number(n) return value("number", "", n, false, [], [], []) end function
/// Performs the bool operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
function bool(v) return value("bool", "", 0, v, [], [], []) end function
/// Performs the array operation for the minipixels tools json module.
/// @param items Items consumed or updated by the operation.
function array(items) return value("array", "", 0, false, items, [], []) end function
/// Performs the object operation for the minipixels tools json module.
/// @param keys keys value consumed by this operation.
/// @param vals vals value consumed by this operation.
function object(keys, vals) return value("object", "", 0, false, [], keys, vals) end function

/// Performs the parser operation for the minipixels tools json module.
/// @param text Text consumed by the operation.
function parser(text)
  return Parser(text, 0, false, "")
end function

/// Returns whether digit satisfies the required condition.
/// @param ch ch value consumed by this operation.
function isDigit(ch)
  return str.contains("0123456789", ch)
end function

/// Returns whether hex satisfies the required condition.
/// @param ch ch value consumed by this operation.
function isHex(ch)
  return str.contains("0123456789abcdefABCDEF", ch)
end function

/// Performs the atEnd operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
function atEnd(p)
  return p.pos >= len(p.text)
end function

/// Performs the peek operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
function peek(p)
  if atEnd(p) then return "" end if
  return p.text[p.pos]
end function

/// Performs the advance operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
function advance(p)
  ch = peek(p)
  p.pos = p.pos + 1
  return ch
end function

/// Updates error maintained by the minipixels tools json module.
/// @param p p value consumed by this operation.
/// @param msg msg value consumed by this operation.
function setError(p, msg)
  if p.failed == false then
    p.failed = true
    p.message = msg
  end if
  return
end function

/// Performs the skipWhitespace operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
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

/// Performs the lineCol operation for the minipixels tools json module.
/// @param text Text consumed by the operation.
/// @param pos pos value consumed by this operation.
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

/// Parses error for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
function parseError(p)
  return error(9100, p.message + " at " + lineCol(p.text, p.pos))
end function

/// Performs the expect operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
/// @param ch ch value consumed by this operation.
/// @param msg msg value consumed by this operation.
function expect(p, ch, msg)
  if peek(p) != ch then
    setError(p, msg)
    return false
  end if
  p.pos = p.pos + 1
  return true
end function

/// Parses string value for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
function parseStringValue(p)
  if expect(p, "\"", "expected string") == false then return end if
  result = sb.StringBuilder.withCapacity(32)
  while atEnd(p) == false
    ch = advance(p)
    if ch == "\"" then
      return string(result.toString())
    end if
    if ch == "\\" then
      if atEnd(p) then
        setError(p, "unterminated escape sequence")
        return
      end if
      esc = advance(p)
      if esc == "\"" then result.appendString("\"")
      else if esc == "\\" then result.appendString("\\")
      else if esc == "/" then result.appendString("/")
      else if esc == "b" then result.appendString("?")
      else if esc == "f" then result.appendString("?")
      else if esc == "n" then result.appendString("\n")
      else if esc == "r" then result.appendString("\r")
      else if esc == "t" then result.appendString("\t")
      else if esc == "u" then
        for i = 0 to 3
          if atEnd(p) or isHex(peek(p)) == false then
            setError(p, "invalid unicode escape")
            return
          end if
          p.pos = p.pos + 1
        end for
        result.appendString("?")
      else
        setError(p, "invalid escape sequence")
        return
      end if
    else
      result.appendString(ch)
    end if
  end while
  setError(p, "unterminated string")
  return
end function

/// Performs the matchLiteral operation for the minipixels tools json module.
/// @param p p value consumed by this operation.
/// @param lit lit value consumed by this operation.
function matchLiteral(p, lit)
  n = len(lit)
  if p.pos + n > len(p.text) then return false end if
  if str.substr(p.text, p.pos, n) != lit then return false end if
  p.pos = p.pos + n
  return true
end function

/// Parses number value for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
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

/// Parses array value for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
function parseArrayValue(p)
  expect(p, "[", "expected array")
  items = list.List.new()
  skipWhitespace(p)
  if peek(p) == "]" then
    p.pos = p.pos + 1
    return array(items.toArray())
  end if
  while p.failed == false
    item = parseValue(p)
    if p.failed then return end if
    items.add(item)
    skipWhitespace(p)
    ch = peek(p)
    if ch == "]" then
      p.pos = p.pos + 1
      return array(items.toArray())
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

/// Parses object value for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
function parseObjectValue(p)
  expect(p, "{", "expected object")
  keys = list.List.new()
  vals = list.List.new()
  skipWhitespace(p)
  if peek(p) == "}" then
    p.pos = p.pos + 1
    return object(keys.toArray(), vals.toArray())
  end if
  while p.failed == false
    key = parseStringValue(p)
    if p.failed then return end if
    skipWhitespace(p)
    if expect(p, ":", "expected ':' after object key") == false then return end if
    skipWhitespace(p)
    val = parseValue(p)
    if p.failed then return end if
    keys.add(key.stringValue)
    vals.add(val)
    skipWhitespace(p)
    ch = peek(p)
    if ch == "}" then
      p.pos = p.pos + 1
      return object(keys.toArray(), vals.toArray())
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

/// Parses value for the minipixels tools json workflow.
/// @param p p value consumed by this operation.
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

/// Parses parse for the minipixels tools json workflow.
/// @param text Text consumed by the operation.
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

/// Returns get maintained by the minipixels tools json module.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
function get(obj, key)
  if obj is not JsonValue then return end if
  if obj.kind != "object" then return end if
  if len(obj.objectKeys) <= 0 then return end if
  for i = 0 to len(obj.objectKeys) - 1
    if obj.objectKeys[i] == key then return obj.objectValues[i] end if
  end for
  return
end function

/// Returns whether has is available.
/// @param obj obj value consumed by this operation.
/// @param key key value consumed by this operation.
function has(obj, key)
  return typeof(get(obj, key)) != "void"
end function

/// Performs the at operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
/// @param index Zero-based index of the affected item.
function at(v, index)
  if v is not JsonValue then return end if
  if v.kind != "array" then return end if
  if index < 0 or index >= len(v.arrayItems) then return end if
  return v.arrayItems[index]
end function

/// Performs the asString operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function asString(v, fallback)
  if v is JsonValue and v.kind == "string" then return v.stringValue end if
  return fallback
end function

/// Performs the asNumber operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function asNumber(v, fallback)
  if v is JsonValue and v.kind == "number" then return v.numberValue end if
  return fallback
end function

/// Performs the asBool operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
/// @param fallback Value returned when no explicit result is available.
function asBool(v, fallback)
  if v is JsonValue and v.kind == "bool" then return v.boolValue end if
  return fallback
end function

/// Performs the lenOf operation for the minipixels tools json module.
/// @param v v value consumed by this operation.
function lenOf(v)
  if v is not JsonValue then return 0 end if
  if v.kind == "array" then return len(v.arrayItems) end if
  if v.kind == "object" then return len(v.objectKeys) end if
  return 0
end function
