# 🚀 Durga OS 1.0 LTS — Architecture & Project Guide

> **Vision**: Durga OS is a next-generation hybrid operating system that combines the **sleek aesthetics and user experience of macOS**, the **broad application compatibility of Windows** (running `.exe` files and Android `.apk` apps), and the **uncompromising security & stability of Linux**.

---

## 🏛️ The Three Pillars of Durga OS

```
                     ┌──────────────────────────────────────────┐
                     │              DURGA OS 1.0                │
                     └────────────────────┬─────────────────────┘
                                          │
        ┌─────────────────────────────────┼─────────────────────────────────┐
        ▼                                 ▼                                 ▼
 🎨 macOS Aesthetics              💻 Windows Features              🛡️ Linux Security
 ────────────────────             ───────────────────              ──────────────────
 • Glassmorphism UI               • Native .exe execution          • Debian Bookworm kernel
 • Animated Plymouth Boot           (Wine64 + Winetricks)          • AppArmor MAC Profiles
 • Unified App Center             • Android .apk apps (Waydroid)   • UFW Firewall (Strict)
 • Smooth KDE Animations          • Windows 11-style Taskbar       • Systemd optimizations
```

---

## 1. 🎨 macOS Features & Aesthetics

Durga OS incorporates the polished visual elegance, smooth animations, and intuitive app workflows characteristic of macOS:

* **Animated Boot Splash (Plymouth)**: 
  * Custom `durga-animated` boot screen with smooth logo fade-in and a pulsating cyan progress bar during system startup.
* **Glassmorphism & Modern UI**:
  * Powered by KDE Plasma 5 with translucent panels, blur effects, dynamic animations, and high-resolution Himalayan wallpapers (`DurgaOS-Himalaya`).
* **Unified App Center Launcher**:
  * Features custom utility `/usr/local/bin/durga-app-center` providing a single macOS-like launcher for discovering Linux apps, running Windows programs, starting Android apps, or opening System Settings.
* **Clean System Layout**:
  * SDDM login manager customized with clean typography, centered user cards, and subtle background blur.

---

## 2. 💻 Windows & Android Application Compatibility

Durga OS removes the software gap by letting users run Windows executables and Android apps natively on Linux:

* **Windows `.exe` Execution Layer**:
  * Built-in **Wine 64-bit**, **Winetricks**, `cabextract`, and support for **Bottles**.
  * Pre-configured dependencies to run Windows desktop software without complex setup.
* **Android App Support (Waydroid Integration)**:
  * Integrated **Waydroid container framework** using Linux LXC containers and kernel `binderfs`.
  * Allows Android `.apk` apps to run seamlessly on modern Linux displays.
* **Universal Software Management**:
  * Pre-configured **Flatpak (Flathub)** and **Snapd** backends integrated into KDE Discover.

---

## 3. 🛡️ Linux Security & Performance Core

Underneath the modern interface, Durga OS relies on Debian Bookworm’s rock-solid kernel and strict security architecture:

* **Debian 12 (Bookworm) 64-Bit Core**:
  * Rock-solid stability, LTS kernel updates, and long-term hardware support.
* **AppArmor Protection**:
  * Kernel parameter `security=apparmor apparmor=1` enabled by default to isolate applications and protect against zero-day vulnerabilities.
* **UFW Firewall Policy**:
  * Default policy blocks all unsolicited incoming network connections while allowing safe outgoing traffic (`ufw default deny incoming`).
* **Fast Boot & Memory Management**:
  * `zswap` memory compression enabled for fast memory handling under heavy workloads.
  * Unnecessary `systemd` online-wait delays masked for quick startup.
* **Dual BIOS + UEFI Bootloader**:
  * Includes both `syslinux` (Legacy BIOS) and `grub-efi` (UEFI) bootloaders for universal PC & Virtual Machine compatibility.

---

## 📁 Repository File Map

| File Path | Host Platform | Description |
| :--- | :--- | :--- |
| [`build-iso.sh`](build-iso.sh) | Linux / WSL | Main script to build the bootable `durgaos-amd64.iso` image. |
| [`build-iso-windows.bat`](build-iso-windows.bat) / [`.ps1`](build-iso-windows.ps1) | Windows | Automates building the ISO on Windows using WSL 2. |
| [`build-iso-docker.bat`](build-iso-docker.bat) | Windows / Docker | Containerized ISO build using Docker Desktop. |
| [`run-virtualbox.bat`](run-virtualbox.bat) / [`.ps1`](run-virtualbox.ps1) | Windows | Auto-configures and runs the ISO in Oracle VirtualBox. |
| [`test-iso.bat`](test-iso.bat) / [`.ps1`](test-iso.ps1) | Windows | Tests the ISO in QEMU with WHPX hardware acceleration. |
| [`run-virtualbox.sh`](run-virtualbox.sh) | Linux | Launches the ISO in VirtualBox on Linux hosts. |
| [`test-iso.sh`](test-iso.sh) | Linux | Script to launch and test the ISO in QEMU with KVM acceleration. |
| [`config/package-lists/desktop.list.chroot`](config/package-lists/desktop.list.chroot) | Common | Package list for KDE Plasma, Plymouth, Calamares installer. |
| [`config/package-lists/wine-android.list.chroot`](config/package-lists/wine-android.list.chroot) | Common | Package list for Wine, Waydroid, Flatpak, and Snap support. |
| [`config/package-lists/security.list.chroot`](config/package-lists/security.list.chroot) | Common | Package list for firewall and security tools. |
| [`config/hooks/live/`](config/hooks/live/) | Common | Automated build scripts for branding, security, Plymouth, and Waydroid setup. |
| [`config/includes.chroot/usr/local/bin/durga-app-center`](config/includes.chroot/usr/local/bin/durga-app-center) | Common | Custom Unified App Center launcher. |
| [`config/includes.chroot/usr/local/bin/durga-firstboot.sh`](config/includes.chroot/usr/local/bin/durga-firstboot.sh) | Common | Post-install system setup service script. |

---

## ⚡ Quick Start Commands

### On Windows
```powershell
# 1. Run in Oracle VirtualBox:
.\run-virtualbox.ps1       # Or double-click run-virtualbox.bat

# 2. Test in QEMU:
.\test-iso.ps1             # Or double-click test-iso.bat

# 3. Build ISO via WSL 2:
.\build-iso-windows.ps1    # Or double-click build-iso-windows.bat
```

### On Linux
```bash
# 1. Build the Durga OS ISO (requires sudo)
sudo ./build-iso.sh

# 2. Run in VirtualBox
./run-virtualbox.sh

# 3. Test the ISO in QEMU
./test-iso.sh
```
