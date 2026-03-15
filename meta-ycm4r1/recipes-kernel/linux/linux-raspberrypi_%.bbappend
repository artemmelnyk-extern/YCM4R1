# linux-raspberrypi_%.bbappend
#
# Appends WiFi, Bluetooth, and CAN bus kernel configuration fragments to the
# Raspberry Pi kernel build.

FILESEXTRAPATHS:prepend := "${THISDIR}/fragments:"

SRC_URI += " \
    file://cfg/wifi.cfg \
    file://cfg/bluetooth.cfg \
    file://cfg/can.cfg \
"

KERNEL_CONFIG_FRAGMENTS += " \
    ${WORKDIR}/cfg/wifi.cfg \
    ${WORKDIR}/cfg/bluetooth.cfg \
    ${WORKDIR}/cfg/can.cfg \
"
