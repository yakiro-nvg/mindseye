/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_CPU_H_
#define _MSE_CPU_H_

#import <mse/prereq.h>
#import <mse/list.h>

/* TODO: rewrite this with objc. */

/// CPU driver class.
typedef struct cpu_driver_class_s {
        /// Driver class name.
        const char* _Nonnull const class_name;
        /// CPU enable method name.
        const char* _Nonnull const enable_method;
        /// Initializes with flattened device tree.
        error_t (* _Nonnull init)(const void* _Nonnull fdt);
        /// Power up a CPU at `idx` using physical entry.
        error_t (* _Nonnull turn_on)(int idx, uint64_t entry_point);
        /** Synchronously turns off the calling CPU.
        \return it is not expected to return if success. */
        error_t (* _Nonnull turn_this_off)();
} cpu_driver_class_t;

/// CPU driver node.
typedef struct cpu_driver_node_s {
        list_node_t node; // must be first
        const cpu_driver_class_t* _Nonnull const class;
} cpu_driver_node_t;

/// List of CPU drivers.
typedef struct cpu_driver_list_s {
        list_node_t* _Nonnull root;
} cpu_driver_list_t;

extern cpu_driver_list_t cpu_drivers;

#define CPU_DRIVER(class) \
        CONSTRUCTOR static void register_cpu_driver##class() { \
                static cpu_driver_node_t node = { .class = &class }; \
                list_push_back(cpu_drivers.root, &node.node); \
        }

#define CPU_DRIVER_FOREACH(itr) \
        for (list_node_t *itr = cpu_drivers.root->next; \
                itr != cpu_drivers.root; \
                itr = itr->next)

#define CPU_DRIVER_GET(itr) ((cpu_driver_node_t*)itr)->class

/// Initializes CPU sub-system.
void                                   cpu_setup   (const void*   _Nonnull   fdt);

/// Get driver for CPU at `idx`.
const cpu_driver_class_t*   _Nullable  cpu_driver  (int                      idx);

#endif // !_MSE_CPU_H_
