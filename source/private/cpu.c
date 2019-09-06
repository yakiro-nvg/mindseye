/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/cpu.h>

#include <config.h>
#include <string.h>
#include <mse/fdt.h>
#include <mse/printk.h>

#define LOG_TAG "cpu"

static list_node_t root = {
  .next = &root,
  .prev = &root
};

cpu_driver_list_t cpu_drivers = {
  .root = &root
};

static const cpu_driver_class_t *driver_per_cpu[MAX_CPUS];

static const cpu_driver_class_t* search_driver(const char *enable_method)
{
  CPU_DRIVER_FOREACH(itr) {
    const cpu_driver_class_t *c = CPU_DRIVER_GET(itr);
    if (strcmp(c->enable_method, enable_method) == 0) {
      return c;
    }
  }
  return NULL;
}

void cpu_setup(const void *fdt)
{
  // initialize drivers
  CPU_DRIVER_FOREACH(itr) {
    CPU_DRIVER_GET(itr)->init(fdt);
  }

  // resolve driver for each CPUs
  const int num_cpus = fdt_num_cpus(fdt);
  if (num_cpus < 0) pr_fatal(LOG_TAG, "failed to get number of CPUs");
  for (int i = 0; i < num_cpus; ++i) {
    const int cpu = fdt_cpu(fdt, i);
    const char *enable_method = (const char*)fdt_getprop(
      fdt, cpu, "enable-method", NULL);
    if (enable_method == NULL) {
      pr_error(LOG_TAG, "'enable-method' was missing for CPU #%d", i);
    } else {
      driver_per_cpu[i] = search_driver(enable_method);
      if (driver_per_cpu[i] == NULL) {
        pr_info(LOG_TAG, "unknown CPU #%d", i);
      } else {
        pr_info(LOG_TAG, "CPU #%d driver: %s", i, driver_per_cpu[i]->class_name);
      }
    }
  }
}

const cpu_driver_class_t* cpu_driver(int idx)
{
  if (idx > MAX_CPUS) return NULL;
  return driver_per_cpu[idx];
}