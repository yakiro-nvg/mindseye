/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PAGING_H_
#define _MSE_PAGING_H_

#import <mse/prereq.h>

/// Physical address.
typedef struct paddr_s paddr_t;

/// Hypervisor virtual address.
typedef struct haddr_s haddr_t;

/// Physical page allocator.
typedef struct page_pool_s page_pool_t;

/** Marks `used_bytes` from the beginning as used.
@param dom0_bytes: number of bytes allocated to the dom0.
\return actual bytes of RAM, or negative error_t if failed. */
int64_t                page_pool_setup   (const void*   _Nonnull   fdt,
                                          int64_t                  used_bytes,
                                          int64_t                  dom0_bytes);

/** Allocates a new page for dom0.
\remarks: Protected by IRQ save spin lock.
\param bytes: number of contiguous bytes.
\param align: must be multiple of page granule.
\return NULL if out-of-memory. */
paddr_t*   _Nullable   page_pool_take    (int                      num_bytes,
                                          int                      align);

/** Returns `page` to dom0's pool.
\remarks: Protected by IRQ save spin lock.
\param bytes: must be matched with the allocation. */
void                   page_pool_drop    (paddr_t*      _Nonnull   pages,
                                          int                      num_bytes);

/** Enables memory management unit.
\remarks: Maps number of `bytes` at PAGE_VOFFSET. */
void                   mmu_setup         (int64_t                  num_bytes);

#endif // !_MSE_PAGING_H_
