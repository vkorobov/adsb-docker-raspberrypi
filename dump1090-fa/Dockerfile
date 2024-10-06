# ARG DEBIAN_VERSION=bookworm-slim
ARG PIAWARE_VERSION=9.0
ARG BASE_IMAGE

FROM debian:$BASE_IMAGE AS builder

# ARG DEBIAN_VERSION
ARG PIAWARE_VERSION

ENTRYPOINT []

WORKDIR /root

RUN apt-get update -qy \
        && apt-get install --no-install-recommends -qy \
        git-core git \
        build-essential fakeroot debhelper librtlsdr-dev pkg-config libncurses5-dev libbladerf-dev libhackrf-dev liblimesuite-dev apt-utils \
        python3-venv && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

ENV VERSION=$PIAWARE_VERSION

WORKDIR /root/dump1090

RUN git config --global http.version HTTP/1.1 && \
        git clone https://github.com/flightaware/dump1090.git

RUN ./prepare-build.sh bullseye
WORKDIR /root/dump1090/package-bullseye
RUN dpkg-buildpackage -b --no-sign --build-profiles=custom,rtlsdr

FROM debian:$BASE_IMAGE AS dump1090-fa
ARG PIAWARE_VERSION
ARG REVISION
ARG BUILD_TIMESTAMP
LABEL org.opencontainers.image.vendor="vkorobov"
LABEL org.opencontainers.image.authors="korobov.vitaly@gmail.com"
LABEL org.opencontainers.image.title="dump1090-fa docker"
LABEL org.opencontainers.image.description="Dump1090 is a simple Mode S decoder for RTLSDR devices"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.version=$PIAWARE_VERSION
LABEL org.opencontainers.image.created=$BUILD_TIMESTAMP

# RUN apt-get update && \
#         apt-get install --no-install-recommends -y init-system-helpers lighttpd supervisor && \
#         apt-get clean && \
#         rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
	apt-get install --no-install-recommends -y librtlsdr0 libbladerf-dev libusb-1.0-0 init-system-helpers lighttpd supervisor libncurses6 jq bc && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
	mkdir -p /run/dump1090-fa

# RUN ln -s /etc/lighttpd/conf-available/88-dump1090-fa-statcache.conf /etc/lighttpd/conf-enabled/88-dump1090-fa-statcache.conf
# RUN ln -s /etc/lighttpd/conf-available/89-dump1090-fa.conf /etc/lighttpd/conf-enabled/89-dump1090-fa.conf

COPY supervisor /etc/supervisor
COPY healthcheck.sh /

HEALTHCHECK --start-period=30s --interval=600s --retries=1 CMD /healthcheck.sh

EXPOSE 30001-30005 30104 8080

COPY --from=builder /root/dump1090/dump1090-fa_*.deb /
RUN dpkg -i  /dump1090-fa_*.deb && rm -rf /dump1090-fa_*.deb

ENTRYPOINT ["supervisord"]

CMD ["-c", "/etc/supervisor/supervisord.conf"]
