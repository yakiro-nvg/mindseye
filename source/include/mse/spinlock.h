/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_SPINLOCK_H_
#define _MSE_SPINLOCK_H_

#import <mse/prereq.h>

#if defined(__arm__) || defined(__aarch64__)
#import <mse/arm/spinlock.h>
#endif

/** CPU non-recursive spin lock.
\remarks: We don't encourage locking. */
typedef struct spinlock_s {
        arch_spinlock_t arch_lock;
} spinlock_t;

/// Saved IRQ flags before lock.
typedef arch_spinlock_flags_t spinlock_flags_t;

/// Initializes a new spinlock as unlocked.
INLINE void   spinlock_init          (spinlock_t*         _Nonnull   lock)
{
        arch_spinlock_init(&lock->arch_lock);
}

/// Saves IRQ state and disable it, then lock.
INLINE void   spinlock_irq_save      (spinlock_t*         _Nonnull   lock,
                                      spinlock_flags_t*   _Nonnull   flags)
{
        arch_spinlock_irq_save(&lock->arch_lock, flags);
}

/// Releases lock, restores IRQ state.
INLINE void   spinlock_irq_restore   (spinlock_t*         _Nonnull   lock,
                                      spinlock_flags_t*   _Nonnull   flags)
{
        arch_spinlock_irq_restore(&lock->arch_lock, flags);
}

#endif // !_MSE_SPINLOCK_H_
