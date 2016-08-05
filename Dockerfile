FROM ubuntu:14.04
USER root

RUN (rm -rf /var/lib/apt/lists/* ; \
 apt-get clean -y ; \
 apt-get update -y -qq; \
 apt-get update --fix-missing ; \
 DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -y --no-install-recommends -q \
   build-essential git libboost-program-options-dev zlib1g-dev libtool autoconf automake1.9 ; \
 mkdir -p /tmp/build ; \
 cd /tmp/build ; \
 apt-get clean -y ; )

RUN git clone git://github.com/JohnLangford/vowpal_wabbit.git

WORKDIR vowpal_wabbit

RUN git checkout 7.8

RUN ./autogen.sh

RUN make && make install

# Massive hack to get it to start
RUN cp /usr/local/lib/libvw* /usr/lib && cp /usr/local/lib/liballreduce* /usr/lib

EXPOSE 26542

CMD ["/usr/local/bin/vw"]
