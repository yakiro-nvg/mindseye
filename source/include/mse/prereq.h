/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_PREREQ_H_
#define _MSE_PREREQ_H_

#import <stdint.h>
#import <stdbool.h>
#import <stddef.h>
#import <mse/errno.h>

#define INLINE static inline
#define UNUSED(x) (void)(x)
#define CONSTRUCTOR __attribute__((constructor))
#define ROOT_CLASS __attribute__((__objc_root_class__))
#define ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#define ASSUME_NONNULL_END _Pragma("clang assume_nonnull end")

#if   UINTPTR_MAX == 0xffffffff
#define MSE32
#elif UINTPTR_MAX == 0xffffffffffffffff
#define MSE64
#else
#error "unknown architecture"
#endif

#define YES true
#define NO false
typedef bool BOOL;

typedef struct objc_class_s* Class;
typedef struct objc_object_s* id;
typedef const struct objc_selector_s* SEL;

#define Nil (Class)0
#define nil (id)0

INLINE void* align_forward(void* p, int align)
{
    const uintptr_t pi = (uintptr_t)p;
    const int mod = pi % align;
    return mod == 0 ? (void*)pi : (void*)(pi + align - mod);
}

#endif // !_MSE_PREREQ_H_
