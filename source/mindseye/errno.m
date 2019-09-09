/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/errno.h>

const char* error_name(error_t ec)
{
        switch (-ec) { // for right order
        case -ERR_NONE:         return "success";
        case -ERR_UNKNOWN:      return "unknown";
        case -ERR_MALFORMED:    return "malformed";
        case -ERR_NOTFOUND:     return "not found";
        case -ERR_NOTSUPPORTED: return "not supported";
        case -ERR_EXISTS:       return "exists";
        case -ERR_NOMEM:        return "no memory";
        case -ERR_BADARG:       return "bad argument";
        case -ERR_INVALID:      return "invalid";
        case -ERR_ALREADY:      return "already";
        case -ERR_DENIED:       return "denined";
        case -ERR_PENDING:      return "pending";
        case -ERR_NOTPRESENT:   return "not present";
        case -ERR_DISABLED:     return "disabled";
        default:                return "<not error_t>";
        }
}
