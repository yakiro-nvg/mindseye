/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJCRT_H_
#define _MSE_OBJCRT_H_

#include <mse/prereq.h>

/// Checks whether two selectors are equal.
BOOL                     sel_isEqual      (SEL   _Nonnull    lhs,
                                           SEL   _Nonnull    rhs);
/// Returns method name of `sel`.
const char*  _Nonnull    sel_getName      (SEL   _Nonnull    sel);

/// Returns the class of an object.
Class        _Nullable   object_getClass  (id    _Nullable   obj);

#endif // !_MSE_OBJCRT_H_
