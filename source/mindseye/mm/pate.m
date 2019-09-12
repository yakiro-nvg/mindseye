/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/paging.h>

#import "bitmap.h"
#import <config.h>
#import <string.h>
#import <mse/spinlock.h>
#import <mse/printk.h>

#define LOG_TAG "paging"

uint64_t* pate_pool_take()
{
        // TODO
        return NULL;
}

void pate_pool_drop(void* entry)
{
        // TODO
}
