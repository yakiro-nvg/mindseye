/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/mindseye.h>

#include <mse/cpu.h>
#include <mse/printk.h>

#define LOG_TAG "entry"

void call_constructors();

void mindseye(const void *fdt)
{
        call_constructors();

        printk_setup(fdt);

        cpu_setup(fdt);
}
