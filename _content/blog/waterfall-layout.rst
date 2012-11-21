WaterFall Layout
===================

:date: 2011-09-10 18:12
:tags: Javascript, CSS


简介
-----------

最近有很多网站, 在设计上采用了多栏布局, 类似于 Pinterest (这貌似是最早使用这种布局的网站了), Mark之, 蘑菇街, 哇哦 等等. 这种类似的布局, 很像是一夜之间出现国内大大小小的网站上, 倒是很流行哈~
这种布局更适合于小而重复的数据块排列, 每个数据块没有侧重, 而且大多情况下, 这种布局下, 随着滚动条向下滚动, 不断加载数据块至当前最后, 鉴于此, 他又有另外一个名字 -- **瀑布流式布局**.

几种实现方式
-----------------

随着越来越多设计师爱用这种布局了, 我们作为前端, 也尽可能满足视觉/交互设计师的需求. 整理了下这种布局的几种实现方式, 有三种:

1) 传统多列浮动, 即 蘑菇街和哇哦 采用的方式, 如下图所示:

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGOnoAQw
    :alt: 传统多列浮动


* 各列固定宽度, 并且左浮动;
* 一列中的数据块为一组, 列中的每个数据块依次排列即可;
* 跟多数据加载时, 需要分别插入到不同的列上;
* `线上例子1 <http://wow.taobao.com/>`_;

优点:
    * 布局简单, 应该说没啥特别的难点;
    * 不用明确知道数据块高度, 当数据块中有图片时, 就不需要指定;

缺点:
    * 列数固定, 扩展不易, 当浏览器窗口大小变化时, 只能固定的x列, 如果要添加一列, 很难调整出来数据块;
    * 滚动加载更多数据时, 还要指定插入到第几列中, 还是不方便;

2) CSS3 定义, W3C 中有讲述关于 `多列布局的文档 <http://www.w3.org/TR/css3-multicol/>`_ , 排列出来的样子:

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGNHwAQw
    :alt: 多列布局

* 由 chrome/ff 浏览器直接渲染出来, 可以指定容器的列个数, 列间距, 列中间边框, 列宽度来实现:

    .. sourcecode:: css

        #container {
            -webkit-column-count: 5;
            /*-webkit-column-gap: 10px;
            -webkit-column-rule: 5px solid #333;
            -webkit-column-width: 210px;*/

            -moz-column-count: 5;
            /*-moz-column-gap: 20px;
            -moz-column-rule: 5px solid #333;
            -moz-column-width: 210px;*/

            column-count: 5;
            /*column-gap: 10px;
            column-rule: 5px solid #333;
            column-width: 210px;*/
        }

* column-count 为列数; column-gap 为每列间隔距离; column-rule 为间隔边线大小; column-width 为每列宽度; 当只设置 column-width 时, 浏览器窗口小于一列宽度时, 列中内容自动隐藏了;当只设置 column-count 时, 平均计算每列宽度, 列内内容超出则隐藏; 都设了 column-count 和column-width, 浏览器会根据 count 计算宽度和 width 比较, 取大的那个值作为每列宽度, 然后当窗口缩小时, width 的值为每列最小宽度. 这边其实很简单, 简易自己尝试下, 详细可参考 https://developer.mozilla.org/en/CSS3_Columns 中的说明;
* `线上列子2 <http://lizzie.github.com/kissy/src/waterfall/demo/css3.html>`_ ;

优点:
    * 直接 CSS 定义, 最方便了;
    * 扩展方便, 直接往容器里添加内容即可;

缺点:
    * 只有高级浏览器中才能使用;
    * 还有一个缺点, 他的数据块排列是从上到下排列到一定高度后, 再把剩余元素依次添加到下一列, 这个本质上就不一样了;
    * 鉴于这两个主要缺点, 注定了该方法只能局限于高端浏览器, 而且, 更适合于文字多栏排列;


