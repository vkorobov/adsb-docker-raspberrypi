ARG DEBIAN_VERSION=bookworm
ARG PIAWARE_VERSION=9.0.1

FROM debian:${DEBIAN_VERSION} AS build
#ARG TARGETPLATFORM
#ARG TARGETARCH 
#ARG TARGETVARIANT 
#ARG BUILDPLATFORM 
#RUN echo "Building from $BUILDPLATFORM for $TARGETPLATFORM arch $TARGETARCH variant $TARGETVARIANT"
ARG DEBIAN_VERSION
ARG PIAWARE_VERSION

ENV DEBIAN_VERSION=$DEBIAN_VERSION
#ENV DEBIAN_FRONTEND noninteractive
#ENV DEBCONF_NOWARNINGS="yes"

RUN apt-get update && \ 
	apt-get install -qy --no-install-recommends apt-utils \ 
        build-essential debhelper tcl8.6-dev autoconf python3-dev python3-venv python3-setuptools libz-dev git wget  \
	libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev devscripts \
        patchelf libssl-dev tcl-dev chrpath openssl python3-wheel python3-build python3-pip

LABEL version=$PIAWARE_VERSION

WORKDIR /
RUN git clone https://github.com/flightaware/piaware_builder.git
WORKDIR /piaware_builder
RUN ./sensible-build.sh ${DEBIAN_VERSION}
WORKDIR package-${DEBIAN_VERSION}
RUN dpkg-buildpackage -b
#RUN ls -l ../*.deb

## Clone source code, build & Install tcl-tls

#-WORKDIR /
#-RUN git clone http://github.com/flightaware/tcltls-rebuild.git
#-WORKDIR /tcltls-rebuild
#-RUN ./prepare-build.sh ${DEBIAN_VERSION} 
#-WORKDIR package-${DEBIAN_VERSION} 
#RUN apt-get update && apt-get -qy --no-install-recommends install tcl-dev chrpath
#-RUN dpkg-buildpackage -b --no-sign
##    dpkg -i tcl-tls_*.deb 

ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ARG PIAWARE_VERSION

LABEL mantainer="vkorobov"
LABEL description="piaware docker"
LABEL version=${PIAWARE_VERSION}

COPY --from=build piaware_builder/piaware_*.deb /
#-COPY --from=build tcltls-rebuild/tcl-tls_*.deb /

RUN apt-get update && \
    apt-get install -qy --no-install-recommends \	
    libexpat1 libtcl net-tools tclx tcl tcllib tcl-tls itcl3 supervisor \
    libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev && \
    rm -rf /var/lib/apt/lists/*

#RUN ls -l / && erw
#-RUN dpkg -i /tcl-tls_*.deb
RUN dpkg -i /piaware*.deb

ADD supervisor /etc/supervisor
WORKDIR /
ADD start.sh .
RUN chmod +x start.sh
EXPOSE 8080

ENTRYPOINT ["/start.sh"]
