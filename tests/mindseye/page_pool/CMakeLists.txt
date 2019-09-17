# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_subdirectory(sut)
file(GLOB HEADERS *.h)
file(GLOB SOURCES *.swift)
xctest_add_bundle(page_pool_tests page_pool ${HEADERS} ${SOURCES})
set_target_properties(page_pool_tests PROPERTIES XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER
        ${CMAKE_CURRENT_SOURCE_DIR}/bridging_header.h)
set_target_properties(page_pool_tests PROPERTIES CMAKE_XCODE_ATTRIBUTE_SWIFT_OBJC_INTERFACE_HEADER_NAME
        ${CMAKE_CURRENT_SOURCE_DIR}/bridging_header.h)
xctest_add_test(XCTest.page_pool page_pool_tests)
target_link_libraries(page_pool_tests PRIVATE fdt)
