/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import "types.h"
#import "selector.h"
#import "class.h"
#import "category.h"
#import "static.h"
#import <mse/printk.h>

#define LOG_TAG "objcrt"

void __objc_exec_class(objc_abi_module_t *module)
{
        objc_register_selectors(module->symtab);
        objc_register_classes(module->symtab);
        objc_register_categories(module->symtab);
        objc_init_static_instances(module->symtab);
}
