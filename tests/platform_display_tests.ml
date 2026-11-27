// SPDX-License-Identifier: Apache-2.0
import std.test as test
#if TARGET_OS == "windows"
import minipixels.platform.windows as platform
#else
import minipixels.platform.linux as platform
#endif

struct KeysOnly
  keyStates
end struct

function invalidWindowGuards()
  test.assertFalse(platform.isFullscreen(void))
  test.assertFalse(platform.setFullscreen(void, true))
  test.assertFalse(platform.keyDownForWindow(void, 162))
end function

#if TARGET_OS == "linux"
function sideSpecificModifiers()
  test.assertEqual(platform.keysymToVirtualKey(0xFFE3), 162)
  test.assertEqual(platform.keysymToVirtualKey(0xFFE4), 163)
  test.assertEqual(platform.keysymToVirtualKey(0xFFE1), 160)
  test.assertEqual(platform.keysymToVirtualKey(0xFFE2), 161)
  test.assertEqual(platform.keysymToVirtualKey(0xFFC8), 122)
  keys = KeysOnly(array(256, false))
  platform.setKeyState(keys, 162, true)
  test.assertTrue(keys.keyStates[162] and keys.keyStates[17])
  test.assertFalse(keys.keyStates[163])
  platform.setKeyState(keys, 163, true)
  platform.setKeyState(keys, 162, false)
  test.assertFalse(keys.keyStates[162])
  test.assertTrue(keys.keyStates[163] and keys.keyStates[17], "right Ctrl remains held when left is released")
  platform.setKeyState(keys, 163, false)
  test.assertFalse(keys.keyStates[17])
end function
#else
function highResolutionBitmapStride()
  info = platform.createBitmapInfo(2200, 1600)
  test.assertEqual(platform.getI32(info, 4), 2200)
  test.assertEqual(platform.getI32(info, 8), -1600)
end function
#endif

function main(args)
  suite = test.Suite.new("MiniPixels display and physical keys")
  suite.add("invalid native windows fail without API calls", invalidWindowGuards)
#if TARGET_OS == "linux"
  suite.add("physical modifier sides preserve generic aggregate state", sideSpecificModifiers)
#else
  suite.add("high-resolution GDI stride uses the physical framebuffer", highResolutionBitmapStride)
#endif
  return test.run([suite], args)
end function
