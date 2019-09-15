# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
link_conf_data = configuration_data({
        'base_offset': base_offset,
        'load_offset': load_offset,
        'page_granule': get_option('page_granule'),
        'page_voffset': get_option('page_voffset'),
        'stack_size': get_option('stack_size'),
        'printk_buffer_size': get_option('printk_buffer_size') })
configure_file(
        input: 'link.ld.in',
        output: 'link.ld',
        configuration: link_conf_data)

mindseye_link_args += [ '-Wl,-T,@0@/@1@'.format(meson.current_build_dir(), 'link.ld') ]

mindseye_srcs += [ files(
        'early_ptbl.S',
        'entry.S',
        'psci.S',
        'mmu.m') ]
