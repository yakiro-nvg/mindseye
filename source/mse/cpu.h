/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_CPU_H_
#define _MSE_CPU_H_

#include <mse/prereq.h>
#include <mse/list.h>

/// CPU driver class.
typedef struct cpu_driver_class_s {
  /// Driver class name.
  const char *const class_name;
  /// CPU enable method name.
  const char *const enable_method;
  /// Initializes with flattened device tree.
  error_t (*init)(const void *fdt);
  /// Power up a CPU at `idx` using physical entry.
  error_t (*turn_on)(int idx, uint64_t entry_point);
  /** Synchronously turns off the calling CPU.
  \return it isn't expected to return if success. */
  error_t (*turn_this_off)();
} cpu_driver_class_t;

/// CPU driver node.
typedef struct cpu_driver_node_s {
  list_node_t node; // must be first
  const cpu_driver_class_t *const class;
} cpu_driver_node_t;

/// List of CPU drivers.
typedef struct cpu_driver_list_s {
  list_node_t *root;
} cpu_driver_list_t;

extern cpu_driver_list_t cpu_drivers;

#define CPU_DRIVER(class) \
  __attribute__((constructor)) static void register_cpu_driver##class() { \
    static cpu_driver_node_t node = { .class = &class }; \
    list_push_back(cpu_drivers.root, &node.node); \
  }

#define CPU_DRIVER_FOREACH(itr) \
  for (list_node_t *itr = cpu_drivers.root->next; \
       itr != cpu_drivers.root; \
       itr = itr->next)

#define CPU_DRIVER_GET(itr) \
  ((cpu_driver_node_t*)itr)->class

/// Initializes CPU sub-system.
void                        cpu_setup   (const void   *fdt);

/// Get driver for CPU at `idx`.
const cpu_driver_class_t*   cpu_driver  (int           idx);

#endif // !_MSE_CPU_H_
