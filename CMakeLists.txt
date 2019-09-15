# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
cmake_minimum_required(VERSION 3.15)
project(mindseye)

enable_language(C ASM)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding -fno-function-sections -mno-red-zone")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostdlib")
set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_LINKER} <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
set(OBJC_FLAGS_LIST -fobjc-arc -fobjc-runtime=objfw)

set(BOARD             qemu_virt        CACHE STRING "Board name")
set(MAX_CPUS          8                CACHE STRING "Maximum number of CPUs")
set(PAGE_GRANULE      0x1000           CACHE STRING "Page granule in bytes")
set(PAGE_VOFFSET      0xfff000000000   CACHE STRING "To map physical memory")
set(STACK_SIZE        0x1000           CACHE STRING "C stack size in bytes")
set(PRINTK_CAPACITY   0x2000           CACHE STRING "Print-K buffer capacity in bytes")

add_subdirectory(source)
add_subdirectory(vendor)
