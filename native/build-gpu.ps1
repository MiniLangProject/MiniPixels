param([Parameter(Mandatory=$true)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
$vswhere = 'C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe'
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) { throw 'Visual Studio C++ x64 tools are required for the optional GPU backend.' }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$dest = (Resolve-Path -LiteralPath $OutputDirectory).Path
$source = Join-Path $PSScriptRoot 'gpu_scene.cpp'
$dll = Join-Path $dest 'minipixels_gpu.dll'
if ((Test-Path -LiteralPath $dll) -and (Get-Item -LiteralPath $dll).LastWriteTime -ge (Get-Item -LiteralPath $source).LastWriteTime) { return }
$vcvars = Join-Path $vs 'VC/Auxiliary/Build/vcvars64.bat'
$command = "`"$vcvars`" >nul && cl /nologo /O2 /EHsc /MT /LD /std:c++17 `"$source`" /Fo`"$dest/gpu_scene.obj`" /link /OUT:`"$dll`" /IMPLIB:`"$dest/minipixels_gpu.lib`" opengl32.lib gdi32.lib user32.lib"
& cmd.exe /d /s /c $command
if ($LASTEXITCODE -ne 0) { throw 'GPU backend compilation failed.' }
