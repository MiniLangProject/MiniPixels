param([Parameter(Mandatory=$true)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
$vswhere = 'C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe'
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
$vs = @($vs)[0]
if (-not $vs) {
  # Visual Studio can temporarily be marked incomplete while a reboot is
  # pending even though the installed C++ toolchain is fully usable.
  $vs = @(& $vswhere -all -products * -property installationPath | Where-Object {
    Test-Path -LiteralPath (Join-Path $_ 'VC\Auxiliary\Build\vcvars64.bat')
  })[0]
}
if (-not $vs) { throw 'Visual Studio C++ x64 tools are required for the optional GPU backend.' }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$dest = (Resolve-Path -LiteralPath $OutputDirectory).Path
$source = Join-Path $PSScriptRoot 'gpu_scene.cpp'
$dll = Join-Path $dest 'minipixels_gpu.dll'
$header = Join-Path $PSScriptRoot 'gpu_scene3d.hpp'
$fingerprint = ((Get-FileHash -LiteralPath $source).Hash + ':' + (Get-FileHash -LiteralPath $header).Hash)
$stamp = Join-Path $dest 'minipixels-gpu-source.sha256'
if ((Test-Path -LiteralPath $dll) -and (Test-Path -LiteralPath $stamp) -and (Get-Content -Raw -LiteralPath $stamp).Trim() -eq $fingerprint) { return }
$vcvars = Join-Path $vs 'VC/Auxiliary/Build/vcvars64.bat'
$command = "`"$vcvars`" >nul && cl /nologo /O2 /EHsc /MT /LD /std:c++17 `"$source`" /Fo`"$dest/gpu_scene.obj`" /link /OUT:`"$dll`" /IMPLIB:`"$dest/minipixels_gpu.lib`" opengl32.lib gdi32.lib user32.lib"
& cmd.exe /d /s /c $command
if ($LASTEXITCODE -ne 0) { throw 'GPU backend compilation failed.' }
Set-Content -LiteralPath $stamp -Value $fingerprint
