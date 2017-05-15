#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# comment out the serial port console
if [ -e ${TARGET_DIR}/etc/inittab ]; then
sed -i '/^console::respawn/s/^/&#/g' ${TARGET_DIR}/etc/inittab
fi

# copy the start script
install -D -m 0755 board/raspberrypi/etc/init.d/*  ${TARGET_DIR}/etc/init.d/
install -D -m 0644 board/raspberrypi/etc/wpa_supplicant.conf  ${TARGET_DIR}/etc/
install -D -m 0644 board/raspberrypi/etc/hostapd.conf  ${TARGET_DIR}/etc/
install -D -m 0644 board/raspberrypi/etc/dnsmasq.conf  ${TARGET_DIR}/etc/
install -D -m 0644 board/raspberrypi/firmware/brcmfmac43430-sdio.txt  ${TARGET_DIR}/lib/firmware/brcm

# enable ssh login as root
if [ -e ${TARGET_DIR}/etc/ssh/sshd_config ]; then
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' ${TARGET_DIR}/etc/ssh/sshd_config
fi

