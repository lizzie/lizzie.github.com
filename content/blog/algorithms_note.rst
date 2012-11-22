一些算法整理
================

:date: 2009-09-14 13:09:34
:tags: Algorithm


Kruskal's mininum spanning tree algorithm
-----------------------------------------------------

最小生成树, 无向图,,选边的方法, 里面如何判断是否构成环比较麻烦

::

    Input: A weighted, connected and undirected graph G = (V, E).
    Output: A minimum spanning tree for G.
        T := \varnothing
        While T contains less than n - 1 edges do
        Begin
            Choose an edge(v,w) from E of the smallest weight
            Delete (v,w) from E
            If (the adding of (v,w) to T does not create a cycle in T) then
                Add (v,w) to T
            Else
                Discard (v,w)
        End


The basic Prim's algorithm to find a minimum spanning tree
-------------------------------------------------------------------------

选点.

Input: A weighted, connected and undirected graph G = (V, E).
Output: A minimum spanning tree for G.

    Step 1: Let x be any vertex in V. Let X = {x} and Y = V - {x}.
    Step 2: Select an edge (u,v) from E such that u \in X, v \in Y and (u,v) has the smallest weight among edges between X and Y.
    Step 3: Connect u to v. Let X = X U {v} and Y = Y - {v}.
    Step 4: If Y is empty, terminate and the resulting tree is a minimum spanning tree. Otherwise, Go to Step 2.

详细点的

    Step 1: Let X = {x} and Y = V - {x} where x is any vertex in V.
    Step 2: Set C_1(y_j) = x and C_2(y_j) = \infty for every vertex y_j in V.
    Step 3: For every vertex y_j in V, examine whether y_j is in Y and edge(x, y_j) exists. If y_j is in Y, edge(x,y_j) exists and w(x, y_j) = b < C_2(y_j), set C_1(y_j) = x and set C_2(y_j) = b; otherwise, do nothing.
    Step 4: Let y be a vertex in Y such that C_2(y) is minimum. Let z = C_1(y)(z must be in X). Connect y with edge (y, z) to z in the partially constructed tree T. Let X = X + {y} and Y = Y - {y}. Set C_2(y) = \infty .
    Step 5: If Y is empty, terminate and the resulting tree T is a minimun spanning tree; otherwise, set x = y and go to Step 3.


Dijkstra's single source shortest paths
-------------------------------------------------------------------------

Input: A directed graph G = (V, E) and a source vertex v_0. For each edge (u, v) \in E, there is a non-negative number c(u, v) associated with it. |V| = n + 1.
Output: For each v \in V. the length of a shortest path from v_0 to v.

::

    S := { v_0 }
    For i:= i to n do
    Begin
        if (v_0, v_i) \in E then
            L(v_i) := c(v_0, v_i)
        else:
            L(v_i) := \infty
    End
    For i := 1 to n do
    Begin
        Choose u from V - S such that L(u) is the smallest
        S := S \cup { u } /* Put u into S */
        For all w in V - S do
            L(w) := min(L(w), L(u) + c(u,w))
    End


O(n^2)



Linear merge algorithm
-------------------------------------------------------------------------

Input: Two sorted lists, L_1 = (a_1, a_2, ..., a_{n_1}) and L_2 = (b_1, b_2, ..., b_{n_2}).
Output: A sorted list consisting of elements in L_1 and L_2;

::

    Begin
        i := 1
        j := 1
        do
            compare a_i and b_j
            if a_i > b_j then output b_j and j := j+1
            else output a_i and i := i+1
        while ( i \leq n_1 and j \leq n_2)
        if i > n_1 then output b_j, b_j+1, ..., b_{n_2},
        else output a_i, a_i+1, ..., a_{n_1}.
    End.

多路归并的话, 可以看成是一棵树, 归并时统计元素比较次数, 越少越好, 那么如果看成是一颗二叉树, 树的深度应该越少越好. 每个数组比较次数为d_i*n_i, d_i为数组i的在二叉树中的深度, n_i为数组元素个数.

A greedy algorithm to generate an optimal 2-way merge tree
Input: m sorted lists, L_i, i=1,2, ..., m, each L_i consisting of n_i elements.
Output: An optimal 2-vay merge tree.

    Step 1: Generate m trees, where each tree has exactly one node (external node) with weight n_i.
    Step 2: Choose two trees T_1 and T_2 with minimal weights.
    Step 3: Create a new tree T whose root has T_1 and T_2 as its subtrees and weight is equal to the sum of weights of T_1 and T_2.
    Step 4: Replace T_1 and T_2 by T.
    Step 5: If there is only one tree left, stop and return; otherwise, go to Step 2.

这个过程: 依次选择最小的两棵树归并, 新的树替代这两棵, 重复找. 和构建huffman树(这树加上0, 1编码就可以得到对应的编码了)类似. 顺便回忆一下huffman编码, 使用频率最为权值, 最频繁的应该位于树根部, 对应的编码长度应该较小, 而频率低的则靠树叶子节点, 对应的编码长度相对较长.