/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PAGING_H_
#define _MSE_PAGING_H_

#import <mse/prereq.h>

/// Physical page allocator.
typedef struct page_pool_s page_pool_t;
/// Page table entry allocator.
typedef struct pate_pool_s pate_pool_t;

/** Initialises page pool.
\return starting memory address or negative error_t if failed. */
size_t                  page_pool_setup        (const void*   _Nonnull   fdt);

/** Marks `used_bytes` from the beginning as used.
@param reserve: number of bytes allocated to the dom0.
\remarks: Called only one time by the primary core. */
void                    page_pool_setup_mark   (uint64_t                 used_bytes,
                                                uint64_t                 reserved_bytes);

/** Allocates a new page.
\remarks: Protected by IRQ save spin lock.
\return NULL if out-of-memory. */
void*   _Nullable       page_pool_take         ();

/** Returns `page` to pool.
\remarks: Protected by IRQ save spin lock. */
void                    page_pool_drop         (void*         _Nonnull   page);

/** Allocates a new page table entry.
\remarks: Protected by IRQ save spin lock.
\return NULL if out-of-memory, . */
uint64_t*   _Nullable   pate_pool_take         ();

/** Returns `entry` to pool.
\remarks: Protected by IRQ save spin lock. */
void                    pate_pool_drop         (void*         _Nonnull   entry);

#endif // !_MSE_PAGING_H_
