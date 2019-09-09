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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcast-of-sel-type"

bool sel_isEqual(SEL lhs, SEL rhs)
{
        objc_abi_selector_t *l = (objc_abi_selector_t*)lhs;
        objc_abi_selector_t *r = (objc_abi_selector_t*)rhs;
        return l == r || strcmp(l->method, r->method) == 0;
}

const char* sel_getName(SEL sel)
{
        return ((objc_abi_selector_t*)sel)->method;
}

void sel_borrow(dynamic_sel_t *dysel, const char *method)
{
        dysel->_ = method;
}

#pragma clang diagnostic pop
