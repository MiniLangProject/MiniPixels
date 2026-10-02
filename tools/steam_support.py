"""Optional Steamworks build and allowlisted SteamPipe staging (never uploads)."""
from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
from pathlib import Path

from build_audio_runtime import _visual_studio_root, _wsl_path

ROOT = Path(__file__).resolve().parents[1]
TARGETS = ("windows-x64", "linux-x64")


def settings(data: dict) -> dict:
    raw = data.get("steam", {})
    if not isinstance(raw, dict):
        raise ValueError("steam must be an object")
    unknown = set(raw) - {"enabled", "appId", "mode", "restartThroughSteam", "pauseOnOverlay", "depots"}
    if unknown:
        raise ValueError(f"unknown steam settings: {', '.join(sorted(unknown))}")
    result = {"enabled": False, "appId": 0, "mode": "optional", "pauseOnOverlay": True, **raw}
    result.setdefault("restartThroughSteam", result["mode"] == "required")
    for key in ("enabled", "restartThroughSteam", "pauseOnOverlay"):
        if type(result[key]) is not bool:
            raise ValueError(f"steam.{key} must be boolean")
    if result["mode"] not in ("optional", "required"):
        raise ValueError("steam.mode must be optional or required")
    if type(result["appId"]) is not int or not 0 <= result["appId"] <= 0xFFFFFFFF:
        raise ValueError("steam.appId must be a uint32 integer")
    if result["enabled"] and result["appId"] == 0:
        raise ValueError("enabled Steam builds need a positive steam.appId")
    depots = result.setdefault("depots", {})
    if not isinstance(depots, dict) or set(depots) - set(TARGETS):
        raise ValueError("steam.depots must map windows-x64/linux-x64 to depot IDs")
    if any(type(value) is not int or not 0 < value <= 0xFFFFFFFF for value in depots.values()):
        raise ValueError("Steam depot IDs must be positive uint32 integers")
    if len(set(depots.values())) != len(depots):
        raise ValueError("Steam depot IDs must be distinct")
    return result


def config_source(config: dict) -> str:
    return "package generated.steam_config\n" + "\n".join(
        f"function {key}() return {str(value).lower()} end function"
        for key, value in (("appId", config["appId"]), ("required", config["mode"] == "required"),
                           ("restartThroughSteam", config["restartThroughSteam"]),
                           ("pauseOnOverlay", config["pauseOnOverlay"]))
    ) + "\n"


def sdk_root(path: Path | None) -> Path:
    raw = path or os.environ.get("STEAMWORKS_SDK")
    if not raw:
        raise RuntimeError("Steam build requires --steam-sdk or STEAMWORKS_SDK (official Steamworks SDK folder)")
    root = Path(raw).resolve()
    if not (root / "public/steam/steam_api.h").is_file():
        raise RuntimeError(f"Steam SDK headers missing in {root}/public/steam")
    return root


def ensure_runtime(target: str, output_dir: Path, sdk: Path | None = None, *, stub: bool = False) -> list[Path]:
    if target not in TARGETS:
        raise ValueError(f"unsupported Steam target: {target}")
    source = ROOT / "native/steam_bridge.cpp"
    sdk = None if stub else sdk_root(sdk)
    runtime = None
    dependencies = [source, Path(__file__)]
    if sdk:
        relative = "win64/steam_api64.dll" if target == TARGETS[0] else "linux64/libsteam_api.so"
        runtime = sdk / "redistributable_bin" / relative
        if not runtime.is_file():
            raise RuntimeError(f"Steam redistributable missing: {runtime}")
        dependencies.extend(sorted((sdk / "public/steam").rglob("*.h")))
    digest = hashlib.sha256()
    for path in dependencies:
        digest.update(str(path).encode())
        digest.update(path.read_bytes())
    fingerprint = digest.hexdigest()
    folder = ROOT / "build/native-steam" / target / ("stub" if stub else "sdk") / fingerprint[:16]
    folder.mkdir(parents=True, exist_ok=True)
    name = "minipixels_steam.dll" if target == TARGETS[0] else "libminipixels_steam.so"
    bridge = folder / name
    if not bridge.is_file():
        if target == TARGETS[0]:
            if os.name != "nt":
                raise RuntimeError("Windows Steam bridge builds require Windows and Visual Studio C++")
            vcvars = _visual_studio_root() / "VC/Auxiliary/Build/vcvars64.bat"
            flags = "/DMP_STEAM_STUB" if stub else f'/I"{sdk / "public"}"'
            script = folder / "build.cmd"
            script.write_text(
                f'@echo off\ncall "{vcvars}" >nul\nif errorlevel 1 exit /b %errorlevel%\n'
                f'cl /nologo /std:c++17 /EHsc /O2 /MT /LD {flags} "{source}" /Fe:"{bridge}" '
                f'/Fo:"{folder / "bridge.obj"}" /link /IMPLIB:"{folder / "bridge.lib"}"\n', encoding="utf-8")
            subprocess.run(["cmd.exe", "/d", "/c", str(script)], check=True, cwd=folder)
        else:
            convert = _wsl_path if os.name == "nt" else str
            command = ["g++", "-std=c++17", "-O2", "-fPIC", "-fvisibility=hidden", "-shared",
                       convert(source), "-ldl", "-o", convert(bridge)]
            command += ["-DMP_STEAM_STUB"] if stub else ["-I" + convert(sdk / "public")]
            if os.name == "nt":
                command = ["wsl.exe", "-d", os.environ.get("MINIPIXELS_WSL_DISTRO", "Ubuntu"), "--", *command]
            subprocess.run(command, check=True)
    output_dir.mkdir(parents=True, exist_ok=True)
    outputs = []
    for path in [bridge, *([runtime] if runtime else [])]:
        destination = output_dir / path.name
        if destination.resolve() != path.resolve():
            shutil.copy2(path, destination)
        outputs.append(destination)
    # Marker is not deployed. It prevents accidentally exporting development stubs.
    (output_dir / "steam-build.json").write_text(json.dumps({"stub": stub, "target": target}), encoding="utf-8")
    return outputs


