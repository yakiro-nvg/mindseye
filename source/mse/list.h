/* Copyright (c) 2019 Nguyen, Giang (G. Yakiro). All rights reserved.
 * SPDX-License-Identifier: BSD-2-Clause. */
#ifndef _MSE_LIST_H_
#define _MSE_LIST_H_

#import <mse/prereq.h>

/// Intrusive linked list node.
typedef struct list_node_s {
        struct list_node_s* next;
        struct list_node_s* prev;
} list_node_t;

/// Adds `node` to back.
INLINE void list_push_back(list_node_t *root,
                           list_node_t *node)
{
        node->next = root->next;
        node->prev = root;
        root->next->prev = node;
        root->next = node;
}

#endif // !_MSE_LIST_H_
