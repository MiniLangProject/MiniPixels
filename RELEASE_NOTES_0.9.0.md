# MiniPixels 0.9.0

MiniPixels 0.9.0 adds a transparent protected-asset pipeline and completes the
Windows/Linux engine workflow introduced after 0.8.0.

## Protected assets

The Python build driver can now wrap the complete MPX1 asset container in an
MPX2 envelope. Each protected build uses a new AES-256-GCM key and signs the
header, ciphertext, and authentication tag with ECDSA P-256/SHA-256. The game
verifies the signature before decryption and fails closed for modified,
truncated, malformed, or wrongly keyed packs.

The private signing key remains on the build host. Generated MiniLang code
contains only the public verification key, its identifier, and an obfuscated
reconstruction of the per-build AES key. This is intended to deter casual asset
extraction and reliably detect unauthorized pack changes; client-side key
material can still be recovered by a determined attacker.

Initialize protection once, then keep using the ordinary build commands:

```powershell
python -m pip install -r requirements.txt
python tools\minipixels.py security init path\to\minipixels.json
python tools\minipixels.py build path\to\minipixels.json --compiler ..\MiniLangCompilerPy\mlc_win64.py
```

CI may supply the signing key through `MINIPIXELS_ASSET_SIGNING_KEY` or
`MINIPIXELS_ASSET_SIGNING_KEY_FILE`. Protected builds require a
`MiniLangCompilerPy` revision containing `std.crypto.ecdsa_p256`; the matching
support was added to its `main` branch together with this release.

## New asset types

- `text`: deterministic UTF-8 catalogs with numbered placeholders and
  exact, language-only, then default-locale fallback.
- `data`: canonical UTF-8 JSON stored in the runtime pack.
- `constants`: JSON converted into generated MiniLang scalar constants and a
  structured `data()` accessor, with no runtime pack entry.

The native MiniLang generator supports unprotected image, procedural, audio,
file, text, and data packs. Protected packs and compiled constants are produced
by the Python end-to-end driver.

## Platform and verification

ECDSA verification uses Windows CNG and OpenSSL 3 on Linux. The release was
validated with the full MiniPixels suite, protected-pack tamper and wrong-key
tests, every example build, and native CLI builds on both Windows x64 and Linux
x64. The committed MiniDoc API reference is warning-free and reproducible.
