/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/printk.h>

static int init(printk_driver_context_t *mem, const void *fdt, int node_offset)
{
  (void)(fdt);
  (void)(node_offset);
  if (mem == NULL) return 0;
  return ERR_NONE;
}

static void putc(printk_driver_context_t *ctx, const char c)
{
  (void)(ctx);
  (void)(c);
  // nop
}

static const driver_match_t matches[] = {
  { }
};

static const printk_driver_class_t class = {
  .class_name = "printk_null"
, .matches = matches
, .init = &init
, .putc = &putc
};

PRINTK_DRIVER(class)
