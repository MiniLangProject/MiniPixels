import minipixels as mp
#if TARGET_OS == "windows"
import minipixels.platform.windows as win
#else
import minipixels.platform.linux as win
#endif

function main(args)
  path = "build/assets.mpx"
  if len(args) >= 1 then path = args[0] end if
  pack = try(mp.openAssetPack(path))
  if typeof(pack) == "error" then
    print "asset-load ERROR " + pack.message
    return 1
  end if
  start = win.ticks()
  loaded = try(mp.preloadAssetPack(pack, 16777216))
  elapsed = win.ticks() - start
  if typeof(loaded) == "error" then
    print "asset-load ERROR " + loaded.message
    mp.closeAssetPack(pack)
    return 1
  end if
  stats = mp.assetPackStats(pack)
  mib = stats.decodedBytes / 1048576.0
  seconds = elapsed / 1000.0
  throughput = 0
  if seconds > 0 then throughput = mib / seconds end if
  print "asset-load entries=" + stats.entries + " storedBytes=" + stats.storedBytesRead + " decodedBytes=" + stats.decodedBytes
  print "asset-load bulkReads=" + stats.bulkReads + " elapsedMs=" + elapsed + " decodedMiB/s=" + throughput
  mp.closeAssetPack(pack)
  return 0
end function
