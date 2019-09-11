/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_ASM_ARM_SPINLOCK_H_
#define _MSE_ASM_ARM_SPINLOCK_H_

#import <mse/prereq.h>
#import <stdatomic.h>

#ifndef ATOMIC_BOOL_LOCK_FREE
#error "atomic bool must be lockfree"
#endif

typedef struct arch_spinlock_s {
        atomic_bool locked;
} arch_spinlock_t;

typedef unsigned long arch_spinlock_flags_t;

INLINE void arch_spinlock_init(arch_spinlock_t* lock)
{
        atomic_init(&lock->locked, false);
}

INLINE void arch_spinlock_irq_save(arch_spinlock_t* lock, arch_spinlock_flags_t* flags)
{
#ifdef __aarch64__
        asm volatile(
                "mrs %0, daif\n"
                "msr daifset, #2"
                : "=r" (*flags) : : "memory", "cc");
#else
        asm volatile(
                "mrs %0, cpsr\n"
                "cpsid i"
                : "=r" (*flags) : : "memory", "cc");
#endif
        static bool unlocked = false;
        while (!atomic_compare_exchange_weak(&lock->locked, &unlocked, true)) { }
}

INLINE void arch_spinlock_irq_restore(arch_spinlock_t* lock, arch_spinlock_flags_t* flags)
{
        atomic_store(&lock->locked, false);
#ifdef __aarch64__
        asm volatile(
                "msr daif, %0\n"
                "msr daifclr, #2"
                : "=r" (*flags) : : "memory", "cc");
#else
        asm volatile(
                "msr cpsr_c, %0\n"
                "cpsie i"
                : "=r" (*flags) : : "memory", "cc");
#endif
}

#endif // !_MSE_ASM_ARM_SPINLOCK_H_
