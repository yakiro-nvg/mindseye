/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>

#import <config.h>
#import <mse/paging.h>
#import <mse/printk.h>
#import <mse/cpu.h>

#define LOG_TAG "entry"

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

void call_constructors();

void mindseye(const void* fdt)
{
        claim_memory(fdt);
        call_constructors();
        printk_setup(fdt);
        cpu_setup(fdt);
}
