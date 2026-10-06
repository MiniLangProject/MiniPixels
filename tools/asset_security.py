"""MPX3 authenticated-encryption and signing helpers.

The build tool deliberately keeps all private-key operations on the host. The
runtime receives only a raw P-256 public key and an obfuscated, per-pack AES key.
"""

from __future__ import annotations

import hashlib
import os
import struct
from dataclasses import dataclass
from pathlib import Path


MPX3_MAGIC = b"MPX3"
MPX3_VERSION = 6
MPX3_HEADER_SIZE = 64
MPX3_INDEX_MAGIC = b"MPI3"
MPX3_NONCE_SIZE = 12
MPX3_TAG_SIZE = 16
MPX3_SIGNATURE_SIZE = 64
MPX3_ENCRYPTION_AES_256_GCM = 1
MPX3_SIGNATURE_ECDSA_P256_SHA256 = 1
PACK_CODEC_NONE = 0
PACK_CODEC_DEFLATE = 1
PACK_CODEC_RLE = 2
PACK_CODEC_LZ4 = 3
PACK_CODEC_STREAM = 4
PACK_COMPRESSED_MAGIC = b"MPC1"
PACK_RLE_MAGIC = b"MPR1"
PACK_LZ4_MAGIC = b"MPL1"
PACK_STREAM_MAGIC = b"MPS1"
PACK_STREAM_CHUNK_SIZE = 256 * 1024
PACK_STREAM_HEADER_SIZE = 24


def _crypto():
    try:
        from cryptography.hazmat.primitives import hashes, serialization
        from cryptography.hazmat.primitives.asymmetric import ec
        from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature
        from cryptography.hazmat.primitives.ciphers.aead import AESGCM
    except ImportError as exc:
        raise RuntimeError(
            "protected asset builds require the 'cryptography' package; "
            "install it with: python -m pip install -r requirements.txt"
        ) from exc
    return hashes, serialization, ec, decode_dss_signature, AESGCM


@dataclass(frozen=True)
class ProtectedPack:
    data: bytes
    aes_key: bytes
    public_key: bytes
    key_id: bytes


def raw_public_key(public_key) -> bytes:
    numbers = public_key.public_numbers()
    return numbers.x.to_bytes(32, "big") + numbers.y.to_bytes(32, "big")


def key_id(public_key_bytes: bytes) -> bytes:
    return hashlib.sha256(public_key_bytes).digest()[:8]


def generate_signing_key(private_path: Path, public_path: Path) -> bytes:
    _, serialization, ec, _, _ = _crypto()
    private_key = ec.generate_private_key(ec.SECP256R1())
    private_pem = private_key.private_bytes(
        serialization.Encoding.PEM,
        serialization.PrivateFormat.PKCS8,
        serialization.NoEncryption(),
    )
    public_pem = private_key.public_key().public_bytes(
        serialization.Encoding.PEM,
        serialization.PublicFormat.SubjectPublicKeyInfo,
    )
    private_path.parent.mkdir(parents=True, exist_ok=True)
    public_path.parent.mkdir(parents=True, exist_ok=True)
    private_path.write_bytes(private_pem)
    public_path.write_bytes(public_pem)
    try:
        os.chmod(private_path, 0o600)
    except OSError:
        pass
    return raw_public_key(private_key.public_key())


def load_private_key(value: bytes):
    _, serialization, ec, _, _ = _crypto()
    key = serialization.load_pem_private_key(value, password=None)
    if not isinstance(key, ec.EllipticCurvePrivateKey) or not isinstance(key.curve, ec.SECP256R1):
        raise ValueError("asset signing key must be an unencrypted P-256 PKCS#8 PEM key")
    return key


def load_signing_key(project_root: Path, config: dict):
    inline = os.environ.get("MINIPIXELS_ASSET_SIGNING_KEY")
    if inline:
        return load_private_key(inline.replace("\\n", "\n").encode("utf-8"))
    env_path = os.environ.get("MINIPIXELS_ASSET_SIGNING_KEY_FILE")
    configured = config.get("signingKey", ".minipixels/asset-signing-key.pem")
    path = Path(env_path).expanduser() if env_path else project_root / str(configured)
    try:
        return load_private_key(path.resolve().read_bytes())
    except OSError as exc:
        raise RuntimeError(
            f"asset signing key not found: {path}; run 'minipixels security init' "
            "or configure MINIPIXELS_ASSET_SIGNING_KEY_FILE"
        ) from exc


