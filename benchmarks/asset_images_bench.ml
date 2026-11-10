// Compile against src and the compiler stdlib, then pass an unprotected MPX.
// Each iteration opens a fresh engine cache; the OS file cache remains warm.
import minipixels.assets.pack as pack
import std.checksum.crc32 as crc
import std.array as arr
#if TARGET_OS == "windows"
import minipixels.platform.windows as clock
#else
import minipixels.platform.linux as clock
#endif

function main(args)
  if len(args) < 1 then
    print "usage: asset_images_bench <unprotected.mpx>"
    return 1
  end if
  for iteration = 0 to 5
    start = clock.seconds()
    assets = pack.open(args[0])
    opened = clock.seconds()
    slots = []
    if assets.count > 0 then
      for i = 0 to assets.count - 1
        if assets.kinds[i] == 1 then slots = arr.append(slots, i) end if
      end for
    end if
    pack.preloadSlots(assets, slots, 16777216)
    loaded = clock.seconds()
    images = array(len(slots), void)
    if len(slots) > 0 then
      for i = 0 to len(slots) - 1
        images[i] = pack.loadPngAt(assets, slots[i])
      end for
    end if
    finished = clock.seconds()
    hash = 0
    if len(images) > 0 then
      for i = 0 to len(images) - 1
        // Order-independent so equivalent packs with different slot order compare.
        hash = (hash + crc.compute(images[i].pixels)) & 4294967295
      end for
    end if
    print "images=" + len(images) + " iteration=" + iteration + " openMs=" + ((opened-start)*1000) + " payloadMs=" + ((loaded-opened)*1000) + " imageMs=" + ((finished-loaded)*1000) + " totalMs=" + ((finished-start)*1000) + " crc=" + hash
    pack.close(assets)
  end for
  return 0
end function
