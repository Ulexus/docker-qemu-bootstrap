#!/bin/sh
set -e

# Install bootstrap script
INSTALL_PATH=/install
if [ ! -e ${INSTALL_PATH}/qemu_bootstrap.sh ]; then
   cp /qemu_bootstrap.sh ${INSTALL_PATH}/
   chmod +x ${INSTALL_PATH}/qemu_bootstrap.sh
fi

