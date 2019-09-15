# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
file(GLOB_RECURSE HEADERS *.h)
file(GLOB_RECURSE SOURCES *.m)
target_sources(mindseye PRIVATE ${HEADERS} ${SOURCES})
