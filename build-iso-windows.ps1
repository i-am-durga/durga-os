<#
.SYNOPSIS
    Builds the Durga OS ISO from Windows using WSL2 (Debian or Ubuntu).
.DESCRIPTION
    live-build requires native Linux features (chroot, loop devices, mknod)
    which are provided on Windows through WSL2. This script automates preparing
    the WSL environment, running the build on the native ext4 filesystem, and
    copying the generated ISO back to Windows.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "       BUILDING DURGA OS LIVE ISO FROM WINDOWS        " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 1. Check if WSL is available
$WslCmd = Get-Command "wsl.exe" -ErrorAction SilentlyContinue
if (-not $WslCmd) {
    Write-Host "[ERROR] WSL (Windows Subsystem for Linux) is not available." -ForegroundColor Red
    Write-Host "Please install WSL by running in Administrator PowerShell: wsl --install" -ForegroundColor Yellow
    exit 1
}

# 2. Check installed WSL distros
$Distros = wsl.exe -l -q 2>$null | Where-Object { $_ -match '\S' } | ForEach-Object { $_.Trim().Replace("`0", "") }

if (-not $Distros -or $Distros.Count -eq 0) {
    Write-Host "[ERROR] No WSL Linux distributions are installed." -ForegroundColor Red
    Write-Host "To install Debian or Ubuntu for WSL, run:" -ForegroundColor Yellow
    Write-Host "   wsl --install -d Debian" -ForegroundColor Cyan
    Write-Host "   OR"
    Write-Host "   wsl --install -d Ubuntu" -ForegroundColor Cyan
    Write-Host "After the distribution finishes installing, run this script again." -ForegroundColor Yellow
    exit 1
}

# Select preferred distro (Debian preferred for Debian live-build, or Ubuntu)
$ChosenDistro = $Distros | Where-Object { $_ -match "Debian" } | Select-Object -First 1
if (-not $ChosenDistro) {
    $ChosenDistro = $Distros | Where-Object { $_ -match "Ubuntu" } | Select-Object -First 1
}
if (-not $ChosenDistro) {
    $ChosenDistro = $Distros[0]
}

Write-Host "[INFO] Using WSL Distribution: $ChosenDistro" -ForegroundColor Green

# Convert Windows path to WSL path
$WslSourcePath = wsl.exe -d $ChosenDistro wslpath -u "`"$ScriptDir`""
$WslSourcePath = $WslSourcePath.Trim()

Write-Host "[INFO] Windows Workspace in WSL: $WslSourcePath" -ForegroundColor Green

# Build script commands executed inside WSL
$WslScript = @"
set -e
echo '[1/4] Ensuring build dependencies (live-build, rsync) are installed...'
sudo apt update
sudo apt install -y live-build rsync ca-certificates

echo '[2/4] Syncing repository to native ext4 filesystem in WSL (~/durga-os-build)...'
mkdir -p ~/durga-os-build
rsync -av --delete \
    --exclude='*.iso' \
    --exclude='binary' \
    --exclude='chroot' \
    --exclude='.build' \
    --exclude='cache' \
    --exclude='chroot.*' \
    --exclude='live-image*' \
    "$WslSourcePath/" ~/durga-os-build/

cd ~/durga-os-build
chmod +x build-iso.sh

echo '[3/4] Running live-build in WSL...'
sudo bash build-iso.sh

if [ -f "durgaos-amd64.iso" ]; then
    echo '[4/4] Copying generated ISO back to Windows folder...'
    cp durgaos-amd64.iso "$WslSourcePath/durgaos-amd64.iso"
    echo 'SUCCESS: durgaos-amd64.iso copied to Windows!'
else
    echo 'ERROR: durgaos-amd64.iso was not found after build.'
    exit 1
fi
"@

Write-Host "`n[STARTING BUILD] Executing live-build inside WSL ($ChosenDistro)...`n" -ForegroundColor Yellow

$TempWslScript = [System.IO.Path]::GetTempFileName() + ".sh"
[System.IO.File]::WriteAllText($TempWslScript, $WslScript.Replace("`r`n", "`n"))

$WslTempScriptPath = wsl.exe -d $ChosenDistro wslpath -u "`"$TempWslScript`""
$WslTempScriptPath = $WslTempScriptPath.Trim()

wsl.exe -d $ChosenDistro bash "$WslTempScriptPath"
$BuildExitCode = $LASTEXITCODE

Remove-Item -Path $TempWslScript -Force -ErrorAction SilentlyContinue

if ($BuildExitCode -eq 0) {
    Write-Host "`n======================================================" -ForegroundColor Green
    Write-Host " BUILD COMPLETE! ISO is available at:" -ForegroundColor Green
    Write-Host " $(Join-Path $ScriptDir 'durgaos-amd64.iso')" -ForegroundColor Green
    Write-Host " You can run it now with: .\run-virtualbox.ps1 or .\test-iso.ps1" -ForegroundColor Cyan
    Write-Host "======================================================" -ForegroundColor Green
} else {
    Write-Host "`n[ERROR] Build failed with exit code $BuildExitCode." -ForegroundColor Red
}
