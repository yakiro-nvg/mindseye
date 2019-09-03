/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/fdt.h>

#include <endianness.h>

const char*
fdt_machine_name(
  const void *fdt)
{
  const char *name = (const char*)fdt_getprop(fdt, 0, "model", NULL);
  if (name == NULL) { // not found, use "compatible"
    name = (const char*)fdt_getprop(fdt, 0, "compatible", NULL);
  }
  return name;
}

int
fdt_chosen(
  const void *fdt
, const char *name)
{
  const int chosen = fdt_subnode_offset(fdt, 0, "chosen");
  if (chosen < 0) return chosen;
  const char *path = fdt_getprop(fdt, chosen, name, NULL);
  if (path == NULL) return -FDT_ERR_NOTFOUND;
  return fdt_path_offset(fdt, path);
}

bool
fdt_compatible(
  const void *fdt
, int node_offset
, const driver_match_t *matches)
{
  int cplen;
  const char *cp = fdt_getprop(fdt, node_offset, "compatible", &cplen);
  if (cp == NULL) return false;
  while (cplen > 0) {
    for (int i = 0; matches[i].compatible; ++i) {
      if (strcmp(matches[i].compatible, cp) == 0) {
        return true;
      }
    }
    int l = strlen(cp) + 1;
    cp += l; cplen -= l; // next compatible
  }
  return false;
}

uint64_t
fdt_next_cell(
  int cell_size
, const uint32_t **cells)
{
  const uint32_t *p = *cells;
  *cells = p + cell_size;
  uint64_t r = 0;
  for (; cell_size--; p++) {
    r = (r << 32) | end_net2host32(*p);
  }
  return r;
}
