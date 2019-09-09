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

#define YES true
#define NO false
typedef bool BOOL;

typedef struct objc_class_s* Class;
typedef struct objc_object_s* id;
typedef const struct objc_selector_s* SEL;

#define Nil (Class)0
#define nil (id)0

#endif // !_MSE_PREREQ_H_