def stage_depot(executable: Path, destination: Path, target: str) -> list[str]:
    """Never recursively copy a development/build directory into a depot."""
    if target not in TARGETS:
        raise ValueError("unsupported depot target")
    marker = json.loads((executable.parent / "steam-build.json").read_text(encoding="utf-8"))
    if marker.get("stub") is not False or marker.get("target") != target:
        raise ValueError("Steam export requires a real SDK build for the requested target")
    win = target == TARGETS[0]
    names = [executable.name, "assets.mpx", "minipixels_audio.dll" if win else "libminipixels_audio.so",
             "minipixels_steam.dll" if win else "libminipixels_steam.so", "steam_api64.dll" if win else "libsteam_api.so"]
    media = "minilang_video.dll" if win else "libminilang_video.so"
    if (executable.parent / media).is_file():
        names.append(media)
    for name in names:
        path = executable.parent / name
        if not path.is_file() or path.is_symlink():
            raise ValueError(f"Missing/unsafe depot artifact: {path}")
    destination.mkdir(parents=True, exist_ok=False)
    for name in names:
        shutil.copy2(executable.parent / name, destination / name)
    if not win:
        (destination / executable.name).chmod(0o755)
    return names


def write_depot_scripts(output: Path, config: dict, targets: list[str]) -> None:
    scripts = output / "scripts"
    scripts.mkdir(parents=True, exist_ok=True)
    lines = ['"AppBuild"', '{', f'  "AppID" "{config["appId"]}"',
             '  "Desc" "MiniPixels Steam export"', '  "BuildOutput" "../logs"',
             '  "ContentRoot" "../content"', '  "Preview" "1"', '  "Depots"', '  {']
    for target in targets:
        depot = config["depots"][target]
        lines.append(f'    "{depot}" "depot_{depot}.vdf"')
        (scripts / f"depot_{depot}.vdf").write_text(
            f'"DepotBuildConfig"\n{{\n  "DepotID" "{depot}"\n  "FileMapping"\n  {{\n'
            f'    "LocalPath" "{target}/*"\n    "DepotPath" "."\n    "recursive" "1"\n  }}\n}}\n', encoding="utf-8")
    lines += ['  }', '}']
    (scripts / f'app_{config["appId"]}.vdf').write_text("\n".join(lines) + "\n", encoding="utf-8")


def export(project: Path, output: Path, compiler: Path, targets: list[str], sdk: Path | None, build, validate) -> None:
    config = settings(validate(project))
    if not config["enabled"] or config["appId"] == 480:
        raise ValueError("Steam export needs an enabled configuration and your own AppID (not test AppID 480)")
    targets = list(dict.fromkeys(targets))
    if not targets or any(target not in config["depots"] for target in targets):
        raise ValueError("Configure a steam.depots ID for every exported target")
    sdk = sdk_root(sdk)
    if output.exists():
        raise ValueError("Export output already exists; choose a new directory to prevent stale depot files")
    name = json.loads(project.read_text(encoding="utf-8"))["name"]
    if not re.fullmatch(r"[A-Za-z0-9_-]+", name):
        raise ValueError("Steam export needs a portable project name (letters, numbers, underscores, hyphens)")
    output.mkdir(parents=True)
    inventory = {}
    for target in targets:
        work = output / "work" / target
        executable = work / (name + (".exe" if target == TARGETS[0] else ""))
        build(project, executable, compiler, work / "generated/generated", target=target, steam_sdk=sdk)
        inventory[target] = stage_depot(executable, output / "content" / target, target)
    write_depot_scripts(output, config, targets)
    (output / "inventory.json").write_text(json.dumps(inventory, indent=2) + "\n", encoding="utf-8")
    print(f"Steam depots prepared: {output / 'content'} (Preview=1; nothing uploaded)")
