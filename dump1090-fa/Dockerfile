FROM raspbian/stretch AS builder

ENTRYPOINT []

WORKDIR /root

RUN apt-get update -qy \
   && apt-get install --no-install-recommends -qy \
   git-core git build-essential debhelper librtlsdr-dev pkg-config dh-systemd libncurses5-dev libbladerf-dev

ENV VERSION 3.8.1

RUN git clone https://github.com/flightaware/dump1090

WORKDIR dump1090

RUN dpkg-buildpackage -b

FROM raspbian/stretch

LABEL mantainer="vkorobov"
LABEL description="dump1090-fa docker"
LABEL version=${PIAWARE_VERSION}

RUN apt-get update && \
        apt-get install -y init-system-helpers lighttpd supervisor

COPY --from=builder /root/dump1090-fa_*_armhf.deb dump1090-fa_armhf.deb

RUN apt-get update && \
	apt-get install -y librtlsdr0 libbladerf1 libusb-1.0-0 init-system-helpers lighttpd supervisor && \
	mkdir -p /run/dump1090-fa

RUN dpkg -i  dump1090-fa_armhf.deb

RUN ln -s /etc/lighttpd/conf-available/88-dump1090-fa-statcache.conf /etc/lighttpd/conf-enabled/88-dump1090-fa-statcache.conf
RUN ln -s /etc/lighttpd/conf-available/89-dump1090-fa.conf /etc/lighttpd/conf-enabled/89-dump1090-fa.conf

ADD supervisor /etc/supervisor

EXPOSE 30001-30005 30104 8080

ENTRYPOINT ["supervisord"]


CMD ["-c", "/etc/supervisor/supervisord.conf"]



