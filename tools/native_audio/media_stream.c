// SPDX-License-Identifier: Apache-2.0
// Loopback-only HTTP range source for file-backed MiniPixels media assets.
// Media frameworks already understand HTTP byte ranges, so this small bridge
// lets them seek in MPX payloads without plaintext temporary files or a full
// in-memory copy.

#define _FILE_OFFSET_BITS 64
#if !defined(_WIN32)
#define _POSIX_C_SOURCE 200809L
#endif

#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <bcrypt.h>
#define MP_API __declspec(dllexport)
typedef SOCKET mp_socket;
typedef HANDLE mp_thread;
typedef int mp_socklen;
#define MP_INVALID_SOCKET INVALID_SOCKET
#else
#include <arpa/inet.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <openssl/evp.h>
#include <poll.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/time.h>
#include <unistd.h>
#define MP_API __attribute__((visibility("default")))
typedef int mp_socket;
typedef pthread_t mp_thread;
typedef socklen_t mp_socklen;
#define MP_INVALID_SOCKET (-1)
#endif

enum { MP_MEDIA_CODEC_PLAIN = 0, MP_MEDIA_CODEC_CHUNKED_GCM = 4 };
enum { MP_STREAM_HEADER_SIZE = 24, MP_STREAM_TAG_SIZE = 16 };

typedef struct MiniPixelsMediaStream {
    FILE* file;
    uint64_t payload_offset;
    uint64_t stored_size;
    uint64_t logical_size;
    uint32_t chunk_size;
    uint32_t chunk_count;
    uint32_t cached_chunk_index;
    size_t cached_chunk_size;
    uint8_t* cached_chunk;
    uint8_t* signed_hashes;
    int codec;
    uint8_t key[32];
    uint8_t nonce[12];
    char mime[96];
    char token[33];
    char suffix[24];
    char url[192];
    mp_socket listener;
    mp_thread thread;
#if defined(_WIN32)
    volatile LONG stopping;
#else
    int stopping;
#endif
    int thread_started;
#if defined(_WIN32)
    int winsock_started;
    BCRYPT_ALG_HANDLE crypto_algorithm;
    BCRYPT_KEY_HANDLE crypto_key;
    PUCHAR crypto_key_object;
    DWORD crypto_key_object_size;
#else
    EVP_CIPHER_CTX* crypto_context;
#endif
} MiniPixelsMediaStream;

static void mp_shutdown_socket(mp_socket value)
{
    if (value == MP_INVALID_SOCKET) return;
#if defined(_WIN32)
    shutdown(value, SD_BOTH);
#else
    shutdown(value, SHUT_RDWR);
#endif
}

static int mp_is_stopping(MiniPixelsMediaStream* stream)
{
#if defined(_WIN32)
    return InterlockedCompareExchange(&stream->stopping, 0, 0) != 0;
#else
    return __atomic_load_n(&stream->stopping, __ATOMIC_ACQUIRE) != 0;
#endif
}

static void mp_request_stop(MiniPixelsMediaStream* stream)
{
#if defined(_WIN32)
    InterlockedExchange(&stream->stopping, 1);
#else
    __atomic_store_n(&stream->stopping, 1, __ATOMIC_RELEASE);
#endif
}

static uint32_t mp_read_u32le(const uint8_t* value)
{
    return (uint32_t)value[0] | ((uint32_t)value[1] << 8) |
           ((uint32_t)value[2] << 16) | ((uint32_t)value[3] << 24);
}

static uint64_t mp_read_u64le(const uint8_t* value)
{
    return (uint64_t)mp_read_u32le(value) | ((uint64_t)mp_read_u32le(value + 4) << 32);
}

static void mp_write_u32le(uint8_t* out, uint32_t value)
{
    out[0] = (uint8_t)value; out[1] = (uint8_t)(value >> 8);
    out[2] = (uint8_t)(value >> 16); out[3] = (uint8_t)(value >> 24);
}

static void mp_write_u64le(uint8_t* out, uint64_t value)
{
    mp_write_u32le(out, (uint32_t)value);
    mp_write_u32le(out + 4, (uint32_t)(value >> 32));
}

static int mp_seek(FILE* file, uint64_t offset)
{
#if defined(_WIN32)
    return _fseeki64(file, (__int64)offset, SEEK_SET) == 0;
#else
    return fseeko(file, (off_t)offset, SEEK_SET) == 0;
#endif
}

