# Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause.
add_project_arguments('-DMSE_ARM64', language : 'c')

link_conf_data = configuration_data({
  'load_offset': load_offset,
  'text_offset': text_offset
})
configure_file(
  input: 'link.ld.in',
  output: 'link.ld',
  configuration: link_conf_data)

mindseye_srcs += [
	files(
	  'entry.S',
    'entry.c',
    'setup.c'
	)
]
