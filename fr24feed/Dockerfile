FROM raspbian/stretch

LABEL mantainer="vkorobov"
LABEL description="flightradar24 feeder docker"

RUN apt-get update && apt-get install -y dirmngr supervisor gettext-base

RUN apt-key adv --recv-keys --keyserver pool.sks-keyservers.net --recv-keys 40C430F5 \
     && echo "deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable" > /etc/apt/sources.list.d/fr24feed.list

ENV VERSION=1.0.24-7
LABEL version=${VERSION}

RUN apt-get update && apt-get install -y fr24feed

EXPOSE 8754

COPY start.sh /
RUN chmod +x /start.sh

COPY supervisor /etc/supervisor
COPY fr24feed.ini.tpl /etc

ENTRYPOINT ["/start.sh"]