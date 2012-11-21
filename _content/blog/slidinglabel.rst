Sliding Label
===================

:date: 2010-12-23 07:12:25
:tags: KISSY, Javascript



以前看到 http://danyi.codetea.co.uk/2010/03/16/sliding-label/ 上的表单中, label元素的飘动设计很有动感.
后来试了下, 用 KISSY 实现了这个小功能, 并放在 kissy gallery (http://kissyteam.github.com/kissy-gallery/) 中.


当我们页面空间比较紧张, 可以将表单每项的提示信息和输入区域合并起来, 当输入区域获得焦点时, 清空输入区域以便用户正常输入. 同时这些提示信息还可以是写默认值, 也给用户一个如何填写当前输入框的示例.

先上个截图

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGLHRAQw

输入区域只要获得焦点(用户点击或tab键), 即可触发移动.


当js禁用, 或者js不可访问时, 也不会影响正常的用户输入, 呈现普通的表单提示和输入框, 如

.. image:: http://lizziepic.appspot.com/img?img_id=aglsaXp6aWVwaWNyDQsSBVBob3RvGMnJAQw


使用的话, 接口比较简单, like:

    .. sourcecode:: js

        new S.SlidingLabels('#info', {
            blurStyle: {
                color: '#aaa'
            },
            focusStyle: {
                color: '#000'
            }
        });



也就是:

- focusStyle/blurStyle 获得焦点和失去焦点时的label样式都可以自定义;
- axis 运动方向可以是水平方向, 也可以是垂直方向上
- offset labels 和 input之间的距离
- duration 运动速度

等等, 具体可以看源码吧.

简单Demo: http://kissyteam.github.com/kissy-gallery/slidinglabels/demo.html

有兴趣的话, 可以在您的留言板中尝试下看~~