static uint64_t mp_file_size(FILE* file)
{
#if defined(_WIN32)
    __int64 current = _ftelli64(file), size;
    if (current < 0 || _fseeki64(file, 0, SEEK_END) != 0) return UINT64_MAX;
    size = _ftelli64(file);
    _fseeki64(file, current, SEEK_SET);
    return size < 0 ? UINT64_MAX : (uint64_t)size;
#else
    off_t current = ftello(file), size;
    if (current < 0 || fseeko(file, 0, SEEK_END) != 0) return UINT64_MAX;
    size = ftello(file);
    fseeko(file, current, SEEK_SET);
    return size < 0 ? UINT64_MAX : (uint64_t)size;
#endif
}

static FILE* mp_open_utf8(const char* path)
{
#if defined(_WIN32)
    int count;
    wchar_t* wide;
    FILE* file;
    if (path == NULL) return NULL;
    count = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, NULL, 0);
    if (count <= 0) return NULL;
    wide = (wchar_t*)calloc((size_t)count, sizeof(wchar_t));
    if (wide == NULL) return NULL;
    if (MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, wide, count) <= 0) {
        free(wide);
        return NULL;
    }
    file = _wfopen(wide, L"rb");
    free(wide);
    return file;
#else
    return path == NULL ? NULL : fopen(path, "rb");
#endif
}

static void mp_close_socket(mp_socket socket_value)
{
    if (socket_value == MP_INVALID_SOCKET) return;
#if defined(_WIN32)
    closesocket(socket_value);
#else
    close(socket_value);
#endif
}

static int mp_nonblocking(mp_socket value)
{
#if defined(_WIN32)
    u_long enabled = 1;
    return ioctlsocket(value, FIONBIO, &enabled) == 0;
#else
    int flags = fcntl(value, F_GETFL, 0);
    return flags >= 0 && fcntl(value, F_SETFL, flags | O_NONBLOCK) == 0;
#endif
}

static int mp_would_block(void)
{
#if defined(_WIN32)
    int error = WSAGetLastError();
    return error == WSAEWOULDBLOCK || error == WSAEINTR;
#else
    return errno == EAGAIN || errno == EWOULDBLOCK || errno == EINTR;
#endif
}

// Bounded idle wait, with cancellation checked at least every 100 ms.
static int mp_wait_socket(MiniPixelsMediaStream* stream, mp_socket value, int writing)
{
    int attempt;
    for (attempt = 0; attempt < 50 && !mp_is_stopping(stream); ++attempt) {
#if defined(_WIN32)
        fd_set ready;
        struct timeval timeout = {0, 100000};
        int result;
        FD_ZERO(&ready);
        FD_SET(value, &ready);
        result = select(0, writing ? NULL : &ready, writing ? &ready : NULL, NULL, &timeout);
#else
        // poll also supports descriptors beyond select's FD_SETSIZE limit.
        struct pollfd ready = {value, writing ? POLLOUT : POLLIN, 0};
        int result = poll(&ready, 1, 100);
#endif
        if (result > 0) return !mp_is_stopping(stream);
        if (result < 0 && !mp_would_block()) return 0;
    }
    return 0;
}

static int mp_send_all(MiniPixelsMediaStream* stream, mp_socket socket_value, const void* data, size_t size)
{
    const char* cursor = (const char*)data;
    while (size > 0) {
        if (mp_is_stopping(stream)) return 0;
#if defined(_WIN32)
        int sent = send(socket_value, cursor, size > INT32_MAX ? INT32_MAX : (int)size, 0);
#else
        ssize_t sent = send(socket_value, cursor, size, MSG_NOSIGNAL);
#endif
        if (sent <= 0) {
            if (sent < 0 && mp_would_block() && mp_wait_socket(stream, socket_value, 1)) continue;
            return 0;
        }
        cursor += sent;
        size -= (size_t)sent;
    }
    return 1;
}

static int mp_random(void* output, size_t size)
{
#if defined(_WIN32)
    return BCryptGenRandom(NULL, (PUCHAR)output, (ULONG)size, BCRYPT_USE_SYSTEM_PREFERRED_RNG) == 0;
#else
    int fd = open("/dev/urandom", O_RDONLY);
    uint8_t* cursor = (uint8_t*)output;
    if (fd < 0) return 0;
    while (size > 0) {
        ssize_t count = read(fd, cursor, size);
        if (count <= 0) { close(fd); return 0; }
        cursor += count;
        size -= (size_t)count;
    }
    close(fd);
    return 1;
#endif
}

