#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${WORKSPACE_DIR:-$SCRIPT_DIR}"
TARGET_DIR="${TARGET_DIR:-/tmp/durga-os-build}"

echo "======================================================"
echo "    BUILDING DURGA OS LIVE INSTALLABLE ISO SYSTEM    "
echo "======================================================"

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: live-build requires root privileges."
    echo "Please run: sudo ./build-iso.sh"
    exit 1
fi

# live-build does not support directories with spaces or NTFS /mnt/ mounts
if [[ "${PWD}" == *" "* ]] || [[ "${PWD}" == /mnt/* ]]; then
    echo "Directory path contains spaces or is on a 9p/NTFS mount (/mnt/*)."
    echo "Syncing build files to native Linux ext4 path: ${TARGET_DIR}..."
    mkdir -p "${TARGET_DIR}"
    rsync -av --delete \
        --exclude='*.iso' \
        --exclude='binary' \
        --exclude='chroot' \
        --exclude='.build' \
        --exclude='cache' \
        --exclude='chroot.*' \
        --exclude='live-image*' \
        "${WORKSPACE_DIR}/" "${TARGET_DIR}/"
    cd "${TARGET_DIR}"
else
    TARGET_DIR="${PWD}"
fi

if ! command -v lb &>/dev/null; then
    echo "ERROR: live-build is not installed. Run 'sudo apt-get install live-build' first."
    exit 1
fi

echo "[1/3] Cleaning previous build environment..."
lb clean --purge

echo "[2/3] Executing live-build configuration..."
lb config \
	--distribution bookworm \
	--architectures amd64 \
	--archive-areas "main contrib non-free non-free-firmware" \
	--debian-installer live \
	--debian-installer-distribution bookworm \
	--binary-images iso-hybrid \
	--bootloader "syslinux,grub-efi" \
	--memtest none \
	--win32-loader false \
	--security true \
	--updates true \
	--apt-indices false \
	--apt-recommends true \
	--debootstrap-options "--include=ca-certificates,gnupg2"

echo "[3/3] Building Durga OS ISO image..."
lb build

if [ -f live-image-amd64.hybrid.iso ]; then
    mv live-image-amd64.hybrid.iso "${TARGET_DIR}/durgaos-amd64.iso"
fi

if [ -f "${TARGET_DIR}/durgaos-amd64.iso" ]; then
    mkdir -p "${WORKSPACE_DIR}"
    cp "${TARGET_DIR}/durgaos-amd64.iso" "${WORKSPACE_DIR}/durgaos-amd64.iso"
    echo ""
    echo "======================================================"
    echo " SUCCESS! Durga OS ISO built successfully at:"
    echo " ${TARGET_DIR}/durgaos-amd64.iso"
    echo " Workspace Copy: ${WORKSPACE_DIR}/durgaos-amd64.iso"
    echo "======================================================"
else
    echo "ERROR: ISO build failed to generate output file."
    exit 1
fi
