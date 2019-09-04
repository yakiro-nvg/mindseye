/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include "setup.h"

#include <mse/fdt.h>
#include <mse/printk.h>

#define LOG_TAG "arm64_setup"

void arch_setup(const void *fdt)
{
  const char *name = fdt_machine_name(fdt) ? : "unknown";
  pr_info(LOG_TAG, "architecture: arm64, machine: %s", name);
  pr_fatal(LOG_TAG, "TODO");
}
