# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
project('mindseye', [ 'c', 'objc' ], default_options: [
        'buildtype=plain',
        'c_std=gnu11',
        'b_staticpic=false',
        'b_lto=false',
        'b_asneeded=false' ])

c_args = [
        '-g', '-O0',
        '-ffreestanding',
        '-fno-function-sections',
        '-mno-red-zone' ]

objc_args = [
        c_args,
        '-fobjc-arc',
        '-fobjc-runtime=objfw' ]

link_args = [
        '-nostdlib' ]

subdir('vendor')
subdir('source')
