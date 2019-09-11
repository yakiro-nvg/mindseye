# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
link_conf_data = configuration_data({
        'load_offset': load_offset,
        'text_offset': text_offset,
        'page_size': get_option('page_size'),
        'stack_size': get_option('stack_size'),
        'printk_buffer_size': get_option('printk_buffer_size') })
configure_file(
        input: 'link.ld.in',
        output: 'link.ld',
        configuration: link_conf_data)

mindseye_link_args += [ '-Wl,-T,@0@/@1@'.format(meson.current_build_dir(), 'link.ld') ]

mindseye_srcs += [ files(
        'entry.S',
        'entry.m',
        'psci.S') ]
