#!/bin/bash
# Durga OS First Boot Setup Script

FLAG_FILE="/var/lib/durga-firstboot.done"

if [ -f "$FLAG_FILE" ]; then
    exit 0
fi

echo "Initializing Durga OS Environment..."

# 1. Setup Binderfs for Waydroid container if needed
if [ ! -d /dev/binderfs ]; then
    mkdir -p /dev/binderfs
fi
if ! mountpoint -q /dev/binderfs; then
    mount -t binder binder /dev/binderfs 2>/dev/null || true
fi

# 2. Add Flathub remote to Flatpak
if command -v flatpak &>/dev/null; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
fi

# 3. Enable UFW firewall
if command -v ufw &>/dev/null; then
    ufw default deny incoming || true
    ufw default allow outgoing || true
    ufw --force enable || true
fi

# 4. Waydroid Init check
if command -v waydroid &>/dev/null; then
    systemctl enable --now waydroid-container.service 2>/dev/null || true
fi

touch "$FLAG_FILE"
echo "Durga OS First Boot Initialization Completed."
