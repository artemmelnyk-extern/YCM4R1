#!/usr/bin/env bash
# scripts/setup-build.sh
#
# Clone all required Yocto layers and prepare the build environment.
# After running this script, source the Yocto init script to start building:
#
#   ./scripts/setup-build.sh
#   source poky/oe-init-build-env build
#   bitbake ycm4r1-image
#
# Alternatively, use kas (recommended):
#
#   kas build kas/ycm4r1.yml

set -euo pipefail

# ── Versions / branches ───────────────────────────────────────────────────────
YOCTO_BRANCH="warrior"        # Yocto 2.7 – aligns with ROS 1 Melodic
POKY_URL="https://git.yoctoproject.org/git/poky"
OE_URL="https://git.openembedded.org/meta-openembedded"
RPI_URL="https://github.com/agherzan/meta-raspberrypi"
ROS_URL="https://github.com/ros/meta-ros"

# Root of the repository (script lives in scripts/).
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log()  { echo "[setup] $*"; }
die()  { echo "[error] $*" >&2; exit 1; }

clone_or_update() {
    local url="$1" dir="$2" branch="$3"
    if [ -d "${dir}/.git" ]; then
        log "Updating ${dir} …"
        git -C "${dir}" fetch --depth=1 origin "${branch}"
        git -C "${dir}" checkout "${branch}"
        git -C "${dir}" reset --hard "origin/${branch}"
    else
        log "Cloning ${url} (branch: ${branch}) → ${dir} …"
        git clone --depth=1 --branch "${branch}" "${url}" "${dir}"
    fi
}

main() {
    cd "${REPO_DIR}"

    log "=== YCM4R1 build environment setup ==="
    log "Repository root: ${REPO_DIR}"

    # ── Clone layers ──────────────────────────────────────────────────────────
    clone_or_update "${POKY_URL}"  "poky"                "${YOCTO_BRANCH}"
    clone_or_update "${OE_URL}"    "meta-openembedded"   "${YOCTO_BRANCH}"
    clone_or_update "${RPI_URL}"   "meta-raspberrypi"    "${YOCTO_BRANCH}"
    clone_or_update "${ROS_URL}"   "meta-ros"            "${YOCTO_BRANCH}"

    # ── Copy conf files into the build directory ──────────────────────────────
    log "Initialising build directory …"
    # Source the Yocto init script to create build/ with default conf files,
    # then overwrite them with our project-specific versions.
    source poky/oe-init-build-env build >/dev/null

    log "Copying project conf files …"
    cp "${REPO_DIR}/conf/local.conf"    "${REPO_DIR}/build/conf/local.conf"
    cp "${REPO_DIR}/conf/bblayers.conf" "${REPO_DIR}/build/conf/bblayers.conf"

    echo ""
    log "=== Setup complete ==="
    echo ""
    echo "To start the build, run:"
    echo "  source poky/oe-init-build-env build"
    echo "  bitbake ycm4r1-image"
    echo ""
    echo "Or with kas (recommended):"
    echo "  kas build kas/ycm4r1.yml"
}

main "$@"
