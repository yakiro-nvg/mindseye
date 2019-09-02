// Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
.global _entry
.extern entry

.section ktext, "ax"
_entry:
  ldr x0, =sstack
  mov sp, x0
  b entry
