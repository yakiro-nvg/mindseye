/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PRINTK_H_
#define _MSE_PRINTK_H_

#include <mse/list.h>
#include <mse/driver.h>
#include <stddef.h>

/// Print-K driver context.
typedef void printk_driver_context_t;

/// Print-K driver class.
typedef struct printk_driver_class_s {
  /// Driver class name.
  const char *const class_name;
  /// List of compatible devices.
  const driver_match_t *const matches;
  /// Returns context or NULL if failed.
  printk_driver_context_t *(*init)(const void *fdt, int node_offset);
  /// Put a single character.
  void (*putc)(printk_driver_context_t *ctx, const char c);
} printk_driver_class_t;

/// Print-K driver node.
typedef struct printk_driver_node_s {
  list_node_t node; // must be first
  const printk_driver_class_t *const class;
} printk_driver_node_t;

/// List of Print-K drivers.
typedef struct printk_driver_list_s {
  list_node_t *root;
} printk_driver_list_t;

extern printk_driver_list_t printk_drivers;

#define PRINTK_DRIVER(class) \
  __attribute__((constructor)) static void register_printk_driver##class() { \
    static printk_driver_node_t node = { .class = &class }; \
    list_push_back(printk_drivers.root, &node.node); \
  }

#define PRINTK_DRIVER_FOREACH(itr) \
  for (list_node_t *itr = printk_drivers.root->next; \
       itr != printk_drivers.root; \
       itr = itr->next)

#define PRINTK_DRIVER_GET(itr) \
  ((printk_driver_node_t*)itr)->class

/** Initializes with chosen.stdout-path.
@param fdt: flattened device tree blob address. */
void
printk_setup(
  const void *fdt
);

#endif // !_MSE_PRINTK_H_
