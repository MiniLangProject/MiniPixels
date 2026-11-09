# MiniPixels 0.20.1

This maintenance release makes MiniPixels build with MiniLang Compiler 1.3.3
and stabilizes Linux window tests.

## Compiler compatibility

- The compiler baseline is MiniLangCompilerPy 1.3.3. Both CI targets pin its
  release commit `25f168e02d9e0ef7c33d7ac37c3ec83779308d02`.
- `AssetPack.protected` is now `AssetPack.isProtected`, because `protected`
  is a reserved visibility keyword. Update direct field accesses in game code;
  generated asset APIs and MPX formats are unchanged.
- The engine version query, native CLI, and SDK now consistently report 0.20.1.

## Reliability and documentation

- Xvfb runs with `-noreset` so closing the last window cannot reset the display
  server before the next window opens. The presenter test exercises eight
  close/reopen cycles followed by native render resolution.
- Asset regressions check plain/protected pack state and verify that closing
  a protected pack overwrites the retained AES key.
- README, changelog, and generated MiniDoc references have been refreshed.

## Validation

The complete Windows x64 and Linux x64/WSL test suites pass with Compiler 1.3.3.
All six examples and all three native CLI templates build on both targets.
Eight captured example scenes are pixel-identical between Windows and Linux.
Windows GPU framebuffer tests, Linux GPU fallback, and Linux X11 window tests
pass. Strict MiniDoc validation reports zero warnings.

The GitHub SDK is published only after both platform CI jobs succeed. The
download contains the source SDK, examples, tools, and documentation, with a
SHA-256 checksum alongside it; the compiler is installed separately.

See the [changelog](https://github.com/MiniLangProject/MiniPixels/blob/v0.20.1/CHANGELOG.md).
