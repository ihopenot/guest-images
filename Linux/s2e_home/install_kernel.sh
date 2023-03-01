#!/bin/sh

set -ex

export DEBIAN_FRONTEND=noninteractive

# Install kernels last, the cause downgrade of libc,
# which will cause issues when installing other packages
install_kernel() {
    sudo dpkg -i linux-image*.deb linux-headers*.deb

    MENU_ENTRY="$(grep menuentry /boot/grub/grub.cfg  | grep s2e | cut -d "'" -f 2 | head -n 1)"
    echo "Default menu entry: $MENU_ENTRY"
    echo "GRUB_DEFAULT=\"1>$MENU_ENTRY\"" | sudo tee -a /etc/default/grub
    sudo update-grub
}

install_kernel

sudo reboot