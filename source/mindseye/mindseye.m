/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/mindseye.h>

#import <config.h>
#import <mse/fdt.h>
#import <mse/paging.h>
#import <mse/printk.h>
#import <mse/cpu.h>

#define LOG_TAG "entry"

// TODO: should be passed from some where?
static const int64_t dom0_bytes = GB(2);

// end of the kernel image
extern uint8_t s_mindseye[];
extern uint8_t e_mindseye[];

// claim physical memory
static void claim_memory(const void *fdt)
{
        const int64_t used_bytes = e_mindseye - s_mindseye;
        const int64_t num_bytes = page_pool_setup(fdt, used_bytes, dom0_bytes);
        if (num_bytes < 0) {
                PR_FATAL("failed to claim memory");
        } else {
                mmu_setup(num_bytes);
        }
}

// static constructors
void call_constructors();

void mindseye(const void* fdt)
{
        PR_INFO("--=-=-=-=-=-=- Mind's Eye, welcome! -=-=-=-=-=-=--");
        const char *name = fdt_machine_name(fdt) ? : "unknown";
        PR_INFO("machine name: %s", name);
        claim_memory(fdt);
        call_constructors(fdt);
        printk_setup(fdt);
        cpu_setup(fdt);
}
