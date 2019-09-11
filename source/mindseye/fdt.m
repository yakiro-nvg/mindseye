/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#import <mse/fdt.h>

#import <endianness.h>
#import <mse/printk.h>

#define LOG_TAG "fdt"

static error_t fdt_to_mse_errno(int e)
{
        if (e >= 0) {
                return e;
        }

        switch (-e) { // fdt error is negative
        case FDT_ERR_NOTFOUND:      return ERR_NOTFOUND;
        case FDT_ERR_EXISTS:        return ERR_EXISTS;
        case FDT_ERR_NOSPACE:       return ERR_NOMEM;
        case FDT_ERR_BADOFFSET:     return ERR_BADARG;
        case FDT_ERR_BADPATH:       return ERR_BADARG;
        case FDT_ERR_BADPHANDLE:    return ERR_BADARG;
        case FDT_ERR_BADSTATE:      return ERR_MALFORMED;
        case FDT_ERR_TRUNCATED:     return ERR_MALFORMED;
        case FDT_ERR_BADMAGIC:      return ERR_MALFORMED;
        case FDT_ERR_BADVERSION:    return ERR_NOTSUPPORTED;
        case FDT_ERR_BADSTRUCTURE:  return ERR_MALFORMED;
        case FDT_ERR_BADLAYOUT:     return ERR_MALFORMED;
        case FDT_ERR_BADNCELLS:     return ERR_MALFORMED;
        case FDT_ERR_BADVALUE:      return ERR_MALFORMED;
        case FDT_ERR_BADOVERLAY:    return ERR_MALFORMED;
        case FDT_ERR_NOPHANDLES:    return ERR_NOTFOUND;
        default:                    return ERR_UNKNOWN;
        }
}

const char* fdt_machine_name(const void *fdt)
{
        const char *name = fdt_getprop(fdt, 0, "model", NULL);
        if (name == NULL) { // not found, use "compatible"
                name = fdt_getprop(fdt, 0, "compatible", NULL);
        }
        return name;
}

int fdt_chosen(const void *fdt, const char *name)
{
        const int chosen = fdt_subnode_offset(fdt, 0, "chosen");
        if (chosen < 0) {
                return chosen;
        }
        const char *path = fdt_getprop(fdt, chosen, name, NULL);
        if (path == NULL) {
                return ERR_NOTFOUND;
        }
        return fdt_to_mse_errno(fdt_path_offset(fdt, path));
}

const char* fdt_compatible(
        const void *fdt, int node_offset, const driver_match_t *matches)
{
        int cplen;
        const char *cp = fdt_getprop(fdt, node_offset, "compatible", &cplen);
        if (cp == NULL) {
                return NULL;
        }
        while (cplen > 0) {
                for (int i = 0; matches[i].compatible; ++i) {
                        if (strcmp(matches[i].compatible, cp) == 0) {
                                return matches[i].compatible;
                        }
                }
                int l = strlen(cp) + 1;
                cp += l; cplen -= l; // next compatible
        }
        return NULL;
}

uint64_t fdt_next_cell(int cell_size, const uint32_t **cells)
{
        const uint32_t *p = *cells;
        *cells = p + cell_size;
        uint64_t r = 0;
        for (; cell_size--; p++) {
                r = (r << 32) | end_net2host32(*p);
        }
        return r;
}

int fdt_num_cpus(const void *fdt)
{
        const int cpus = fdt_subnode_offset(fdt, 0, "cpus");
        if (cpus < 0) {
                return ERR_MALFORMED;
        }
        int cpu_idx = 0, cpu_off = fdt_first_subnode(fdt, cpus);
        while (cpu_off != -FDT_ERR_NOTFOUND) {
                cpu_off = fdt_next_subnode(fdt, cpu_off);
                ++cpu_idx;
        }
        return cpu_idx;
}

int fdt_cpu(const void *fdt, int idx)
{
        const int cpus = fdt_subnode_offset(fdt, 0, "cpus");
        int cpu_idx = 0, cpu_off = fdt_first_subnode(fdt, cpus);
        while (cpu_off != -FDT_ERR_NOTFOUND) {
                if (cpu_idx == idx) {
                        return cpu_off;
                }
                cpu_off = fdt_next_subnode(fdt, cpu_off);
                ++cpu_idx;
        }
        PR_FATAL("no CPU at %d", idx);
        return 0; // never reach here
}
