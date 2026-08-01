# 🚀 Durga OS 1.0 LTS

[![Debian](https://img.shields.io/badge/Debian-12%20Bookworm-red.svg)](https://www.debian.org/)
[![Desktop](https://img.shields.io/badge/Desktop-KDE%20Plasma-blue.svg)](https://kde.org/plasma-desktop/)
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

| Path | Description |
| :--- | :--- |
| [`build-iso.sh`](file:///home/durga/Desktop/ai%20project/durga-os-build/build-iso.sh) | Automated script to build the bootable `durgaos-amd64.iso` image. |
| [`test-iso.sh`](file:///home/durga/Desktop/ai%20project/durga-os-build/test-iso.sh) | Script to test the built ISO image in QEMU virtual machine. |
| [`run-virtualbox.sh`](file:///home/durga/Desktop/ai%20project/durga-os-build/run-virtualbox.sh) | Launcher script to test the ISO in Oracle VM VirtualBox. |
| [`config/package-lists/`](file:///home/durga/Desktop/ai%20project/durga-os-build/config/package-lists/) | Desktop, Security, and Compatibility package definitions for `live-build`. |
| [`config/hooks/live/`](file:///home/durga/Desktop/ai%20project/durga-os-build/config/hooks/live/) | Build hooks for branding, Plymouth theme, UFW firewall, and Waydroid setup. |
| [`config/includes.chroot/`](file:///home/durga/Desktop/ai%20project/durga-os-build/config/includes.chroot/) | Custom system configurations, launchers, and wallpapers. |

---

## 🛠️ How to Build & Test Durga OS

### 1. Build the Live ISO Image
Make sure `live-build` is installed on your Debian/Ubuntu host:
```bash
sudo apt update && sudo apt install -y live-build rsync

# Run the ISO build script (requires root privileges)
sudo ./build-iso.sh
```
*The resulting ISO file will be created as `durgaos-amd64.iso`.*

### 2. Test in Oracle VirtualBox
Launch Durga OS directly in Oracle VirtualBox:
```bash
./run-virtualbox.sh
```

### 3. Test in QEMU Virtual Machine
```bash
sudo apt install -y qemu-system-x86 qemu-utils
./test-iso.sh
```

---

## 📜 License
Durga OS is open-source software released under the **GNU General Public License v3.0 (GPL-3.0)**.
