#!/bin/bash
set -e

# Install qemu base
MACHINE_NAME=cycore_qemu
INSTALL_PATH=/var/lib/cycore/qemu
if [ ! -e ${INSTALL_PATH}/usr/bin/kvm ]; then
   mkdir -p ${INSTALL_PATH}
   docker pull ulexus/qemu
   docker run --name=${MACHINE_NAME} --entrypoint=/bin/true ulexus/qemu
   docker export ${MACHINE_NAME} | sudo tar xf - -C ${INSTALL_PATH}
   docker rm ${MACHINE_NAME}
fi

