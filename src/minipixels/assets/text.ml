// SPDX-License-Identifier: Apache-2.0

//! UTF-8 localization catalogs stored inside MiniPixels asset packs.

package minipixels.assets.text

import std.bytes as by
import std.ds.hashmap as hm
import std.string as strings
import minipixels.assets.pack as packs

const TEXT_ERR = 9303

/// Immutable lookup table decoded from one localized MPT1 pack entry.
struct TextCatalog
  locale
  values

  /// Return the localized value for a key, or void when it is absent.
  /// @param name Translation key.
  function get(name)
    return this.values.get(name)
  end function

  /// Return whether the catalog contains a translation key.
  /// @param name Translation key.
  function has(name)
    return this.values.has(name)
  end function
end struct

/// Selects catalogs with regional and default-locale fallback.
struct Localization
  catalogs
  defaultLocale
  locale

  /// Register or replace a locale catalog.
  /// @param catalog TextCatalog to register.
  function add(catalog)
    if not (catalog is TextCatalog) then return false end if
    this.catalogs.set(catalog.locale, catalog)
    return true
  end function

  /// Select the locale used by text and format lookups.
  /// @param locale Locale name such as de or de-DE.
  function setLocale(locale)
    if typeof(locale) != "string" or len(locale) == 0 then return false end if
    this.locale = locale
    return true
  end function

  /// Resolve an exact, base-language, or default catalog.
  /// @param locale Requested locale.
  function resolveCatalog(locale)
    catalog = this.catalogs.get(locale)
    if catalog is TextCatalog then return catalog end if
    separator = strings.indexOf(locale, "-", 0)
    if separator < 0 then separator = strings.indexOf(locale, "_", 0) end if
    if separator > 0 then
      catalog = this.catalogs.get(strings.substr(locale, 0, separator))
      if catalog is TextCatalog then return catalog end if
    end if
    return this.catalogs.get(this.defaultLocale)
  end function

  /// Return translated text, falling back to the key when it is absent.
  /// @param name Translation key.
  function text(name)
    catalog = this.resolveCatalog(this.locale)
    if catalog is TextCatalog then
      value = catalog.get(name)
      if typeof(value) == "string" then return value end if
    end if
    fallback = this.catalogs.get(this.defaultLocale)
    if fallback is TextCatalog then
      value = fallback.get(name)
      if typeof(value) == "string" then return value end if
    end if
    return name
  end function

  /// Replace numbered placeholders in translated text.
  /// @param name Translation key.
  /// @param values Array used for placeholders {0}, {1}, and so on.
  function format(name, values)
    result = this.text(name)
    if typeof(values) != "array" then return result end if
    if len(values) == 0 then return result end if
    for i = 0 to len(values) - 1
      result = strings.replaceAll(result, "{" + i + "}", "" + values[i])
    end for
    return result
  end function
end struct

/// Create a text-catalog decoding error.
/// @param message Human-readable error message.
function textError(message)
  return error(TEXT_ERR, message)
end function

/// Return whether a byte range lies inside the supplied buffer.
/// @param data Byte buffer.
/// @param offset First byte offset.
/// @param size Number of bytes.
function hasRange(data, offset, size)
  return typeof(data) == "bytes" and offset >= 0 and size >= 0 and offset + size <= len(data)
end function

/// Decode a deterministic MPT1 catalog payload.
/// @param data Encoded MPT1 bytes.
/// @param locale Locale assigned to the resulting catalog.
function decodeCatalog(data, locale)
  if not hasRange(data, 0, 8) then return textError("text catalog is truncated") end if
  if data[0] != 77 or data[1] != 80 or data[2] != 84 or data[3] != 49 then return textError("invalid text catalog") end if
  count = by.readU32LE(data, 4)
  if typeof(count) != "int" or count < 0 then return textError("invalid text catalog count") end if
  values = hm.HashMap.withCapacity(count * 2 + 1)
  pos = 8
  i = 0
  while i < count
    if not hasRange(data, pos, 6) then return textError("text catalog entry is truncated") end if
    nameLength = by.readU16LE(data, pos)
    valueLength = by.readU32LE(data, pos + 2)
    pos = pos + 6
    if nameLength <= 0 or not hasRange(data, pos, nameLength + valueLength) then return textError("invalid text catalog entry") end if
    name = decode(slice(data, pos, nameLength))
    pos = pos + nameLength
    value = decode(slice(data, pos, valueLength))
    pos = pos + valueLength
    if typeof(name) != "string" or typeof(value) != "string" then return textError("text catalog is not valid UTF-8") end if
    if values.has(name) then return textError("duplicate text key: " + name) end if
    values.set(name, value)
    i = i + 1
  end while
  if pos != len(data) then return textError("text catalog has trailing data") end if
  return TextCatalog(locale, values)
end function

/// Load a text catalog directly from an asset pack entry.
/// @param pack Open asset pack.
/// @param name Packed text asset id.
/// @param locale Locale assigned to the resulting catalog.
function load(pack, name, locale)
  slot = packs.find(pack, name)
  if slot < 0 then return textError("text asset not found: " + name) end if
  return loadAt(pack, slot, locale)
end function

/// Load a text catalog through a pre-resolved pack slot.
/// @param pack Open asset pack.
/// @param slot Stable entry slot generated at build time.
/// @param locale Locale assigned to the resulting catalog.
function loadAt(pack, slot, locale)
  data = packs.getBytesAt(pack, slot)
  if typeof(data) == "error" then return data end if
  catalog = decodeCatalog(data, locale)
  if typeof(catalog) != "error" then packs.dropPayloadAt(pack, slot) end if
  return catalog
end function

/// Create a localization service with a default locale.
/// @param defaultLocale Locale used when the requested catalog or key is absent.
function create(defaultLocale)
  return Localization(hm.HashMap.withCapacity(8), defaultLocale, defaultLocale)
end function
