@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ISO_PATH=%SCRIPT_DIR%durgaos-amd64.iso"

echo ======================================================
echo          BOOT TESTING DURGA OS ISO IN QEMU           
echo ======================================================

:: 1. Check if ISO exists
if not exist "%ISO_PATH%" (
    echo [ERROR] %ISO_PATH% does not exist!
    echo Please build the ISO first using build-iso-windows.bat or copy durgaos-amd64.iso here.
    echo.
    pause
    exit /b 1
)

:: 2. Check for QEMU executable
set "QEMU_BIN="
where qemu-system-x86_64 >nul 2>nul
if %ERRORLEVEL% equ 0 (
    set "QEMU_BIN=qemu-system-x86_64"
) else if exist "%ProgramFiles%\qemu\qemu-system-x86_64.exe" (
    set "QEMU_BIN=%ProgramFiles%\qemu\qemu-system-x86_64.exe"
)

if "%QEMU_BIN%"=="" (
    echo [ERROR] QEMU was not found on your system!
    echo.
    echo To install QEMU on Windows, run in PowerShell:
    echo   winget install SoftwareFreedomConservancy.QEMU
    echo Or download from: https://www.qemu.org/download/#windows
    echo.
    echo Alternatively, you can use VirtualBox with: run-virtualbox.bat
    echo.
    pause
    exit /b 1
)

echo [INFO] Found QEMU at: "%QEMU_BIN%"
echo [INFO] ISO File: "%ISO_PATH%"
echo.
echo Launching Durga OS in QEMU...
echo Tip: Use Ctrl+Alt+G to release mouse focus from QEMU window.
echo ------------------------------------------------------

"%QEMU_BIN%" ^
    -accel whpx -accel tcg ^
    -m 4096 ^
    -smp 4 ^
    -vga virtio ^
    -display default,show-cursor=on ^
    -device intel-hda -device hda-duplex ^
    -cdrom "%ISO_PATH%"

pause
