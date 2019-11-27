# adsb-docker
**dump1090-fa + piaware + fr24feed with docker-compose on rasberry pi.**

Upload ADS-B data from a local rtlsdr receiver to Flightaware and Flightradar24.

## Configuration
Set correct values in .env file

```
LAT=
LON=
FLIGHTAWARE_USER=
FLIGHTAWARE_PASSWORD=
FLIGHTAWARE_FEEDER_ID=
RECEIVER_HOST=dump1090-fa
RECEIVER_PORT=30005
RECEIVER_MLAT_PORT=30104
FR24_KEY=
```

**Additionally, you have to blacklist the `dvb_usb_rtl28xxu` module on the host.**  
To do this, put the following lines into `/etc/modprobe.d/blacklist.conf`:
```
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
```
