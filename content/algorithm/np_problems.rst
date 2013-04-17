NP 问题
================

:date: 2009-09-13 13:09:41
:tags: Other

A problem is easy if it can be solved by an efficient algorithm, perhaps an algorithm with polynomial-time complexity. Conversely, if a problem cannot be solved by any polynomial-time algorithm, it must be a difficult problem.

`更详细的介绍 <http://www.matrix67.com/blog/archives/105>`_

前面的几类复杂度被分为两种级别，其中后者的复杂度无论如何都远远大于前者：

* 一种是O(1),O(log(n)),O(n^a)等，我们把它叫做多项式级的复杂度，因为它的规模n出现在底数的位置；
* 另一种是O(a^n)和O(n!)型复杂度，它是非多项式级的，其复杂度计算机往往不能承受。

如果一个问题可以找到一个能在多项式的时间里解决它的算法，那么这个问题就属于P问题。P是英文单词多项式的第一个字母。

NP问题不是非P类问题。NP问题是指可以在多项式的时间里验证一个解的问题。NP问题的另一个定义是，可以在多项式的时间里猜出一个解的问题。

NP问题不是P问题, 但P问题属于NP问题.

“可约化”是指的可“多项式地”约化(Polynomial-time Reducible)，即变换输入的方法是能在多项式的时间里完成的。约化的过程只有用多项式的时间完成才有意义。

我们可以看到，人们想表达一个问题不存在多项式的高效算法时应该说它“属于NPC问题”。

NPC问题的定义非常简单。同时满足下面两个条件的问题就是NPC问题。首先，它得是一个NP问题；然后，所有的NP问题都可以约化到它。证明一个问题是 NPC问题也很简单。先证明它至少是一个NP问题，再证明其中一个已知的NPC问题能约化到它（由约化的传递性，则NPC问题定义的第二条也得以满足；至于第一个NPC问题是怎么来的，下文将介绍），这样就可以说它是NPC问题了。
既然所有的NP问题都能约化成NPC问题，那么只要任意一个NPC问题找到了一个多项式的算法，那么所有的NP问题都能用这个算法解决了，NP也就等于P 了。因此，给NPC找一个多项式算法太不可思议了。因此，前文才说，“正是NPC问题的存在，使人们相信P≠NP”。我们可以就此直观地理解，NPC问题目前没有多项式的有效算法，只能用指数级甚至阶乘级复杂度的搜索。

NP-Hard问题是这样一种问题，它满足NPC问题定义的第二条但不一定要满足第一条（就是说，NP-Hard问题要比 NPC问题的范围广）。NP-Hard问题同样难以找到多项式的算法，但它不列入我们的研究范围，因为它不一定是NP问题。即使NPC问题发现了多项式级的算法，NP-Hard问题有可能仍然无法得到多项式级的算法。事实上，由于NP-Hard放宽了限定条件，它将有可能比所有的NPC问题的时间复杂度更高从而更难以解决。



Time-complexity functions

::

    \log < n < n\log < n^2 < 2^n < n!