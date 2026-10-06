"""SDK-independent Steam build/export regression tests."""
import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import steam_support as steam
import minipixels as cli
import package_sdk


class SteamToolsTests(unittest.TestCase):
    def test_build_output_never_deletes_source_audio(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            audio = root / "assets/audio"
            audio.mkdir(parents=True)
            original = audio / "original.wav"
            original.write_bytes(b"irreplaceable source fixture")
            data = {"assets": [{"type": "audio", "path": "assets/audio/original.wav"}]}
            cli.copy_runtime_assets(data, root, root / "game.exe")
            self.assertEqual(original.read_bytes(), b"irreplaceable source fixture")

    def test_configuration(self):
        self.assertFalse(steam.settings({})["enabled"])
        self.assertFalse(steam.settings({"steam": {"enabled": True, "appId": 480}})["restartThroughSteam"])
        self.assertTrue(steam.settings({"steam": {"mode": "required"}})["restartThroughSteam"])
        for value in (None, [], {"enabled": 1}, {"appId": True}, {"appId": -1}, {"appId": 2**32},
                      {"enabled": True}, {"mode": "online"}, {"pauseOnOverlay": 1}, {"typo": True},
                      {"depots": {"windows-x64": 1, "linux-x64": 1}}):
            with self.subTest(value=value), self.assertRaises(ValueError):
                steam.settings({"steam": value})

    def test_export_allowlist(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            build = root / "build"
            build.mkdir()
            names = ["game.exe", "assets.mpx", "minipixels_audio.dll", "minipixels_steam.dll", "steam_api64.dll", "minilang_video.dll", "minipixels_gpu.dll"]
            for name in names + ["steam_appid.txt", "secret.pem", "main.ml", "junk.dll"]:
                (build / name).write_bytes(b"test")
            (build / "steam-build.json").write_text(json.dumps({"stub": False, "target": "windows-x64"}))
            self.assertEqual(set(steam.stage_depot(build / "game.exe", root / "depot", "windows-x64")), set(names))
            self.assertEqual({p.name for p in (root / "depot").iterdir()}, set(names))
            with self.assertRaises(FileExistsError):
                steam.stage_depot(build / "game.exe", root / "depot", "windows-x64")
            (build / "steam-build.json").write_text(json.dumps({"stub": True, "target": "windows-x64"}))
            with self.assertRaisesRegex(ValueError, "real SDK"):
                steam.stage_depot(build / "game.exe", root / "stub", "windows-x64")
            self.assertFalse((root / "stub").exists())

    def test_preview_scripts(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            cfg = steam.settings({"steam": {"enabled": True, "appId": 1234, "depots": {"windows-x64": 1235, "linux-x64": 1236}}})
            steam.write_depot_scripts(root, cfg, list(steam.TARGETS))
            app = (root / "scripts/app_1234.vdf").read_text()
            self.assertIn('"Preview" "1"', app)
            self.assertNotIn("SetLive", app)
            self.assertIn('"ContentRoot" "../content"', app)
            self.assertIn('"LocalPath" "linux-x64/*"', (root / "scripts/depot_1236.vdf").read_text())

    def test_no_implicit_sdk_or_download(self):
        with patch.dict("os.environ", {}, clear=True):
            with self.assertRaisesRegex(RuntimeError, "STEAMWORKS_SDK"):
                steam.sdk_root(None)

    def test_generated_config(self):
        text = steam.config_source(steam.settings({"steam": {"appId": 480, "mode": "required"}}))
        self.assertIn("function appId() return 480", text)
        self.assertIn("function required() return true", text)

    def test_sdk_package_excludes_development_material(self):
        for relative in ("examples/game/.minipixels/key.pem", "native/steamworks_sdk/public/steam/steam_api.h",
                         "examples/game/steam_appid.txt", "examples/game/steam_api64.dll"):
            self.assertFalse(package_sdk.include_path(package_sdk.ROOT / relative))

    def test_missing_and_wrong_target_artifacts_are_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            marker = root / "steam-build.json"
            marker.write_text(json.dumps({"stub": False, "target": "linux-x64"}))
            with self.assertRaisesRegex(ValueError, "real SDK"):
                steam.stage_depot(root / "game.exe", root / "depot", "windows-x64")
            with self.assertRaisesRegex(ValueError, "Missing/unsafe"):
                steam.stage_depot(root / "game", root / "depot", "linux-x64")
            self.assertFalse((root / "depot").exists())

    def test_export_orchestration(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            sdk = root / "sdk"
            (sdk / "public/steam").mkdir(parents=True)
            (sdk / "public/steam/steam_api.h").write_text("test fixture only")
            data = {"name": "game", "steam": {"enabled": True, "appId": 1234,
                    "depots": {"windows-x64": 1235, "linux-x64": 1236}}}
            project = root / "minipixels.json"
            project.write_text(json.dumps(data))
            built = []

            def fake_build(project, executable, compiler, generated, *, target, steam_sdk):
                built.append(target)
                executable.parent.mkdir(parents=True)
                win = target == "windows-x64"
                names = [executable.name, "assets.mpx", "minipixels_audio.dll" if win else "libminipixels_audio.so",
                         "minipixels_steam.dll" if win else "libminipixels_steam.so", "steam_api64.dll" if win else "libsteam_api.so"]
                for name in names + ["steam_appid.txt", "secret.pem"]:
                    (executable.parent / name).write_bytes(b"test fixture")
                (executable.parent / "steam-build.json").write_text(json.dumps({"stub": False, "target": target}))

            steam.export(project, root / "output", root / "compiler", list(steam.TARGETS), sdk, fake_build, lambda p: data)
            self.assertEqual(built, list(steam.TARGETS))
            for target in steam.TARGETS:
                depot = root / "output/content" / target
                self.assertTrue((depot / "assets.mpx").is_file())
                self.assertFalse((depot / "secret.pem").exists())
                self.assertFalse((depot / "steam_appid.txt").exists())
            with self.assertRaisesRegex(ValueError, "already exists"):
                steam.export(project, root / "output", root / "compiler", list(steam.TARGETS), sdk, fake_build, lambda p: data)
            data["steam"]["appId"] = 480
            with self.assertRaisesRegex(ValueError, "own AppID"):
                steam.export(project, root / "testapp", root / "compiler", list(steam.TARGETS), sdk, fake_build, lambda p: data)

    def test_custom_generated_pack_not_stale_project_pack(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / "build").mkdir()
            (root / "build/assets.mpx").write_bytes(b"stale")
            fresh = root / "export/assets.mpx"
            fresh.parent.mkdir()
            fresh.write_bytes(b"fresh")
            cli.copy_runtime_assets({}, root, fresh.parent / "game.exe", fresh)
            self.assertEqual(fresh.read_bytes(), b"fresh")

    def test_dev_appid_not_overwritten(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            project = root / "minipixels.json"
            project.write_text(json.dumps({"steam": {"enabled": True, "appId": 480}}))
            cli.write_steam_dev_id(project, root / "game.exe")
            self.assertEqual((root / "steam_appid.txt").read_text(), "480\n")
            (root / "steam_appid.txt").write_text("999\n")
            with self.assertRaises(SystemExit):
                cli.write_steam_dev_id(project, root / "game.exe")
            self.assertEqual((root / "steam_appid.txt").read_text(), "999\n")


if __name__ == "__main__":
    unittest.main()
