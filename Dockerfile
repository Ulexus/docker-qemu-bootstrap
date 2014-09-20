# QEMU Bootstrap (for CoreOS)
# VERSION 0.1
FROM busybox
MAINTAINER ulexus@gmail.com

# Add entrypoint script
ADD entrypoint.sh /entrypoint.sh
ADD qemu_bootstrap.sh /qemu_bootstrap.sh
ADD qemu_wrapper.sh /qemu_wrapper.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
