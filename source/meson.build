# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
include_directories = [
]

srcs = [
  'private/ctors.c',
  'private/bump.c',
  'private/fdt.c',
  'private/mindseye.c',
  'private/paging.c',
  'private/printk.c'
]

c_args = [
  '-ffreestanding',
  '-fno-function-sections'
]

link_args = [
  '-nostdlib'
]

subdir('private/boards')
subdir('private/arch')
subdir('private/printk')

subdir('private/vendor/string')
subdir('private/vendor/printf')
subdir('private/vendor/libfdt')
subdir('private/vendor/endianness')

conf_data = configuration_data({
  'page_size': get_option('page_size')
})
configure_file(
  input: 'private/config.h.in',
  output: 'config.h',
  configuration: conf_data)

executable(
  'mindseye',
  srcs, c_args: c_args,
  link_args: link_args,
  include_directories: include_directories)
