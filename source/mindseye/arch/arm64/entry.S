/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
.global entry
.extern mindseye
.extern early_ptbl_setup

#include <config.h>

.section ktext, "ax"
entry:
        bl early_ptbl_setup
        ldr x0, =s_stack
        mov sp, x0
        ldr x0, =PAGE_VOFFSET
        bl mindseye
        b .
