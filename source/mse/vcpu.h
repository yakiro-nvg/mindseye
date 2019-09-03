/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_VCPU_H_
#define _MSE_VCPU_H_

typedef struct vcpu_s* vcpu_t;
typedef struct vcpu_system_s* vcpu_system_t;

/** Returns which pool `vcpu` belongs to.
\return NULL means default pool. */
const char*
vcpu_pool(
  vcpu_t *vcpu
);

/** Allocates a new VCPU.
@param pool: pass NULL for default.
\return NULL if out-of-resources. */
vcpu_t
vcpu_system_take(
  vcpu_system_t sys
, void (*entry_point)()
, const char *pool
);

/// Release a VCPU.
void
vcpu_system_drop(
  vcpu_system_t sys
, vcpu_t vcpu
);

#endif // !_MSE_VCPU_H_
