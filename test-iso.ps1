<#
.SYNOPSIS
    Tests Durga OS Live ISO using QEMU for Windows.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IsoPath   = Join-Path $ScriptDir "durgaos-amd64.iso"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "          BOOT TESTING DURGA OS ISO IN QEMU           " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

if (-not (Test-Path $IsoPath)) {
    Write-Host "[ERROR] ISO file not found at: $IsoPath" -ForegroundColor Red
    Write-Host "Please build the ISO first or copy durgaos-amd64.iso to this folder." -ForegroundColor Yellow
    exit 1
}

$QemuBin = Get-Command "qemu-system-x86_64.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $QemuBin) {
    if (Test-Path "$env:ProgramFiles\qemu\qemu-system-x86_64.exe") {
        $QemuBin = "$env:ProgramFiles\qemu\qemu-system-x86_64.exe"
    }
}

if (-not $QemuBin) {
    Write-Host "[ERROR] QEMU executable not found!" -ForegroundColor Red
    Write-Host "Install QEMU on Windows via winget: winget install SoftwareFreedomConservancy.QEMU" -ForegroundColor Yellow
    Write-Host "Or run with Oracle VirtualBox using: .\run-virtualbox.ps1" -ForegroundColor Cyan
    exit 1
}

Write-Host "[INFO] Using QEMU: $QemuBin" -ForegroundColor Green
Write-Host "[INFO] ISO File:   $IsoPath" -ForegroundColor Green
Write-Host "`nLaunching QEMU (Ctrl+Alt+G releases cursor focus)...`n" -ForegroundColor Yellow

& "$QemuBin" `
    -accel whpx -accel tcg `
    -m 4096 `
    -smp 4 `
    -vga virtio `
    -display default,show-cursor=on `
    -device intel-hda -device hda-duplex `
    -cdrom $IsoPath
