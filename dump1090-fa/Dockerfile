FROM debian:bullseye AS builder

ENTRYPOINT []

WORKDIR /root

RUN apt-get update -qy \
        && apt-get install --no-install-recommends -qy \
        git-core git \
        build-essential fakeroot debhelper librtlsdr-dev pkg-config libncurses5-dev libbladerf-dev libhackrf-dev liblimesuite-dev apt-utils \
        python3-venv && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
ENV VERSION 7.2

RUN git clone https://github.com/flightaware/dump1090.git

WORKDIR /root/dump1090
RUN ./prepare-build.sh bullseye
WORKDIR /root/dump1090/package-bullseye
RUN dpkg-buildpackage -b --no-sign --build-profiles=custom,rtlsdr

FROM debian:bullseye AS dump1090-fa

LABEL mantainer="vkorobov"
LABEL description="dump1090-fa docker"
LABEL version=${PIAWARE_VERSION}

RUN apt-get update && \
        apt-get install --no-install-recommends -y init-system-helpers lighttpd supervisor && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/dump1090/dump1090-fa_*.deb /

RUN apt-get update && \
	apt-get install --no-install-recommends -y librtlsdr0 libbladerf-dev libusb-1.0-0 init-system-helpers lighttpd supervisor libncurses6  && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
	mkdir -p /run/dump1090-fa

RUN dpkg -i  /dump1090-fa_*.deb

# RUN ln -s /etc/lighttpd/conf-available/88-dump1090-fa-statcache.conf /etc/lighttpd/conf-enabled/88-dump1090-fa-statcache.conf
# RUN ln -s /etc/lighttpd/conf-available/89-dump1090-fa.conf /etc/lighttpd/conf-enabled/89-dump1090-fa.conf

COPY supervisor /etc/supervisor

EXPOSE 30001-30005 30104 8080

ENTRYPOINT ["supervisord"]


CMD ["-c", "/etc/supervisor/supervisord.conf"]
