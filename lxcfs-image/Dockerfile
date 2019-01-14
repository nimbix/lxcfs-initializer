FROM centos:7
RUN yum -y install fuse-devel pam-devel wget install gcc automake autoconf libtool make
ARG LXCFS_VERSION=3.0.3
ENV LXCFS_VERSION ${LXCFS_VERSION}
RUN wget https://linuxcontainers.org/downloads/lxcfs/lxcfs-$LXCFS_VERSION.tar.gz && \
	mkdir /lxcfs && tar xzvf lxcfs-$LXCFS_VERSION.tar.gz -C /lxcfs  --strip-components=1 && \
	cd /lxcfs && ./configure CFLAGS=-static && make
RUN mkdir /output && cp /lxcfs/lxcfs /output && cp /lxcfs/.libs/liblxcfs.so /output

FROM centos:7
STOPSIGNAL SIGINT
ADD start.sh /
COPY --from=0 /output /lxcfs
CMD ["/start.sh"]
