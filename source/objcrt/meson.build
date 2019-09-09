objcrt_srcs = [
        files(
                'arc.m',
                'category.m',
                'class.m',
                'init.m',
                'object.m',
                'selector.m',
                'static.m') ]

build_target(
        'objcrt',
        objcrt_srcs,
        c_args: c_args,
        objc_args: [
                c_args,
                objc_args,
                '-fno-objc-arc'
        ],
        include_directories: [
                '../include',
                vendor_include_directories ],
        target_type: 'static_library')
