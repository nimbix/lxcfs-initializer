#!/bin/bash

[ -z "$HOST_LXCFS_DIR" ] && HOST_LXCFS_DIR=/var/lib/lxcfs
[ -z "$HOST_LXCFS_BIN" ] && HOST_LXCFS_BIN=/usr/local/bin/lxcfs-static

# Cleanup
nsenter -m/proc/1/ns/mnt fusermount -u $HOST_LXCFS_DIR 2> /dev/null || true
nsenter -m/proc/1/ns/mnt [ -L /etc/mtab ] || \
        sed -i "|^lxcfs $HOST_LXCFS_DIR fuse.lxcfs|d" /etc/mtab

# Prepare
mkdir -p /host$HOST_LXCFS_DIR
mkdir -p /host$(dirname $HOST_LXCFS_BIN)
cp -f /lxcfs/lxcfs /host$HOST_LXCFS_BIN

# Mount
exec nsenter -m/proc/1/ns/mnt $HOST_LXCFS_BIN $HOST_LXCFS_DIR/
