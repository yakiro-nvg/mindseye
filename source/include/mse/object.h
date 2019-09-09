/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJECT_H_
#define _MSE_OBJECT_H_

#include <mse/prereq.h>

/// Root protocol.
@protocol MEObject

/// Increases the retain count.
- (instancetype)retain;

/// Decreases the retain count.
- (void)release;

@end

/// Root class.
ROOT_CLASS @interface MEObject <MEObject>
{
@private
        Class isa;
}

@end

#endif // !_MSE_OBJECT_H_
