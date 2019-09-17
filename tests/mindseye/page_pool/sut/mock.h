/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#import <stdint.h>
#import <stdbool.h>
#import <assert.h>
#import <mse/errno.h>

// mock prereq
#define _MSE_PREREQ_H_
#define SECTION(x)
#define INLINE static inline
#define MSE64
#define BUG_ON(exp) assert(!(exp))
#define MIN(l, r) ((l) < (r) ? (l) : (r))
void* _Nonnull align_forward(void* _Nonnull p, int align);

// mock spinlock
#define _MSE_SPINLOCK_H_
typedef uint64_t spinlock_t;
typedef uint64_t spinlock_flags_t;
#define spinlock_init(l) ((void)(l))
#define spinlock_irq_save(l, f) { (void)(l); (void)(f); }
#define spinlock_irq_restore(l, f) { (void)(l); (void)(f); }

// mock printk
#define _MSE_PRINTK_H_
#define PR_INFO(...)
#define PR_ERROR(...)
#define PR_FATAL(...)

// device tree blob
extern const char* _Nonnull dtb_path;

#ifdef __cplusplus
} // extern "C"
#endif
