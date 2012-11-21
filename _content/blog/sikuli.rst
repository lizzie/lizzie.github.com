Introduce to SIKULI
========================

:date: 2010-01-26 14:01:40
:tags: Tools

今天上午大集中, 和xxh聊了会, 无意间找到 `SIKULI <http://groups.csail.mit.edu/uid/sikuli/index.shtml>`_ 这个项目, 看了下 `demo <http://groups.csail.mit.edu/uid/sikuli/demo.shtml>`_, 原来这个"小玩意儿"挺酷! 于是乎这边简单介绍下.


什么是SIKULI
---------------------

SIKULI, 名字读起来像Sakura(樱花), 她是一种可视化搜索技术并且可以自动识别GUI上的图像...
她包含自己的脚本, 可视化的API(for Jython), 本身的IDE和相关的集成环境. 可运行于windows, Linux, Mac OSx(示例中的就是在Mac上), 甚至是iphone中.
哈哈,,,说了这么多, 是不是还是不知道她到底是做什么的? ----- 按照我的理解, 用户写一个sikuli脚本, 定义一些操作, 这些操作是模拟你在当前桌面上的实际操作, 比如说, 你点击Click了一个图标, 这个图标可以由图像形式嵌入到你的脚本中, 当这个脚本运行时, 就能自动从当前整个桌面图像上识别这个图标, 然后自动执行click操作并反映出来, 这个模拟操作就像是你手动执行的一样.


如何使用
---------------------

step1: 安装java 6和sikuli, 基于Java, 但可用Jython也
step2: 运行sikuli, 编写脚本, 她提供了很多命令, 比如click(), 中间的括号中会出现让你截图的按钮, 点击一下过了一会, 能让你截图你想要点击的图标, 这个图标作为图片嵌入到脚本中.
step3: 运行这个脚本, 就能看到效果了....

我做了个小小小示例, 就是运行后, 自动开启桌面上的picasa. 太简单以至于不好意思拿出来晒了. 而更多的功能得靠个人想象力来了.

`官方更多的demo <http://groups.csail.mit.edu/uid/sikuli/demo.shtml>`_


点点分析
---------------------

瞎想想她的实现原理. 估计是充分利用图像匹配技术, 找到相关的按钮, 调用系统api进行各种操作, 比如点击图标, 在输入框中输入. 以此实现全自动.... 那我们可以事先写好一个脚本, 比如一开机之后, 打开音乐, 进入某个文件夹, 打开浏览器, 打开编辑器....哈哈, 全自动!


最后, 顺便推荐一个latex画图的包, PGF TiKz, 据xxh说功能强大, 嗯嗯, 下次试试~

.. image:: http://media.texample.net/img/rottriangle.png