static int mp_crypto_init(MiniPixelsMediaStream* stream)
{
    if (stream->codec != MP_MEDIA_CODEC_CHUNKED_GCM) return 1;
#if defined(_WIN32)
    {
        DWORD actual = 0;
        if (BCryptOpenAlgorithmProvider(&stream->crypto_algorithm, BCRYPT_AES_ALGORITHM, NULL, 0) != 0) return 0;
        if (BCryptSetProperty(stream->crypto_algorithm, BCRYPT_CHAINING_MODE, (PUCHAR)BCRYPT_CHAIN_MODE_GCM,
                              sizeof(BCRYPT_CHAIN_MODE_GCM), 0) != 0) return 0;
        if (BCryptGetProperty(stream->crypto_algorithm, BCRYPT_OBJECT_LENGTH,
                              (PUCHAR)&stream->crypto_key_object_size, sizeof(stream->crypto_key_object_size),
                              &actual, 0) != 0) return 0;
        stream->crypto_key_object = (PUCHAR)calloc(1, stream->crypto_key_object_size);
        if (stream->crypto_key_object == NULL) return 0;
        return BCryptGenerateSymmetricKey(stream->crypto_algorithm, &stream->crypto_key,
                                           stream->crypto_key_object, stream->crypto_key_object_size,
                                           stream->key, 32, 0) == 0;
    }
#else
    stream->crypto_context = EVP_CIPHER_CTX_new();
    return stream->crypto_context != NULL;
#endif
}

static void mp_crypto_close(MiniPixelsMediaStream* stream)
{
#if defined(_WIN32)
    if (stream->crypto_key != NULL) BCryptDestroyKey(stream->crypto_key);
    stream->crypto_key = NULL;
    if (stream->crypto_key_object != NULL) {
        SecureZeroMemory(stream->crypto_key_object, stream->crypto_key_object_size);
        free(stream->crypto_key_object);
    }
    stream->crypto_key_object = NULL;
    if (stream->crypto_algorithm != NULL) BCryptCloseAlgorithmProvider(stream->crypto_algorithm, 0);
    stream->crypto_algorithm = NULL;
#else
    EVP_CIPHER_CTX_free(stream->crypto_context);
    stream->crypto_context = NULL;
#endif
}

static int mp_decrypt_gcm(
    MiniPixelsMediaStream* stream, const uint8_t nonce[12], const uint8_t* aad, size_t aad_size,
    const uint8_t* ciphertext, size_t ciphertext_size, const uint8_t tag[16], uint8_t* plaintext)
{
#if defined(_WIN32)
    BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO auth;
    DWORD written = 0;
    NTSTATUS status;
    if (stream->crypto_key == NULL) return 0;
    BCRYPT_INIT_AUTH_MODE_INFO(auth);
    auth.pbNonce = (PUCHAR)nonce; auth.cbNonce = 12;
    auth.pbAuthData = (PUCHAR)aad; auth.cbAuthData = (ULONG)aad_size;
    auth.pbTag = (PUCHAR)tag; auth.cbTag = 16;
    status = BCryptDecrypt(stream->crypto_key, (PUCHAR)ciphertext, (ULONG)ciphertext_size, &auth,
                           NULL, 0, plaintext, (ULONG)ciphertext_size, &written, 0);
    return status == 0 && written == ciphertext_size;
#else
    EVP_CIPHER_CTX* context = stream->crypto_context;
    int length = 0, total = 0, ok = 0;
    if (context == NULL) return 0;
    EVP_CIPHER_CTX_reset(context);
    if (EVP_DecryptInit_ex(context, EVP_aes_256_gcm(), NULL, NULL, NULL) != 1) goto cleanup;
    if (EVP_CIPHER_CTX_ctrl(context, EVP_CTRL_GCM_SET_IVLEN, 12, NULL) != 1) goto cleanup;
    if (EVP_DecryptInit_ex(context, NULL, NULL, stream->key, nonce) != 1) goto cleanup;
    if (aad_size > 0 && EVP_DecryptUpdate(context, NULL, &length, aad, (int)aad_size) != 1) goto cleanup;
    if (EVP_DecryptUpdate(context, plaintext, &length, ciphertext, (int)ciphertext_size) != 1) goto cleanup;
    total = length;
    if (EVP_CIPHER_CTX_ctrl(context, EVP_CTRL_GCM_SET_TAG, 16, (void*)tag) != 1) goto cleanup;
    if (EVP_DecryptFinal_ex(context, plaintext + total, &length) != 1) goto cleanup;
    total += length;
    ok = (size_t)total == ciphertext_size;
cleanup:
    return ok;
#endif
}

