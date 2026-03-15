SUMMARY = "YCM4R1 image – Yocto Linux with ROS 1 Noetic for Raspberry Pi CM4"
DESCRIPTION = " \
    Minimal Yocto image for the Raspberry Pi Compute Module 4 (4 GB RAM, 32 GB eMMC, WiFi). \
    Includes: \
      * ROS 1 Noetic core stack (roscpp, rospy, std_msgs, sensor_msgs, …) \
      * WiFi connectivity (wpa_supplicant + connman) \
      * SSH server (dropbear) \
      * Python 3 run-time \
      * CAN bus utilities (canutils) \
    Target machine: raspberrypi4-64 \
"

LICENSE = "MIT"

# Start from the standard Poky base image.
inherit core-image

# ── Base image features ─────────────────────────────────────────────────────
IMAGE_FEATURES += " \
    ssh-server-dropbear \
    package-management \
    hwcodecs \
"

# ── Core packages ───────────────────────────────────────────────────────────
IMAGE_INSTALL:append = " \
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

# ── Python 3 (required by ROS 1 Noetic) ──────────────────────────────────────
IMAGE_INSTALL:append = " \
    python3 \
    python3-pip \
    python3-setuptools \
"

# ── WiFi / Connectivity ─────────────────────────────────────────────────────
IMAGE_INSTALL:append = " \
    linux-firmware-rpidistro-bcm43455 \
    linux-firmware-rpidistro-bcm43430 \
    wpa-supplicant \
    connman \
    connman-client \
    iw \
    wireless-tools \
"

# ── ROS 1 Noetic ────────────────────────────────────────────────────────────
IMAGE_INSTALL:append = " \
    ros-noetic-ros-core \
    ros-noetic-ros-base \
    ros-noetic-roscpp \
    ros-noetic-rospy \
    ros-noetic-roslaunch \
    ros-noetic-rosnode \
    ros-noetic-rostopic \
    ros-noetic-rosservice \
    ros-noetic-rosparam \
    ros-noetic-std-msgs \
    ros-noetic-sensor-msgs \
    ros-noetic-geometry-msgs \
    ros-noetic-nav-msgs \
    ros-noetic-actionlib \
    ros-noetic-tf \
    ros-noetic-tf2 \
    ros-noetic-pluginlib \
    ros-noetic-dynamic-reconfigure \
    ros-noetic-diagnostic-updater \
    ros-noetic-robot-state-publisher \
    ros-noetic-joint-state-publisher \
"

# ── CAN bus utilities ───────────────────────────────────────────────────────
IMAGE_INSTALL:append = " \
    canutils \
"

# ── Image size / filesystem ─────────────────────────────────────────────────
# 32 GB eMMC: reserve generous space for root-fs.
IMAGE_ROOTFS_SIZE ?= "16777216"     # 16 GiB (in KiB)
IMAGE_OVERHEAD_FACTOR ?= "1.3"

# Generate a compressed wic image suitable for dd / balenaEtcher.
IMAGE_FSTYPES += "wic.bz2 wic.bmap rpi-sdimg"
WKS_FILE = "sdimage-raspberrypi.wks"
