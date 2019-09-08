/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>
#import <mse/printk.h>
#import <mse/fdt.h>
#import <printf.h>

#define LOG_TAG "arm64"

// TODO: should be passed from bootloader
static const void *fdt = (const void *)0x40000000;

void entry()
{
        printf("\n--=-=-=-=-=-=- Mind's Eye, welcome! -=-=-=-=-=-=--\n");
        const char *name = fdt_machine_name(fdt) ? : "unknown";
        PR_INFO(LOG_TAG, "machine name: %s", name);
        mindseye(fdt);
}
