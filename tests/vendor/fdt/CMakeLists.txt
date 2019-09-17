# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause
file(GLOB HEADERS ${MINDSEYE_VENDOR}/libfdt/*.h)
file(GLOB SOURCES ${MINDSEYE_VENDOR}/libfdt/*.c)
add_library(fdt ${HEADERS} ${SOURCES})
target_include_directories(fdt PUBLIC ${MINDSEYE_VENDOR}/libfdt)
