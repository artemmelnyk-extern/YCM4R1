# linux-raspberrypi_%.bbappend
#
# Appends WiFi and Bluetooth kernel configuration fragments to the
# Raspberry Pi kernel build.

FILESEXTRAPATHS_prepend := "${THISDIR}/fragments:"

SRC_URI += " \
    file://cfg/wifi.cfg \
    file://cfg/bluetooth.cfg \
"

KERNEL_CONFIG_FRAGMENTS += " \
    ${WORKDIR}/cfg/wifi.cfg \
    ${WORKDIR}/cfg/bluetooth.cfg \
"
