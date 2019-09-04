/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include "setup.h"

#include <mse/printk.h>
#include <printf.h>

#define LOG_TAG "arm64_entry"

// TODO: should be passed from bootloader
static const void *fdt = (const void *)0x40000000;

void call_constructors();

void entry()
{
  printf("\n--=-=-=-=-=-=- Mind's Eye, welcome! -=-=-=-=-=-=--\n");

  // static initializes
  call_constructors();

  // setup printk for log
  printk_setup(fdt);

  // architecture bringups
  arch_setup(fdt);
}
