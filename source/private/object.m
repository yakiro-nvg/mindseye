/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/object.h>

#import <mse/objcrt.h>

@implementation MEObject

- (Class)class
{
        return object_getClass(self);
}

+ (Class)class
{
        return self;
}

@end
