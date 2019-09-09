/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_OBJECT_H_
#define _MSE_OBJECT_H_

/// Mind's Eye root class.
__attribute__((__objc_root_class__))
@interface MEObject

/// Returns the class.
+ (Class) class;

/// Returns receiver's class.
- (Class) class;

@end

#endif // !_MSE_OBJECT_H_
