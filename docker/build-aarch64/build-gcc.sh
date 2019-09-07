#!/usr/bin/env bash
wget http://mirror.keystealth.org/gnu/binutils/binutils-2.32.tar.gz
wget http://mirror.team-cymru.com/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.gz
wget http://mirror.us-midwest-1.nexcess.net/gnu/mpfr/mpfr-4.0.2.tar.gz
wget http://mirror.keystealth.org/gnu/gmp/gmp-6.1.2.tar.xz
wget http://mirror.keystealth.org/gnu/mpc/mpc-1.1.0.tar.gz
wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2
wget https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
for f in *.tar*; do tar xf $f; done

cd gcc-9.2.0
ln -s ../mpfr-4.0.2 mpfr
ln -s ../gmp-6.1.2 gmp
ln -s ../mpc-1.1.0 mpc
ln -s ../isl-0.18 isl
ln -s ../cloog-0.18.1 cloog
cd ..

mkdir -p /opt/cross
PATH="/opt/cross/bin:${PATH}"

mkdir build-binutils && cd build-binutils
../binutils-2.32/configure --prefix=/opt/cross --target=aarch64-elf --disable-multilib
make -j4 && make install
cd ..

mkdir -p build-gcc && cd build-gcc
../gcc-9.2.0/configure --prefix=/opt/cross --target=aarch64-elf \
        --enable-languages=c,c++,objc,obj-c++ --disable-multilib --disable-threads --disable-tls
make -j4 all-gcc && make install-gcc
cd ..
