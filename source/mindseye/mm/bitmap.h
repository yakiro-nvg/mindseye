/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_MM_BITMAP_H_
#define _MSE_MM_BITMAP_H_

#import <mse/prereq.h>

#import <mse/bitops.h>

#ifdef MSE32
typedef uint32_t bitmap_t;
#define count_leading_zeros count_leading_zeros32
#define clear_bit clear_bit32
#define set_bit set_bit32
#elif defined(MSE64)
typedef uint64_t bitmap_t;
#define count_leading_zeros count_leading_zeros64
#define clear_bit clear_bit64
#define set_bit set_bit64
#else
#error "not implemented"
#endif

enum { BITMAP_BITS = sizeof(bitmap_t)*8 };

#endif // !_MSE_MM_BITMAP_H_
