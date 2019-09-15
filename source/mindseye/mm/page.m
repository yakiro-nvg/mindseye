/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/paging.h>

#import <config.h>
#import <string.h>
#import <mse/bitops.h>
#import <mse/spinlock.h>
#import <mse/printk.h>
#import <mse/fdt.h>

#define LOG_TAG "paging"

#ifdef MSE32
typedef uint32_t bitmap_t;
#define count_leading_zeros count_leading_zeros32
#define clear_bit clear_bit32
#define set_bit set_bit32
#elif defined(MSE64)
typedef uint64_t bitmap_t;
#define count_leading_zeros count_leading_zeros64
#define clear_bit clear_bit64
#define set_bit set_bit64
#else
#error "not implemented"
#endif

enum { BITMAP_BITS = sizeof(bitmap_t)*8 };

static struct page_pool_s {
        uint8_t*    _Nonnull   pages;
        int                    num_pages;
        bitmap_t*   _Nonnull   bitmaps;
        spinlock_t             lock;
} pool SECTION("shared");

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
                pool.num_pages = fdt_next_cell(2, &reg) / PAGE_GRANULE;
                return ERR_NONE;
        }
}

error_t page_pool_setup(const void* fdt)
{
        const error_t ec = parse_fdt(fdt);
        if (ec != ERR_NONE) {
                return ec;
        } else {
                PR_INFO("page size is %d bytes", PAGE_GRANULE);
                PR_INFO("discovered %d pages", pool.num_pages);
                spinlock_init(&pool.lock);
                return ERR_NONE;
        }
}

void page_pool_setup_mark(uint64_t used_bytes, uint64_t dom0_bytes)
{
        BUG_ON(dom0_bytes % PAGE_GRANULE != 0);
        const uint64_t dom0_pages = dom0_bytes / PAGE_GRANULE;
        int used_pages = (int)((used_bytes + PAGE_GRANULE - 1) / PAGE_GRANULE); // round-up to PAGE_SIZE

        // bitmaps starts after marked area
        pool.num_pages = MIN(dom0_pages, pool.num_pages);
        const size_t num_bitmaps = pool.num_pages / BITMAP_BITS;
        pool.num_pages = num_bitmaps*BITMAP_BITS; // clamp to multiple of bitmaps
        PR_INFO("reserves %d pages for dom0", pool.num_pages);
        pool.bitmaps = (bitmap_t*)(pool.pages + used_pages*PAGE_GRANULE);
        while (true) { }
        memset(pool.bitmaps, 0xff, sizeof(bitmap_t)*num_bitmaps); // unused
        const uint8_t* bitmaps_end = align_forward(pool.bitmaps + num_bitmaps, PAGE_GRANULE);
        used_pages = (int)((bitmaps_end - pool.pages) / PAGE_GRANULE); // will mark bitmaps buffer as used also

        // mark all used pages
        for (int i = 0; i < used_pages; ++i) {
                const int bitmap_idx = i / BITMAP_BITS;
                int bitmap_nth = i % BITMAP_BITS;
                bitmap_nth = BITMAP_BITS - bitmap_nth - 1; // little-endian
                clear_bit(pool.bitmaps + bitmap_idx, bitmap_nth);
        }
}

void* page_pool_base_address()
{
        return pool.pages;
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
                        page = pool.pages + (i*BITMAP_BITS + zeros)*PAGE_GRANULE;
                        break; // found
                }
        }
        spinlock_irq_restore(&pool.lock, &flags);

        return page;
}

void page_pool_drop(void* page)
{
        const int byte_dif = (((uint8_t*)page) - pool.pages);
        const int page_idx = byte_dif / PAGE_GRANULE;
        const int bitmap_idx = page_idx / BITMAP_BITS;
        int bitmap_nth = page_idx % BITMAP_BITS;
        bitmap_nth = BITMAP_BITS - bitmap_nth - 1; // little-endian

        spinlock_flags_t flags;
        spinlock_irq_save(&pool.lock, &flags);
        set_bit(pool.bitmaps + bitmap_idx, bitmap_nth);
        spinlock_irq_restore(&pool.lock, &flags);
}
