import minipixels.graphics.canvas as canvas
import std.test as test

function scalar(destination, source, di, si)
  alpha = source[si + 3]
  if alpha == 0 then return end if
  da = destination[di + 3]
  if alpha == 255 or da == 0 then
    copyBytes(destination, di, source, si, 4)
    return
  end if
  inverse = 255 - alpha
  coverage = alpha * 255 + da * inverse
  outAlpha = coverage div 255
  for channel = 0 to 2
    destination[di + channel] = (source[si + channel] * alpha * 255 + destination[di + channel] * da * inverse) div coverage
  end for
  destination[di + 3] = outAlpha
end function

function mixedTargetRows()
  width = 256
  source = bytes((width + 2) * 4, 91)
  destination = bytes((width + 2) * 4, 73)
  expected = bytes(len(destination), 0)
  mismatches = 0
  for each destinationAlpha in [0, 1, 127, 254, 255]
    for each component in [0, 1, 63, 127, 128, 254, 255]
      for alpha = 0 to 255
        offset = (alpha + 1) * 4
        source[offset] = component
        source[offset + 1] = 255 - component
        source[offset + 2] = (component * 79 + alpha * 13) % 256
        source[offset + 3] = alpha
        destination[offset] = alpha
        destination[offset + 1] = (alpha * 67 + 1) % 256
        destination[offset + 2] = 255 - alpha
        destination[offset + 3] = destinationAlpha
      end for
      copyBytes(expected, 0, destination, 0, len(destination))
      for x = 1 to width
        scalar(expected, source, x * 4, x * 4)
      end for
      canvas.blendTransparentSpriteRow(destination, source, 4, 4, width)
      for offset = 0 to len(destination) - 1
        if destination[offset] != expected[offset] then mismatches = mismatches + 1 end if
      end for
    end for
  end for
  test.assertEqual(mismatches, 0, "opaque pixel fast path matches straight-alpha oracle and preserves row guards")
end function

function main(args)
  suite = test.Suite.new("Mixed-alpha destination rows")
  suite.add("all source alphas and destination boundaries", mixedTargetRows)
  return test.run([suite], args)
end function
