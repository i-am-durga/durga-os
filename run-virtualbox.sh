#!/bin/bash

set -e

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO_PATH="${BUILD_DIR}/durgaos-amd64.iso"
VM_NAME="durgadd"

if [ ! -f "${ISO_PATH}" ]; then
    echo "ERROR: ${ISO_PATH} does not exist. Run ./build-iso.sh first."
    exit 1
fi

echo "======================================================"
echo "      STARTING DURGA OS ISO IN ORACLE VIRTUALBOX      "
echo "======================================================"
echo "ISO Path: ${ISO_PATH}"
echo "VM Name:  ${VM_NAME}"
echo ""

# Ensure VM exists or create it
if ! VBoxManage list vms | grep -q "\"${VM_NAME}\""; then
    echo "Creating new VirtualBox VM: ${VM_NAME}..."
    VBoxManage createvm --name "${VM_NAME}" --ostype "Debian_64" --register
    VBoxManage storagectl "${VM_NAME}" --name "IDE" --add ide
    VBoxManage storagectl "${VM_NAME}" --name "SATA" --add sata
fi

# Configure VM specs
VBoxManage modifyvm "${VM_NAME}" \
    --memory 4096 \
    --vram 128 \
    --cpus 2 \
    --graphicscontroller vmsvga \
    --boot1 dvd \
    --boot2 disk

# Attach ISO image
VBoxManage storageattach "${VM_NAME}" \
    --storagectl "IDE" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium "${ISO_PATH}"

# Launch VM
echo "Launching VirtualBox GUI window..."
VBoxManage startvm "${VM_NAME}" --type gui
echo "Durga OS VM is now running in Oracle VirtualBox!"
