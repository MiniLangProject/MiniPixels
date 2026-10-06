# Steam integration

MiniPixels has an optional Steamworks adapter for Windows x64 and Linux x64.
Ordinary builds do not import or require the Steam bridge or Steamworks SDK.
Steam builds initialize before window creation, dispatch callbacks once per
rendered frame (also while paused), and shut down after the game's shutdown callback.
All API calls belong on the game thread. One active Steam session is supported.

## Build configuration

Add this block to `minipixels.json`:

```json
"steam": {
  "enabled": true,
  "appId": 480,
  "mode": "optional",
  "restartThroughSteam": false,
  "pauseOnOverlay": true
}
```

`480` is Valve's shared development test application, not a publishing AppID.
Use your own AppID and published achievement/stat definitions for your game.
The `examples/steam-demo` manifest has Steam disabled so the normal example
build works without an SDK. Enable it to test a Steam build.

Obtain the official Steamworks SDK through your Steamworks account and keep it
outside the repository. Point to its `sdk` directory (containing `public/steam`
and `redistributable_bin`) using `--steam-sdk` or `STEAMWORKS_SDK`.
The bridge needs MSVC C++17 on Windows or `g++` on Linux; Windows-to-Linux builds
use the configured WSL distro. No SDK is downloaded by MiniPixels.
For a Linux release, build native bridges in the intended Steam Linux Runtime
SDK/container and test on that runtime. A successful local Ubuntu/WSL build alone
does not establish glibc/libstdc++ compatibility on other distributions.

```powershell
python tools/minipixels.py run examples/steam-demo/minipixels.json --steam-sdk C:/SDK/steamworks/sdk --steam-dev
python tools/minipixels.py build examples/steam-demo/minipixels.json --target linux-x64 --steam-sdk C:/SDK/steamworks/sdk --steam-dev
```

`--steam-dev` explicitly creates `steam_appid.txt` beside the executable; it
refuses to replace a different AppID. Launch with that directory as the working
directory (the Python `run` command does this automatically). Do not ship this
file. It suppresses Steam's normal restart behavior and is only for development.

In `optional` mode, a missing Steam client/runtime falls back to a standalone
game. `required` mode returns a startup error instead; it defaults
`restartThroughSteam` to true. If Steam requests a relaunch, MiniPixels exits
before creating the window or calling game initialization. Required does **not**
mean always-online: a running offline Steam client is allowed. Missing the
MiniPixels bridge itself is a broken installation, not a supported fallback.
Headless execution never initializes Steam.

## Game API

```ml
import minipixels.steam as steam

function initialize(game)
  if game.steam.available then
    print game.steam.userName
    print game.steam.userId  // Exact decimal string, not a floating-point number.
    print game.steam.language
  end if
end function

function wonLevel(game)
  if game.steam.available then
    steam.unlockAchievement(game.steam, "FIRST_WIN")
    steam.setStat(game.steam, "BEST_SCORE", 100)
    steam.flush(game.steam)
  end if
end function
```

`unlockAchievement`/`setStat` report local API acceptance, not persistence.
`achievement` returns 1/0, or -1 when unknown/unavailable. `stat` returns an
integer or an error. Stats here are signed 32-bit integers, not float or
average-rate stats. Names must match your published Steamworks definitions.

Accepted changes are marked dirty and stored automatically, throttled to at
most one request every five seconds after the first. Only one request is in
flight. `game.steam.storeStatus` is `idle`, `pending`, `confirmed`, or `failed`;
confirmation comes from `UserStatsStored_t`, not the initial call. A confirmation
means the Steam API accepted the store, **not** proof of internet synchronization
while offline. Steam handles its own offline cache. Failed stores keep dirty
changes for a later retry. Changes made during a pending store are retained.
Shutdown makes a best-effort store but does not block waiting for callbacks:
store important progress before exiting. Inspect `lastError` for diagnostics.

## Overlay and input

```ml
steam.openOverlay(game.steam, "friends")
steam.openOverlay(game.steam, "achievements")
```

Supported dialog names are `friends`, `achievements`, `stats`, `community`,
`players`, and `settings`. A true return means a request was submitted, not
that the overlay has become visible. `overlayActive` follows Steam callbacks;
`overlaySupported` describes the current MiniPixels presenter capability.

- Windows OpenGL presentation is overlay-capable; GDI fallback is not.
- **Linux currently uses XImage, so the in-game overlay is not supported there.**
  Account APIs, stats, saves and depot export do not depend on the overlay.
  A Linux GLX/EGL presenter remains a separate rendering task.
- Steam client/user settings can disable the overlay even with a capable renderer.
- Overlay activation discards buffered keyboard/mouse input, including the close
  frame, so Escape or a click used in Steam does not immediately affect the game.
- By default simulation pauses while the overlay is active, but presentation and
  Steam callbacks continue. Set `pauseOnOverlay: false` for games that must keep
  simulating. Separately set `cfg.pauseWhenUnfocused = false` when needed.

## Saves and Steam Auto-Cloud

```ml
steam.writeSave(game.steam, "slot1.json", bytes("{\"level\":2}"))
saved = steam.readSave(game.steam, "slot1.json")
```

These functions return success/data or an error; callers must handle failures.
They work with a positive configured AppID even without an active Steam session.
Paths are:

