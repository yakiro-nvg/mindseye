/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import "psci.h"

#import <mse/cpu.h>
#import <mse/driver.h>
#import <mse/fdt.h>
#import <mse/printk.h>
#import <mse/arm/psci.h>

#define LOG_TAG "cpu_psci"

typedef struct psci_cpu_driver_s {
        const char *compatible;
        uint32_t fid_cpu_on;
        uint32_t fid_cpu_off;
} psci_cpu_driver_t;
static psci_cpu_driver_t ctx;

static const driver_match_t matches[] = {
        { .compatible = "arm,psci-0.2" },
        { .compatible = "arm,psci" },
        { }
};

INLINE error_t psci_to_mse_errno(int e)
{
        switch (-e) { // for right order
        case -PSCI_RET_SUCCESS:          return ERR_NONE;
        case -PSCI_RET_NOT_SUPPORTED:    return ERR_NOTSUPPORTED;
        case -PSCI_RET_INVALID_PARAMS:   return ERR_BADARG;
        case -PSCI_RET_DENIED:           return ERR_DENIED;
        case -PSCI_RET_ALREADY_ON:       return ERR_ALREADY;
        case -PSCI_RET_ON_PENDING:       return ERR_PENDING;
        case -PSCI_RET_INTERNAL_FAILURE: return ERR_UNKNOWN;
        case -PSCI_RET_NOT_PRESENT:      return ERR_NOTPRESENT;
        case -PSCI_RET_DISABLED:         return ERR_DISABLED;
        case -PSCI_RET_INVALID_ADDRESS:  return ERR_BADARG;
        default:                         return ERR_UNKNOWN;
        }
}

INLINE uint16_t parse_fdt_fid(const void *fdt, const char *name, int psci_offset)
{
        const uint32_t *prop = fdt_getprop(fdt, psci_offset, name, NULL);
        if (prop == NULL) {
                PR_ERROR("'%s' was missing", name);
                return 0;
        } else {
                return (uint16_t)fdt_next_cell(1, &prop);
        }
}

INLINE int psci_version()
{
        return psci_smc(PSCI_FN32_PSCI_VERSION, 0, 0, 0);
}

static error_t parse_fdt(const void *fdt)
{
        const int psci = fdt_subnode_offset(fdt, 0, "psci");
        if (psci < 0) {
                PR_ERROR("'psci' was missing");
                return ERR_MALFORMED;
        }

        ctx.compatible = fdt_compatible(fdt, psci, matches);
        if (ctx.compatible == NULL) {
                PR_ERROR("incompatible PSCI version");
                return ERR_NOTSUPPORTED;
        }
        PR_INFO("compatible: %s", ctx.compatible);

        if (strcmp(ctx.compatible, "arm,psci") == 0) {
                ctx.fid_cpu_on  = parse_fdt_fid(fdt, "cpu_on",  psci);
                ctx.fid_cpu_off = parse_fdt_fid(fdt, "cpu_off", psci);
        } else {
#ifdef __aarch64__
                ctx.fid_cpu_on  = PSCI_FN64_CPU_ON;
#else
                ctx.fid_cpu_on  = PSCI_FN32_CPU_ON;
#endif
                ctx.fid_cpu_off = PSCI_FN32_CPU_OFF;
        }

        const char *method = fdt_getprop(fdt, psci, "method", NULL);
        if (method == NULL || strcmp(method, "smc") != 0) {
                PR_ERROR("this is hypervisor so method must be 'smc'");
                return ERR_NOTSUPPORTED;
        }
        return ERR_NONE;
}

static error_t init_0_2()
{
        const int ver = psci_version();
        if (ver < PSCI_RET_NOT_SUPPORTED) {
                PR_ERROR("firmware does not comply with the v0.2 spec");
                return ERR_NOTSUPPORTED;
        }
        const int major = PSCI_VERSION_MAJOR(ver);
        const int minor = PSCI_VERSION_MINOR(ver);
        PR_INFO("firmware version: v%d.%d", major, minor);
        if (major == 0 && minor < 2) {
                PR_ERROR("conflicting PSCI version detected");
                return ERR_INVALID;
        }
        return ERR_NONE;
}

static error_t psci_init(const void *fdt)
{
        error_t ec = parse_fdt(fdt);
        if (ec < 0) {
                return ec;
        }
        if (strcmp(ctx.compatible, "arm,psci-0.2") == 0) {
                ec = init_0_2();
        }
        PR_INFO("fid_cpu_on:  0x%x", ctx.fid_cpu_on);
        PR_INFO("fid_cpu_off: 0x%x", ctx.fid_cpu_off);
        return ec;
}

static error_t psci_cpu_on(int idx, uint64_t entry_point)
{
        if (ctx.fid_cpu_on == 0) {
                return ERR_NOTSUPPORTED;
        }
        const int ec = psci_smc(ctx.fid_cpu_on, idx, entry_point, 0);
        return psci_to_mse_errno(ec);
}

static error_t psci_cpu_off()
{
        if (ctx.fid_cpu_off == 0) {
                return ERR_NOTSUPPORTED;
        }
        const int ec = psci_smc(ctx.fid_cpu_off, 0, 0, 0);
        return psci_to_mse_errno(ec);
}

static const cpu_driver_class_t class = {
        .class_name    = "cpu_psci",
        .enable_method = "psci",
        .init          = &psci_init,
        .turn_on       = &psci_cpu_on,
        .turn_this_off = &psci_cpu_off
};

CPU_DRIVER(class)
