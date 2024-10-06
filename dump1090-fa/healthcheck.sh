#!/bin/bash
#shellcheck shell=bash

set -e

EXITCODE=0

if [ -f "/run/dump1090-fa/aircraft.json" ]; then

    # get latest timestamp of readsb json update
    TIMESTAMP_LAST_READSB_UPDATE=$(jq '.now' < /run/dump1090-fa/aircraft.json)

    # get current timestamp
    TIMESTAMP_NOW=$(date +"%s.%N")

    # make sure readsb has updated json in past 60 seconds
    TIMEDELTA=$(echo "$TIMESTAMP_NOW - $TIMESTAMP_LAST_READSB_UPDATE" | bc)
    if [ "$(echo "$TIMEDELTA" \< 60 | bc)" -ne 1 ]; then
	    echo "readsb last updated: $(date +"%Y-%M-%d %T %z" -d @${TIMESTAMP_LAST_READSB_UPDATE}), now: $(date +"%Y-%M-%d %T %z" -d @${TIMESTAMP_NOW}), delta: ${TIMEDELTA}. UNHEALTHY"
        EXITCODE=1
    else
        echo "readsb last updated: ${TIMESTAMP_LAST_READSB_UPDATE}, now: ${TIMESTAMP_NOW}, delta: ${TIMEDELTA}. HEALTHY"
    fi

else

    echo "ERROR: Cannot find /run/dump1090-fa/aircraft.json!"
    EXITCODE=1

fi

exit $EXITCODE
