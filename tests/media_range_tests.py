"""Native MPX transport regressions; also run directly inside WSL/Linux."""
from __future__ import annotations

import ctypes
import http.client
import os
import socket
import struct
import sys
import tempfile
import threading
import time
from contextlib import contextmanager
from pathlib import Path
from urllib.parse import urlsplit

from cryptography.hazmat.primitives.ciphers.aead import AESGCM


def test_runtime(runtime: Path) -> None:
    library = ctypes.CDLL(str(runtime.resolve()))
    open_stream = library.mpMediaStreamOpen
    open_stream.restype = ctypes.c_void_p
    open_stream.argtypes = [
        ctypes.c_char_p, ctypes.c_uint64, ctypes.c_uint64, ctypes.c_uint64, ctypes.c_int32,
        ctypes.c_void_p, ctypes.c_uint64, ctypes.c_void_p, ctypes.c_uint64,
        ctypes.c_char_p, ctypes.c_char_p, ctypes.c_void_p, ctypes.c_int32,
    ]
    close_stream = library.mpMediaStreamClose
    close_stream.argtypes = [ctypes.c_void_p]
    close_stream.restype = None

    def open_native(path, offset, stored, logical, codec=0, key=b"", nonce=b""):
        url = ctypes.create_string_buffer(192)
        handle = open_stream(
            str(path).encode("utf-8"), offset, stored, logical, codec,
            ctypes.create_string_buffer(key) if key else None, len(key),
            ctypes.create_string_buffer(nonce) if nonce else None, len(nonce),
            b"application/octet-stream", b".bin", url, len(url),
        )
        assert handle, "native media range source did not open"
        return handle, urlsplit(url.value.decode("ascii"))

    @contextmanager
    def stream(*args):
        handle, url = open_native(*args)
        try:
            yield url
        finally:
            close_stream(handle)

    def request(url, headers="", method="GET", fragment=False, path=None):
        raw = f"{method} {path or url.path} HTTP/1.1\r\nHost: localhost\r\n{headers}\r\n".encode("ascii")
        with socket.create_connection((url.hostname, url.port), timeout=3) as client:
            if fragment:
                for part in (raw[:3], raw[3:19], raw[19:-3], raw[-3:]):
                    client.sendall(part)
                    time.sleep(0.02)  # Force separate recv calls, not just separate send calls.
            else:
                client.sendall(raw)
            response = http.client.HTTPResponse(client, method=method)
            response.begin()
            try:
                body = response.read()
            except http.client.IncompleteRead as error:
                # Authentication errors deliberately terminate the body, never send plaintext.
                body = error.partial
            return response.status, dict(response.getheaders()), body

    with tempfile.TemporaryDirectory(prefix="minipixels_media_range_") as td:
        directory = Path(td)
        chunk_size = 256 * 1024
        # Distinct chunks are critical: a periodic fixture would hide cache poisoning.
        payload = b"A" * chunk_size + b"B" * chunk_size + b"C" * 137
        plain_path = directory / "plain-ä.bin"
        plain_path.write_bytes(b"prefix-data" + payload + b"suffix-data")
        with stream(plain_path, 11, len(payload), len(payload)) as url:
            for headers, start, end in (
                ("Range: bytes=262120-262200\r\n", 262120, 262201),
                ("range: bytes=0-3\r\n", 0, 4),
                ("rAnGe:\tBYTES=262140-262148 \t\r\n", 262140, 262149),
                ("Range: bytes=-17\r\n", len(payload) - 17, len(payload)),
                ("Range: bytes=524300-\r\n", 524300, len(payload)),
                ("Range: bytes=524300-18446744073709551615\r\n", 524300, len(payload)),
                ("Range: bytes=-9999999\r\n", 0, len(payload)),
            ):
                status, result_headers, body = request(url, headers)
                assert status == 206, (headers, status)
                assert body == payload[start:end], headers
                assert result_headers["Content-Range"] == f"bytes {start}-{end - 1}/{len(payload)}"
                assert int(result_headers["Content-Length"]) == end - start
            assert request(url)[2] == payload  # No prefix/suffix leaks outside the entry.
            assert request(url, "range: bytes=0-3\r\n", fragment=True)[2] == b"AAAA"
            status, headers, body = request(url, "Range: bytes=0-3\r\n", method="HEAD")
            assert status == 200 and not body and int(headers["Content-Length"]) == len(payload)
            for value in ("bytes=4-3", "bytes=-0", "bytes=9999999-", "bytes=0-1,4-5",
                          "bytes=18446744073709551616-", "bytes=0-18446744073709551616",
                          "bytes=0-1oops", "bytes=", "bytes=0", "bytes=--1"):
                status, headers, body = request(url, f"Range: {value}\r\n")
                assert status == 416 and not body, value
                assert headers["Content-Range"] == f"bytes */{len(payload)}"
            assert request(url, "Range: bytes=0-1\r\nrange: bytes=2-3\r\n")[0] == 416
            assert request(url, path="/wrong-token/file.bin")[0] == 404
            assert request(url, "X-Padding: " + "x" * 8200 + "\r\n")[0] == 431
            # A disconnected partial request must not poison subsequent clients.
            with socket.create_connection((url.hostname, url.port), timeout=3) as client:
                client.sendall(b"GET ")
            assert request(url, "Range: bytes=0-3\r\n")[2] == b"AAAA"

        empty = directory / "empty.bin"
        empty.write_bytes(b"")
        with stream(empty, 0, 0, 0) as url:
            assert request(url)[0:3:2] == (200, b"")
            assert request(url, "Range: bytes=0-\r\n")[0] == 416

        key, base_nonce = os.urandom(32), os.urandom(12)
        chunk_count = (len(payload) + chunk_size - 1) // chunk_size
        envelope = bytearray(b"MPS1" + struct.pack("<IQII", chunk_size, len(payload), chunk_count, 0))
        cipher = AESGCM(key)
        for index in range(chunk_count):
            chunk = payload[index * chunk_size:(index + 1) * chunk_size]
            nonce = base_nonce[:4] + (int.from_bytes(base_nonce[4:], "little") ^ index).to_bytes(8, "little")
            sealed = cipher.encrypt(nonce, chunk, b"MPS1" + base_nonce + struct.pack("<QI", len(payload), index))
            envelope.extend(sealed[-16:] + sealed[:-16])
        protected = directory / "protected.bin"
        protected.write_bytes(envelope)
        with stream(protected, 0, len(envelope), len(payload), 4, key, base_nonce) as url:
            assert request(url, "Range: bytes=262120-262200\r\n")[2] == payload[262120:262201]
            assert request(url)[2] == payload

        envelope[24 + 16 + chunk_size] ^= 1  # Corrupt only B's authentication tag.
        protected.write_bytes(envelope)
        with stream(protected, 0, len(envelope), len(payload), 4, key, base_nonce) as url:
            for _ in range(3):
                assert request(url, "Range: bytes=0-3\r\n")[2] == b"AAAA"
                assert request(url, "Range: bytes=262144-262147\r\n")[2] == b"", "unauthenticated bytes leaked"
                assert request(url, "Range: bytes=0-3\r\n")[2] == b"AAAA", "failed GCM poisoned previous cache entry"
            assert request(url, "Range: bytes=-4\r\n")[2] == b"CCCC"

        # Cover both a receiver waiting for headers and a sender blocked by a slow reader.
        large = directory / "large.bin"
        large.write_bytes(b"D" * (16 * 1024 * 1024))
        for mode in ("idle", "partial", "stalled-send"):
            handle, url = open_native(large, 0, large.stat().st_size, large.stat().st_size)
            client = socket.socket()
            client.settimeout(3)
            client.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024)
            client.connect((url.hostname, url.port))
            if mode == "partial":
                client.sendall(b"GET ")
            elif mode == "stalled-send":
                client.sendall(f"GET {url.path} HTTP/1.1\r\nHost: localhost\r\n\r\n".encode())
                assert client.recv(1) == b"H"  # Server is actively sending.
            time.sleep(0.05)
            closer = threading.Thread(target=close_stream, args=(handle,), daemon=True)
            closer.start()
            closer.join(1.5)
            stopped = not closer.is_alive()
            client.close()  # Release a regressed implementation before failing the assertion.
            closer.join(6)
            assert stopped, f"close hung with {mode} client"
        for _ in range(20):  # Immediate close also races with entry into accept().
            handle, _ = open_native(empty, 0, 0, 0)
            close_stream(handle)
    print("Native MPX media regression tests passed (ranges, GCM cache, cancellation)")


if __name__ == "__main__":
    test_runtime(Path(sys.argv[1]))
