/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJCRT_TYPES_H_
#define _MSE_OBJCRT_TYPES_H_

#import <mse/prereq.h>

typedef struct objc_abi_selector_s {
        const char *method;
} objc_abi_selector_t;

typedef struct objc_abi_symtab_s {
        unsigned long _;
        objc_abi_selector_t *selector_refs;
        uint16_t class_defs_count;
        uint16_t category_defs_count;
        void *defs[];
} objc_abi_symtab_t;

typedef struct objc_abi_module_s {
        unsigned long version;
        unsigned long size;
        const char *name;
        objc_abi_symtab_t *symtab;
} objc_abi_module_t;

#endif // !_MSE_OBJCRT_TYPES_H_
