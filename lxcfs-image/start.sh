#!/bin/bash

[ -z "$HOST_LXCFS_DIR" ] && HOST_LXCFS_DIR=/var/lib/lxcfs
[ -z "$HOST_LXCFS_INSTALL_DIR" ] && \
    HOST_LXCFS_INSTALL_DIR=/usr/local/lxcfs-daemonset

HOST_LXCFS_BIN_DIR=$HOST_LXCFS_INSTALL_DIR/bin
HOST_LXCFS_LIB_DIR=$HOST_LXCFS_INSTALL_DIR/lib/lxcfs

# Install lxcfs binaries and libs
mkdir -p /host$HOST_LXCFS_BIN_DIR /host$HOST_LXCFS_LIB_DIR /host$HOST_LXCFS_DIR
cp -f /lxcfs/bin/* /host$HOST_LXCFS_BIN_DIR
cp -fP /lxcfs/lib/lxcfs/* /host$HOST_LXCFS_LIB_DIR

# Cleanup
nsenter -m/proc/1/ns/mnt /bin/sh -c "export LD_LIBRARY_PATH=$HOST_LXCFS_LIB_DIR; $HOST_LXCFS_BIN_DIR/fusermount -u $HOST_LXCFS_DIR" 2> /dev/null || true
nsenter -m/proc/1/ns/mnt [ -L /etc/mtab ] || \
        sed -i "|^lxcfs $HOST_LXCFS_DIR fuse.lxcfs|d" /etc/mtab

# Mount
exec nsenter -m/proc/1/ns/mnt /bin/sh -c "export LD_LIBRARY_PATH=$HOST_LXCFS_LIB_DIR; $HOST_LXCFS_BIN_DIR/lxcfs $HOST_LXCFS_DIR/"

