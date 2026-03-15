SUMMARY = "YCM4R1 image – Yocto Linux with ROS 1 Melodic for Raspberry Pi CM4 WiFi"
DESCRIPTION = " \
    Minimal Yocto image for the Raspberry Pi Compute Module 4 (4 GB RAM, 32 GB eMMC, WiFi). \
    Includes: \
      * ROS 1 Melodic core stack (roscpp, rospy, std_msgs, sensor_msgs, …) \
      * WiFi connectivity (wpa_supplicant + connman) \
      * SSH server (dropbear) \
      * Python 2 run-time (required by Melodic) \
      * CAN bus utilities (canutils) \
    Target machine: raspberrypi-cm4 / raspberrypi-cm4-wifi \
"

LICENSE = "MIT"

# Start from the standard Poky base image.
inherit core-image

# ── Base image features ───────────────────────────────────────────────────────
IMAGE_FEATURES += " \
    ssh-server-dropbear \
    package-management \
    hwcodecs \
"

# ── Core packages ─────────────────────────────────────────────────────────────
IMAGE_INSTALL_append = " \
    packagegroup-core-boot \
    packagegroup-base-extended \
    kernel-modules \
    i2c-tools \
    util-linux \
    nano \
    htop \
    strace \
    gdb \
"

# ── Python 2 (required by ROS1 Melodic) ──────────────────────────────────────
IMAGE_INSTALL_append = " \
    python \
    python-argparse \
    python-datetime \
    python-distutils \
    python-docutils \
    python-logging \
    python-multiprocessing \
    python-pprint \
    python-shell \
    python-xmlrpc \
    python-compression \
    python-math \
    python-netclient \
    python-netserver \
    python-threading \
    python-pickle \
    python-subprocess \
"

# ── Python 3 utilities ────────────────────────────────────────────────────────
IMAGE_INSTALL_append = " \
    python3 \
    python3-pip \
    python3-setuptools \
"

# ── WiFi / Connectivity ───────────────────────────────────────────────────────
IMAGE_INSTALL_append = " \
    linux-firmware-rpidistro-bcm43455 \
    linux-firmware-rpidistro-bcm43430 \
    wpa-supplicant \
    connman \
    connman-client \
    iw \
    wireless-tools \
    crda \
"

# ── ROS 1 Melodic ─────────────────────────────────────────────────────────────
IMAGE_INSTALL_append = " \
    ros-melodic-ros-core \
    ros-melodic-ros-base \
    ros-melodic-roscpp \
    ros-melodic-rospy \
    ros-melodic-roslaunch \
    ros-melodic-rosnode \
    ros-melodic-rostopic \
    ros-melodic-rosservice \
    ros-melodic-rosparam \
    ros-melodic-std-msgs \
    ros-melodic-sensor-msgs \
    ros-melodic-geometry-msgs \
    ros-melodic-nav-msgs \
    ros-melodic-actionlib \
    ros-melodic-tf \
    ros-melodic-tf2 \
    ros-melodic-pluginlib \
    ros-melodic-dynamic-reconfigure \
    ros-melodic-diagnostic-updater \
    ros-melodic-robot-state-publisher \
    ros-melodic-joint-state-publisher \
"

# ── CAN bus utilities ─────────────────────────────────────────────────────────
IMAGE_INSTALL_append = " \
    canutils \
"

# ── Image size / filesystem ───────────────────────────────────────────────────
# 32 GB eMMC: reserve generous space for root-fs.
IMAGE_ROOTFS_SIZE ?= "16777216"     # 16 GiB (in KiB)
IMAGE_OVERHEAD_FACTOR ?= "1.3"

# Generate a compressed wic image suitable for dd / balenaEtcher.
IMAGE_FSTYPES += "wic.bz2 wic.bmap rpi-sdimg"
WKS_FILE = "sdimage-raspberrypi.wks"
