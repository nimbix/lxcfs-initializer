FROM centos:7

RUN yum -y install pam-devel wget install gcc glibc-static automake autoconf libtool make file

ARG FUSE_VERSION=2.9.9
ENV FUSE_VERSION ${FUSE_VERSION}
ARG LXCFS_VERSION=3.0.3
ENV LXCFS_VERSION ${LXCFS_VERSION}

ENV BUILD 20180114.2149

RUN wget https://github.com/libfuse/libfuse/releases/download/fuse-$FUSE_VERSION/fuse-$FUSE_VERSION.tar.gz && \
    mkdir /fuse && \
    tar xzvf fuse-$FUSE_VERSION.tar.gz -C /fuse --strip-components=1 && \
    cd /fuse && \
    ./configure --disable-shared && \
    sed -ie 's/mode=link $(CCLD)/mode=link $(CCLD) -all-static/g' util/Makefile && \
    make && \
    make install && \
    strip /fuse/util/fusermount && \
    mkdir -p /output && \
    cp /fuse/util/fusermount /output

RUN wget https://linuxcontainers.org/downloads/lxcfs/lxcfs-$LXCFS_VERSION.tar.gz && \
    mkdir /lxcfs && \
    tar xzvf lxcfs-$LXCFS_VERSION.tar.gz -C /lxcfs  --strip-components=1 && \
    cd /lxcfs && \
    ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig --disable-shared && \
    sed -ie 's/mode=link $(CCLD)/mode=link $(CCLD) -all-static/g' Makefile && \
    make lxcfs && \
    strip /lxcfs/lxcfs && \
    mkdir -p /output && \
    cp /lxcfs/lxcfs /output

FROM centos:7
STOPSIGNAL SIGINT
ADD start.sh /
COPY --from=0 /output /lxcfs
CMD ["/start.sh"]
