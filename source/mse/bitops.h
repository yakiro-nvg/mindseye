/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_BITOPS_H_
#define _MSE_BITOPS_H_

#import <mse/prereq.h>

#ifdef MSE_ARM
#import <mse/arm/bitops.h>
#endif

/// Turns `nth` bit on.
INLINE void  set_bit     (uint32_t*   _Nonnull    u,
                          int                     nth)
{
        *u |=  (1 << nth);
}

/// Turns `nth` bit off.
INLINE void  clear_bit   (uint32_t*   _Nonnull    u,
                          int                     nth)
{
        *u &= ~(1 << nth);
}

#endif // !_MSE_BITOPS_H_
