# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
cmake_minimum_required(VERSION 3.15)
project(mindseye_test)
enable_language(C Swift)
enable_testing()

set(MINDSEYE_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/../source)
set(MINDSEYE_VENDOR ${CMAKE_CURRENT_SOURCE_DIR}/../vendor)
set(TEST_DATA ${CMAKE_CURRENT_SOURCE_DIR}/data)

include_directories(${MINDSEYE_SOURCES}/include)
find_package(XCTest REQUIRED)

add_subdirectory(mindseye)
add_subdirectory(vendor)
