# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
mindseye_include_directories = [
        include_directories('.')
]

mindseye_srcs = [
        'private/cpu.m',
        'private/ctors.m',
        'private/errno.m',
        'private/fdt.m',
        'private/mindseye.m',
        'private/object.m',
        'private/paging.m',
        'private/printk.m'
]

mindseye_c_args = [
        '-ffreestanding',
        '-fno-function-sections',
        '-fno-exceptions'
]

mindseye_objc_args = [
        '-std=c11',
        '-fobjc-runtime=objfw'
]

mindseye_link_args = [
        '-nostdlib'
]

subdir('private/objcrt')
subdir('private/boards')
subdir('private/arch')
subdir('private/printk')

conf_data = configuration_data({
        'max_cpus': get_option('max_cpus'),
        'page_size': get_option('page_size'),
        'printk_buffer_size': get_option('printk_buffer_size')
})
configure_file(
        input: 'private/config.h.in',
        output: 'config.h',
        configuration: conf_data)

executable(
        'mindseye',
        [ mindseye_srcs, vendor_srcs ],
        c_args: mindseye_c_args,
        objc_args: [
                mindseye_c_args,
                mindseye_objc_args
        ],
        link_args: mindseye_link_args,
        include_directories: [
                mindseye_include_directories,
                vendor_include_directories ])
