/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJECT_H_
#define _MSE_OBJECT_H_

#include <mse/prereq.h>

/// Mind's Eye root class.
ROOT_CLASS @interface MEObject
{
@private
        Class isa;
}

/// Returns the class object.
+ (Class)class;

@end

#endif // !_MSE_OBJECT_H_
