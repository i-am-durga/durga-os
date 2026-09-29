<#
.SYNOPSIS
    Launches Durga OS Live ISO in Oracle VM VirtualBox on Windows.
#>

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IsoPath   = Join-Path $ScriptDir "durgaos-amd64.iso"
$VmName    = "DurgaOS"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "      STARTING DURGA OS ISO IN ORACLE VIRTUALBOX     " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 1. Check if ISO exists
if (-not (Test-Path $IsoPath)) {
    Write-Host "[ERROR] ISO file not found at: $IsoPath" -ForegroundColor Red
    Write-Host "Please build the ISO first using .\build-iso-windows.ps1 or copy durgaos-amd64.iso here." -ForegroundColor Yellow
    exit 1
}

# 2. Locate VBoxManage
$VBoxManage = Get-Command "VBoxManage.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if (-not $VBoxManage) {
    $CommonPaths = @(
        "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe",
        "${env:ProgramFiles(x86)}\Oracle\VirtualBox\VBoxManage.exe"
    )
    foreach ($Path in $CommonPaths) {
        if (Test-Path $Path) {
            $VBoxManage = $Path
            break
        }
    }
}

if (-not $VBoxManage) {
    Write-Host "[ERROR] Oracle VirtualBox is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Install it with winget: winget install Oracle.VirtualBox" -ForegroundColor Yellow
    Write-Host "Or download from: https://www.virtualbox.org/wiki/Downloads" -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] VirtualBox executable: $VBoxManage" -ForegroundColor Green
Write-Host "[INFO] ISO File: $IsoPath" -ForegroundColor Green

# 3. Create VM if not existing
$Vms = & "$VBoxManage" list vms
if ($Vms -notmatch "`"$VmName`"") {
    Write-Host "[1/3] Creating VirtualBox VM '$VmName'..." -ForegroundColor Magenta
    & "$VBoxManage" createvm --name $VmName --ostype "Debian_64" --register
    & "$VBoxManage" storagectl $VmName --name "IDE" --add ide
    & "$VBoxManage" storagectl $VmName --name "SATA" --add sata
} else {
    Write-Host "[1/3] VM '$VmName' already exists." -ForegroundColor Gray
}

# 4. Configure VM specifications
Write-Host "[2/3] Configuring VM specs (4GB RAM, 2 vCPUs, 128MB VRAM)..." -ForegroundColor Magenta
& "$VBoxManage" modifyvm $VmName `
    --memory 4096 `
    --vram 128 `
    --cpus 2 `
    --graphicscontroller vmsvga `
    --boot1 dvd `
    --boot2 disk

# 5. Attach ISO
Write-Host "[3/3] Attaching Durga OS ISO..." -ForegroundColor Magenta
& "$VBoxManage" storageattach $VmName `
    --storagectl "IDE" `
    --port 0 `
    --device 0 `
    --type dvddrive `
    --medium $IsoPath

# 6. Start VM
Write-Host "`nLaunching Durga OS in VirtualBox..." -ForegroundColor Cyan
& "$VBoxManage" startvm $VmName --type gui

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n======================================================" -ForegroundColor Green
    Write-Host " SUCCESS! Durga OS is booting in VirtualBox." -ForegroundColor Green
    Write-Host "======================================================" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to start VirtualBox VM." -ForegroundColor Red
}
