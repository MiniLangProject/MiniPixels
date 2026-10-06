"""MPX3 v6 index commitments, including chunk boundaries and deduplication."""
import hashlib
from pathlib import Path
import struct
import sys
import unittest

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import encode_dss_signature
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from asset_security import protect_pack


class ProtectedIndexTests(unittest.TestCase):
    def test_chunk_commitments_and_shared_payloads(self):
        signing_key = ec.generate_private_key(ec.SECP256R1())
        for size in (0, 1, 262144, 524289):
            with self.subTest(size=size):
                payload = b"a" * size
                names = (b"media", b"alias", b"empty-file")
                payload_offset = 8 + sum(12 + len(name) for name in names)
                plain = bytearray(b"MPX1" + struct.pack("<I", 3))
                for i, name in enumerate(names):
                    plain.extend(struct.pack("<H", len(name)) + name)
                    plain.extend(bytes((2 if i < 2 else 3, 0)))
                    plain.extend(struct.pack("<II", payload_offset if i < 2 else payload_offset + size,
                                             size if i < 2 else 0))
                plain.extend(payload)
                protected = protect_pack(bytes(plain), signing_key)
                data = protected.data
                self.assertEqual(data[4], 6)
                index_size = struct.unpack_from("<Q", data, 12)[0]
                signature_offset = 64 + index_size + 16
                signature = data[signature_offset:signature_offset + 64]
                der = encode_dss_signature(int.from_bytes(signature[:32], "big"), int.from_bytes(signature[32:], "big"))
                signing_key.public_key().verify(der, data[:signature_offset], ec.ECDSA(hashes.SHA256()))
                cipher = AESGCM(protected.aes_key)
                index = cipher.decrypt(data[36:48], data[64:signature_offset], data[:64])
                position = 8
                stream_offset = None
                for i, name in enumerate(names):
                    length = struct.unpack_from("<H", index, position)[0]
                    self.assertEqual(index[position + 2:position + 2 + length], name)
                    metadata = position + 2 + length
                    offset, logical, stored = struct.unpack_from("<QQQ", index, metadata + 2)
                    nonce = index[metadata + 26:metadata + 38]
                    tag = index[metadata + 38:metadata + 54]
                    position = metadata + 54
                    if i < 2:
                        self.assertEqual(index[metadata + 1], 4)
                        self.assertEqual(tag, bytes(16))
                        if stream_offset is None:
                            stream_offset = offset
                        self.assertEqual(offset, stream_offset, "aliases must share encrypted bytes")
                        chunks = (size + 262143) // 262144
                        self.assertEqual((logical, stored), (size, 24 + size + 16 * chunks))
                        for chunk in range(chunks):
                            count = min(262144, size - chunk * 262144)
                            record = offset + 24 + chunk * (262144 + 16)
                            ciphertext = data[record + 16:record + 16 + count]
                            self.assertEqual(index[position:position + 32], hashlib.sha256(ciphertext).digest())
                            position += 32
                            chunk_nonce = nonce[:4] + (int.from_bytes(nonce[4:], "little") ^ chunk).to_bytes(8, "little")
                            aad = b"MPS1" + nonce + struct.pack("<QI", size, chunk)
                            self.assertEqual(cipher.decrypt(chunk_nonce, ciphertext + data[record:record + 16], aad), b"a" * count)
                    else:
                        self.assertEqual((logical, stored), (0, 0))
                        self.assertEqual(index[position:position + 32], hashlib.sha256(b"").digest())
                        position += 32
                        self.assertEqual(cipher.decrypt(nonce, tag, None), b"")
                self.assertEqual(position, len(index))


if __name__ == "__main__":
    unittest.main()
