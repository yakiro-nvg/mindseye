/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#include <mse/printk.h>

#include <mse/mmio.h>
#include <mse/fdt.h>

#define LOG_TAG "printk_pl011"

enum { BAUDRATE = 115200 };

// FIFO enabled / no parity / 8 data bit / one stop bit.
enum { LINE_CONTROL = (1 << 4) | (3 << 5) };

// UART enable.
enum { CR_EN   = (1 << 0) };
// transmit enable.
enum { CR_TXEN = (1 << 8) };

// transmit FIFO full.
enum { FR_TXFF = (1 << 5) };

// data read or written register.
enum { REG_UARTDR    = 0x00 };
// error clear register.
enum { REG_UARTECR   = 0x04 };
// flag register.
enum { REG_UARTFR    = 0x18 };
// integer baud rate divisor register.
enum { REG_UARTIBRD  = 0x24 };
// fractional baud rate divisor register.
enum { REG_UARTFBRD  = 0x28 };
// line control register.
enum { REG_UARTLCR_H = 0x2c };
// control register.
enum { REG_UARTCR    = 0x30 };

struct pl011_context_s {
  uint64_t base_address;
  uint32_t clock_frequency;
};

static bool parse_fdt(struct pl011_context_s *self, const void *fdt, int node_offset)
{
  const int address_cells = fdt_address_cells(fdt, node_offset);
  const uint32_t *reg = (const uint32_t*)fdt_getprop(
    fdt, node_offset, "reg", NULL);
  if (reg == NULL) {
    pr_error(LOG_TAG, "'reg' was missing\n");
    return false;
  }
  self->base_address = fdt_next_cell(address_cells, &reg);
  const uint32_t *clk = (const uint32_t*)fdt_getprop(
    fdt, node_offset, "clocks", NULL);
  if (clk == NULL) {
    pr_error(LOG_TAG, "'clocks' was missing\n");
    return false;
  }
  const uint32_t clock_phandle = (uint32_t)fdt_next_cell(1, &clk);
  const int clock_offset = fdt_node_offset_by_phandle(fdt, clock_phandle);
  if (clock_offset < 0) {
    pr_error(LOG_TAG, "clock not found\n");
    return false;
  }
  const uint32_t *clk_frq = (const uint32_t*)fdt_getprop(
    fdt, clock_offset, "clock-frequency", NULL);
  if (clk_frq == NULL) {
    pr_error(LOG_TAG, "'clock-frequency' was missing\n");
    return false;
  }
  self->clock_frequency = (uint32_t)fdt_next_cell(1, &clk_frq);
  return true;
}

static inline void set_baudrate(struct pl011_context_s *self, int baudrate)
{
  unsigned int divisor = (self->clock_frequency*4) / baudrate;
	mmio_write32(self->base_address, REG_UARTIBRD, divisor >> 6);
	mmio_write32(self->base_address, REG_UARTFBRD, divisor & 0x3f);
}

static inline void set_line_control(struct pl011_context_s *self, int line_control)
{
  mmio_write32(self->base_address, REG_UARTLCR_H, line_control);
}

static inline void clear_pending_errors(struct pl011_context_s *self)
{
  mmio_write32(self->base_address, REG_UARTECR, 0);
}

static inline void enable_tx_only(struct pl011_context_s *self)
{
  mmio_write32(self->base_address, REG_UARTCR, CR_TXEN | CR_EN);
}

static inline void wait_until_uart_free(struct pl011_context_s *self)
{
  while ((mmio_read32(self->base_address, REG_UARTFR) & FR_TXFF) != 0) { }
}

static error_t init(printk_driver_context_t* mem, const void *fdt, int node_offset)
{
  struct pl011_context_s *self;
  if (mem == NULL) return sizeof(*self);
  self = (struct pl011_context_s*)mem;
  if (!parse_fdt(self, fdt, node_offset)) return ERR_MALFORMED;
  set_baudrate(self, BAUDRATE);
  set_line_control(self, LINE_CONTROL);
  enable_tx_only(self);
  return ERR_NONE;
}

static void putc(printk_driver_context_t *ctx, const char c)
{
  struct pl011_context_s *self = (struct pl011_context_s*)ctx;
  if (c == '\n') { // line return is "\r\n"
    wait_until_uart_free(self);
		mmio_write32(self->base_address, REG_UARTDR, '\r');
	}
  wait_until_uart_free(self);
	mmio_write32(self->base_address, REG_UARTDR, c);
}

static const driver_match_t matches[] = {
  { .compatible = "arm,pl011" }
, { .compatible = "arm,primecell" }
, { }
};

static const printk_driver_class_t class = {
  .class_name = "printk_pl011"
, .matches = matches
, .init = &init
, .putc = &putc
};

PRINTK_DRIVER(class)
