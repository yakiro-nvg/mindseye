# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
mindseye_srcs = [ files(
        'cpu.m',
        'ctors.m',
        'errno.m',
        'fdt.m',
        'mindseye.m',
        'printk.m') ]

mindseye_c_args = [ ]

mindseye_objc_args = [
        mindseye_c_args ]

mindseye_link_args = [ ]

subdir('boards')
subdir('arch')
subdir('printk')
subdir('mm')

conf_data = configuration_data({
        'max_cpus': get_option('max_cpus'),
        'page_granule': get_option('page_granule'),
        'printk_buffer_size': get_option('printk_buffer_size') })
configure_file(
        input: 'config.h.in',
        output: 'config.h',
        configuration: conf_data)

executable(
        'mindseye',
        [ mindseye_srcs, vendor_srcs ],
        c_args: [
                c_args,
                mindseye_c_args ],
        objc_args: [
                objc_args,
                mindseye_objc_args ],
        link_args: [
                link_args,
                mindseye_link_args ],
        include_directories: [
                '../include',
                vendor_include_directories ],
        link_with: objcrt)