static int mp_read_plain(MiniPixelsMediaStream* stream, uint64_t offset, void* output, size_t size)
{
    if (offset > stream->logical_size || size > stream->logical_size - offset) return 0;
    if (!mp_seek(stream->file, stream->payload_offset + offset)) return 0;
    return fread(output, 1, size, stream->file) == size;
}

// Public collision-resistant digest, independent of the embedded AES key.
static int mp_sha256(const uint8_t* input, size_t size, uint8_t output[32])
{
#if defined(_WIN32)
    BCRYPT_ALG_HANDLE algorithm = NULL;
    BCRYPT_HASH_HANDLE hash = NULL;
    int ok = 0;
    if (size > ULONG_MAX || BCryptOpenAlgorithmProvider(&algorithm, BCRYPT_SHA256_ALGORITHM, NULL, 0) != 0) return 0;
    if (BCryptCreateHash(algorithm, &hash, NULL, 0, NULL, 0, 0) == 0) {
        ok = BCryptHashData(hash, (PUCHAR)input, (ULONG)size, 0) == 0 && BCryptFinishHash(hash, output, 32, 0) == 0;
        BCryptDestroyHash(hash);
    }
    BCryptCloseAlgorithmProvider(algorithm, 0);
    return ok;
#else
    unsigned int written = 0;
    return EVP_Digest(input, size, output, &written, EVP_sha256(), NULL) == 1 && written == 32;
#endif
}

static int mp_read_chunk(MiniPixelsMediaStream* stream, uint32_t index, uint8_t* output, size_t* output_size)
{
    uint64_t plain_offset, remaining, record_offset;
    size_t plain_size;
    uint8_t tag[16], nonce[12], aad[28], digest[32];
    uint8_t* ciphertext;
    uint64_t counter;
    int byte_index, result;
    if (index >= stream->chunk_count) return 0;
    if (stream->cached_chunk != NULL && stream->cached_chunk_index == index) {
        memcpy(output, stream->cached_chunk, stream->cached_chunk_size);
        *output_size = stream->cached_chunk_size;
        return 1;
    }
    plain_offset = (uint64_t)index * stream->chunk_size;
    remaining = stream->logical_size - plain_offset;
    plain_size = remaining < stream->chunk_size ? (size_t)remaining : stream->chunk_size;
    record_offset = stream->payload_offset + MP_STREAM_HEADER_SIZE +
                    (uint64_t)index * (stream->chunk_size + MP_STREAM_TAG_SIZE);
    if (!mp_seek(stream->file, record_offset) || fread(tag, 1, sizeof(tag), stream->file) != sizeof(tag)) return 0;
    ciphertext = (uint8_t*)malloc(plain_size == 0 ? 1 : plain_size);
    if (ciphertext == NULL) return 0;
    if (fread(ciphertext, 1, plain_size, stream->file) != plain_size) { free(ciphertext); return 0; }
    if (!mp_sha256(ciphertext, plain_size, digest) ||
        memcmp(digest, stream->signed_hashes + (size_t)index * 32, 32) != 0) {
        free(ciphertext); return 0;
    }
    memcpy(nonce, stream->nonce, sizeof(nonce));
    counter = index;
    for (byte_index = 0; byte_index < 8; ++byte_index) {
        nonce[4 + byte_index] ^= (uint8_t)counter;
        counter >>= 8;
    }
    memcpy(aad, "MPS1", 4);
    memcpy(aad + 4, stream->nonce, 12);
    mp_write_u64le(aad + 16, stream->logical_size);
    mp_write_u32le(aad + 24, index);
    if (stream->cached_chunk == NULL) {
        stream->cached_chunk = (uint8_t*)malloc(stream->chunk_size);
        if (stream->cached_chunk == NULL) { memset(ciphertext, 0, plain_size); free(ciphertext); return 0; }
    }
    // Decryption may write unauthenticated plaintext before rejecting its tag.
    // Invalidate the old identity before touching the shared output buffer.
    stream->cached_chunk_index = UINT32_MAX;
    stream->cached_chunk_size = 0;
    result = mp_decrypt_gcm(stream, nonce, aad, sizeof(aad), ciphertext, plain_size, tag, stream->cached_chunk);
    memset(ciphertext, 0, plain_size);
    free(ciphertext);
    if (result) {
        stream->cached_chunk_index = index;
        stream->cached_chunk_size = plain_size;
        memcpy(output, stream->cached_chunk, plain_size);
        *output_size = plain_size;
    } else {
        memset(stream->cached_chunk, 0, stream->chunk_size);
    }
    return result;
}

