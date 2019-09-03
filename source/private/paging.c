/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/paging.h>

#include <config.h>
#include <string.h>
#include <mse/bitops.h>

void
page_pool_setup(
  page_pool_t *pool
, uint8_t *pages
, uint32_t *bitmap
, int capacity)
{
  pool->pages = pages;
  pool->bitmap = bitmap;
  pool->num_bitmap = capacity / 32;
  memset(bitmap, 0xff, sizeof(*bitmap)*pool->num_bitmap);
}

void*
page_pool_take(
  page_pool_t *pool)
{
  for (int i = 0; i < pool->num_bitmap; ++i) {
    const int clz = count_leading_zeros(pool->bitmap[i]);
    if (clz < 32) { // next bit is unallocated
      clear_bit(pool->bitmap + i, clz + 1);
      return pool->pages + (i*32 + clz)*PAGE_SIZE;
    }
  }
  return NULL;
}

void
page_pool_drop(
  page_pool_t *pool
, void *page)
{
  const int byte_dif = (((uint8_t*)page) - pool->pages);
  const int page_idx = byte_dif / PAGE_SIZE;
  const int bitmap_idx = page_idx / 32;
  const int bitmap_nth = page_idx % 32;
  set_bit(pool->bitmap + bitmap_idx, bitmap_nth);
}
