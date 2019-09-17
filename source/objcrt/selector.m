/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/objcrt.h>
#import "selector.h"

#import <mse/printk.h>
#import <string.h>

#define LOG_TAG "objcrt"

void objc_register_selectors(objc_abi_symtab_t *symtab)
{
        UNUSED(symtab);
        // selector is just a string,
        // we don't need to register it
}

BOOL sel_isEqual(SEL lhs, SEL rhs)
{
        return lhs == rhs || strcmp(lhs->method, rhs->method) == 0;
}

const char* sel_getName(SEL sel)
{
        return sel->method;
}
