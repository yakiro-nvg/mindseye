/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PRINTK_H_
#define _MSE_PRINTK_H_

#import <mse/prereq.h>
#import <mse/list.h>
#import <mse/driver.h>

/* TODO: rewrite this with objc. */

/// Print-K driver context.
typedef void printk_driver_context_t;

/// Print-K driver class.
typedef struct printk_driver_class_s {
        /// Driver class name.
        const char* _Nonnull const class_name;
        /// List of compatible devices.
        const driver_match_t* _Nonnull const matches;
        /** Initializes with a context memory region.
        @param mem: pass `NULL` to get number of bytes required.
        \return error_t or number of bytes required. */
        int (* _Nonnull init)(printk_driver_context_t* _Nullable mem,
                const char* _Nonnull compatible, const void* _Nullable fdt, int node_offset);
        /// Put a single character.
        void (* _Nonnull putc)(printk_driver_context_t* _Nonnull ctx, const char c);
} printk_driver_class_t;

/// Print-K driver node.
typedef struct printk_driver_node_s {
        list_node_t node; // must be first
        const printk_driver_class_t* _Nonnull const class;
} printk_driver_node_t;

/// List of Print-K drivers.
typedef struct printk_driver_list_s {
        list_node_t* _Nonnull root;
} printk_driver_list_t;

extern printk_driver_list_t printk_drivers;

#define PRINTK_DRIVER(class) \
        CONSTRUCTOR static void register_printk_driver##class() { \
                static printk_driver_node_t node = { .class = &class }; \
                list_push_back(printk_drivers.root, &node.node); \
        }

#define PRINTK_DRIVER_FOREACH(itr) \
        for (list_node_t *itr = printk_drivers.root->next; \
                itr != printk_drivers.root; \
                itr = itr->next)

#define PRINTK_DRIVER_GET(itr) ((printk_driver_node_t*)itr)->class

/// Initializes with chosen.stdout-path.
void   printk_setup   (const void*    _Nonnull   fdt);

/// Print information message.
void   pr_info        (const char*    _Nonnull   log_tag,
                       const char*    _Nonnull   format,
                       ...);

/// Print warning message.
void   pr_warning     (const char*    _Nonnull   log_tag,
                       const char*    _Nonnull   format,
                       ...);

/// Print error message.
void   pr_error       (const char*    _Nonnull   log_tag,
                       const char*    _Nonnull   format,
                       ...);

/// Rest in peace.
void   pr_fatal       (const char*    _Nonnull   log_tag,
                       const char*    _Nonnull   format,
                       ...);

#define PR_INFO(...)    pr_info(LOG_TAG, __VA_ARGS__)
#define PR_WARNING(...) pr_warning(LOG_TAG, __VA_ARGS__)
#define PR_ERROR(...)   pr_error(LOG_TAG, __VA_ARGS__)
#define PR_FATAL(...)   pr_fatal(LOG_TAG, __VA_ARGS__)

#endif // !_MSE_PRINTK_H_
