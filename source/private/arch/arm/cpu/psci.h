/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ARM_CPU_PSCI_H_
#define _MSE_ARM_CPU_PSCI_H_

#define PSCI_FN32(n)               (0x84000000 + (n))
#define PSCI_FN64(n)               (0xC4000000 + (n))

#define PSCI_FN32_PSCI_VERSION     PSCI_FN32(0)
#define PSCI_FN32_CPU_OFF          PSCI_FN32(2)
#define PSCI_FN32_CPU_ON           PSCI_FN32(3)
#define PSCI_FN32_SYSTEM_OFF       PSCI_FN32(8)
#define PSCI_FN32_SYSTEM_RESET     PSCI_FN32(9)

#define PSCI_FN64_CPU_ON           PSCI_FN64(3)

#define PSCI_VERSION_MAJOR(ver)    (((ver) & ~((1U << 16) - 1)) >> 16)
#define PSCI_VERSION_MINOR(ver)    ((ver) & ((1U << 16) - 1))

/// PSCI call result.
enum {
  PSCI_RET_SUCCESS          =  0,
  PSCI_RET_NOT_SUPPORTED    = -1,
  PSCI_RET_INVALID_PARAMS   = -2,
  PSCI_RET_DENIED           = -3,
  PSCI_RET_ALREADY_ON       = -4,
  PSCI_RET_ON_PENDING       = -5,
  PSCI_RET_INTERNAL_FAILURE = -6,
  PSCI_RET_NOT_PRESENT      = -7,
  PSCI_RET_DISABLED         = -8,
  PSCI_RET_INVALID_ADDRESS  = -9
};

#endif // !_MSE_ARM_CPU_PSCI_H_
