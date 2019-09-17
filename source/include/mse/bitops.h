/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_BITOPS_H_
#define _MSE_BITOPS_H_

#import <mse/prereq.h>

/// Turns `nth` bit on.
INLINE void  set_bit32     (uint32_t*   _Nonnull   u,
                            int                    nth)
{
        *u |=  ((uint32_t)1 << nth);
}

/// Turns `nth` bit off.
INLINE void  clear_bit32   (uint32_t*   _Nonnull   u,
                            int                    nth)
{
        *u &= ~((uint32_t)1 << nth);
}

/// Turns `nth` bit on.
INLINE void  set_bit64     (uint64_t*   _Nonnull   u,
                            int                    nth)
{
        *u |=  ((uint64_t)1 << nth);
}

/// Turns `nth` bit off.
INLINE void  clear_bit64   (uint64_t*   _Nonnull   u,
                            int                    nth)
{
        *u &= ~((uint64_t)1 << nth);
}

/// 32 bits, not work on zero input.
#define count_leading_zeros32 __builtin_clz
/// 64 bits, not work on zero input.
#define count_leading_zeros64 __builtin_clzll

#endif // !_MSE_BITOPS_H_