- Windows: `%LOCALAPPDATA%/MiniPixels/<AppID>/<SteamID64>/save-slot1.json`
- Linux: `$XDG_DATA_HOME/MiniPixels/<AppID>/<SteamID64>/save-slot1.json`
  (fallback `$HOME/.local/share`).

An unavailable Steam identity uses the separate `local` directory. Saves are
never silently migrated between local mode or different accounts. Names are
portable ASCII letters/digits, `_`, `-`, and `.`; traversal/separators are rejected.
Writes use a process-specific temporary file and atomic same-directory rename,
so readers see either the old or new complete file. This is not a guarantee
against every power-loss scenario, and simultaneous writers are last-writer-wins.

Configure **Steam Auto-Cloud in Steamworks**; MiniPixels does not change your
partner configuration. Use Windows root `WinAppDataLocal`, subdirectory
`MiniPixels/<AppID>/{64BitSteamID}`, pattern `save-*.json` for these examples.
Add a Linux root override to `LinuxXdgDataHome` using the same relative path.
Do not use `save-*`: temporary files end in `.tmp` and must not be synchronized.
Set suitable quotas and test account switching/offline conflicts. Cloud transfers
are handled by Steam around launch/exit, not directly by `writeSave`. Dynamic
Cloud Sync/Steam Deck suspend handling is not implemented by this adapter.

## SteamPipe export (no upload)

Use your own AppID and depot IDs:

```json
"steam": {
  "enabled": true,
  "appId": 123456,
  "mode": "required",
  "depots": {"windows-x64": 123457, "linux-x64": 123458}
}
```

```powershell
python tools/minipixels.py steam export path/to/minipixels.json --steam-sdk C:/SDK/steamworks/sdk --target windows-x64 --target linux-x64 --output-dir dist/steam-build-001
```

This builds fresh target artifacts and stages `content/<target>` with an explicit
allowlist: executable, matching MPX, audio bridge, Steam bridge, Valve's runtime,
the MiniLang video runtime when present, and the optional Windows `minipixels_gpu.dll`
when present beside the executable. No recursive build-directory copy,
private keys, sources, SDK, `steam_appid.txt`, or credentials enter the depot.
Existing output directories are refused to prevent stale files. Development
stub builds and test AppID 480 cannot be exported. SteamCMD scripts reference
only `content`, never the `work` directory containing generated build files.
Custom extra runtime files need an explicit future export rule, not a wildcard.

Generated `scripts/app_<AppID>.vdf` has **`Preview "1"`**, no `SetLive`, and does
not run SteamCMD. Run a preview with your own Steamworks build account; after
reviewing it, change Preview to 0 for an actual upload. Configure each depot's OS,
launch executable and working directory in Steamworks, and release through the
normal partner process. Steam handles installation and updates, not the engine.
Meet the SDK redistribution terms for the Valve runtime included in your game.

Encryption still affects Steam patch sizes: MPX protection currently creates
fresh ciphertext on each pack build. This integration does not claim to solve
incremental encrypted patches. Stable authenticated per-asset/chunk reuse needs
a separate cache design; never reuse an AES-GCM nonce with changed plaintext.

## Tests and validation limits

The real bridge has been compiled against Steamworks SDK 1.65 for Windows x64
and Linux x64. A Windows client smoke test verifies initialization, identity,
language, manual callbacks and shutdown through both the C ABI and a compiled
MiniLang program. Linux/WSL verifies loading and optional fallback without a
Linux Steam client. Missing Valve runtime DLL fallback is also tested. These
read-only tests do not unlock achievements, change stats or upload builds.

To repeat the real SDK test (the Windows command requires a logged-in client):

```powershell
python tests/steam_runtime_tests.py ../MiniLangCompilerPy/mlc_win64.py windows-x64 --sdk C:/SDK/steamworks/sdk --require-client
python tests/steam_runtime_tests.py ../MiniLangCompilerPy/mlc_win64.py linux-x64 --sdk C:/SDK/steamworks/sdk
```

`--sdk` is explicit: the normal automated suite always uses the test stub even
when `STEAMWORKS_SDK` is installed. SDK 1.65 uses the exported `SteamAPI_InitFlat`
entry point for dynamic loading; `SteamAPI_Init` is an inline C++ helper.

`tests/run_tests.py` runs deterministic Steam session/overlay/store tests and an
explicit native **test stub** on both platforms. It also tests atomic save
replacement, account-separated paths, manifest validation, and depot allowlists.
`--steam-stub` exists only to test missing-client behavior without the SDK; it
does not simulate a real successful Steam connection and cannot be exported.

Build against your supplied official SDK and exercise your own Steam AppID before
shipping. Validate overlay open/close,
offline startup, published achievements, cloud conflicts and installed depots
before release. Tests without that SDK/client are not a Steam certification.
Steam Input action sets, leaderboards, Workshop, DLC entitlement helpers and
Steam networking are not included in this first adapter.

References: [Steamworks API](https://partner.steamgames.com/doc/sdk/api),
[overlay](https://partner.steamgames.com/doc/features/overlay),
[stats](https://partner.steamgames.com/doc/api/ISteamUserStats),
[Auto-Cloud](https://partner.steamgames.com/doc/features/cloud),
[SteamPipe](https://partner.steamgames.com/doc/sdk/uploading).
