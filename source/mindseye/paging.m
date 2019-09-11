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
                PR_INFO("discovered %d pages * %d bytes", pool.num_pages, PAGE_SIZE);
                spinlock_init(&pool.lock);
                return (size_t)pool.pages;
        }
}

void page_pool_setup_mark(int num)
{
        // bitmaps starts after marked area
        const size_t num_bitmaps = pool.num_pages / BITMAP_BITS;
        pool.num_pages = num_bitmaps*BITMAP_BITS;
        PR_INFO("now manage %d pages * %d bytes", pool.num_pages, PAGE_SIZE);
        pool.bitmaps = (bitmap_t*)(pool.pages + num*PAGE_SIZE);
        memset(pool.bitmaps, 0xff, sizeof(bitmap_t)*num_bitmaps); // unused
        const uint8_t* bitmaps_end = align_forward(pool.bitmaps + num_bitmaps, PAGE_SIZE);
        num = (bitmaps_end - pool.pages) / PAGE_SIZE; // will mark this buffer as used also

        // mark all used pages
        for (int i = 0; i < num; ++i) {
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
