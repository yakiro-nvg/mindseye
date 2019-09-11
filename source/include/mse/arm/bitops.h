/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ASM_ARM_BITOPS_H_
#define _MSE_ASM_ARM_BITOPS_H_

#import <mse/prereq.h>

/// Returns number of leading zero bits.
INLINE int count_leading_zeros32(uint32_t u)
{
        uint32_t v;
        __asm volatile ("clz %w0, %w1" : "=r" (v) : "r" (u));
        return (int)v;
}

#ifdef __aarch64__

/// Returns number of leading zero bits.
INLINE int count_leading_zeros64(uint64_t u)
{
        uint64_t v;
        __asm volatile ("clz %x0, %x1" : "=r" (v) : "r" (u));
        return (int)v;
}

#endif

#endif // !_MSE_ASM_ARM_BITOPS_H_
