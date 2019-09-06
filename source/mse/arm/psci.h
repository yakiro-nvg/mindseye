/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ASM_ARM_PSCI_H_
#define _MSE_ASM_ARM_PSCI_H_

#include <mse/prereq.h>

/// Secure monitor call for PSCI.
int psci_smc(uint64_t fid,
             uint64_t arg0,
             uint64_t arg1,
             uint64_t arg2);

#endif // !_MSE_ASM_ARM_PSCI_H_
