# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
file(GLOB_RECURSE HEADERS *.h)
file(GLOB_RECURSE SOURCES *.m)
file(GLOB_RECURSE ASM_SOURCES *.S)
target_sources(mindseye PRIVATE ${HEADERS} ${SOURCES} ${ASM_SOURCES})
configure_file(link.ld.in ${CMAKE_CURRENT_BINARY_DIR}/link.ld @ONLY)
target_link_options(mindseye PRIVATE "-T${CMAKE_CURRENT_BINARY_DIR}/link.ld")
