# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
set(CMAKE_SYSTEM_NAME         Generic)
set(CMAKE_SYSTEM_PROCESSOR    aarch64)
set(CLANG_TARGET_TRIPLE       aarch64-elf)
set(CMAKE_C_COMPILER          clang)
set(CMAKE_C_COMPILER_WORKS    1)
set(CMAKE_CXX_COMPILER_WORKS  1)
set(CMAKE_C_COMPILER_TARGET   ${CLANG_TARGET_TRIPLE})
set(CMAKE_ASM_COMPILER        clang)
set(CMAKE_ASM_COMPILER_TARGET ${CLANG_TARGET_TRIPLE})
set(CMAKE_LINKER              ${CLANG_TARGET_TRIPLE}-gcc)
