objcrt_srcs = [ files(
        'arc.m',
        'category.m',
        'class.m',
        'init.m',
        'object.m',
        'selector.m',
        'static.m') ]

objcrt = build_target(
        'objcrt',
        objcrt_srcs,
        objc_args: [
                objc_args,
                '-fno-objc-arc' ],
        include_directories: [
                '../include',
                vendor_include_directories ],
        target_type: 'static_library')
