ImageZoom重构记
===================

:date: 2011-02-18 11:02:09
:tags: Javascript, KISSY


年后回到公司, 花了些时间重构原来写的imagezoom, 主要是重构成基于uibase的组件模块化开发.

首先, 如果不熟悉 uibase的话, 可以先看承玉写的:

* 基于mixin的组件设计: http://yiminghe.javaeye.com/blog/808763 及里面的PPT ,
* selectbox的例子 http://yiminghe.javaeye.com/blog/897229,

PS: 这两篇文章及里面的ppt, 值得多看几遍, 不然肯定会看不懂~~ 偶就看文章/PPT, 对着代码, 不下看了三四遍后, 终于被我折腾出新的imagezoom. 而且还发现旧版的一个比较严重的bug.


分离
------------------
将原来放在一起的逻辑分离出来:

- imagezoom/base.js, 处理初始化逻辑, 及小图, 放大镜图标的DOM构建, 绑定鼠标移入事件 等
- imagezoom/zoomer.js, 放大显示逻辑, 放大层的DOM构建, 绑定鼠标移动事件, 显示对应的图像

两者独立开来, 功能比较明确;


结构分离
------------------

整个结构如下图所示:

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGJnZAQw


imagezoom主组件扩展于UIBase, 具有基本的box, position, align, mask 功能, 再加上扩展组件zoomer, 就可以写出新的 imagezoom, 而这里的扩展组件 zoomer 也方便其他组件使用.


这样组织的好处是:

- 利于已有组件, 快速搭建你所需要的新组件;
- 设置变量和UI展现分离, 数据通过setter/getter 统一设置, 而数据更改带来的UI变化, 通过_uiSetXX方式自动被调用, 而完成对应的UI变化. 这样分离了便于思维逻辑上的分离;
- 开发代码量减少, 因为组件可以重用, 我们自己只要写上对应的逻辑即可. 不过总的代码量没变多少, 重构后, 原先 imagezoom-pkg-min.js 7k , 重构后imagezoom-pkg-min.js, 6k 再加uibase-pkg-min.js 12k 共18k, 从这点上看, 貌似代码还可以优化..


重构过程中, 还发现旧版本中的一个bug, 情况简化可以描述成, 当mouseenter到小图后, 绑定mousemove到body, 然后 mouseleave小图后, 删除body的mousemove事件, 大致想一下, 这逻辑没问题, 但是问题在小图上覆盖了一层镜片, 当显示大图时, 鼠标正在镜片元素上, 导致立即触发小图的mouseleave事件, 这样就会立刻hide()了, 但就是因为旧版本上, 在 mouseleave小图时, 没有正确删除body的mousemove事件, 即 原本是

    .. sourcecode:: js

        Event.on(self.image, 'mouseenter', function() {
            //..
            Event.on(body, 'mousemove', self._onMouseMove, self);
            //..
        });
        Event.on(self.image, 'mouseleave', function() {
            //..
            Event.remove(body, 'mousemove', self._onMouseMove);
            //..
        });



而这里事件删除时, 后面的参数应该和on时完全一致, 如

    .. sourcecode:: js

        Event.on(self.image, 'mouseenter', function() {
            //..
            Event.on(body, 'mousemove', self._onMouseMove, self);
            //..
        });
        Event.on(self.image, 'mouseleave', function() {
            //..
            Event.remove(body, 'mousemove', self._onMouseMove, self);
            //..
        });


这样才对, 不然就body上一直存在mouseleave, 而且每次mouseenter后, 再一次绑定body的mousemove事件, 虽然视觉差异不大, 测试也注意到这个问题, 唉... 说到这里, 好惭愧啊...



嗯嗯, 下次一定得记住了!