# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_executable(mindseye)

add_subdirectory(boards)
get_property(BASE_OFFSET TARGET mindseye PROPERTY BASE_OFFSET)
get_property(BASE_OFFSET TARGET mindseye PROPERTY LOAD_OFFSET)

add_subdirectory(arch)
add_subdirectory(mm)
add_subdirectory(printk)

target_include_directories(mindseye PRIVATE . ../include ${CMAKE_CURRENT_BINARY_DIR})

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h @ONLY)

target_compile_options(mindseye PRIVATE ${OBJC_FLAGS_LIST})

file(GLOB HEADERS *.h)
file(GLOB SOURCES *.m)
file(GLOB_RECURSE PUBLIC_HEADERS ../include/*.h)
target_sources(mindseye PUBLIC ${PUBLIC_HEADERS})
target_sources(mindseye PRIVATE ${HEADERS} ${SOURCES})

target_link_libraries(mindseye objcrt endian fdt printf string)
