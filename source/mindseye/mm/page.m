/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/paging.h>

#import "bitmap.h"
#import <config.h>
#import <string.h>
#import <mse/spinlock.h>
#import <mse/printk.h>
#import <mse/fdt.h>

#define LOG_TAG "paging"

enum { PAGE_SIZE = PAGE_GRANULE };

static struct page_pool_s {
        uint8_t*    _Nonnull   pages;
        int                    num_pages;
        bitmap_t*   _Nonnull   bitmaps;
        spinlock_t             lock;
} pool __attribute__((section("shared")));

static error_t parse_fdt(const void* fdt)
{
        // now support only single memory bank
        const int mem = fdt_subnode_offset(fdt, 0, "memory");
        if (mem < 0) {
                PR_ERROR("'memory' was missing");
                return ERR_MALFORMED;
        }
        const uint32_t *reg = fdt_getprop(fdt, mem, "reg", NULL);
        if (reg == NULL) {
                PR_ERROR("'reg' was missing");
                return ERR_MALFORMED;
        } else {
                pool.pages = (uint8_t*)fdt_next_cell(2, &reg);
                pool.num_pages = fdt_next_cell(2, &reg) / PAGE_SIZE;
                return ERR_NONE;
        }
}

size_t page_pool_setup(const void* fdt)
{
        const error_t ec = parse_fdt(fdt);
        if (ec != ERR_NONE) {
                return ec;
        } else {
                PR_INFO("page size is %d bytes", PAGE_SIZE);
                PR_INFO("discovered %d pages", pool.num_pages);
                spinlock_init(&pool.lock);
                return (size_t)pool.pages;
        }
}

void page_pool_setup_mark(uint64_t used_bytes, uint64_t reserved_bytes)
{
        // number of page, round-up to PAGE_SIZE
        const uint64_t reserved_pages = (reserved_bytes + PAGE_SIZE - 1) / PAGE_SIZE;
        uint64_t used_pages = (used_bytes + PAGE_SIZE - 1) / PAGE_SIZE;

        // bitmaps starts after marked area
        pool.num_pages = MIN(reserved_pages, pool.num_pages);
        const size_t num_bitmaps = pool.num_pages / BITMAP_BITS;
        pool.num_pages = num_bitmaps*BITMAP_BITS; // clamp to multiple of bitmaps
        PR_INFO("dom0 reserves %d pages", pool.num_pages);
        pool.bitmaps = (bitmap_t*)(pool.pages + used_pages*PAGE_SIZE);
        memset(pool.bitmaps, 0xff, sizeof(bitmap_t)*num_bitmaps); // unused
        const uint8_t* bitmaps_end = align_forward(pool.bitmaps + num_bitmaps, PAGE_SIZE);
        used_pages = (bitmaps_end - pool.pages) / PAGE_SIZE; // will mark bitmaps buffer as used also

        // mark all used pages
        for (uint64_t i = 0; i < used_pages; ++i) {
                const int bitmap_idx = i / BITMAP_BITS;
                int bitmap_nth = i % BITMAP_BITS;
                bitmap_nth = BITMAP_BITS - bitmap_nth - 1; // little-endian
                clear_bit(pool.bitmaps + bitmap_idx, bitmap_nth);
        }
}

void* page_pool_take()
{
        void *page = NULL;

        spinlock_flags_t flags;
        spinlock_irq_save(&pool.lock, &flags);
        for (int i = 0; i*BITMAP_BITS < pool.num_pages; ++i) {
                if (pool.bitmaps[i] == 0) {
                        continue; // no free slot, next bitmap
                }

                const int zeros = count_leading_zeros(pool.bitmaps[i]);
                if (zeros < BITMAP_BITS) { // next bit is unallocated
                        clear_bit(pool.bitmaps + i, BITMAP_BITS - zeros - 1); // little-endian
                        page = pool.pages + (i*BITMAP_BITS + zeros)*PAGE_SIZE;
                        break; // found
                }
        }
        spinlock_irq_restore(&pool.lock, &flags);

        return page;
}

void page_pool_drop(void* page)
{
        const int byte_dif = (((uint8_t*)page) - pool.pages);
        const int page_idx = byte_dif / PAGE_SIZE;
        const int bitmap_idx = page_idx / BITMAP_BITS;
        int bitmap_nth = page_idx % BITMAP_BITS;
        bitmap_nth = BITMAP_BITS - bitmap_nth - 1; // little-endian

        spinlock_flags_t flags;
        spinlock_irq_save(&pool.lock, &flags);
        set_bit(pool.bitmaps + bitmap_idx, bitmap_nth);
        spinlock_irq_restore(&pool.lock, &flags);
}
