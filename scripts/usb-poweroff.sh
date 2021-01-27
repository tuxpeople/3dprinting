#!/usr/bin/env bash

# see https://github.com/mvp/uhubctl#raspberry-pi-turns-power-off-on-all-ports-not-just-the-one-i-specified
# these are for Raspberry Pi 3B+:
location="1-1"
port="2"

if [ ! -f /usr/sbin/uhubctl ]; then
    sudo apt -y install libusb-1.0-0-dev
    git clone https://github.com/mvp/uhubctl
    cd uhubctl
    make
    sudo make install
fi

logger -t usb-poweroff.sh Disable USB power now...

echo 0 | sudo tee /sys/bus/usb/devices/${location}.${port}/authorized
sudo uhubctl -a off -l ${location} -p ${port}
sudo udevadm trigger --action=remove /sys/bus/usb/devices/${location}.${port}/

# this is needed to work around bug in octoprint
sudo service octoprint restart 
