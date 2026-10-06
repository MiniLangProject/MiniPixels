import minipixels.assets.pack as packs
import std.assert as a

struct OffsetFixture
  offsets
end struct

function main(args)
  offsets = array(8193, 0)
  reversed = array(8193, 0)
  for i = 0 to 8192
    offsets[i] = i * 16
    reversed[i] = 8192 - i
  end for
  fixture = OffsetFixture(offsets)
  packs._sortSlotsByOffset(fixture, reversed, len(reversed))
  sorted = true
  for i = 0 to 8192
    if reversed[i] != i then sorted = false end if
  end for
  a.assertTrue(sorted, "large reversed preload order sorts correctly")
  packs._sortSlotsByOffset(fixture, reversed, 1)
  packs._sortSlotsByOffset(fixture, [], 0)
  tied = [2, 0, 1]
  packs._sortSlotsByOffset(OffsetFixture([7, 7, 7]), tied, 3)
  a.assertEq(tied, [2, 0, 1], "equal offsets retain stable order")
  pack = packs.open("build/tests/preload.mpx")
  a.assertTrue(typeof(pack) != "error", "preload regression pack opens")
  first = packs.find(pack, "a")
  last = packs.find(pack, "c")
  alias = packs.find(pack, "e_alias")
  // Unsorted slots, duplicates and aliases must not include the skipped movie.
  a.assertTrue(packs.preloadSlots(pack, [last, alias, first, last], 16777216), "sparse preload succeeds")
  stats = packs.stats(pack)
  a.assertEq(stats.storedBytesRead, 8192, "preload never reads unrequested video gap")
  a.assertEq(stats.bulkReads, 2, "gap splits physical batches")
  a.assertEq(stats.decodedBytes, 8192, "aliases decode once")
  a.assertEq(packs.getBytesAt(pack, first)[0], 65, "first entry preserved")
  a.assertEq(packs.getBytesAt(pack, last)[4095], 67, "last entry preserved")
  a.assertEq(packs.getBytesAt(pack, alias), packs.getBytesAt(pack, first), "alias shares buffer")
  a.assertTrue(packs.preloadSlots(pack, [first, last, alias], 65536), "cached preload succeeds")
  a.assertEq(packs.stats(pack).storedBytesRead, 8192, "cached preload does no physical IO")
  packs.close(pack)

  pack = packs.open("build/tests/preload.mpx")
  large = packs.find(pack, "d_large")
  a.assertTrue(packs.preloadSlots(pack, [large], 65536), "large first entry preloads")
  stats = packs.stats(pack)
  a.assertEq(stats.storedBytesRead, 2097169, "large entry exact byte count")
  a.assertEq(stats.bulkReads, 33, "large first entry obeys 64 KiB read limit including tail")
  a.assertEq(stats.decodedBytes, 2097169, "large raw entry materializes once")
  content = packs.getBytesAt(pack, large)
  a.assertEq(len(content), 2097169, "large raw buffer has final size")
  a.assertEq(content[0], 68, "large raw first byte")
  a.assertEq(content[65536], 68, "large raw read boundary")
  a.assertEq(content[2097168], 68, "large raw tail")
  empty = packs.find(pack, "f_empty")
  a.assertTrue(packs.preloadSlots(pack, [empty], 65536), "empty entry preloads")
  a.assertEq(len(packs.getBytesAt(pack, empty)), 0, "empty entry stays empty")
  a.assertEq(packs.stats(pack).bulkReads, 33, "empty entry needs no physical read")
  invalid = try(packs.preloadSlots(pack, [-1], 65536))
  a.assertTrue(typeof(invalid) == "error", "invalid preload slot rejected")
  packs.close(pack)
  print "=== ASSET PRELOAD REGRESSION TESTS DONE ==="
  return 0
end function
