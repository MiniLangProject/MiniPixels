param([switch]$AllowUnavailable)
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$vswhere=Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$vs=@(& $vswhere -all -products '*' -property installationPath | Where-Object {Test-Path (Join-Path $_ 'VC/Auxiliary/Build/vcvars64.bat')})[0]
if(-not $vs){throw 'Visual Studio C++ tools required'}
$out=Join-Path $root 'build/scene3d-tests'
New-Item -ItemType Directory -Force $out | Out-Null
$vc=Join-Path $vs 'VC/Auxiliary/Build/vcvars64.bat'
& cmd /d /s /c "`"$vc`" >nul && cl /nologo /O2 /EHsc /MT /std:c++17 `"$root/tests/scene3d_tests.cpp`" /Fo`"$out/tests.obj`" /Fe:`"$out/tests.exe`" /link opengl32.lib gdi32.lib user32.lib"
if($LASTEXITCODE -ne 0){throw 'Compile failed'}
$arguments=@();if($AllowUnavailable){$arguments+='--allow-unavailable'}
& "$out/tests.exe" @arguments
if($LASTEXITCODE -ne 0){throw '3D tests failed'}
