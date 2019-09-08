/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
typedef void (*constructor_t)();
extern const constructor_t sinit_array[];
extern const constructor_t einit_array[];

void call_constructors()
{
        const constructor_t *fn = sinit_array;
        while (fn < einit_array) {
                (*fn++)();
        }
}
