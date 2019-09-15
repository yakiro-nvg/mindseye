# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_library(printf STATIC)
target_include_directories(printf PUBLIC .)
target_sources(printf PRIVATE printf.h printf.c)
