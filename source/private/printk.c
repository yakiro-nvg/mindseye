/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/printk.h>

#include <string.h>
#include <mse/fdt.h>

static list_node_t root = {
  .next = &root
, .prev = &root
};

printk_driver_list_t printk_drivers = {
  .root = &root
};

static printk_driver_context_t *ctx = NULL;
static const printk_driver_class_t *class = NULL;

void
_putchar(
  char c)
{
  class->putc(ctx, c);
}

void
printk_setup(
  const void *fdt)
{
  int stdout = fdt_chosen(fdt, "stdout-path");
  if (stdout >= 0) {
    PRINTK_DRIVER_FOREACH(itr) {
      class = PRINTK_DRIVER_GET(itr);
      if (fdt_compatible(fdt, stdout, class->matches)) {
        ctx = class->init(fdt, stdout);
        if (ctx != NULL) return; // matched
      }
    }
  }

  // fall-back to NULL driver
  PRINTK_DRIVER_FOREACH(itr) {
    class = PRINTK_DRIVER_GET(itr);
    if (strcmp(class->class_name, "printk_null") == 0) {
      ctx = class->init(NULL, 0);
      break;
    }
  }
}
