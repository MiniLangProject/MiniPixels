# Visual Tiled maps (development)

`minipixels.world.visualmap` is a small renderer for finite, orthogonal Tiled
JSON maps. Unlike the existing levels generator, it treats GIDs as image
references rather than collision. Import directly, supply the atlas, call
`visualmap.parse(jsonText, sheet)` and `visualmap.draw(map, canvas, camera)`.
The canvas and camera viewport should match. Empty cells are not drawn.
Horizontal and vertical flip flags are preserved (including both together).
Invalid IDs are errors rather than clamped sprite indices. Only visible tiles
intersecting the canvas are traversed, and sprite frames are cached at load.

The initial scope is one numeric tile layer and one embedded spritesheet
tileset with declared matching dimensions. Infinite/chunked maps, external
tilesets, object/group layers, diagonal/hex rotation flags, animation tiles,
offsets and custom blending are outside this contract. Collision remains a
separate caller concern; the existing tilemap/levels pipeline is unchanged.

The test suite adds an asymmetric synthetic tile and checks exact pixels,
camera culling, all four supported orientations, empty cells and malformed
IDs/data. Native compilation/execution and API documentation regeneration
are still required before merging this development branch.
