ARG DEBIAN_VERSION="bookworm"
ARG FR24FEED_VERSION=1.0.48-0

FROM debian:${DEBIAN_VERSION}

ARG FR24FEED_VERSION

LABEL mantainer="vkorobov"
LABEL description="flightradar24 feeder docker"
# https://www.flightradar24.com/share-your-data
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y dirmngr supervisor gettext-base wget

# ENV KEY_ID=C969F07840C430F5
# RUN apt-key adv --recv-key --keyserver keyserver.ubuntu.com ${KEY_ID} || \
#     apt-key adv --recv-key --keyserver pool.sks-keyservers.net ${KEY_ID} || \
#     apt-key adv --recv-key --keyserver pgp.mit.edu ${KEY_ID} && \
#     echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list

# RUN apt-key adv --recv-keys --keyserver pool.sks-keyservers.net --recv-keys 40C430F5 \
#      && echo "deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable" > /etc/apt/sources.list.d/fr24feed.list

ENV FR24FEED_VERSION=$FR24FEED_VERSION

# RUN export ARCH=$(dpkg --print-architecture)
# ENV ARCH=armhf
LABEL version=${FR24FEED_VERSION}
# RUN wget https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_1.0.25-3_amd64.deb
# RUN wget -O fr24feed.deb https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${VERSION}_${ARCH}.deb
# RUN dpkg -i fr24feed.deb
# RUN apt-get update -y && \
#     apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y fr24feed
COPY fr24feed_inst.sh /
#RUN chmod +x /fr24feed_inst.sh && /fr24feed_inst.sh
RUN /bin/bash /fr24feed_inst.sh

EXPOSE 8754

COPY start.sh /
RUN chmod +x /start.sh

COPY supervisor /etc/supervisor
COPY fr24feed.ini.tpl /etc

ENTRYPOINT ["/start.sh"]
