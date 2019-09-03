/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/printk.h>

#include <config.h>
#include <string.h>
#include <printf.h>
#include <stdbool.h>
#include <stdarg.h>
#include <mse/fdt.h>

#define LOG_TAG "printk"

static list_node_t root = {
  .next = &root
, .prev = &root
};

printk_driver_list_t printk_drivers = {
  .root = &root
};

extern char sprintk[]; extern char eprintk[];
static int write_off = 0, driver_off = 0;

static void
early_putc(
  printk_driver_context_t *ctx
, const char c)
{
  if (write_off != PRINTK_BUFFER_SIZE) {
    sprintk[write_off++] = c;
  }
}

// early memory backed printk driver, don't register it
static const printk_driver_class_t early_class = {
  .class_name = NULL,
  .matches = NULL,
  .init = NULL,
  .putc = &early_putc
};

static const printk_driver_class_t *class = &early_class;

// driver context resides in bottom
static inline printk_driver_context_t*
driver_context(
  void)
{
  return (printk_driver_context_t*)(eprintk - driver_off);
}

static bool
try_switch_driver(
  const printk_driver_class_t *c
, const void *fdt
, int node_offset)
{
  driver_off = c->init(NULL, NULL, 0);
  if (c->init(driver_context(), fdt, node_offset) == ERR_NONE) {
    class = c; // switch to new driver
    for (int i = 0; i < write_off; ++i) {
      const char ic = sprintk[i];
      if (ic != '\0') {
        _putchar(ic); // and flush early log
      }
    }
    return true;
  } else {
    return false;
  }
}

void
_putchar(
  char c)
{
  class->putc(driver_context(), c);
}

void
printk_setup(
  const void *fdt)
{
  bool found = false;

  const int stdout = fdt_chosen(fdt, "stdout-path");
  if (stdout >= 0) {
    PRINTK_DRIVER_FOREACH(itr) {
      const printk_driver_class_t *c = PRINTK_DRIVER_GET(itr);
      if (fdt_compatible(fdt, stdout, c->matches) &&
          try_switch_driver(c, fdt, stdout)) {
        found = true;
        break;
      }
    }
  }

  if (!found) {
    pr_info(LOG_TAG, "fall-back to NULL driver\n");
    PRINTK_DRIVER_FOREACH(itr) {
      const printk_driver_class_t *c = PRINTK_DRIVER_GET(itr);
      if (strcmp(c->class_name, "printk_null") == 0 &&
          try_switch_driver(c, fdt, stdout)) {
        found = true;
        break;
      }
    }
  }

  if (!found) pr_fatal(LOG_TAG, "failed to initialize\n");
}

void
pr_info(
  const char *log_tag
, const char *format
, ...)
{
  printf("[i@%s] ", log_tag);
  va_list va;
  va_start(va, format);
  vprintf_(format, va);
  va_end(va);
}

void
pr_warning(
  const char *log_tag
, const char *format
, ...)
{
  printf("[w@%s] ", log_tag);
  va_list va;
  va_start(va, format);
  vprintf_(format, va);
  va_end(va);
}

void
pr_error(
  const char *log_tag
, const char *format
, ...)
{
  printf("[e@%s] ", log_tag);
  va_list va;
  va_start(va, format);
  vprintf_(format, va);
  va_end(va);
}

void
pr_fatal(
  const char *log_tag
, const char *format
, ...)
{
  printf("[f@%s] ", log_tag);
  va_list va;
  va_start(va, format);
  vprintf_(format, va);
  va_end(va);
  while (true) { /* RIP */ }
}
