# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_library(objcrt STATIC)
target_include_directories(objcrt PRIVATE . ../include)
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.m)
target_compile_options(objcrt PRIVATE ${OBJC_FLAGS_LIST} -fno-objc-arc)
target_sources(objcrt PRIVATE ${HEADERS} ${SOURCES})
target_link_libraries(objcrt string)
