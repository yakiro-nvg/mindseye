#!/usr/bin/env bash
mkdir /sonar && cd /sonar
wget https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
unzip -j build-wrapper-linux-x86.zip

export TRAVIS=true
export LD_LIBRARY_PATH="/sonar"
cd /root
meson --cross-file=cross/aarch64.txt build
cd build && /sonar/build-wrapper-linux-x86-64 --out-dir bw-output ninja
