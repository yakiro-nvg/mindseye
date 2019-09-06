/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ASM_ARM_BITOPS_H_
#define _MSE_ASM_ARM_BITOPS_H_

#include <mse/prereq.h>

/// Returns number of leading zero bits.
INLINE int count_leading_zeros(uint32_t u)
{
        uint32_t v;
        asm volatile ("clz %0, %1" : "=r" (v) : "r" (u));
        return (int)v;
}

#endif // !_MSE_ASM_ARM_BITOPS_H_
