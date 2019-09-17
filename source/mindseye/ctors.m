/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
typedef void (*constructor_t)();
extern const constructor_t s_init_array[];
extern const constructor_t e_init_array[];

void call_constructors()
{
        const constructor_t *fn = s_init_array;
        while (fn < e_init_array) {
                (*fn++)();
        }
}
