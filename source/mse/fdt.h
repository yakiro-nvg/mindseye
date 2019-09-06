/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_FDT_H_
#define _MSE_FDT_H_

#include <mse/prereq.h>
#include <mse/driver.h>
#include <libfdt.h>

/// Returns machine name.
const char*   fdt_machine_name  (const void             *fdt);

/// Returns node offset,
/// or negative error_t if failed.
int           fdt_chosen        (const void             *fdt,
                                 const char             *name);

/** Check for compatibles.
\return matched compatible string or NULL if failed. */
const char*   fdt_compatible    (const void             *fdt,
                                 int                     node_offset,
                                 const driver_match_t   *matches);

/** Returns next-cell value.
@param cell_size: in uint32_ts, not bytes. */
uint64_t      fdt_next_cell     (int                     cell_size,
                                 const uint32_t        **cells);

/// Returns number of CPUs,
/// or negative error_t if failed.
int           fdt_num_cpus      (const void             *fdt);

/// Returns CPU at `idx`.
int           fdt_cpu           (const void             *fdt,
                                 int                     idx);

#endif // !_MSE_FDT_H_
