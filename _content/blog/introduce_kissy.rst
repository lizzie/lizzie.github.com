About KISSY
===================

:date: 2010-07-02 13:07:47
:tags: Javascript, CSS


今天懒懒交流会..收获挺大的. 再次小记一下

CSS3动画
---------------------

主要分3个部分:

    - transition
    - transform 2D/3D
    - animation

找了份小教程, http://css3.bradshawenterprises.com/, 有几个demo http://css3.bradshawenterprises.com/demos/, 有兴趣的自己研究下.

Note: 酷炫技术的实现并不是很难, 只是这种酷炫的效果&好的创意不容易想到.
现在我觉得吧, 网页能实现的动画/酷炫效果变多了之后, 刚开始真的会"哇, 好酷"的感叹一下, 但逐渐逐渐, 有点审美疲劳了, 感觉也就这样, 呵呵, 貌似是惊叹不起来了. 可能是不是得换个方式展现了.


Kissy
---------------------

- google code: http://code.google.com/p/kissy/
- 旨在: An Enjoyable JavaScript Library
- 愿景：小巧灵活，简洁实用，使用起来让人感觉愉悦。

    Keep It
    Simple & Stupid, Short & Sweet, Slim & Sexy...
    Yeah!

刚开始接触类库/框架设计开发, 说实话, 一开始完全不懂, 只能硬逼着自己看kissy-core代码, 目前虽然还没完全看懂, 今天第一次完整听到yubo关于kissy的why, how, now/future, 以及对其他现有框架的比较深入的分析, 让我还是能比较清晰的领会kissy理念.

    - jQuery 在代码组织和可复用性上存在先天缺陷. (太易用了导致只要是能写代码的都能用jQuery, 大多数代码没使用jquery提供的plugin机制来扩展代码.)
    - Mootools 存在全局污染隐患, 太OO, 不够Javascript. (直接修改prototype)
    - YUI3 理想主义者, 学术味太浓 (...)
    - Ext 野心很大, 想做一平台.

而kissy:

    - 简洁易用
    - 少而精 28原则
    - 适度灵活

这些框架比较, 倒是很让我想起python中各个框架的比较. 呵呵,,难免联想一下.
django, pylons, web.py, uliweb 等等n多的框架, 每个框架总有她自身的设计理念, 最开始要想清楚的原则, 以后就能按照此原则坚定不移的执行下去.

而kissy, 越仔细看就越喜欢:P