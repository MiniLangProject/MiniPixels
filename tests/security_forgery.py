"""Adversarial fixture: rewrite a stream knowing only the shipped AES key."""
import struct
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import encode_dss_signature
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes


def _multiply(x, y):
    """GHASH field multiplication (NIST SP 800-38D, Algorithm 1)."""
    result = 0
    for bit in range(127, -1, -1):
        if (x >> bit) & 1:
            result ^= y
        y = (y >> 1) ^ (0xE1000000000000000000000000000000 if y & 1 else 0)
    return result


def _power(value, exponent):
    result = 1 << 127
    while exponent:
        if exponent & 1:
            result = _multiply(result, value)
        value = _multiply(value, value)
        exponent >>= 1
    return result


def same_tag_forgery(key, nonce, ciphertext, tag, aad):
    """Known-key GHASH collision: altered ciphertext AND the original GCM tag.

    A signature over GCM tags alone cannot reject this. This is exclusively a
    regression fixture for the assets we generate and own in this test suite.
    """
    assert len(ciphertext) >= 32
    cipher = AESGCM(key)
    plain = cipher.decrypt(nonce, ciphertext + tag, aad)
    changed_plain = bytes([plain[0] ^ 1]) + plain[1:]
    changed = cipher.encrypt(nonce, changed_plain, aad)
    difference = int.from_bytes(tag, 'big') ^ int.from_bytes(changed[-16:], 'big')
    h = int.from_bytes(Cipher(algorithms.AES(key), modes.ECB()).encryptor().update(bytes(16)), 'big')
    block = len(ciphertext) // 16 - 1  # a full block distinct from the first
    exponent = (len(ciphertext) + 15) // 16 - block + 1
    correction = _multiply(difference, _power(_power(h, exponent), (1 << 128) - 2))
    result = bytearray(changed[:-16])
    start = block * 16
    result[start:start + 16] = (int.from_bytes(result[start:start + 16], 'big') ^ correction).to_bytes(16, 'big')
    assert bytes(result) != ciphertext
    assert cipher.decrypt(nonce, bytes(result) + tag, aad) != plain
    return bytes(result)


def forge_stream(protected, name):
    data = protected.data
    size = struct.unpack_from('<Q', data, 12)[0]
    signature_offset = 64 + size + 16
    cipher = AESGCM(protected.aes_key)
    index = cipher.decrypt(data[36:48], data[64:signature_offset], data[:64])
    position = 8
    for _ in range(struct.unpack_from('<I', index, 4)[0]):
        length = struct.unpack_from('<H', index, position)[0]
        entry_name = index[position + 2:position + 2 + length].decode()
        metadata = position + 2 + length
        codec = index[metadata + 1]
        offset, logical, stored = struct.unpack_from('<QQQ', index, metadata + 2)
        nonce = index[metadata + 26:metadata + 38]
        position = metadata + 54
        if codec == 4:
            position += ((logical + 262143) // 262144) * 32
        else:
            position += 32
        if entry_name != name:
            continue
        if codec == 4:
            count = min(logical, 262144)
            aad = b'MPS1' + nonce + struct.pack('<QI', logical, 0)
            tag = data[offset + 24:offset + 40]
            start = offset + 40
        else:
            count = stored
            aad = None
            tag = index[metadata + 38:metadata + 54]
            start = offset
        original = data[start:start + count]
        changed = same_tag_forgery(protected.aes_key, nonce, original, tag, aad)
        forged = bytearray(data)
        forged[start:start + count] = changed
        assert forged[:signature_offset + 64] == data[:signature_offset + 64]
        signature = data[signature_offset:signature_offset + 64]
        public = ec.EllipticCurvePublicKey.from_encoded_point(ec.SECP256R1(), b'\x04' + protected.public_key)
        public.verify(encode_dss_signature(int.from_bytes(signature[:32], 'big'), int.from_bytes(signature[32:], 'big')),
                      bytes(forged[:signature_offset]), ec.ECDSA(hashes.SHA256()))
        return bytes(forged)
    raise AssertionError(f'No stream {name}')
