FROM centos:7

RUN yum -y install fuse-devel fuse pam-devel wget install gcc glibc-static automake autoconf libtool make file

ARG LXCFS_VERSION=3.0.3
ENV LXCFS_VERSION ${LXCFS_VERSION}

ENV DATETIME 20190125.1416
RUN wget https://linuxcontainers.org/downloads/lxcfs/lxcfs-$LXCFS_VERSION.tar.gz && \
    mkdir /lxcfs && \
    tar xzvf lxcfs-$LXCFS_VERSION.tar.gz -C /lxcfs --strip-components=1 && \
    cd /lxcfs && \
    ./configure CFLAGS="-O2 -g" --prefix=/usr/local/lxcfs-daemonset && \
    make && \
    strip /lxcfs/lxcfs && \
    mkdir -p /output/bin && \
    cp /lxcfs/lxcfs /output/bin && \
    cp /usr/bin/fusermount /output/bin && \
    mkdir -p /output/lib/lxcfs && \
    cp /lxcfs/.libs/liblxcfs.so /output/lib/lxcfs && \
    cp /usr/lib*/libfuse.so.2.9.2 /output/lib/lxcfs/libfuse.so.2.9.2 && \
    cp /usr/lib*/libulockmgr.so.1.0.1 /output/lib/lxcfs/libulockmgr.so.1.0.1 && \
    ln -s libfuse.so.2.9.2 /output/lib/lxcfs/libfuse.so.2 && \
    ln -s libulockmgr.so.1.0.1 /output/lib/lxcfs/libulockmgr.so.1

FROM centos:7
STOPSIGNAL SIGINT
ENV DATETIME 20190118.2136
ADD start.sh /
COPY --from=0 /output /lxcfs
CMD ["/start.sh"]
