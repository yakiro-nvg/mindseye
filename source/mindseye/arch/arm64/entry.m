/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>

#import <printf.h>
#import <config.h>
#import <mse/printk.h>
#import <mse/fdt.h>
#import <mse/paging.h>

#define LOG_TAG "arm64"

// TODO: should be passed from bootloader
static const void *fdt = (const void *)0x40000000;

// end of the kernel image
extern uint8_t e_mindseye[];

static void claim_memory(const void* fdt)
{
        const size_t ec = page_pool_setup(fdt);
        if (ec < 0) {
                PR_FATAL("failed to claim memory");
        } else {
                const size_t used_bytes = (size_t)e_mindseye - ec;
                page_pool_setup_mark(used_bytes / PAGE_SIZE);
        }
}

void entry()
{
        printf("\n--=-=-=-=-=-=- Mind's Eye, welcome! -=-=-=-=-=-=--\n");
        const char *name = fdt_machine_name(fdt) ? : "unknown";
        PR_INFO("machine name: %s", name);
        claim_memory(fdt);
        mindseye(fdt);
}
