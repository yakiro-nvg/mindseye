/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include "setup.h"

#include <mse/fdt.h>
#include <printf.h>

void
arch_setup(
  const void *fdt)
{
  const char *name = fdt_machine_name(fdt) ? : "unknown";
  printf("Architecture: arm64, machine: %s\n", name);
  while (1);
}
