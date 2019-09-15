#!/usr/bin/env bash
mkdir /sonar && cd /sonar
wget https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
unzip -j build-wrapper-linux-x86.zip
cp libinterceptor-x86_64.so libinterceptor-haswell.so

export TRAVIS=true
cd /root
mkdir build && cd build && cmake ../ -DCMAKE_TOOLCHAIN_FILE=../cross/aarch64.cmake
/sonar/build-wrapper-linux-x86-64 --out-dir bw-output make
