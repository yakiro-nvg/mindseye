cpu = host_machine.cpu()

arch_name = ''

if cpu == 'armv8'
	subdir('arm')
  arch_name = 'arm64'
	subdir(arch_name)
else
	error('unknown architecture: ' + cpu)
endif

link_args += ['-Wl,-T,@0@/@1@'.format(meson.current_build_dir(), arch_name/'link.ld')]
