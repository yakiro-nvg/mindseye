# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_library(string STATIC)
target_include_directories(string PUBLIC .)
file(GLOB SOURCES ${CMAKE_SYSTEM_PROCESSOR}/*.S)
target_sources(string PRIVATE string.h ${SOURCES})
