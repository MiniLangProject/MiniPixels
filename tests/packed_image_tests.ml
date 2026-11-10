import minipixels.assets.packed_image as prepared
import minipixels.assets.png as png
import minipixels.assets.pack as pack
import std.bytes as by
import std.assert as a
import std.fs as fs
import std.compress.lz4 as lz4
import std.checksum.crc32 as crc

function main(args)
  source = fs.readAllBytes("build/tests/png/dynamic_filters.png")
  original = png.decode(source, "original")
  encoded = prepared.encode(original.width, original.height, original.pixels)
  restored = prepared.decode(encoded, "restored")
  a.assertEq(restored.width, original.width, "prepared image width")
  a.assertEq(restored.height, original.height, "prepared image height")
  a.assertEq(crc.compute(restored.pixels), crc.compute(original.pixels), "prepared RGBA is pixel-identical")
  a.assertEq(restored.opaque, false, "prepared image preserves transparency")
  opaque = prepared.decode(prepared.encode(2, 2, bytes(16, 255)), "opaque")
  a.assertTrue(opaque.opaque, "prepared opaque pixels detected")
  legacy = prepared.decode(source, "png")
  a.assertEq(crc.compute(legacy.pixels), crc.compute(original.pixels), "ordinary PNG pack payload still loads")

  a.assertTrue(typeof(try(prepared.decode(bytes(11, 0), "short"))) == "error", "truncated prepared header rejected")
  a.assertTrue(typeof(try(prepared.decode(slice(encoded, 0, len(encoded) - 1), "short"))) == "error", "truncated pixels rejected")
  extra = bytes(len(encoded) + 1, 0)
  copyBytes(extra, 0, encoded, 0, len(encoded))
  a.assertTrue(typeof(try(prepared.decode(extra, "extra"))) == "error", "trailing pixels rejected")
  encoded[3] = 50
  a.assertTrue(typeof(try(prepared.decode(encoded, "version"))) == "error", "unknown image version rejected")
  encoded[3] = 49
  by.writeU32LE(encoded, 4, 0)
  a.assertTrue(typeof(try(prepared.decode(encoded, "zero"))) == "error", "zero width rejected")
  by.writeU32LE(encoded, 4, 4294967295)
  by.writeU32LE(encoded, 8, 4294967295)
  a.assertTrue(typeof(try(prepared.decode(encoded, "overflow"))) == "error", "dimension overflow rejected before allocation")
  a.assertTrue(typeof(try(prepared.encode(1, 1, bytes(3, 0)))) == "error", "encode requires complete RGBA")

  for size = 0 to 32
    input = bytes(size * 513, 0)
    if len(input) > 0 then
      for i = 0 to len(input) - 1
        input[i] = (i * 13 + (i >> 6)) % 251
      end for
    end if
    block = lz4.encode(input)
    envelope = bytes(len(block) + 17, 0)
    envelope[5] = 77; envelope[6] = 80; envelope[7] = 76; envelope[8] = 49
    by.writeU32LE(envelope, 9, len(input))
    copyBytes(envelope, 13, block, 0, len(block))
    decoded = pack._decodePayloadRange(pack.CODEC_LZ4, envelope, 5, len(block) + 8, len(input))
    a.assertEq(len(decoded), len(input), "native LZ4 exact output length")
    a.assertEq(crc.compute(decoded), crc.compute(input), "native LZ4 matches MiniLang encoder at nonzero offset")
  end for
  invalid = bytes(9, 0)
  invalid[0] = 77; invalid[1] = 80; invalid[2] = 76; invalid[3] = 49
  by.writeU32LE(invalid, 4, 3)
  a.assertTrue(typeof(try(pack._decodePayloadRange(pack.CODEC_LZ4, invalid, 0, 9, 3))) == "error", "LZ4 output mismatch rejected")
  a.assertTrue(typeof(try(pack._decodePayloadRange(pack.CODEC_LZ4, invalid, 0, 10, 3))) == "error", "LZ4 input range rejected")
  by.writeU32LE(invalid, 4, pack.MAX_DECOMPRESSED_ASSET_SIZE + 1)
  a.assertTrue(typeof(try(pack._decodePayloadRange(pack.CODEC_LZ4, invalid, 0, 9, -1))) == "error", "LZ4 allocation limit enforced")
  print "=== PACKED IMAGE AND NATIVE LZ4 TESTS DONE ==="
  return 0
end function
