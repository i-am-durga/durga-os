@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ISO_PATH=%SCRIPT_DIR%durgaos-amd64.iso"
set "VM_NAME=DurgaOS"

echo ======================================================
echo       STARTING DURGA OS ISO IN ORACLE VIRTUALBOX     
echo ======================================================

:: 1. Check if ISO exists
if not exist "%ISO_PATH%" (
    echo [ERROR] %ISO_PATH% does not exist!
    echo Please build the ISO first using build-iso-windows.bat or copy durgaos-amd64.iso here.
    echo.
    pause
    exit /b 1
)

:: 2. Locate VBoxManage.exe
set "VBOX_BIN="
where VBoxManage >nul 2>nul
if %ERRORLEVEL% equ 0 (
    set "VBOX_BIN=VBoxManage"
) else if exist "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" (
    set "VBOX_BIN=%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe"
) else if exist "%ProgramFiles(x86)%\Oracle\VirtualBox\VBoxManage.exe" (
    set "VBOX_BIN=%ProgramFiles(x86)%\Oracle\VirtualBox\VBoxManage.exe"
)

if "%VBOX_BIN%"=="" (
    echo [ERROR] Oracle VirtualBox was not found on your system!
    echo.
    echo To install VirtualBox on Windows, run in PowerShell:
    echo   winget install Oracle.VirtualBox
    echo Or download the installer from: https://www.virtualbox.org/wiki/Downloads
    echo.
    pause
    exit /b 1
)

echo [INFO] Found VirtualBox at: "%VBOX_BIN%"
echo [INFO] ISO File: "%ISO_PATH%"
echo [INFO] VM Name:  "%VM_NAME%"
echo.

:: 3. Check if VM exists, create if not
"%VBOX_BIN%" list vms | findstr /i "\"%VM_NAME%\"" >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [1/3] Creating VM "%VM_NAME%" (Debian 64-bit)...
    "%VBOX_BIN%" createvm --name "%VM_NAME%" --ostype "Debian_64" --register
    "%VBOX_BIN%" storagectl "%VM_NAME%" --name "IDE" --add ide
    "%VBOX_BIN%" storagectl "%VM_NAME%" --name "SATA" --add sata
) else (
    echo [1/3] VM "%VM_NAME%" already registered.
)

:: 4. Configure specs
echo [2/3] Configuring VM hardware (4GB RAM, 2 CPUs, 128MB VRAM, VMSVGA)...
"%VBOX_BIN%" modifyvm "%VM_NAME%" ^
    --memory 4096 ^
    --vram 128 ^
    --cpus 2 ^
    --graphicscontroller vmsvga ^
    --boot1 dvd ^
    --boot2 disk

:: 5. Attach ISO
echo [3/3] Attaching Durga OS ISO to DVD drive...
"%VBOX_BIN%" storageattach "%VM_NAME%" ^
    --storagectl "IDE" ^
    --port 0 ^
    --device 0 ^
    --type dvddrive ^
    --medium "%ISO_PATH%"

:: 6. Launch VM
echo.
echo Launching Durga OS GUI in Oracle VirtualBox...
"%VBOX_BIN%" startvm "%VM_NAME%" --type gui

if %ERRORLEVEL% equ 0 (
    echo.
    echo ======================================================
    echo  SUCCESS! Durga OS is now booting in VirtualBox!
    echo ======================================================
) else (
    echo [ERROR] Failed to start VirtualBox VM.
)

pause
