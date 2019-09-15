/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/paging.h>

#import <config.h>
#import <mse/printk.h>

#define LOG_TAG "mmu"

enum { NOT_AVAILABLE = -1 };
enum { NO_BLOCK_SIZE = -2 };
enum { LOOKUP_LEVELS =  4 };

typedef struct page_level_s {
        int64_t block_size;
} page_level_t;

#if   PAGE_GRANULE == KB(4)
static const page_level_t PL[LOOKUP_LEVELS] = {
        { .block_size = NO_BLOCK_SIZE },
        { .block_size = GB(1)         },
        { .block_size = MB(2)         },
        { .block_size = KB(4)         }
};
#elif PAGE_GRANULE == KB(16)
static const page_level_t PL[LOOKUP_LEVELS] = {
        { .block_size = NO_BLOCK_SIZE },
        { .block_size = NO_BLOCK_SIZE },
        { .block_size = MB(32)        },
        { .block_size = KB(16)        }
};
#elif PAGE_GRANULE == KB(64)
static const page_level_t PL[LOOKUP_LEVELS] = {
        { .block_size = NOT_AVAILABLE },
        { .block_size = NO_BLOCK_SIZE },
        { .block_size = MB(512)       },
        { .block_size = KB(64)        }
};
#else
#error "not supported granule"
#endif

typedef struct PACKED page_table_entry_s {
        uint64_t valid : 1;
        uint64_t table : 1; // FALSE is block
} page_table_entry_t;

#if 0
static struct mmu_s {

} mmu SECTION("shared");
#endif

// for map complete physical memory at offset
INLINE int largest_level(int64_t bytes)
{
        for (int i = 0; i < LOOKUP_LEVELS; ++i) {
                if (PL[i].block_size > 0 && bytes % PL[i].block_size == 0) {
                        return i;
                }
        }

        return NOT_AVAILABLE;
}

void mmu_setup(int64_t bytes)
{
        const int l = largest_level(bytes); BUG_ON(l < 0);
        int64_t num_pages = bytes / PL[l].block_size;
        while (true) { }
}
