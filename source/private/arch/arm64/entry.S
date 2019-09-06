/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
.global _entry
.extern entry

.section ktext, "ax"
_entry:
        ldr x0, =sstack
        mov sp, x0
        b entry
