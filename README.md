# YCM4R1 — Yocto Linux with ROS 1 Melodic for Raspberry Pi Compute Module

A complete Yocto build configuration that produces a bootable Linux image for
the **Raspberry Pi Compute Module 3+ (16 GB eMMC, onboard WiFi)** pre-loaded
with **ROS 1 Melodic**.

---

## Target hardware

| Attribute | Value |
|-----------|-------|
| Board | Raspberry Pi Compute Module 3+ (CM3+) |
| Storage | 16 GB eMMC (onboard) |
| WiFi | Broadcom BCM43455 (802.11 b/g/n/ac) |
| Architecture | ARMv8 (32-bit kernel, `raspberrypi-cm3`) |

---

## Repository layout

```
YCM4R1/
├── kas/
│   └── ycm4r1.yml              # KAS multi-layer build configuration
├── conf/
│   ├── local.conf              # Local build settings (classic build)
│   └── bblayers.conf           # Layer list (classic build)
├── meta-ycm4r1/                # Custom Yocto layer
│   ├── conf/
│   │   ├── layer.conf          # Layer declaration
│   │   └── machine/
│   │       └── raspberrypi-cm3-wifi.conf  # Optional CM3+WiFi machine
│   └── recipes-core/
│       └── images/
│           └── ycm4r1-image.bb # Custom image recipe
└── scripts/
    ├── install-deps.sh         # Install host build dependencies
    └── setup-build.sh          # Clone layers & initialise build dir
```

### Yocto layers used

| Layer | Branch | Purpose |
|-------|--------|---------|
| `poky` | `warrior` | Yocto 2.7 build system & core metadata |
| `meta-openembedded` | `warrior` | Extended package set (OE, Python, Networking) |
| `meta-raspberrypi` | `warrior` | Raspberry Pi BSP (kernel, firmware, bootloader) |
| `meta-ros` | `warrior` | ROS 1 Melodic generated recipes |
| `meta-ycm4r1` | — | Project-specific image & machine configuration |

---

## Quick start (recommended — using kas)

[kas](https://kas.readthedocs.io) handles layer cloning, branch pinning and
`local.conf` generation automatically.

### 1 — Install host dependencies

```bash
# Ubuntu 18.04 / 20.04 / Debian 10/11
./scripts/install-deps.sh
```

> **Minimum host requirements:** 100 GB free disk space, 16 GB RAM (32 GB
> recommended for parallel builds with ROS packages), Ubuntu 18.04 LTS or later.
> If RAM is limited, configure `BB_NUMBER_THREADS` and `PARALLEL_MAKE` in
> `conf/local.conf` to reduce concurrency and add swap space (≥ 8 GB).

### 2 — Build the image

```bash
kas build kas/ycm4r1.yml
```

The first build takes **4–8 hours** on a modern workstation depending on the
number of available CPU cores.

### 3 — Flash the image

After a successful build the image is located at:

```
build/tmp/deploy/images/raspberrypi-cm3/ycm4r1-image-raspberrypi-cm3.wic.bz2
```

Flash it to the CM3+ eMMC using the
[Raspberry Pi usbboot](https://github.com/raspberrypi/usbboot) utility or
`rpiboot` + `Raspberry Pi Imager`:

```bash
# Using bmaptool (fast, verifies checksum)
sudo bmaptool copy \
    build/tmp/deploy/images/raspberrypi-cm3/ycm4r1-image-raspberrypi-cm3.wic.bz2 \
    /dev/sdX
```

---

## Alternative: classic Yocto build

If you prefer to manage layers manually:

```bash
# 1. Clone all layers
./scripts/setup-build.sh

# 2. Enter the build environment
source poky/oe-init-build-env build

# 3. Build
bitbake ycm4r1-image
```

---

## What is included in the image

| Category | Packages |
|----------|---------- |
| **ROS 1 Melodic** | `ros-core`, `ros-base`, `roscpp`, `rospy`, `roslaunch`, `rosnode`, `rostopic`, `rosservice`, `rosparam`, `tf`, `tf2`, `std_msgs`, `sensor_msgs`, `geometry_msgs`, `nav_msgs`, `actionlib` |
| **WiFi** | `linux-firmware-rpidistro-bcm43455`, `wpa-supplicant`, `connman`, `iw` |
| **Python** | Python 2 (ROS Melodic runtime), Python 3 + pip |
| **System tools** | `nano`, `htop`, `strace`, `gdb`, `i2c-tools`, `util-linux` |
| **SSH** | `dropbear` SSH server |

---

## WiFi configuration

After first boot, connect to a network using `connmanctl`:

```bash
connmanctl
> enable wifi
> scan wifi
> services
> connect wifi_<id>
> quit
```

Or use `wpa_supplicant` directly:

```bash
wpa_passphrase "MySSID" "MyPassword" >> /etc/wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
udhcpc -i wlan0
```

---

## ROS quick check

```bash
# On the target board
source /opt/ros/melodic/setup.sh
roscore &
rostopic list
```

---

## License

MIT — see individual layer and package licenses for their respective terms.
