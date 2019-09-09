/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_FDT_H_
#define _MSE_FDT_H_

#import <mse/prereq.h>
#import <mse/driver.h>
#import <libfdt.h>

/// Returns machine name.
const char*   _Nonnull      fdt_machine_name   (const void*             _Nonnull    fdt);

/// Returns node offset,
/// or negative error_t if failed.
int                         fdt_chosen         (const void*             _Nonnull    fdt,
                                                const char*             _Nonnull    name);

/** Check for compatibles.
\return matched compatible string or NULL if failed. */
const char*   _Nullable     fdt_compatible     (const void*             _Nonnull    fdt,
                                                int                                 node_offset,
                                                const driver_match_t*   _Nonnull    matches);

/** Returns next-cell value.
@param cell_size: in uint32_ts, not bytes. */
uint64_t                    fdt_next_cell      (int                                 cell_size,
                                                const uint32_t*         _Nonnull
                                                              *         _Nonnull    cells);

/// Returns number of CPUs,
/// or negative error_t if failed.
int                         fdt_num_cpus       (const void*             _Nonnull    fdt);

/// Returns CPU at `idx`.
int                         fdt_cpu            (const void*             _Nonnull    fdt,
                                                int                                 idx);

#endif // !_MSE_FDT_H_
