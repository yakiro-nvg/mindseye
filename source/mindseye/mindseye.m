/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>

#import <mse/cpu.h>
#import <mse/printk.h>

#import <mse/objcrt.h>

#define LOG_TAG "entry"

void call_constructors();

void mindseye(const void *fdt)
{
        call_constructors();
        printk_setup(fdt);
        cpu_setup(fdt);
}
