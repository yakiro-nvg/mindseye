/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_BUMP_H_
#define _MSE_BUMP_H_

#include <stddef.h>

/// Allocates `sz` bytes.
void*
bump_malloc(
  size_t sz
);

#endif // !_MSE_BUMP_H_
