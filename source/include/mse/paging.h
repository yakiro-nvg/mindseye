/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PAGING_H_
#define _MSE_PAGING_H_

#import <mse/prereq.h>

/// Physical page allocator.
typedef struct page_pool_s page_pool_t;

/** Initialises page pool.
\return starting memory address or negative error_t if failed. */
size_t              page_pool_setup        (const void*   _Nonnull   fdt);

/** Marks `num` pages from the beginning as used.
\remarks: Called only one time by the primary core. */
void                page_pool_setup_mark   (int                      num);

/** Allocates a new page.
\remarks: Protected by a spin lock.
\return NULL if out-of-memory. */
void*   _Nullable   page_pool_take         ();

/** Returns `page` to pool.
\remarks: Protected by a spin lock. */
void                page_pool_drop         (void*         _Nonnull   page);

#endif // !_MSE_PAGING_H_
