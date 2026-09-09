"""MPX2 authenticated-encryption and signing helpers.

The build tool deliberately keeps all private-key operations on the host. The
runtime receives only a raw P-256 public key and an obfuscated, per-pack AES key.
"""

from __future__ import annotations

import hashlib
import os
import struct
from dataclasses import dataclass
from pathlib import Path


MPX2_MAGIC = b"MPX2"
MPX2_VERSION = 2
MPX2_HEADER_SIZE = 64
MPX2_NONCE_SIZE = 12
MPX2_TAG_SIZE = 16
MPX2_SIGNATURE_SIZE = 64
MPX2_ENCRYPTION_AES_256_GCM = 1
MPX2_SIGNATURE_ECDSA_P256_SHA256 = 1


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


def _header(plaintext_size: int, ciphertext_size: int, nonce: bytes, signing_key_id: bytes) -> bytes:
    if len(nonce) != MPX2_NONCE_SIZE or len(signing_key_id) != 8:
        raise ValueError("invalid MPX2 header material")
    return b"".join(
        [
            MPX2_MAGIC,
            bytes(
                [
                    MPX2_VERSION,
                    0,
                    MPX2_ENCRYPTION_AES_256_GCM,
                    MPX2_SIGNATURE_ECDSA_P256_SHA256,
                ]
            ),
            struct.pack("<HHQQ", MPX2_HEADER_SIZE, 0, plaintext_size, ciphertext_size),
            nonce,
            signing_key_id,
            bytes(16),
        ]
    )


def protect_pack(plaintext: bytes, private_key) -> ProtectedPack:
    hashes, _, ec, decode_dss_signature, AESGCM = _crypto()
    if not plaintext.startswith(b"MPX1"):
        raise ValueError("MPX2 can only wrap a complete MPX1 pack")
    aes_key = os.urandom(32)
    nonce = os.urandom(MPX2_NONCE_SIZE)
    public = raw_public_key(private_key.public_key())
    identity = key_id(public)
    header = _header(len(plaintext), len(plaintext), nonce, identity)
    sealed = AESGCM(aes_key).encrypt(nonce, plaintext, header)
    ciphertext, tag = sealed[:-MPX2_TAG_SIZE], sealed[-MPX2_TAG_SIZE:]
    der_signature = private_key.sign(header + ciphertext + tag, ec.ECDSA(hashes.SHA256()))
    r, s = decode_dss_signature(der_signature)
    signature = r.to_bytes(32, "big") + s.to_bytes(32, "big")
    return ProtectedPack(header + ciphertext + tag + signature, aes_key, public, identity)


def inspect_header(data: bytes) -> dict:
    if len(data) < MPX2_HEADER_SIZE + MPX2_TAG_SIZE + MPX2_SIGNATURE_SIZE:
        raise ValueError("MPX2 file is truncated")
    if data[:4] != MPX2_MAGIC or data[4] != MPX2_VERSION:
        raise ValueError("not a supported MPX2 file")
    header_size, reserved, plaintext_size, ciphertext_size = struct.unpack_from("<HHQQ", data, 8)
    if header_size != MPX2_HEADER_SIZE or reserved != 0:
        raise ValueError("unsupported MPX2 header")
    if data[6] != MPX2_ENCRYPTION_AES_256_GCM or data[7] != MPX2_SIGNATURE_ECDSA_P256_SHA256:
        raise ValueError("unsupported MPX2 algorithm suite")
    expected = header_size + ciphertext_size + MPX2_TAG_SIZE + MPX2_SIGNATURE_SIZE
    if expected != len(data) or plaintext_size != ciphertext_size:
        raise ValueError("invalid MPX2 payload size")
    return {
        "header_size": header_size,
        "plaintext_size": plaintext_size,
        "ciphertext_size": ciphertext_size,
        "nonce": data[28:40],
        "key_id": data[40:48],
    }