def protect_pack(plaintext: bytes, private_key) -> ProtectedPack:
    """Convert a deterministic MPX1 stream into a random-access MPX3 pack.

    The encrypted/signed index authenticates every block's location, nonce and
    GCM tag and SHA-256 ciphertext digest. Payloads can be read independently
    without weakening the private signing-key modification boundary.
    """
    hashes, _, ec, decode_dss_signature, AESGCM = _crypto()
    if not plaintext.startswith(b"MPX1"):
        raise ValueError("MPX3 can only wrap a complete MPX1 pack")
    if len(plaintext) < 8:
        raise ValueError("MPX1 pack is truncated")

    count = struct.unpack_from("<I", plaintext, 4)[0]
    source_entries: list[tuple[bytes, int, int, int, bytes]] = []
    position = 8
    for _ in range(count):
        if position + 12 > len(plaintext):
            raise ValueError("MPX1 index is truncated")
        name_size = struct.unpack_from("<H", plaintext, position)[0]
        position += 2
        if name_size == 0 or position + name_size + 10 > len(plaintext):
            raise ValueError("MPX1 name is truncated")
        name = plaintext[position : position + name_size]
        position += name_size
        kind = plaintext[position]
        codec = plaintext[position + 1]
        position += 2
        if codec not in (PACK_CODEC_NONE, PACK_CODEC_DEFLATE, PACK_CODEC_RLE, PACK_CODEC_LZ4):
            raise ValueError("MPX1 asset uses an unsupported compression codec")
        offset, size = struct.unpack_from("<II", plaintext, position)
        position += 8
        if offset < position or offset + size > len(plaintext):
            raise ValueError("MPX1 payload is out of range")
        payload = plaintext[offset : offset + size]
        logical_size = len(payload)
        if codec != PACK_CODEC_NONE:
            expected_magic = {PACK_CODEC_DEFLATE: PACK_COMPRESSED_MAGIC, PACK_CODEC_RLE: PACK_RLE_MAGIC, PACK_CODEC_LZ4: PACK_LZ4_MAGIC}[codec]
            if len(payload) < 8 or payload[:4] != expected_magic:
                raise ValueError("MPX1 compressed asset envelope is invalid")
            logical_size = struct.unpack_from("<I", payload, 4)[0]
        source_entries.append((name, kind, codec, logical_size, payload))

    aes_key = os.urandom(32)
    public = raw_public_key(private_key.public_key())
    identity = key_id(public)
    cipher = AESGCM(aes_key)
    sealed_blocks: list[tuple[bytes, bytes, bytes]] = []
    block_indices: dict[tuple[int, bytes], int] = {}
    sealed_entries: list[tuple[bytes, int, int, int, int]] = []
    for name, kind, codec, logical_size, payload in source_entries:
        # Streamed audio/video stays seekable inside MPX3. Each fixed-size
        # block is authenticated independently, so playback only decrypts the
        # ranges requested by the native media backend.
        stream_payload = kind in (2, 6) and codec == PACK_CODEC_NONE
        output_codec = PACK_CODEC_STREAM if stream_payload else codec
        block_key = (output_codec, payload)
        block_index = block_indices.get(block_key)
        if block_index is None:
            nonce = os.urandom(MPX3_NONCE_SIZE)
            if stream_payload:
                chunk_count = (len(payload) + PACK_STREAM_CHUNK_SIZE - 1) // PACK_STREAM_CHUNK_SIZE
                envelope = bytearray(PACK_STREAM_MAGIC)
                signed_hashes = bytearray()
                envelope.extend(struct.pack("<IQII", PACK_STREAM_CHUNK_SIZE, len(payload), chunk_count, 0))
                for chunk_index in range(chunk_count):
                    start = chunk_index * PACK_STREAM_CHUNK_SIZE
                    chunk = payload[start : start + PACK_STREAM_CHUNK_SIZE]
                    chunk_nonce = bytearray(nonce)
                    counter = int.from_bytes(chunk_nonce[4:12], "little") ^ chunk_index
                    chunk_nonce[4:12] = counter.to_bytes(8, "little")
                    aad = PACK_STREAM_MAGIC + nonce + struct.pack("<QI", len(payload), chunk_index)
                    sealed_chunk = cipher.encrypt(bytes(chunk_nonce), chunk, aad)
                    envelope.extend(sealed_chunk[-MPX3_TAG_SIZE:])
                    signed_hashes.extend(hashlib.sha256(sealed_chunk[:-MPX3_TAG_SIZE]).digest())
                    envelope.extend(sealed_chunk[:-MPX3_TAG_SIZE])
                ciphertext = bytes(envelope)
                tag = bytes(signed_hashes)
            else:
                sealed = cipher.encrypt(nonce, payload, None)
                ciphertext = sealed[:-MPX3_TAG_SIZE]
                tag = sealed[-MPX3_TAG_SIZE:] + hashlib.sha256(ciphertext).digest()
            block_index = len(sealed_blocks)
            block_indices[block_key] = block_index
            sealed_blocks.append((nonce, ciphertext, tag))
        sealed_entries.append((name, kind, output_codec, logical_size, block_index))

    index_size = 8 + sum(56 + len(name) + (len(sealed_blocks[block][2]) if codec == PACK_CODEC_STREAM else 32)
                         for name, _, codec, _, block in sealed_entries)
    if index_size > 64 * 1024 * 1024:
        raise ValueError("MPX3 signed index exceeds the runtime limit")
    payload_offset = MPX3_HEADER_SIZE + index_size + MPX3_TAG_SIZE + MPX3_SIGNATURE_SIZE
    block_offsets: list[int] = []
    next_offset = payload_offset
    for _, ciphertext, _ in sealed_blocks:
        block_offsets.append(next_offset)
        next_offset += len(ciphertext)
    index = bytearray(MPX3_INDEX_MAGIC)
    index.extend(struct.pack("<I", len(sealed_entries)))
    for name, kind, codec, logical_size, block_index in sealed_entries:
        nonce, ciphertext, tag = sealed_blocks[block_index]
        index.extend(struct.pack("<H", len(name)))
        index.extend(name)
        index.extend(bytes([kind, codec]))
        index.extend(struct.pack("<QQQ", block_offsets[block_index], logical_size, len(ciphertext)))
        index.extend(nonce)
        # GCM/GHASH is not a collision-resistant digest when the AES key is
        # known. v6 signs SHA-256 ciphertext digests, not merely GCM tags.
        if codec == PACK_CODEC_STREAM:
            index.extend(bytes(MPX3_TAG_SIZE))
        index.extend(tag)

    index_nonce = os.urandom(MPX3_NONCE_SIZE)
    file_size = next_offset
    header = b"".join(
        [
            MPX3_MAGIC,
            bytes([MPX3_VERSION, 0, MPX3_ENCRYPTION_AES_256_GCM, MPX3_SIGNATURE_ECDSA_P256_SHA256]),
            struct.pack("<HHQQQ", MPX3_HEADER_SIZE, 0, len(index), len(index), file_size),
            index_nonce,
            identity,
            bytes(8),
        ]
    )
    sealed_index = cipher.encrypt(index_nonce, bytes(index), header)
    index_ciphertext, index_tag = sealed_index[:-MPX3_TAG_SIZE], sealed_index[-MPX3_TAG_SIZE:]
    signed = header + index_ciphertext + index_tag
    der_signature = private_key.sign(signed, ec.ECDSA(hashes.SHA256()))
    r, s = decode_dss_signature(der_signature)
    signature = r.to_bytes(32, "big") + s.to_bytes(32, "big")
    payloads = b"".join(ciphertext for _, ciphertext, _ in sealed_blocks)
    return ProtectedPack(signed + signature + payloads, aes_key, public, identity)


def inspect_header(data: bytes) -> dict:
    if len(data) < MPX3_HEADER_SIZE + MPX3_TAG_SIZE + MPX3_SIGNATURE_SIZE:
        raise ValueError("MPX3 file is truncated")
    if data[:4] != MPX3_MAGIC or data[4] != MPX3_VERSION:
        raise ValueError("not a supported MPX3 version-6 file")
    header_size, reserved, index_size, index_cipher_size, file_size = struct.unpack_from("<HHQQQ", data, 8)
    if header_size != MPX3_HEADER_SIZE or reserved != 0:
        raise ValueError("unsupported MPX3 header")
    if data[6] != MPX3_ENCRYPTION_AES_256_GCM or data[7] != MPX3_SIGNATURE_ECDSA_P256_SHA256:
        raise ValueError("unsupported MPX3 algorithm suite")
    if index_size != index_cipher_size or file_size != len(data):
        raise ValueError("invalid MPX3 size")
    return {
        "version": MPX3_VERSION,
        "header_size": header_size,
        "index_size": index_size,
        "file_size": file_size,
        "nonce": data[36:48],
        "key_id": data[48:56],
    }
