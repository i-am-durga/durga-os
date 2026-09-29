@echo off
setlocal enabledelayedexpansion

echo ======================================================
echo       BUILDING DURGA OS LIVE ISO FROM WINDOWS        
echo ======================================================

where powershell >nul 2>nul
if %ERRORLEVEL% equ 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-iso-windows.ps1"
) else (
    echo [ERROR] PowerShell is required to run the automated WSL build script.
    echo Alternatively, run WSL manually and execute: sudo ./build-iso.sh
    pause
    exit /b 1
)

pause
