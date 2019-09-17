# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause
add_library(endian INTERFACE)
target_include_directories(endian INTERFACE ${MINDSEYE_VENDOR}/endian)
target_sources(endian INTERFACE ${MINDSEYE_VENDOR}/endian/endianness.h)
