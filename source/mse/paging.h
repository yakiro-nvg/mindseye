/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PAGING_H_
#define _MSE_PAGING_H_

#import <mse/prereq.h>

/// Physical page allocator.
typedef struct page_pool_s {
        uint8_t*    _Nullable   pages;
        uint32_t*   _Nullable   bitmap;
        int                     num_bitmap;
} page_pool_t;

/** Setups a new page pool.
@param pages: must be aligned on PAGE_SIZE.
@param bitmap: number of bitmap = capacity / 32 (bits). */
void                page_pool_setup   (page_pool_t*   _Nonnull   pool,
                                       uint8_t*       _Nonnull   pages,
                                       uint32_t*      _Nonnull   bitmap,
                                       int                       capacity);

/** Allocates a new page.
\return NULL if out-of-memory. */
void*   _Nullable   page_pool_take    (page_pool_t*   _Nonnull   pool);

/// Returns `page` to pool.
void                page_pool_drop    (page_pool_t*   _Nonnull   pool,
                                       void*          _Nonnull   page);

#endif // !_MSE_PAGING_H_