static int mp_send_range(MiniPixelsMediaStream* stream, mp_socket client, uint64_t start, uint64_t size)
{
    uint8_t* buffer;
    if (size == 0) return 1;
    if (stream->codec == MP_MEDIA_CODEC_PLAIN) {
        buffer = (uint8_t*)malloc(64 * 1024);
        if (buffer == NULL || !mp_seek(stream->file, stream->payload_offset + start)) { free(buffer); return 0; }
        while (size > 0) {
            if (mp_is_stopping(stream)) { free(buffer); return 0; }
            size_t count = size > 64 * 1024 ? 64 * 1024 : (size_t)size;
            if (fread(buffer, 1, count, stream->file) != count || !mp_send_all(stream, client, buffer, count)) {
                free(buffer); return 0;
            }
            size -= count;
        }
        free(buffer);
        return 1;
    }
    buffer = (uint8_t*)malloc(stream->chunk_size);
    if (buffer == NULL) return 0;
    while (size > 0) {
        if (mp_is_stopping(stream)) { memset(buffer, 0, stream->chunk_size); free(buffer); return 0; }
        uint32_t chunk_index = (uint32_t)(start / stream->chunk_size);
        size_t chunk_size = 0;
        size_t within = (size_t)(start % stream->chunk_size);
        size_t count;
        if (!mp_read_chunk(stream, chunk_index, buffer, &chunk_size) || within >= chunk_size) {
            free(buffer); return 0;
        }
        count = chunk_size - within;
        if ((uint64_t)count > size) count = (size_t)size;
        if (!mp_send_all(stream, client, buffer + within, count)) { free(buffer); return 0; }
        start += count;
        size -= count;
    }
    memset(buffer, 0, stream->chunk_size);
    free(buffer);
    return 1;
}

static int mp_ascii_equal(const char* left, const char* right, size_t count)
{
    size_t i;
    for (i = 0; i < count; ++i) {
        unsigned char a = (unsigned char)left[i], b = (unsigned char)right[i];
        if (a >= 'A' && a <= 'Z') a += 'a' - 'A';
        if (b >= 'A' && b <= 'Z') b += 'a' - 'A';
        if (a != b) return 0;
    }
    return 1;
}

static int mp_decimal(const char** cursor, uint64_t* value)
{
    const char* p = *cursor;
    uint64_t result = 0;
    if (*p < '0' || *p > '9') return 0;
    while (*p >= '0' && *p <= '9') {
        unsigned digit = (unsigned)(*p++ - '0');
        if (result > (UINT64_MAX - digit) / 10) return 0;
        result = result * 10 + digit;
    }
    *cursor = p;
    *value = result;
    return 1;
}

// A deliberately single-range source. Reject malformed or multiple ranges.
static int mp_parse_range(const char* value, uint64_t size, uint64_t* start, uint64_t* end)
{
    uint64_t suffix;
    if (strlen(value) < 6 || !mp_ascii_equal(value, "bytes=", 6) || size == 0) return 0;
    value += 6;
    if (*value == '-') {
        ++value;
        if (!mp_decimal(&value, &suffix) || suffix == 0) return 0;
        *start = suffix >= size ? 0 : size - suffix;
    } else {
        if (!mp_decimal(&value, start) || *value++ != '-' || *start >= size) return 0;
        if (*value >= '0' && *value <= '9') {
            if (!mp_decimal(&value, end) || *end < *start) return 0;
            if (*end >= size) *end = size - 1;
        }
    }
    while (*value == ' ' || *value == '\t') ++value;
    return *value == '\0';
}

