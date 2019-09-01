.global _entry
.extern entry

.section ktext, "ax"
_entry:
  ldr x0, =sstack
  mov sp, x0
  b entry
