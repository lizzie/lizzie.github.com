Sort
================

:date: 2009-09-14 13:09:28
:tags: Algorithm


staight insertion sort
-----------------------------------

    ::

        Best Case: 2(n - 1) = O(n)
        Average Case: \frac{1}{4}(n+8)(n-1) = O(n^{2})
        Worst Case: \frac{1}{2}(n-1)(n+4) = O(n^{2})


Binary Search
-----------------------------------

    ::

        Best Case: O(1)
        Average Case: O(log n)
        Worst Case: O(log n)


Straight selection sort
-----------------------------------

    ::

        Best Case: O(1)
        Average Case: O(nlog n) 这三个都是O(n^{2})
        Worst Case: O(n^{2})


Quichsort(f,l)
-----------------------------------

    ::

        Input: a_f, a_{f+1}, ..., a_l
        if f >= l then return
        x = a_f
        i = f+1
        j = l
        while i <j {
            while a_j >= X and j >= f+1 {
                j -= 1
            }
            while a_i <= X and i <= l {
                i += 1
            }
        }
        a_f \leftrightarrow a_j
        Quicksort(f, j-1)
        Quicksort(j+1, l)

时间复杂度

    ::

        Best Case: O(nlog n)
        Average Case: O(nlog n)
        Worst Case: O(n^{2})


The Problem of Finding Ranks
-----------------------------------

一维, 二维空间上, 寻找能支配点的个数
大概思想:

    * 找中间位置的一根线, 分成左右俩部分; O(n)
    * 递归找这两部分的rank;
    * 对于右边的部分, 需要增加每个元素的rank为 += 这个元素的y比A中元素大的个数. O(nlog n)

最终为O(nlog_2 n)


The Lower Bound of A Problem
-----------------------------------

A lower bound of a problem is the least time complexity required for any algorithm which can be used to solve this problem.


Xor
-----------------------------------

1) 有些公司面试的时候会问：知道怎么不用中间变量实现swap(a,b)吗？

    ::

        a ^= b //a=a^b, b=b
        b ^= a //a=a^b, b=(a^b)^b=a
        a ^= b //a=(a^b)^a=b, b=a

2) 有一组数字，从1到n，中减少了一个数，顺序也被打乱，放在一个n-1的数组里，设计算法在O(n)时间O(1)空间内找出丢失的数字！
从1到n异或一遍，再从从数组里面异或一遍，最后的值就是那个丢失的数字

3)
    1. 给你n个数，其中有且仅有一个数出现了奇数次，其余的数都出现了偶数次。用线性时间常数空间找出出现了奇数次的那一个数。
    2. 给你n个数，其中有且仅有两个数出现了奇数次，其余的数都出现了偶数次。用线性时间常数空间找出出现了奇数次的那两个数。

答案：

1.从头到尾异或一遍，最后得到的那个数就是出现了奇数次的数。这是因为异或有一个神奇的性质：两次异或同一个数，结果不变。再考虑到异或运算满足交换律，先异或和后异或都是一样的，因此这个算法显然正确。

    >>> 1^2^3^1^3
    2
    >>> 3^3
    0
    >>> 3^3^3
    3

2.从头到尾异或一遍，你就得到了需要求的两个数异或后的值。这两个数显然不相等，异或出来的结果不为0。我们可以据此找出两个数的二进制表达中不同的一位，然后把所有这n个数分成两类，在那一位上是0的分成一类，在那一位上是1的分到另一类。对每一类分别使用前一个问题的算法。

    x & -x 获得的是1的最低位