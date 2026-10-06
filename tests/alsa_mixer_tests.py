"""Run the real MiniPixels mixer with an isolated, deterministic ALSA sink."""
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from build_audio_runtime import _wsl_path


def run(compiler):
    output = ROOT / 'build/tests/alsa-isolated'
    output.mkdir(parents=True, exist_ok=True)
    native = _wsl_path if os.name == 'nt' else str
    prefix = ['wsl.exe', '-d', os.environ.get('MINIPIXELS_WSL_DISTRO', 'Ubuntu'), '--'] if os.name == 'nt' else []
    subprocess.run(prefix + ['gcc', '-shared', '-fPIC', native(ROOT / 'tests/fixtures/alsa_mock.c'), '-o', native(output / 'libasound.so.2')], check=True)
    exe = output / 'alsa-mixer-tests'
    subprocess.run([sys.executable, str(compiler), str(ROOT / 'tests/alsa_mixer_tests.ml'), str(exe), '-I', str(ROOT / 'src'), '-I', str(compiler.parent), '--target', 'linux-x64'], check=True)
    result = subprocess.run(prefix + ['env', 'LD_LIBRARY_PATH=' + native(output), native(exe)], text=True, capture_output=True, timeout=30)
    print(result.stdout)
    if result.returncode or '[FAIL]' in result.stdout or 'ALSA_MIXER_TESTS_DONE' not in result.stdout:
        raise AssertionError(result.stdout + result.stderr)
