#!/usr/bin/env bash
mkdir /coverity && cd /coverity
wget https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_SCAN_TOKEN}&project=yakiro-nvg%2Fmindseye" -O coverity_tool.tgz
tar -xzf coverity_tool.tgz

cd /root && meson --cross-file=cross/aarch64.txt build && cd build
/coverity/cov-configure --comptype gcc --compiler /opt/cross/bin/aarch64-elf-gcc
/coverity/cov-configure -co aarch64-elf-gcc -- -std=gnu11 -ffreestanding
/coverity/cov-build --dir cov-int ninja
tar czvf mindseye.tgz cov-int
