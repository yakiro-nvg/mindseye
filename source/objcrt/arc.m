/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import "types.h"

id _Nullable objc_retain(id _Nullable obj)
{
        return [obj retain];
}

void objc_release(id _Nullable obj)
{
        [obj release];
}

id objc_storeStrong(id _Nullable* object, id _Nullable value)
{
        if (*object != value) {
                id old = *object;
                *object = objc_retain(value);
                objc_release(old);
        }
        return value;
}
