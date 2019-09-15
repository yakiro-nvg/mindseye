/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
.global early_ptbl_setup

#include <config.h>

#define SUB_TO_PHYSICAL x4
#define L0_PTBL_ENTRY   x5
#define L1_PTBL_ENTRY   x6
#define L2_PTBL_ENTRY   x7

// map 1st 2MB of RAM as R/W/E,
// it will be replaced later anyway
early_ptbl_setup:
        // physical offset
        ldr  x0, =LOAD_OFFSET
        ldr  SUB_TO_PHYSICAL, =s_mindseye
        sub  SUB_TO_PHYSICAL, SUB_TO_PHYSICAL, x0

        // page table entry index
        ldr  x1, =s_mindseye
        and  x0, x1, 0xff8000000000
        lsr  L0_PTBL_ENTRY, x0, #39
        and  x0, x1, 0x7fc0000000
        lsr  L1_PTBL_ENTRY, x0, #30
        and  x0, x1, 0x3fe00000
        lsr  L2_PTBL_ENTRY, x0, #21

        // map index to address
        mov  x0, #8 // size of page table entry
        ldr  x1, =s_early_ptbl
        sub  x1, x1, SUB_TO_PHYSICAL
        madd L0_PTBL_ENTRY, L0_PTBL_ENTRY, x0, x1
        add  x1, x1, #0x1000 // L1 page table
        madd L1_PTBL_ENTRY, L1_PTBL_ENTRY, x0, x1
        add  x1, x1, #0x1000 // L2 page table
        madd L2_PTBL_ENTRY, L2_PTBL_ENTRY, x0, x1

        // write L0 & L1
        ldr  x1, =s_early_ptbl
        sub  x1, x1, SUB_TO_PHYSICAL
        add  x1, x1, #0x1000 // L1 table
        lsl  x0, x1, #12 // address
        orr  x0, x0, #3  // is page table
        str  x0, [L0_PTBL_ENTRY]
        add  x1, x1, #0x1000 // L2 table
        lsl  x0, x1, #12 // address
        orr  x0, x0, #3  // is page table
        str  x0, [L1_PTBL_ENTRY]

        // write L2
        ldr  x1, =s_mindseye
        sub  x1, x1, SUB_TO_PHYSICAL
        lsl  x0, x1, #21 // address
        orr  x0, x0, #1  // is block
        str  x0, [L2_PTBL_ENTRY]

        // attribute table
        mov  x0, #0xff // idx 0 only
        msr  mair_el2, x0

        // page table address
        ldr  x0, =s_early_ptbl
        sub  x0, x0, SUB_TO_PHYSICAL
        lsl  x0, x0, #1
        mov  x0, #0
        msr  ttbr0_el2, x0
        msr  ttbr1_el2, x0

        // 16 bits T0SZ, 4KB granule,
        // write back & r/w allocate,
        // non-shareable, 36 bits address,
        // top bytes used (no tagging).
        ldr  x0, =0x80810510
        msr  tcr_el2, x0
        isb

        // enable MMU
        ldr  x0, =0x30850031
        msr  sctlr_el2, x0
        isb

        b .

        ldr  x1, =0xfff000008000
        ldr  x0, [x1]

        ret
