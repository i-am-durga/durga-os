#!/bin/bash

set -e

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO_PATH="${BUILD_DIR}/durgaos-amd64.iso"

if [ ! -f "${ISO_PATH}" ]; then
    echo "ERROR: ${ISO_PATH} does not exist. Run ./build-iso.sh first."
    exit 1
fi

echo "======================================================"
echo "          BOOT TESTING DURGA OS ISO IN QEMU           "
echo "======================================================"
echo "ISO File: ${ISO_PATH}"
echo ""
echo "NOTE ON WAYDROID/ANDROID TESTING:"
echo "Waydroid container hardware acceleration requires real GPU / KVM passthrough."
echo "QEMU software emulation can boot Durga OS and run Linux/Wine apps cleanly,"
echo "but Waydroid Android performance requires host KVM + GPU rendering."
echo "------------------------------------------------------"

qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -cpu host \
    -smp 4 \
    -vga virtio \
    -display default,show-cursor=on \
    -device intel-hda -device hda-duplex \
    -cdrom "${ISO_PATH}"
