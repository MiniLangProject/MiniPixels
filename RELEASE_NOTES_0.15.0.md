# MiniPixels 0.15.0

This release improves MPX asset loading while keeping packs compact and game code unchanged. It requires MiniLang Compiler 1.2.9 or newer.

## Faster asset loading

- MPX1 opens its bounded index in bulk rather than reading each entry separately.
- `preload()` and named preload groups read adjacent assets in bounded file-order batches. `resident` mode can load the pack on first use without retaining a second copy of the stored file.
- Decoded payloads for deduplicated entries are shared. Pack statistics now expose physical bytes read, logical bytes decoded, and bulk read counts.
- Native zlib/Deflate decoding writes directly into the final buffer for PNG and MPX payloads, with the portable decoder retained as a fallback.

## Size and latency controls

- MiniLang Compiler 1.2.9's portable LZ4 block decoder powers the `fast` compression profile. The Python `auto` profile selects LZ4 for `.sprites` and `.rgba` file assets of at least 64 KiB; other file/text/data assets remain size-oriented with Deflate/RLE. The native generator chooses between LZ4 and RLE for `auto` and `small`.
- `assetLoading` supports `lazy` or `resident`, a bounded `batchBytes`, and the `auto`, `fast`, `small`, and `none` compression profiles. Assets can override the default and opt into named preload groups.
- Existing Deflate/RLE MPX entries remain readable. Protected MPX3 packs still authenticate each encrypted payload before decoding it.

## Verification

The complete Windows x64 and Linux x64 test suites pass with compiler 1.2.9, including LZ4 roundtrips from both packers, deduplicated entries, protected MPX3 loading and tamper rejection. The strict MiniDoc HTML and Markdown references were regenerated without warnings.
