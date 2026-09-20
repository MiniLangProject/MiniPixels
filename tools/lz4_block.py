"""Dependency-free encoder for independent, standard LZ4 blocks.

The MiniLang runtime decodes these blocks with ``std.compress.lz4.decode``.
MPX stores the exact logical size in its own eight-byte payload envelope.
"""

from __future__ import annotations


def _length(output: bytearray, value: int) -> None:
    while value >= 255:
        output.append(255)
        value -= 255
    output.append(value)


def encode(data: bytes) -> bytes:
    """Encode one LZ4 block, retaining the required final five literals."""
    size = len(data)
    if size < 13:
        return bytes((size << 4,)) + data
    table = [-1] * 65536
    output = bytearray()
    anchor = position = 0
    search = 1
    limit = size - 12
    while position <= limit:
        word = int.from_bytes(data[position : position + 4], "little")
        slot = ((word * 2654435761) >> 16) & 65535
        previous = table[slot]
        table[slot] = position
        if previous >= 0 and position - previous <= 65535 and data[previous : previous + 4] == data[position : position + 4]:
            matched = 4
            while position + matched < size - 5 and data[previous + matched] == data[position + matched]:
                matched += 1
            literal_length = position - anchor
            match_extra = matched - 4
            output.append((min(literal_length, 15) << 4) | min(match_extra, 15))
            if literal_length >= 15:
                _length(output, literal_length - 15)
            output.extend(data[anchor:position])
            offset = position - previous
            output.extend((offset & 255, offset >> 8))
            if match_extra >= 15:
                _length(output, match_extra - 15)
            position += matched
            anchor = position
            search = 1
        else:
            position += (search >> 6) + 1
            search += 1
    literal_length = size - anchor
    output.append(min(literal_length, 15) << 4)
    if literal_length >= 15:
        _length(output, literal_length - 15)
    output.extend(data[anchor:])
    return bytes(output)
