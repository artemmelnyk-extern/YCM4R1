#!/usr/bin/env bash
# scripts/install-deps.sh
#
# Install all host-side dependencies required to run a Yocto kirkstone build.
# Tested on Ubuntu 20.04 / 22.04 / Debian 11/12.
# Run once as a user with sudo privileges before starting the build.

set -euo pipefail

UBUNTU_DEPS=(
    # Yocto host tools
    gawk wget git-core diffstat unzip texinfo gcc-multilib
    build-essential chrpath socat cpio python3 python3-pip python3-pexpect
    xz-utils debianutils iputils-ping python3-git python3-jinja2
    libegl1-mesa libsdl1.2-dev xterm python3-distutils
    # Additional utilities
    curl git-lfs locales lsb-release sudo
    # kas (Yocto build management)
    python3-setuptools
)

DEBIAN_DEPS=("${UBUNTU_DEPS[@]}")

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "${ID}"
    else
        echo "unknown"
    fi
}

install_packages() {
    local distro
    distro=$(detect_distro)

    case "${distro}" in
        ubuntu|debian)
            echo "[info] Updating package index …"
            sudo apt-get update -y
            echo "[info] Installing required packages …"
            sudo apt-get install -y "${UBUNTU_DEPS[@]}"
            ;;
        *)
            echo "[warn] Unsupported distribution '${distro}'."
            echo "       Please install the following packages manually:"
            printf '  %s\n' "${UBUNTU_DEPS[@]}"
            exit 1
            ;;
    esac
}

install_kas() {
    echo "[info] Installing kas (pinned version) …"
    # Pin to a known-good version; update intentionally when upgrading.
    pip3 install --user "kas==4.4"
    export PATH="${HOME}/.local/bin:${PATH}"
    kas --version
}

configure_locales() {
    echo "[info] Configuring UTF-8 locale …"
    if command -v locale-gen &>/dev/null; then
        sudo locale-gen en_US.UTF-8
        sudo update-locale LANG=en_US.UTF-8
    fi
}

main() {
    echo "=== YCM4R1 host dependency installer ==="
    install_packages
    install_kas
    configure_locales
    echo ""
    echo "[done] All dependencies installed."
    echo "       You may need to log out and back in for PATH changes to take effect."
}

main "$@"
