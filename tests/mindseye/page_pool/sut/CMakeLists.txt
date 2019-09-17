# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
include_directories(.)
add_compile_options(-include mock.h)
add_definitions(-DDTB_PATH="${TEST_DATA}/virt.dtb")
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.mm)
add_library(page_pool ${HEADERS} ${SOURCES}
        ${MINDSEYE_SOURCES}/mindseye/mm/page.m
        ${MINDSEYE_SOURCES}/mindseye/fdt.m)
target_link_libraries(page_pool PRIVATE endian fdt)
