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

static int64_t parse_fdt(const void* fdt)
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
                fdt_next_cell(2, &reg); // skip address
                const int64_t bytes = fdt_next_cell(2, &reg);
                pool.pages = (uint8_t*)PAGE_VOFFSET;
                pool.num_pages = bytes / PAGE_GRANULE;
                return bytes;
        }
}

static void mark(int64_t used_bytes, int64_t dom0_bytes)
{
        BUG_ON(dom0_bytes % PAGE_GRANULE != 0);
        const int64_t dom0_pages = dom0_bytes / PAGE_GRANULE;
        int used_pages = (int)((used_bytes + PAGE_GRANULE - 1) / PAGE_GRANULE); // round-up to PAGE_SIZE

        // bitmaps starts after marked area
        pool.num_pages = MIN(dom0_pages, pool.num_pages);
        const int64_t num_bitmaps = pool.num_pages / BITMAP_BITS;
        pool.num_pages = num_bitmaps*BITMAP_BITS; // clamp to multiple of bitmaps
        PR_INFO("reserves %d pages for dom0", pool.num_pages);
        pool.bitmaps = (bitmap_t*)(pool.pages + used_pages*PAGE_GRANULE);
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

static void drop_no_lock(uint8_t* pages, int num_pages)
{
        const int first_idx = (pages - pool.pages) / PAGE_GRANULE;
        for (int i = 0; i < num_pages; ++i) {
                const int page_idx = first_idx + i;
                const int bitmap_idx = page_idx / BITMAP_BITS;
                int bitmap_nth = page_idx % BITMAP_BITS;
                bitmap_nth = BITMAP_BITS - bitmap_nth - 1; // little-endian
                set_bit(pool.bitmaps + bitmap_idx, bitmap_nth);
        }
}

int64_t page_pool_setup(const void* fdt, int64_t used_bytes, int64_t dom0_bytes)
{
        const int64_t bytes = parse_fdt(fdt);

        if (bytes > 0) {
                PR_INFO("page size is %d bytes", PAGE_GRANULE);
                PR_INFO("discovered %d pages", pool.num_pages);
                spinlock_init(&pool.lock);
                mark(used_bytes, dom0_bytes);
        }

        return bytes;
}

paddr_t* page_pool_take(int num_bytes, int align)
{
        uint8_t *pages = NULL;
        bool alignment_matched = false;
        int acc_pages = 0, num_padding = 0;
        BUG_ON(align % PAGE_GRANULE != 0);
        const int num_pages = (num_bytes + PAGE_GRANULE - 1) / PAGE_GRANULE;

        spinlock_flags_t flags;
        spinlock_irq_save(&pool.lock, &flags);

        for (int i = 0; i*BITMAP_BITS < pool.num_pages;) {
                const int zeros = pool.bitmaps[i] == 0 ? 64 : count_leading_zeros(pool.bitmaps[i]);

                if (zeros < BITMAP_BITS) { // next bit is unallocated
                        clear_bit(pool.bitmaps + i, BITMAP_BITS - zeros - 1); // little-endian
                        uint8_t *cp = pool.pages + (i*BITMAP_BITS + zeros)*PAGE_GRANULE;

                        if (acc_pages == 0) {
                                pages = cp; // remember starting point
                        }

                        // keep add padding pages until matched
                        if (!alignment_matched) {
                                if ((size_t)cp % align != 0) {
                                        ++num_padding;
                                } else {
                                        alignment_matched = true;
                                }
                        }

                        // check for complete
                        if (++acc_pages - num_padding == num_pages) {
                                // drop padding pages
                                drop_no_lock(pages, num_padding);
                                pages = pages + num_padding*PAGE_GRANULE;
                                break; // found
                        }

                        // end of the current bitmap
                        if (zeros == BITMAP_BITS - 1) {
                                ++i;
                        }
                } else if (zeros == BITMAP_BITS) {
                        // rollback marked bits
                        drop_no_lock(pages, acc_pages);

                        ++i; // next bitmap
                        pages = NULL;
                        alignment_matched = false;
                        acc_pages = 0; num_padding = 0;
                }
        }

        spinlock_irq_restore(&pool.lock, &flags);

        return (paddr_t*)pages;
}

void page_pool_drop(paddr_t* pages, int num_bytes)
{
        spinlock_flags_t flags;
        spinlock_irq_save(&pool.lock, &flags);
        const int num_pages = (num_bytes + PAGE_GRANULE - 1) / PAGE_GRANULE;
        drop_no_lock((uint8_t*)pages, num_pages);
        spinlock_irq_restore(&pool.lock, &flags);
}
