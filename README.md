# 🚀 Durga OS 1.0 LTS

[![Debian](https://img.shields.io/badge/Debian-12%20Bookworm-red.svg)](https://www.debian.org/)
[![Desktop](https://img.shields.io/badge/Desktop-KDE%20Plasma-blue.svg)](https://kde.org/plasma-desktop/)
[![Platform](https://img.shields.io/badge/Host-Linux%20%7C%20Windows%20(WSL2)-brightgreen.svg)](#)
[![License](https://img.shields.io/badge/License-GPL%20v3-green.svg)](LICENSE)
[![Build](https://img.shields.io/badge/Build-Live--Build-orange.svg)](build-iso.sh)

> **Durga OS** is a next-generation hybrid operating system combining the **sleek aesthetics and user experience of macOS**, the **broad software compatibility of Windows & Android**, and the **uncompromising security & performance of Debian Linux**.

---

## 🏛️ System Architecture Overview

```
                     ┌──────────────────────────────────────────┐
                     │              DURGA OS 1.0                │
                     └────────────────────┬─────────────────────┘
                                          │
        ┌─────────────────────────────────┼─────────────────────────────────┐
        ▼                                 ▼                                 ▼
 🎨 macOS Aesthetics              💻 Windows & Android             🛡️ Linux Security
 ────────────────────             ────────────────────             ──────────────────
 • Glassmorphism UI               • Native .exe execution          • Debian 12 LTS Core
 • Animated Plymouth Boot           (Wine64 + Winetricks)          • AppArmor MAC Profiles
 • Unified App Center             • Android .apk apps (Waydroid)   • UFW Firewall (Strict)
 • KDE Plasma Customization       • Windows 11-style Taskbar       • zswap Memory Compression
```

---

## ✨ Key Features

### 🎨 1. macOS Aesthetics & Visual Excellence
- **Animated Boot Splash (Plymouth)**: Custom `durga-animated` theme with smooth logo animations and glowing progress indicators.
- **Glassmorphism UI**: Powered by KDE Plasma 5 with blurred translucency, dynamic dock layout, and HD Himalayan wallpapers (`DurgaOS-Himalaya`).
- **Unified App Center**: Custom launcher tool (`/usr/local/bin/durga-app-center`) to quickly open Linux, Windows, or Android apps.
- **Customized SDDM**: Clean login manager interface with centered user cards and ambient background blur.

### 💻 2. Windows & Android Compatibility Layer
- **Windows `.exe` Execution**: Pre-configured **Wine 64-bit**, **Winetricks**, `cabextract`, and support for **Bottles**.
- **Android App Support (Waydroid)**: Integrated LXC container framework with kernel `binderfs` for running Android `.apk` applications natively on Linux display servers.
- **Universal Package Support**: Out-of-the-box integration with **Flatpak (Flathub)** and **Snapd** backends.

### 🛡️ 3. Hardened Linux Security Core
- **Debian 12 (Bookworm) 64-Bit Base**: Enterprise-grade stability and long-term hardware support.
- **AppArmor Protection**: Kernel parameter `security=apparmor apparmor=1` enabled by default to isolate sandboxed processes.
- **UFW Firewall**: Default network policy blocks all unsolicited incoming connections (`ufw default deny incoming`).
- **Universal Bootloader**: Supports both Legacy BIOS (`syslinux`) and UEFI (`grub-efi`).

---

## 📁 Repository Directory Map

| Path | OS Target | Description |
| :--- | :--- | :--- |
| [`build-iso.sh`](build-iso.sh) | Linux / WSL | Automated script to build `durgaos-amd64.iso` via Debian `live-build`. |
| [`build-iso-windows.bat`](build-iso-windows.bat) / [`.ps1`](build-iso-windows.ps1) | Windows | Automates building the ISO on Windows using WSL 2 (Debian/Ubuntu). |
| [`build-iso-docker.bat`](build-iso-docker.bat) | Windows / Docker | Builds the ISO in a clean Debian container using Docker Desktop. |
| [`run-virtualbox.bat`](run-virtualbox.bat) / [`.ps1`](run-virtualbox.ps1) | Windows | Auto-configures and boots Durga OS in Oracle VirtualBox on Windows. |
| [`test-iso.bat`](test-iso.bat) / [`.ps1`](test-iso.ps1) | Windows | Boots the ISO in QEMU for Windows with WHPX hardware acceleration. |
| [`run-virtualbox.sh`](run-virtualbox.sh) | Linux | Launcher script to test the ISO in Oracle VM VirtualBox on Linux. |
| [`test-iso.sh`](test-iso.sh) | Linux | Script to test the built ISO in QEMU on Linux. |
| [`config/package-lists/`](config/package-lists/) | Common | Desktop, Security, and Compatibility package definitions. |
| [`config/hooks/live/`](config/hooks/live/) | Common | Build hooks for branding, Plymouth theme, UFW firewall, and Waydroid setup. |
| [`config/includes.chroot/`](config/includes.chroot/) | Common | Custom system configurations, launchers, and wallpapers. |

---

## 🪟 Windows Instructions: Running & Building

You can test, run, and build Durga OS directly from Windows.

### 1. Run Durga OS in Oracle VirtualBox (Recommended)
1. **Prerequisites**: Ensure Oracle VirtualBox is installed.
   ```powershell
   winget install Oracle.VirtualBox
   ```
2. **Launch**:
   - Double-click **`run-virtualbox.bat`** in Windows Explorer, OR
   - Run in PowerShell:
     ```powershell
     .\run-virtualbox.ps1
     ```
   *The script automatically creates the VM (`DurgaOS`), allocates 4GB RAM, 2 CPUs, 128MB VRAM with VMSVGA 3D graphics, mounts `durgaos-amd64.iso`, and powers on the machine.*

---

### 2. Test in QEMU for Windows
1. **Prerequisites**: Install QEMU for Windows.
   ```powershell
   winget install SoftwareFreedomConservancy.QEMU
   ```
2. **Launch**:
   - Double-click **`test-iso.bat`**, OR
   - Run in PowerShell:
     ```powershell
     .\test-iso.ps1
     ```
   *Uses the Windows Hypervisor Platform (`-accel whpx`) for hardware-accelerated virtualization.*
   *(Tip: Press `Ctrl + Alt + G` to release the mouse cursor from the QEMU window).*

---

### 3. Build the ISO from Windows

Because Debian `live-build` requires Linux kernel namespaces, chroots, and loop device mounts, building on Windows is performed using either **WSL 2** or **Docker Desktop**.

#### Method A: Using WSL 2 (Automated)
1. **Install WSL with Debian or Ubuntu** (run in Administrator PowerShell):
   ```powershell
   wsl --install -d Debian
   # Or: wsl --install -d Ubuntu
   ```
2. **Run the Automated Windows Build Script**:
   - Double-click **`build-iso-windows.bat`**, OR
   - Run in PowerShell:
     ```powershell
     .\build-iso-windows.ps1
     ```
   *What this script does:*
   - Automatically detects your WSL distribution.
   - Copies files into WSL's native `ext4` filesystem (`~/durga-os-build`) to prevent Windows NTFS permissions conflicts with `live-build`.
   - Installs `live-build` and `rsync` inside WSL.
   - Executes `lb build` with root privileges.
   - Transfers the finished `durgaos-amd64.iso` straight back into your Windows directory.

#### Method B: Using Docker Desktop
If you have Docker Desktop installed on Windows:
```cmd
build-iso-docker.bat
```

---

## 🐧 Linux Instructions: Running & Building

### 1. Build the Live ISO Image
Make sure `live-build` and `rsync` are installed on your Debian or Ubuntu host:
```bash
sudo apt update && sudo apt install -y live-build rsync

# Run the ISO build script (requires root privileges)
sudo ./build-iso.sh
```
*The resulting ISO file will be created as `durgaos-amd64.iso`.*

### 2. Test in Oracle VirtualBox
Launch Durga OS directly in Oracle VirtualBox:
```bash
chmod +x run-virtualbox.sh
./run-virtualbox.sh
```

### 3. Test in QEMU Virtual Machine
```bash
sudo apt install -y qemu-system-x86 qemu-utils
chmod +x test-iso.sh
./test-iso.sh
```

---

## 📜 License
Durga OS is open-source software released under the **GNU General Public License v3.0 (GPL-3.0)**.