static void mp_handle_client(MiniPixelsMediaStream* stream, mp_socket client)
{
    char request[8192], header[1024], expected_path[96];
    int received, is_head = 0, partial = 0, header_size;
    size_t used = 0;
    uint64_t start = 0, end = stream->logical_size == 0 ? 0 : stream->logical_size - 1;
    const char* range = NULL;
    char* line;
    int duplicate_range = 0;
    request[0] = '\0';
    while (strstr(request, "\r\n\r\n") == NULL) {
        if (used == sizeof(request) - 1) {
            static const char too_large[] = "HTTP/1.1 431 Request Header Fields Too Large\r\nConnection: close\r\nContent-Length: 0\r\n\r\n";
            char discarded[1024];
            size_t remaining = 64 * 1024;
            mp_send_all(stream, client, too_large, sizeof(too_large) - 1);
            // Send FIN before discarding bounded excess input. Closing a socket
            // with unread bytes can otherwise reset the connection on Windows,
            // losing even the already-sent 431 response. Waits remain cancellable.
#if defined(_WIN32)
            shutdown(client, SD_SEND);
#else
            shutdown(client, SHUT_WR);
#endif
            while (remaining > 0 && !mp_is_stopping(stream)) {
                int capacity = remaining < sizeof(discarded) ? (int)remaining : (int)sizeof(discarded);
                int count = recv(client, discarded, capacity, 0);
                if (count > 0) { remaining -= (size_t)count; continue; }
                if (count < 0 && mp_would_block() && mp_wait_socket(stream, client, 0)) continue;
                break;
            }
            return;
        }
        if (mp_is_stopping(stream)) return;
        received = recv(client, request + used, (int)(sizeof(request) - used - 1), 0);
        if (received <= 0) {
            if (received < 0 && mp_would_block() && mp_wait_socket(stream, client, 0)) continue;
            return;
        }
        if (memchr(request + used, '\0', (size_t)received) != NULL) return;
        used += (size_t)received;
        request[used] = '\0';
    }
    snprintf(expected_path, sizeof(expected_path), "/%s/file%s", stream->token, stream->suffix);
    if (strncmp(request, "HEAD ", 5) == 0) is_head = 1;
    else if (strncmp(request, "GET ", 4) != 0) return;
    {
        const char* path = strchr(request, ' ');
        size_t path_size;
        if (path == NULL) return;
        ++path;
        path_size = strcspn(path, " ");
        if (strlen(expected_path) != path_size || memcmp(path, expected_path, path_size) != 0) {
            static const char denied[] = "HTTP/1.1 404 Not Found\r\nConnection: close\r\nContent-Length: 0\r\n\r\n";
            mp_send_all(stream, client, denied, sizeof(denied) - 1);
            return;
        }
    }
    line = strstr(request, "\r\n") + 2;
    while (*line != '\r') {
        char* next = strstr(line, "\r\n");
        char* colon;
        if (next == NULL) return;
        *next = '\0';
        colon = strchr(line, ':');
        if (colon != NULL && colon - line == 5 && mp_ascii_equal(line, "Range", 5)) {
            if (range != NULL) duplicate_range = 1;
            range = colon + 1;
            while (*range == ' ' || *range == '\t') ++range;
        }
        line = next + 2;
    }
    if (range != NULL && !is_head) {
        if (duplicate_range || !mp_parse_range(range, stream->logical_size, &start, &end)) {
            header_size = snprintf(header, sizeof(header),
                "HTTP/1.1 416 Range Not Satisfiable\r\nContent-Range: bytes */%" PRIu64 "\r\nConnection: close\r\nContent-Length: 0\r\n\r\n",
                stream->logical_size);
            mp_send_all(stream, client, header, (size_t)header_size);
            return;
        }
        partial = 1;
    }
    if (stream->logical_size == 0) { start = 0; end = 0; }
    {
        uint64_t content_size = stream->logical_size == 0 ? 0 : end - start + 1;
        if (partial) {
            header_size = snprintf(header, sizeof(header),
                "HTTP/1.1 206 Partial Content\r\nContent-Type: %s\r\nAccept-Ranges: bytes\r\n"
                "Content-Range: bytes %" PRIu64 "-%" PRIu64 "/%" PRIu64 "\r\nContent-Length: %" PRIu64 "\r\nConnection: close\r\nCache-Control: no-store\r\n\r\n",
                stream->mime, start, end, stream->logical_size, content_size);
        } else {
            header_size = snprintf(header, sizeof(header),
                "HTTP/1.1 200 OK\r\nContent-Type: %s\r\nAccept-Ranges: bytes\r\n"
                "Content-Length: %" PRIu64 "\r\nConnection: close\r\nCache-Control: no-store\r\n\r\n",
                stream->mime, content_size);
        }
        if (header_size > 0 && (size_t)header_size < sizeof(header) && mp_send_all(stream, client, header, (size_t)header_size) && !is_head) {
            mp_send_range(stream, client, start, content_size);
        }
    }
}

