/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_VENDOR_STRING_H_
#define _MSE_VENDOR_STRING_H_

#include <stddef.h>

void*           memchr          (const void    *s,
                                 int            c,
                                 size_t         n);

int             memcmp          (const void    *ptr1,
                                 const void    *ptr2,
                                 size_t         num);

void*           memcpy          (void          *destination,
                                 const void    *source,
                                 size_t         num);

void*           memmove         (void          *destination,
                                 const void    *source,
                                 size_t         num);

void*           memset          (void          *ptr,
                                 int            value,
                                 size_t         num);

int             strcmp          (const char    *str1,
                                 const char    *str2);

size_t          strlen          (const char    *str);

size_t          strnlen         (const char    *s,
                                 size_t         maxlen);

const char*     strrchr         (const char    *str,
                                 int            character);

#endif // _MSE_VENDOR_STRING_H_
