/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>

#import <config.h>
#import <mse/paging.h>
#import <mse/printk.h>
#import <mse/cpu.h>

#define LOG_TAG "entry"

// TODO: should be passed from bootloader
static const size_t reserved_bytes = 0x80000000;

// end of the kernel image
extern uint8_t e_mindseye[];

// claim physical memory
static void claim_memory(const void* fdt)
{
        const size_t ec = page_pool_setup(fdt);
        if (ec < 0) {
                PR_FATAL("failed to claim memory");
        } else {
                const size_t used_bytes = (size_t)e_mindseye - ec;
                page_pool_setup_mark(used_bytes, reserved_bytes);
        }
}

// static constructors
void call_constructors();

void mindseye(const void* fdt)
{
        claim_memory(fdt);
        call_constructors();
        printk_setup(fdt);
        cpu_setup(fdt);
        {
                void *p1 = page_pool_take(15*PAGE_GRANULE);
                void *p2 = page_pool_take(PAGE_GRANULE);
                void *p3 = page_pool_take(33*PAGE_GRANULE);
                page_pool_drop(p2, PAGE_GRANULE);
                void *p4 = page_pool_take(2*PAGE_GRANULE);
                void *p5 = page_pool_take(PAGE_GRANULE);

                PR_INFO("p1: 0x%p, p2: 0x%p, p3: 0x%p, p4: 0x%p, p5: 0x%p", p1, p2, p3, p4, p5);

                page_pool_drop(p1, 15*PAGE_GRANULE);
                page_pool_drop(p3, 33*PAGE_GRANULE);
                page_pool_drop(p4, 2*PAGE_GRANULE);
                page_pool_drop(p5, PAGE_GRANULE);
        }

        {
                void *p1 = page_pool_take(15*PAGE_GRANULE);
                void *p2 = page_pool_take(PAGE_GRANULE);
                void *p3 = page_pool_take(33*PAGE_GRANULE);
                page_pool_drop(p2, PAGE_GRANULE);
                void *p4 = page_pool_take(2*PAGE_GRANULE);
                void *p5 = page_pool_take(PAGE_GRANULE);

                PR_INFO("p1: 0x%p, p2: 0x%p, p3: 0x%p, p4: 0x%p, p5: 0x%p", p1, p2, p3, p4, p5);

                page_pool_drop(p1, 15*PAGE_GRANULE);
                page_pool_drop(p3, 33*PAGE_GRANULE);
                page_pool_drop(p4, 2*PAGE_GRANULE);
                page_pool_drop(p5, PAGE_GRANULE);
        }

        while (true) { }
}
