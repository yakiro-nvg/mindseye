# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_library(fdt STATIC)
target_include_directories(fdt PUBLIC .)
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.c)
target_sources(fdt PRIVATE ${HEADERS} ${SOURCES})
target_link_libraries(fdt string)