#if defined(_WIN32)
static DWORD WINAPI mp_server_thread(LPVOID parameter)
#else
static void* mp_server_thread(void* parameter)
#endif
{
    MiniPixelsMediaStream* stream = (MiniPixelsMediaStream*)parameter;
    while (!mp_is_stopping(stream)) {
        if (!mp_wait_socket(stream, stream->listener, 0)) continue;
        mp_socket client = accept(stream->listener, NULL, NULL);
        if (client == MP_INVALID_SOCKET) {
            if (mp_is_stopping(stream)) break;
            continue;
        }
        if (mp_is_stopping(stream)) {
            mp_close_socket(client);
            break;
        }
        if (mp_nonblocking(client)) mp_handle_client(stream, client);
        mp_shutdown_socket(client);
        mp_close_socket(client);
    }
#if defined(_WIN32)
    return 0;
#else
    return NULL;
#endif
}

static void mp_copy_ascii(char* output, size_t capacity, const char* value, const char* fallback, int suffix)
{
    size_t used = 0;
    const char* input = value != NULL && value[0] != '\0' ? value : fallback;
    if (capacity == 0) return;
    while (*input != '\0' && used + 1 < capacity) {
        unsigned char c = (unsigned char)*input++;
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') ||
            c == '-' || c == '+' || c == '.' || (!suffix && (c == '/' || c == ';'))) output[used++] = (char)c;
    }
    output[used] = '\0';
}

