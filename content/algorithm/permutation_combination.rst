排列与组合
===============

:date: 2008-07-02 14:07:23
:tags: Python

从M个数中取N个数进行排列或组合，即为选排列/组合
抛弃递归，采用迭代更新。但是是顺序方法：

.. sourcecode:: python

    #!/bin/python
    # coding: utf-8

    """ Permutation
    @author: shengyan
    @license: ...
    @contract: shengyan1985@gmail.com
    @see: ...
    @version:0.1
    """

    import os
    import sys

    class Permutation(object):
        """ 产生组合
        """
        def __init__(self, total=10):
            """初始化
            @param total: 所有要排列的数字个数
            @type total: integer
            """
            self.totalNum = total

        def perm(self, i):
            """对于total个数选取i个数进行选组合
            @param i: 实际的数字个数
            @type i: integer
            @todo: 产生Pmn选排列，而不是组合，是一种组合对应有n!个排列
            """
            first = [] # 初始的组合
            end = [] # 最终的组合
            for j in range(i):
                first.append(j)
                end.append(self.totalNum-i+j)

            all = 0 # 组合的个数
            change = i-1 # 待改变的位置
            while 1:
                #for k in range(i):
                #    print first # 输出当前first组合，这里储存并可以进一步生成排列
                # print first

                for kk in range(24):
                    pass

                all += 24
                if first[change] <> end[change]:
                    first[change] += 1
                else:
                    change -= 1
                    if change<0:
                        break
                    first[change] += 1
                    newchange = change
                    for h in range(change+1, i):
                        first[h] = first[h-1]+1
                        if first[h] <> end[h]:
                            newchange = h
                    change = newchange
            return all
        def perm2(self, i):
            """对于totalNum个数选取i个数进行选排列1...totalNum 选i个
            @param i: 实际的数字个数
            @type i: integer
            """
            first = [] # 初始的排列
            end = [] # 最终的排列，即 n, n-1, ..., n-m+1
            u = [1 for ii in range(self.totalNum)] # 辅助标志数组 1为未使用，0为使用过
            for j in range(i):
                first.append(j+1)
                end.append(self.totalNum-j) # -1
            # 排列个数
            all = 1
            # print first
            # 初态递增到终态为止
            while first <> end:
                for j in range(i):
                    u[first[j]-1] = 0

                f = self.totalNum
                # 找未使用过的最大整数
                while u[f-1] <> 1 :
                    f -= 1
                k = i
                h = -1
                # 找最右可修改元素
                while h == -1:
                    k -= 1
                    u[first[k]-1] = 1
                    if first[k] < f:
                        # 找满足first[k] < j <= totalNum且u[j] =1的最小下标j
                        j = first[k]
                        for jj in range(first[k]+1, self.totalNum+1):
                            if u[jj-1]:
                                j = jj
                                break
                        h = k
                        first[h] = j
                        u[first[h]-1] = 0
                    else:
                        f = first[k]
                # 修改first[h]之右的元素
                for ka in range(1, i-h):
                    kk = 0
                    s = -1
                    for s in range(self.totalNum):
                        if u[s]:
                            kk += 1
                            if kk == ka:
                                break
                    first[h+ka] = s+1
                for kb in range(h):
                    u[first[kb]-1] = 1
                # 产生输出
                #print u
                print first
                all += 1
            return all

    if __name__ == '__main__':
        num = 10
        p = Permutation(num)
        t = 0
        #for i in range(1, num):
        #    t += p.perm(i)
        t = p.perm2(6)
        print '共有%d种组合' % t

该方法组合所花的时间还是很少的，但是排列效率不高，时间是列表中的一倍多。待改进