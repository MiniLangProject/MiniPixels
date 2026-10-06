"""Steam FFI/save smoke tests; defaults to a stub, --sdk opts into real SDK tests."""
import json
import argparse
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from minipixels import build
from build_audio_runtime import _wsl_path


def run(compiler: Path, target: str, sdk: Path | None = None, require_client: bool = False):
    with tempfile.TemporaryDirectory(prefix="steam-test-", dir=ROOT / "build") as folder:
        root = Path(folder)
        project = root / "minipixels.json"
        project.write_text(json.dumps({"name": "steam-smoke", "main": "main.ml", "window": {"width": 8, "height": 8},
                                       "assets": [], "steam": {"enabled": True, "appId": 480}}), encoding="utf-8")
        source = "steam_sdk_game_smoke.ml" if sdk else "steam_runtime_smoke.ml"
        (root / "main.ml").write_bytes((ROOT / "tests" / source).read_bytes())
        exe = build(project, None, compiler, root / "build/generated/generated", target=target, subsystem="console", steam_stub=sdk is None, steam_sdk=sdk)
        env = os.environ.copy()
        env["LOCALAPPDATA"] = str(root / "userdata")
        env["XDG_DATA_HOME"] = str(root / "userdata")
        extra = ["--require-client"] if require_client else []
        # WSL can briefly retain the launch directory after process exit.
        # Keep this empty fixture outside the temporary build being cleaned up.
        foreign = ROOT / "build/tests/steam foreign working directory"
        foreign.mkdir(parents=True, exist_ok=True)
        command = [str(exe), *extra]
        if sdk:
            env["SteamAppId"] = env["SteamGameId"] = "480"
        if target == "linux-x64" and os.name == "nt":
            command = ["wsl.exe", "-d", os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu"), "--cd", _wsl_path(foreign),
                       "--", "env", "XDG_DATA_HOME=" + _wsl_path(root / "userdata"),
                       *(["SteamAppId=480", "SteamGameId=480"] if sdk else []), _wsl_path(exe), *extra]
        result = subprocess.run(command, cwd=foreign, env=env, text=True, capture_output=True, timeout=45)
        print(result.stdout)
        success = "Tests: 1, passed: 1, failed: 0" if sdk else "=== STEAM NATIVE/SAVE SMOKE DONE ==="
        if result.returncode or "[FAIL]" in result.stdout or success not in result.stdout:
            raise AssertionError(result.stdout + result.stderr)
        assert not list((root / "userdata").rglob("*.tmp")), "atomic save left temporary files"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("target", choices=("windows-x64", "linux-x64"))
    parser.add_argument("--sdk", type=Path, help="opt in to the real SDK instead of the CI stub")
    parser.add_argument("--require-client", action="store_true", help="fail unless a real Steam client connects")
    args = parser.parse_args()
    if args.require_client and args.sdk is None:
        parser.error("--require-client requires --sdk")
    run(args.compiler.resolve(), args.target, args.sdk, args.require_client)
