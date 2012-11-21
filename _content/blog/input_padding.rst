Input Padding
===================

:date: 2010-08-10 12:08:40
:tags: CSS


现象
-----------------

今天看到个以前从没注意到的现象.

先看图1

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGPm5AQw


这是正常情况下的,

再来看下图2

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGOHBAQw


看到问题了么?

当输入框内的文字太长, IE6下导致 前面的搜索图片不见了.
这里的小图片原本是设置成input元素的背景图, 再设置padding-left 调整文字的起始位置.

这样实现, 在Firefox/chrome下完全没有问题, 但IE6,7, 后来测试在IE8 下也有这个问题.
查找IE下的原因, 因为input的宽度固定, 当内容超过宽度时, 随着光标显示, 文字一直往左移, 同时也包括背景图片也一起往左移动, 所以展示出来图片消失.

如果再深入一些, 就又要看css盒模型, 传统的盒模型, 如IE的实现, 盒子的宽度包含margin, border, padding, 内容. 而W3C的盒模型, 如Firefox的实现, 定义宽度只包含内容, 不包含margin, border, padding. 详细见http://www.quirksmode.org/css/box.html.
而这边, 从input上可以看到, 背景图片设置在盒子上, Firefox中, 随着输入内容的增多, 文本内容不断伸展, 但不会影响到padding和margin, 所以看到背景图片还是在原来的位置上. 而IE下, 随着输入内容的增加, 整个盒子宽度伸展, 因为包括padding和margin, 伸展时也连同它们一起移动.


解决
-----------------

为了解决这个问题, 做了以下尝试

1) 首先想到的是IE下, 将背景图片的background-attachment: fixed; 见 `demo1 <http://liz.appspot.com/static/show.html>`_ 但带来的问题是: 1) 文字覆盖在背景图片上, 2) ie7下图片不能显示出来
2) 有人说用将背景图片的位置设置为bottom right即可, 但这种方式需要你的背景图片大小和你的输入框一致; 见 `demo2 <http://liz.appspot.com/static/show.html>`_ 出来的效果, 在IE下, 一个一个字符输入, 可以看到文字也会覆盖背景图片, 而且鼠标选择时还会出现背景图片位置不再原来的位置上了.
3) 将背景图片设置在input的父元素上, 但这就需要改变DOM结构了.

不知道这个问题有没有更好的解决方式...