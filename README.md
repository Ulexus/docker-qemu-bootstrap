qemu-bootstrap
--------------

A bootstrap script to pull in the ulexus/qemu docker image, and export it to the host filesystem.

This is a means of working around the packet storm problem of running kvm within a container whose image is housed on rbd and whose network is attached to a host bridge.  Instead of using docker for execution, use systemd-nspawn.

This is customized for internal use, so it is probably not fit for public consumption.
