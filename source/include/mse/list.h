/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_LIST_H_
#define _MSE_LIST_H_

#import <mse/prereq.h>

/* TODO: consider remove it. */

/// Intrusive linked list node.
typedef struct list_node_s {
        struct list_node_s* _Nullable next;
        struct list_node_s* _Nullable prev;
} list_node_t;

/// Adds `node` to back.
INLINE void list_push_back(list_node_t* _Nonnull root,
                           list_node_t* _Nonnull node)
{
        node->next = root->next;
        node->prev = root;
        root->next->prev = node;
        root->next = node;
}

#endif // !_MSE_LIST_H_
