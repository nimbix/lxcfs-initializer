FROM centos:7

RUN [ -f /etc/yum.repos.d/CentOS-PowerTools.repo ] && \
        sed -ie 's/^enabled=.*/enabled=1/' \
        /etc/yum.repos.d/CentOS-PowerTools.repo || /bin/true
RUN yum -y install fuse-devel fuse pam-devel wget gcc glibc-static \
        automake autoconf libtool make file diffutils

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
    cp /usr/bin/fusermount /output/bin
RUN mkdir -p /output/lib/lxcfs && \
    cp /lxcfs/.libs/liblxcfs.so /output/lib/lxcfs && \
    cp -a /usr/lib*/libfuse.so* /output/lib/lxcfs && \
    cp /usr/lib*/libulockmgr.so* /output/lib/lxcfs

FROM centos:7
STOPSIGNAL SIGINT
ENV DATETIME 20190118.2136
ADD start.sh /
COPY --from=0 /output /lxcfs
CMD ["/start.sh"]
