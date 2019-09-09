/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJCRT_SELECTOR_H_
#define _MSE_OBJCRT_SELECTOR_H_

#import <mse/prereq.h>
#import "types.h"

void objc_register_selectors(objc_abi_symtab_t* _Nonnull symtab);

#endif // !_MSE_OBJCRT_SELECTOR_H_
