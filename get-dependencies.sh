#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake             \
    clang             \
    erofs-utils       \
    erofsfuse         \
    fmt               \
    kvantum           \
    lld               \
    lxqt-qtplugin     \
    ninja             \
    pipewire-audio    \
    pipewire-jack     \
    python-setuptools \
    qqc2-breeze-style \
    qt6-declarative   \
    qt6ct             \
    sdl3              \
    squashfs-tools    \
    squashfuse        \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
echo "Making nightly build of FEX-Emu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/FEX-Emu/FEX"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./FEX
echo "$VERSION" > ~/version

cd FEX
mkdir build && cd build
CC=clang CXX=clang++ cmake .. \
    -DENABLE_BINFMT=OFF \
    -DCMAKE_AR=/usr/bin/ar \
    -DCMAKE_RANLIB=/usr/bin/ranlib \
    -DCMAKE_C_COMPILER_AR=/usr/bin/ar \
    -DCMAKE_CXX_COMPILER_AR=/usr/bin/ar \
    -DCMAKE_C_COMPILER_RANLIB=/usr/bin/ranlib \
    -DCMAKE_CXX_COMPILER_RANLIB=/usr/bin/ranlib \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_LINKER=lld \
    -DENABLE_LTO=True \
    -DBUILD_TESTING=False \
    -DENABLE_ASSERTIONS=False \
    -G Ninja
ninja
ninja install
#ninja binfmt_misc
