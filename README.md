qemu-bootstrap
--------------

A bootstrap script to pull in the ulexus/qemu docker image, and export it to the host filesystem.

This is a means of working around the packet storm problem of running kvm within a container whose image is housed on rbd and whose network is attached to a host bridge.  Instead of using docker for execution, use systemd-nspawn.

This is customized for internal use, so it is probably not fit for public consumption.

new vm notes
------------

1.  `rbd -p vms create --size <sizeinMB> vm9`
2.  Create all the necessary etcd keys:
  * /kvm/9/ram - RAM to allocate, in MB
  * /kvm/9/mac - MAC address
  * /kvm/9/rbd - RBD to use (e.g. `vms/vm9`)
  * /kvm/9/spice\_port - Port on which SPICE server should bind (5900 + vm instance)
3.  Bootstrap the image for installation
  1.  ssh cc3
  2.  sudo -i
  3.  export INSTANCE=9
  4.  export BRIDGE\_IF=public
  5.  /opt/bin/qemu\_wrapper.sh -cdrom rbd:isos/ubuntu-14.04.1
  6.  Install OS
  7.  Halt the OS
4.  Start with fleet:  `fleetctl start kvm@9`
