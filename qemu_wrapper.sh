#!/bin/bash
set -e

# Function for extracting keys from etcdctl if they exist
# sets getKeyReturn to value of requested key (or "" if it doesn't exist)
function getKey() {
   getKeyReturn=""
   if [ -n $1 ]; then
      val=$(etcdctl get $1)
      if [ $? -eq 0 ]; then
         getKeyReturn=$val
      fi
   fi
   return
}

# Make sure the required modules are loaded
modprobe kvm
modprobe tun

# Bump the connection tracking maximum
sysctl net.netfilter.nf_conntrack_max=512000

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

# Get settings
VM_RAM=${VM_RAM:-$(getKey /kvm/${INSTANCE}/ram; echo $getKeyReturn)}
VM_MAC=${VM_MAC:-$(getKey /kvm/${INSTANCE}/mac; echo $getKeyReturn)}
VM_RBD=${VM_RBD:-$(getKey /kvm/${INSTANCE}/rbd; echo $getKeyReturn)}
SPICE_PORT=${SPICE_PORT:-$(getKey /kvm/${INSTANCE}/spice_port; echo $getKeyReturn)}
EXTRA_FLAGS=${EXTRA_FLAGS:-$(getKey /kvm/${INSTANCE}/extra_flags; echo $getKeyReturn)}

# Mark us as the host
etcdctl set /kvm/${INSTANCE}/host ${HOSTNAME}

# Execute
exec /usr/bin/systemd-nspawn -D /var/lib/cycore/qemu \
   --share-system --capability=all \
   --bind /etc/ceph:/etc/ceph \
   --setenv=BRIDGE_IF=${BRIDGE_IF} \
   /bin/bash /usr/local/bin/entrypoint.sh \
   -vga qxl -spice port=${SPICE_PORT},addr=127.0.0.1,disable-ticketing \
   -k en-us -m $VM_RAM -cpu qemu64 \
   -netdev bridge,br=${BRIDGE_IF},id=net0 -device virtio-net,netdev=net0,mac=$VM_MAC \
   -drive format=rbd,file=rbd:${VM_RBD},cache=writeback,if=virtio $EXTRA_FLAGS $@

