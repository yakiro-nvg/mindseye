/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
.global early_ptbl_setup

#include <config.h>

#define SUB_TO_PHYSICAL x3
#define MAP_ADDRESS     x4
#define IS_IDENTICAL    x5
#define PTBL_BASE       x6
#define L0_PTBL_ENTRY   x7
#define L1_PTBL_ENTRY   x8
#define L2_PTBL_ENTRY   x9

// map 1st 4MB of RAM as R/W/E, it will be replaced later anyway,
// assume that these blocks is placed on the same L1 page (obviously?)
early_ptbl_setup:
        // physical offset
        ldr  x0, =BASE_OFFSET
        ldr  SUB_TO_PHYSICAL, =s_mindseye
        sub  SUB_TO_PHYSICAL, SUB_TO_PHYSICAL, x0

        // page table entry index
        ldr  MAP_ADDRESS, =s_mindseye
        ldr  PTBL_BASE, =s_early_ptbl
        sub  PTBL_BASE, PTBL_BASE, SUB_TO_PHYSICAL
        mov  IS_IDENTICAL, #0

loop:
        and  x0, MAP_ADDRESS, 0xff8000000000
        lsr  L0_PTBL_ENTRY, x0, #39
        and  x0, MAP_ADDRESS, 0x7fc0000000
        lsr  L1_PTBL_ENTRY, x0, #30
        and  x0, MAP_ADDRESS, 0x3fe00000
        lsr  L2_PTBL_ENTRY, x0, #21

        // map index to address
        mov  x0, #8 // size of page table entry
        mov  x1, PTBL_BASE
        madd L0_PTBL_ENTRY, L0_PTBL_ENTRY, x0, x1

        mov  x1, #0x2000
        mul  x1, x1, IS_IDENTICAL
        add  x1, x1, PTBL_BASE
        add  x1, x1, #0x1000 // PTBL[IS_IDENTICAL*2 + 1]
        madd L1_PTBL_ENTRY, L1_PTBL_ENTRY, x0, x1

        mov  x1, #0x2000
        mul  x1, x1, IS_IDENTICAL
        add  x1, x1, PTBL_BASE
        add  x1, x1, #0x2000 // PTBL[IS_IDENTICAL*2 + 2]
        madd L2_PTBL_ENTRY, L2_PTBL_ENTRY, x0, x1

        // write L0 & L1
        mov  x1, #0x2000
        mul  x1, x1, IS_IDENTICAL
        add  x1, x1, PTBL_BASE
        add  x1, x1, #0x1000 // PTBL[IS_IDENTICAL*2 + 1]
        mov  x0, #0x403
        orr  x0, x0, x1
        str  x0, [L0_PTBL_ENTRY]

        mov  x1, #0x2000
        mul  x1, x1, IS_IDENTICAL
        add  x1, x1, PTBL_BASE
        add  x1, x1, #0x2000 // PTBL[IS_IDENTICAL*2 + 2]
        mov  x0, #0x403
        orr  x0, x0, x1
        str  x0, [L1_PTBL_ENTRY]

        // write L2
        mov  x0, #0x401
        ldr  x1, =s_mindseye
        sub  x1, x1, SUB_TO_PHYSICAL
        orr  x1, x0, x1
        str  x1, [L2_PTBL_ENTRY]
        add  x1, x1, #0x200000
        orr  x1, x0, x1
        str  x1, [L2_PTBL_ENTRY, #8]

        // setup for identical too
        add  IS_IDENTICAL, IS_IDENTICAL, #1
        sub  MAP_ADDRESS, MAP_ADDRESS, SUB_TO_PHYSICAL
        cmp  IS_IDENTICAL, #1
        b.eq loop

        // attribute table
        mov  x0, #0xff // idx 0 only
        msr  mair_el2, x0

        // page table address
        ldr  x0, =s_early_ptbl
        sub  x0, x0, SUB_TO_PHYSICAL
        msr  ttbr0_el2, x0

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

        // return to upper
        add  x30, x30, SUB_TO_PHYSICAL
        ret