3) 绝对定位, 即 Pinterest , Mark之, KISSY 采用的方式:

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGLn4AQw
    :alt: 绝对定位

* 可谓是最优的一种方案, 方便添加数据内容, 窗口变化, 列数/数据块都会自动调整;
* `线上列子3 <http://docs.kissyui.com/docs/html/static/demo/waterfall/demo2.html>`_

缺点:
    * 需要实现知道数据块高度, 如果其中包含图片, 需要知道图片高度;
    * JS 动态计算数据块位置, 当窗口缩放频繁, 可能会狂耗性能;


KISSY.Waterfall 实现思路
---------------------------------

`KISSY 的 Waterfall 组件 <http://docs.kissyui.com/docs/html/api/component/waterfall/>`_ 主要包含两个部分, 一个是对现有数据块进行排列计算各自所在的位置; 二是下拉滚动时, 触发加载数据操作, 并把数据添加到目标容器中;

1) 数据块排列, 算法步骤简述下:
    * 初始化时, 对容器中已有数据块元素进行第一次的计算, 需要用户给定: a, 容器元素 -- 以此获取容器总宽度; b, 列宽度; c, 最小列数; 最终列数取的是容器宽度/列宽度和最小列数的最大值, 这样保证了, 当窗口很小时, 仍然出现最小列数的数据;
    * 获得列数后, 需要保存每个列的当前高度, 这样在添加每个数据块时, 才知道起始高度是多少;
    * 依次取容器中的所有数据块, 先寻找当前高度最小的某列, 之后根据列序号, 确定数据块的left, top值, left 为所在列的序号乘以列宽, top 为所在列的当前高度, 最后更新所在列的当前高度加上这个数据块元素的高度, 至此, 插入一个元素结束;
    * 当所有元素插入完毕后, 调整容器的高度为各列最大的高度值, 结束依次调整;
    * 性能效率上的注意点: a, 如果当前正在调整中, 又触发了 resize 事件, 需要将上次调整暂停后执行这次调整(见 timedChunk 函数); b, resize 触发会很频繁, 可以将回调函数缓存一段时候后执行, 即当这段时间内多次触发了resize事件, 但回调函数只会执行一次(见 S.buffer 函数)
    * 感兴趣的可以参见 `源码1 <https://github.com/kissyteam/kissy/blob/master/src/waterfall/base.js>`_

2) 异步加载数据, 前面讲的是如何对容器中已有元素进行排列, 但很多情况下, 还需要不断加载新数据块, 为此专门设计了一个独立的模块 KISSY.Waterfall.Loader, 其实这个功能就更简单了, 仅包含两个步骤:
    * 绑定滚动事件, 并确定预加载线高度值, 即滚动到哪个高度后, 需要去加载数据, 其实这个就是列的最小高度值, 这样当前滚动值和最小高度值比较一下即可判断出来, 是否要触发加载数据;
    * 加载数据, 为了不对数据源做太多限制, 完全由使用者自己决定数据源从哪边获取和其格式, 这样更好的方便用户使用. 为此, 该组件只提供一个load(success, end) 接口, 怎样load 由用户自己去定义, 而其中的 success/end, 分别给出如何添加新数据(suceess 即同 addItems)/如何停止加载的接口. 这样真是太方便了~~
    * 感兴趣的可以参见 `源码2 <https://github.com/kissyteam/kissy/blob/master/src/waterfall/loader.js>`_


KISSY.Waterfall 示例和文档
---------------------------------

看到这边, 是不是很想试用一下~~, 嗯嗯, 这里给出一些相关学习资料和示例, 以供参考:

* `Waterfall API 文档 <http://docs.kissyui.com/docs/html/api/component/waterfall/%3Cbr%20/%3E>`_ , 相关构造器, 配置项, 方法都在这里;
* `示例 <http://docs.kissyui.com/docs/html/demo/component/waterfall/%3Cbr%20/%3E>`_, 包含静态和动态两种;

欢迎试用和提出意见~~
