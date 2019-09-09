/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJCRT_H_
#define _MSE_OBJCRT_H_

#include <mse/prereq.h>

/// Dynamic selector.
typedef struct dynamic_sel_s {
        const void *_;
} dynamic_sel_t;

/// Checks whether two selectors are equal.
bool           sel_isEqual   (SEL                lhs,
                              SEL                rhs);
/// Returns method name of `sel`.
const char*    sel_getName   (SEL                sel);

/** Borrow a dynamic selector from method.
\remarks Valid until the original string is freed. */
void           sel_borrow    (dynamic_sel_t     *dysel,
                              const char        *method);

/// Cast to SEL, with the same life-cycle.
INLINE SEL     sel_dynamic   (dynamic_sel_t     *dysel)
{
        return (SEL)dysel;
}

#endif // !_MSE_OBJCRT_H_
