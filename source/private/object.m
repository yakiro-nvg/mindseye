/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/object.h>

@implementation MEObject
{
        Class isa;
}

+ (Class) class
{
        return self;
}

- (Class) class
{
        return isa;
}

@end
