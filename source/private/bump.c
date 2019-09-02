// Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
#include <mse/bump.h>

#include <stdint.h>

extern const uint8_t sbumpa[];
extern const uint8_t ebumpa[];
static size_t allocated = 0;

void*
bump_malloc(
  size_t sz)
{
  const uint8_t *buf = sbumpa + allocated;
  allocated += sz;
  const size_t bump_area_sz = ebumpa - sbumpa;
  while (allocated > bump_area_sz) { /* full? */ }
  return (void*)buf;
}
