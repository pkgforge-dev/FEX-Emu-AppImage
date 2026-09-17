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

echo "Building FEX-Emu..."
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
    -DTUNE_CPU=generic \
    -DTUNE_ARCH=generic \
    -DUSE_LINKER=lld \
    -DENABLE_LTO=True \
    -DBUILD_TESTING=False \
    -DENABLE_ASSERTIONS=False \
    -G Ninja
ninja
ninja install
#ninja binfmt_misc
