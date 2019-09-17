/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_MMIO_H_
#define _MSE_MMIO_H_

#import <mse/prereq.h>

/// 32 bits memory mapped register write.
INLINE void      mmio_write32  (uint64_t  base_address,
                                int       register_offset,
                                uint32_t  value)
{
        *((volatile uint32_t*)base_address + register_offset) = value;
}

/// 32 bits memory mapped register read.
INLINE uint32_t  mmio_read32   (uint64_t  base_address,
                                int       register_offset)
{
        return *((volatile uint32_t*)base_address + register_offset);
}

#endif // !_MSE_MMIO_H_
