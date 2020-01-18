FROM raspbian/stretch AS build

RUN apt-get update && \
	apt-get install -y build-essential debhelper tcl8.6-dev autoconf python3-dev python3-venv dh-systemd libz-dev git wget  \
	libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev devscripts apt-utils

LABEL version=3.8.0

RUN git clone https://github.com/flightaware/piaware_builder.git

WORKDIR piaware_builder

RUN ./sensible-build.sh stretch

WORKDIR package-stretch

RUN dpkg-buildpackage -b

FROM raspbian/stretch

LABEL mantainer="vkorobov"
LABEL description="piaware docker"
LABEL version=${PIAWARE_VERSION}

COPY --from=build piaware_builder/piaware_*_armhf.deb piaware_armhf.deb

RUN apt-get update && \
	apt-get install -y libexpat1 libreadline7 libssl1.1 libtcl8.6 net-tools tclx8.4 tcl8.6 tcllib tcl-tls itcl3 supervisor \
	libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN dpkg -i piaware_armhf.deb

ADD supervisor /etc/supervisor
WORKDIR /
ADD start.sh .
RUN chmod +x start.sh
EXPOSE 8080

ENTRYPOINT ["/start.sh"]
