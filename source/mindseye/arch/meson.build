# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
cpu = host_machine.cpu()

if cpu == 'armv8'
        subdir('arm')
        subdir('arm64')
else
        error('unknown architecture: ' + cpu)
endif
