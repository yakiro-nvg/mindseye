# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
mindseye_include_directories = [
  include_directories('.')
]

mindseye_srcs = [
  'private/ctors.c',
  'private/bump.c',
  'private/fdt.c',
  'private/mindseye.c',
  'private/paging.c',
  'private/printk.c'
]

mindseye_c_args = [
  '-ffreestanding',
  '-fno-function-sections'
]

mindseye_link_args = [
  '-nostdlib'
]

subdir('private/boards')
subdir('private/arch')
subdir('private/printk')

conf_data = configuration_data({
  'page_size': get_option('page_size')
})
configure_file(
  input: 'private/config.h.in',
  output: 'config.h',
  configuration: conf_data)

executable(
  'mindseye',
  [mindseye_srcs, vendor_srcs],
  c_args: mindseye_c_args,
  link_args: mindseye_link_args,
  include_directories: [
    mindseye_include_directories,
    vendor_include_directories ])
