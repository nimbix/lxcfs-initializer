FROM ubuntu:bionic

RUN apt-get update && \
        apt-get install -y libfuse-dev fuse libpam-dev wget gcc libc6-dev \
            automake autoconf libtool make file diffutils pkg-config

ARG LXCFS_VERSION=3.0.3
ENV LXCFS_VERSION ${LXCFS_VERSION}

ENV DATETIME 20190125.1416
RUN wget https://linuxcontainers.org/downloads/lxcfs/lxcfs-$LXCFS_VERSION.tar.gz && \
    mkdir /lxcfs && \
    tar xzvf lxcfs-$LXCFS_VERSION.tar.gz -C /lxcfs --strip-components=1
RUN cd /lxcfs && \
    ./configure CFLAGS="-O2 -g" --prefix=/usr/local/lxcfs-daemonset && \
    make && \
    strip /lxcfs/lxcfs && \
    mkdir -p /output/bin && \
    cp /lxcfs/lxcfs /output/bin && \
    cp /bin/fusermount /output/bin
RUN mkdir -p /output/lib/lxcfs && \
    cp /lxcfs/.libs/liblxcfs.so /output/lib/lxcfs && \
    cp -a /lib*/*/libfuse.so* /output/lib/lxcfs && \
    cp -a /lib*/*/libulockmgr.so* /output/lib/lxcfs

FROM ubuntu:bionic
STOPSIGNAL SIGINT
ENV DATETIME 20190118.2136
ADD start.sh /
COPY --from=0 /output /lxcfs
CMD ["/start.sh"]
