/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/objcrt.h>
#import "class.h"

#import <mse/printk.h>

#define LOG_TAG "objcrt"

void objc_register_classes(objc_abi_symtab_t *symtab)
{
        // TODO
}

Class object_getClass(id obj)
{
        return obj ? ((__bridge objc_object_t*)obj)->isa : Nil;
}
