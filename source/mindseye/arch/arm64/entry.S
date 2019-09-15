/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
.extern centry
.extern early_ptbl_setup

.section ktext, "ax"
entry:
        bl early_ptbl_setup
        ldr x0, =s_stack
        mov sp, x0
        b centry
