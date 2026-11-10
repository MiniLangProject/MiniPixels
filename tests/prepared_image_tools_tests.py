"""Build-time pixel fidelity, compact defaults, and corrupt-source rejection."""
import io
import struct
import sys
import tempfile
import unittest
import zlib
from contextlib import redirect_stderr
from pathlib import Path
from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import minipixels as cli


class PreparedImageTests(unittest.TestCase):
    def test_png_modes_preserve_rgba_and_use_compact_prepared_payloads(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for mode in ("RGBA", "RGB", "L", "LA", "P"):
                with self.subTest(mode=mode):
                    image = Image.new(mode, (32, 16))
                    if mode == "P":
                        image.putpalette([255, 0, 0, 0, 255, 0] + [0] * 762)
                        image.putdata([i % 2 for i in range(512)])
                    else:
                        image.paste(Image.new(mode, (16, 16), 127), (0, 0))
                    path = root / "image.png"
                    image.save(path, **({"transparency": bytes([255, 64])} if mode == "P" else {}))
                    with Image.open(path) as reference:
                        expected = reference.convert("RGBA").tobytes()
                    payload = cli.asset_pack_payload({"type": "image", "path": "image.png"}, root)
                    self.assertEqual(payload["codec"], cli.PACK_CODEC_DEFLATE)
                    cooked = zlib.decompress(payload["data"][8:])
                    self.assertEqual(cooked, b"MRI1" + struct.pack("<II", 32, 16) + expected)
                    raw = cli.asset_pack_payload({"type": "image", "path": "image.png", "compression": "none"}, root)
                    self.assertEqual(raw["codec"], cli.PACK_CODEC_NONE)
                    self.assertEqual(raw["data"], cooked)
                    fast = cli.asset_pack_payload({"type": "image", "path": "image.png", "compression": "fast"}, root)
                    self.assertEqual(fast["codec"], cli.PACK_CODEC_LZ4)

    def test_corrupt_png_is_not_silently_repacked(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bad.png"
            good = cli.write_png_rgba_store(2, 1, bytes([1, 2, 3, 255]) * 2)
            bad = bytearray(good)
            bad[29] ^= 1
            for data in (bad, good[:-15], b"not png"):
                path.write_bytes(data)
                with redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                    cli.read_png_rgba(path)

    def test_prepared_dimensions_are_bounded(self):
        for width, height, pixels in ((0, 1, b""), (2**32, 2**32, b""), (1, 1, b"abc")):
            with redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                cli.prepared_image(width, height, pixels)


if __name__ == "__main__":
    unittest.main()
