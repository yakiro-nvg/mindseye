/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/printk.h>

static int null_context;

static printk_driver_context_t*
init(
  const void *fdt
, int node_offset)
{
  (void)(fdt);
  (void)(node_offset);
  return (printk_driver_context_t*)&null_context;
}

static void
putc(
  printk_driver_context_t *ctx
, const char c)
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
