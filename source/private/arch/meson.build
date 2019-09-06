# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
cpu = host_machine.cpu()

arch_name = ''

if cpu == 'armv8'
        subdir('arm')
  arch_name = 'arm64'
        subdir(arch_name)
else
        error('unknown architecture: ' + cpu)
endif

mindseye_link_args += [
        '-Wl,-T,@0@/@1@'.format(
                meson.current_build_dir(), arch_name/'link.ld')]
