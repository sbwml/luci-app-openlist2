#!/bin/sh
set -e

# Define color codes and output functions
RED='\033[1;31m'
GREEN='\033[1;32m'
RESET='\033[0m'

msg_red()   { printf "${RED}%s${RESET}\n" "$*"; }
msg_green() { printf "${GREEN}%s${RESET}\n" "$*"; }

# Parse gh_proxy from $1 if provided, e.g. gh_proxy="https://gh-proxy.com/"
gh_proxy=""
if [ -n "$1" ]; then
    case "$1" in
        gh_proxy=*)
            gh_proxy="${1#gh_proxy=}"
            # ensure gh_proxy ends with /
            [ -n "$gh_proxy" ] && case "$gh_proxy" in
                */) : ;;
                *) gh_proxy="$gh_proxy/" ;;
            esac
            ;;
    esac
fi

# Check if running on OpenWrt
if [ ! -f /etc/openwrt_release ]; then
    msg_red "Unknown OpenWrt Version"
    exit 1
fi

# Read architecture information
. /etc/openwrt_release
DISTRIB_ARCH="${DISTRIB_ARCH:-unknown}"

# Detect package manager and set SDK version
if [ -x "/usr/bin/apk" ]; then
    PKG_MANAGER="apk add --allow-untrusted"
    SDK="SNAPSHOT"
elif command -v opkg >/dev/null 2>&1; then
    PKG_MANAGER="opkg install"
    SDK="openwrt-24.10"
else
    msg_red "No supported package manager found."
    exit 1
fi

# Check LuCI version compatibility
if [ ! -d "/usr/share/luci/menu.d" ]; then
    msg_red "OpenWrt LuCI version is not supported. The minimum required version is openwrt-21.02 or higher."
    exit 1
fi

# Check available root partition space (at least 35MB required)
ROOT_SPACE=$(df -m /usr | awk 'END{print $4}')
if [ "$ROOT_SPACE" -lt 35 ]; then
    msg_red "Error: The system storage space is less than 35MB."
    exit 1
fi

# Create temporary directory and set up cleanup on exit
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Check if the current platform is supported
msg_green "Checking platform..."

SUPPORTED_PLATFORMS="
aarch64_cortex-a53
aarch64_cortex-a72
aarch64_cortex-a76
aarch64_generic
arm_arm1176jzf-s_vfp
arm_arm926ej-s
arm_cortex-a15_neon-vfpv4
arm_cortex-a5_vfpv4
arm_cortex-a7
arm_cortex-a7_neon-vfpv4
arm_cortex-a7_vfpv4
arm_cortex-a8_vfpv3
arm_cortex-a9
arm_cortex-a9_neon
arm_cortex-a9_vfpv3-d16
arm_fa526
arm_xscale
i386_pentium-mmx
i386_pentium4
loongarch64_generic
mips64_mips64r2
mips64_octeonplus
mips64el_mips64r2
mips_24kc
mips_4kec
mips_mips32
mipsel_24kc
mipsel_24kc_24kf
mipsel_74kc
mipsel_mips32
riscv64_riscv64
x86_64
"

FOUND=0
for arch in $SUPPORTED_PLATFORMS; do
    if [ "$DISTRIB_ARCH" = "$arch" ]; then
        FOUND=1
        break
    fi
done

if [ "$FOUND" -ne 1 ]; then
    msg_red "Error! The current \"$DISTRIB_ARCH\" platform is not supported."
    exit 1
fi

# Download the corresponding package archive
PKG_FILE="$SDK-$DISTRIB_ARCH.tar.gz"
BASE_URL="https://github.com/sbwml/luci-app-openlist/releases/latest/download/$PKG_FILE"
if [ -n "$gh_proxy" ]; then
    PKG_URL="${gh_proxy}${BASE_URL}"
else
    PKG_URL="$BASE_URL"
fi

msg_green "Downloading $PKG_URL ..."
if ! curl --connect-timeout 5 -m 300 -kLo "$TEMP_DIR/$PKG_FILE" "$PKG_URL"; then
    msg_red "Download $PKG_FILE failed."
    exit 1
fi

# Extract and install packages
msg_green "Installing Packages ..."
tar -zxf "$TEMP_DIR/$PKG_FILE" -C "$TEMP_DIR/"
for pkg in "$TEMP_DIR"/packages_ci/openlist*.ipk \
           "$TEMP_DIR"/packages_ci/luci-app-openlist*.ipk \
           "$TEMP_DIR"/packages_ci/luci-i18n-openlist-zh-cn*.ipk; do
    [ -f "$pkg" ] && $PKG_MANAGER "$pkg"
done

# Clean up temporary files and finish
rm -rf /tmp/luci-*
msg_green "Done!"
