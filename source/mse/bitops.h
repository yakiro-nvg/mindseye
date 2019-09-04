
/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_BITOPS_H_
#define _MSE_BITOPS_H_

#include <stdint.h>

#ifdef MSE_ARM
#include <mse/arm/bitops.h>
#endif

/// Turns `nth` bit on.
static inline void  set_bit   (uint32_t *u,
                               int       nth)
{
  *u |=  (1 << nth);
}

/// Turns `nth` bit off.
static inline void  clear_bit (uint32_t *u,
                               int       nth)
{
  *u &= ~(1 << nth);
}

#endif // !_MSE_BITOPS_H_
