// Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
#include "setup.h"

#include <mse/fdt.h>
#include <printf.h>

void
arch_setup(
  const void *fdt)
{
  const char *name = fdt_machine_name(fdt);
  printf("hello, this is: %s\n", name);
  while (1);
}
