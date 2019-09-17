/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import "mock.h"
#import "config.h"
#import <memory>

void* PAGE_VOFFSET = NULL;

void* align_forward(void* p, int align)
{
        size_t space;
        std::align(align, UINT64_MAX, p, space);
        return p;
}

const char *dtb_path = DTB_PATH;
