/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/printk.h>

static int printk_null_init(
  printk_driver_context_t *mem,
  const char *compatible, const void *fdt, int node_offset)
{
        UNUSED(compatible);
        UNUSED(fdt);
        UNUSED(node_offset);
        if (mem == NULL) {
                return 0;
        }
        return ERR_NONE;
}

static void printk_null_putc(printk_driver_context_t *ctx, const char c)
{
        UNUSED(ctx);
        UNUSED(c);
        // nop
}

static const driver_match_t matches[] = {
        { }
};

static const printk_driver_class_t class = {
        .class_name = "printk_null",
        .matches    = matches,
        .init       = &printk_null_init,
        .putc       = &printk_null_putc
};

PRINTK_DRIVER(class)