MP_API void* mpMediaStreamOpenV6(
    const char* path, uint64_t payload_offset, uint64_t stored_size, uint64_t logical_size, int32_t codec,
    const void* key, uint64_t key_size, const void* nonce, uint64_t nonce_size,
    const void* signed_hashes, uint64_t signed_hashes_size,
    const char* mime, const char* suffix, void* url_output, int32_t url_capacity)
{
    MiniPixelsMediaStream* stream = NULL;
    uint64_t file_size;
    struct sockaddr_in address;
    mp_socklen address_size = (mp_socklen)sizeof(address);
    uint8_t random_value[16];
    static const char hex[] = "0123456789abcdef";
    int index;
    if (path == NULL || url_output == NULL || url_capacity < 2 ||
        (codec != MP_MEDIA_CODEC_PLAIN && codec != MP_MEDIA_CODEC_CHUNKED_GCM)) return NULL;
    if (codec == MP_MEDIA_CODEC_CHUNKED_GCM &&
        (key == NULL || key_size != 32 || nonce == NULL || nonce_size != 12)) return NULL;
    stream = (MiniPixelsMediaStream*)calloc(1, sizeof(*stream));
    if (stream == NULL) return NULL;
    stream->listener = MP_INVALID_SOCKET;
    stream->payload_offset = payload_offset;
    stream->stored_size = stored_size;
    stream->logical_size = logical_size;
    stream->codec = codec;
    stream->cached_chunk_index = UINT32_MAX;
    if (key != NULL && key_size == 32) memcpy(stream->key, key, 32);
    if (nonce != NULL && nonce_size == 12) memcpy(stream->nonce, nonce, 12);
    mp_copy_ascii(stream->mime, sizeof(stream->mime), mime, "application/octet-stream", 0);
    mp_copy_ascii(stream->suffix, sizeof(stream->suffix), suffix, ".bin", 1);
    if (stream->suffix[0] != '.') strcpy(stream->suffix, ".bin");
    stream->file = mp_open_utf8(path);
    if (stream->file == NULL) goto failure;
    file_size = mp_file_size(stream->file);
    if (file_size == UINT64_MAX || payload_offset > file_size || stored_size > file_size - payload_offset) goto failure;
    if (codec == MP_MEDIA_CODEC_PLAIN) {
        if (stored_size != logical_size) goto failure;
    } else {
        uint8_t header[MP_STREAM_HEADER_SIZE];
        uint64_t expected_size, expected_chunks;
        if (stored_size < sizeof(header) || !mp_seek(stream->file, payload_offset) ||
            fread(header, 1, sizeof(header), stream->file) != sizeof(header) || memcmp(header, "MPS1", 4) != 0) goto failure;
        stream->chunk_size = mp_read_u32le(header + 4);
        if (mp_read_u64le(header + 8) != logical_size) goto failure;
        stream->chunk_count = mp_read_u32le(header + 16);
        if (mp_read_u32le(header + 20) != 0 || stream->chunk_size != 256 * 1024) goto failure;
        expected_chunks = logical_size == 0 ? 0 : 1 + ((logical_size - 1) / stream->chunk_size);
        if (expected_chunks > UINT32_MAX || stream->chunk_count != expected_chunks) goto failure;
        if ((uint64_t)stream->chunk_count > (UINT64_MAX - MP_STREAM_HEADER_SIZE - logical_size) / MP_STREAM_TAG_SIZE) goto failure;
        expected_size = MP_STREAM_HEADER_SIZE + logical_size + (uint64_t)stream->chunk_count * MP_STREAM_TAG_SIZE;
        if (expected_size != stored_size) goto failure;
        if (signed_hashes_size != (uint64_t)stream->chunk_count * 32 || signed_hashes_size > 64 * 1024 * 1024) goto failure;
        if (signed_hashes_size > 0) {
            if (signed_hashes == NULL) goto failure;
            stream->signed_hashes = (uint8_t*)malloc((size_t)signed_hashes_size);
            if (stream->signed_hashes == NULL) goto failure;
            memcpy(stream->signed_hashes, signed_hashes, (size_t)signed_hashes_size);
        }
    }
    if (!mp_crypto_init(stream)) goto failure;
#if defined(_WIN32)
    {
        WSADATA data;
        if (WSAStartup(MAKEWORD(2, 2), &data) != 0) goto failure;
        stream->winsock_started = 1;
    }
#endif
    stream->listener = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (stream->listener == MP_INVALID_SOCKET) goto failure;
    memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    address.sin_port = 0;
    if (bind(stream->listener, (struct sockaddr*)&address, sizeof(address)) != 0 ||
        listen(stream->listener, 4) != 0 || !mp_nonblocking(stream->listener) ||
        getsockname(stream->listener, (struct sockaddr*)&address, &address_size) != 0) goto failure;
    if (!mp_random(random_value, sizeof(random_value))) goto failure;
    for (index = 0; index < 16; ++index) {
        stream->token[index * 2] = hex[random_value[index] >> 4];
        stream->token[index * 2 + 1] = hex[random_value[index] & 15];
    }
    stream->token[32] = '\0';
    snprintf(stream->url, sizeof(stream->url), "http://127.0.0.1:%u/%s/file%s",
             (unsigned)ntohs(address.sin_port), stream->token, stream->suffix);
    if ((int)strlen(stream->url) + 1 > url_capacity) goto failure;
#if defined(_WIN32)
    stream->thread = CreateThread(NULL, 0, mp_server_thread, stream, 0, NULL);
    if (stream->thread == NULL) goto failure;
#else
    if (pthread_create(&stream->thread, NULL, mp_server_thread, stream) != 0) goto failure;
#endif
    stream->thread_started = 1;
    memcpy(url_output, stream->url, strlen(stream->url) + 1);
    return stream;
failure:
    if (stream != NULL) {
        if (stream->listener != MP_INVALID_SOCKET) mp_close_socket(stream->listener);
        if (stream->file != NULL) fclose(stream->file);
        if (stream->cached_chunk != NULL) { memset(stream->cached_chunk, 0, stream->chunk_size); free(stream->cached_chunk); }
        free(stream->signed_hashes);
        mp_crypto_close(stream);
#if defined(_WIN32)
        if (stream->winsock_started) WSACleanup();
#endif
        memset(stream->key, 0, sizeof(stream->key));
        free(stream);
    }
    return NULL;
}

MP_API void mpMediaStreamClose(void* handle)
{
    MiniPixelsMediaStream* stream = (MiniPixelsMediaStream*)handle;
    if (stream == NULL) return;
    mp_request_stop(stream);
    if (stream->thread_started) {
#if defined(_WIN32)
        WaitForSingleObject(stream->thread, INFINITE);
        CloseHandle(stream->thread);
#else
        pthread_join(stream->thread, NULL);
#endif
    }
    mp_close_socket(stream->listener);
    if (stream->file != NULL) fclose(stream->file);
    if (stream->cached_chunk != NULL) {
        memset(stream->cached_chunk, 0, stream->chunk_size);
        free(stream->cached_chunk);
    }
    mp_crypto_close(stream);
#if defined(_WIN32)
    if (stream->winsock_started) WSACleanup();
#endif
    memset(stream->key, 0, sizeof(stream->key));
    memset(stream->nonce, 0, sizeof(stream->nonce));
    free(stream->signed_hashes);
    free(stream);
}
