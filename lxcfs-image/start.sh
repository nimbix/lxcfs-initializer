#!/bin/bash

# Cleanup
nsenter -m/proc/1/ns/mnt fusermount -u /var/lib/lxcfs 2> /dev/null || true
nsenter -m/proc/1/ns/mnt [ -L /etc/mtab ] || \
        sed -i "/^lxcfs \/var\/lib\/lxcfs fuse.lxcfs/d" /etc/mtab

# Prepare
[ -z "$HOST_LXCFS_DIR" ] && HOST_LXCFS_DIR=/var/lib/lxcfs
mkdir -p /host/$HOST_LXCFS_DIR
mkdir -p /host/usr/local/lib/lxcfs
cp -f /lxcfs/lxcfs /host/usr/local/bin/lxcfs
cp -f /lxcfs/liblxcfs.so /host/usr/local/lib/lxcfs/liblxcfs.so

# Mount
exec nsenter -m/proc/1/ns/mnt lxcfs /var/lib/lxcfs/
