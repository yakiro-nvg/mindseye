# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
if (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64")
        add_subdirectory("arm")
        add_subdirectory("arm64")
else()
        message(FATAL_ERROR "unknown architecture")
endif()
