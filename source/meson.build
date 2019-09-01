include_directories = [
]

srcs = [
  'private/mindseye.c',
  'private/paging.c'
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

subdir('private/vendor/string')
subdir('private/vendor/libfdt')

conf_data = configuration_data({
  'pti': get_option('pti') ? 'true' : 'false',
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
