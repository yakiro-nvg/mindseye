#!/usr/bin/env bash
mkdir /coverity && cd /coverity
wget https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_SCAN_TOKEN}&project=yakiro-nvg%2Fmindseye" -O coverity_tool.tgz
tar -xzf coverity_tool.tgz --strip-components 1

cd /root && meson --cross-file=cross/aarch64.ini build && cd build
/coverity/bin/cov-configure --comptype gcc --compiler /opt/cross/bin/aarch64-elf-gcc
/coverity/bin/cov-configure -co aarch64-elf-gcc -- -std=gnu11 -ffreestanding
/coverity/bin/cov-build --dir cov-int ninja
tar czvf mindseye.tgz cov-int
