/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
typedef void (*constructor_t)();
extern constructor_t sinit_array[];
extern constructor_t einit_array[];

void call_constructors()
{
        constructor_t *fn = sinit_array;
        while (fn < einit_array) {
                (*fn++)();
        }
}
