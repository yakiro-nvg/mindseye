/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ERRNO_H_
#define _MSE_ERRNO_H_

/// Error codes.
typedef enum {
        ERR_NONE         =  0,
        ERR_UNKNOWN      = -1,
        ERR_MALFORMED    = -2,
        ERR_NOTFOUND     = -3,
        ERR_NOTSUPPORTED = -4,
        ERR_EXISTS       = -5,
        ERR_NOMEM        = -6,
        ERR_BADARG       = -7,
        ERR_INVALID      = -8,
        ERR_ALREADY      = -9,
        ERR_DENIED       = -10,
        ERR_PENDING      = -11,
        ERR_NOTPRESENT   = -12,
        ERR_DISABLED     = -13
} error_t;

/// Returns human readable error.
const char* _Nonnull error_name(error_t ec);

#endif // !_MSE_ERRNO_H_
