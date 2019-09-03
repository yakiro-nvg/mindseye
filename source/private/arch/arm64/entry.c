// Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
#include "setup.h"

#include <mse/printk.h>
#include <printf.h>

void
call_constructors(
  void
);

void entry()
{
  // TODO: should be passed from bootloader
  const void *fdt = (const void *)0x40000000;

  // static initializes
  call_constructors();

  // setup printk for log
  printk_setup(fdt);
  printf("\n\n======= Mind's Eye, welcome! =======\n");

  // architecture bringups
  arch_setup(fdt);
}
