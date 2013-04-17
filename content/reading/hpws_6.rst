HPWS 6
===================

:date: 2009-03-22 14:03:05
:tags: Javascript, note

Rule 7: Avoid CSS Expressions

即避免CSS中的表达式，如

    .. sourcecode:: css

        width: expression(document.body.clientWidth<600?"600px":"auto");
        min-width: 600px;

为什么要避免呢？因为在css中出现表达式带来的是频繁的计算这些表达式，不仅仅在页面初始渲染或页面改变大小时，而且当页面滚动甚至用户在页面上移动鼠标等，如果其中涉及到的元素样式中含有css表达式则会有不断的计算。这种计算次数会比你想象的更多。

例子：

Expression Counter：http://stevesouders.com/hpws/expression-counter.php IE打开才能看到计数，计数值超乎想象的多。
这个例子定义了p的样式为

    .. sourcecode:: css

        p {
            width: expression(setCntr(), document.body.clientWidth<600?"600px":"auto");
            min-width: 600px;
            min-width: 600px;
            border: 1px solid;
        }

如何解决？两种方式

1） One-Time Expressions

    即使用js函数中设置相关属性
    One-Time Expressions：http://stevesouders.com/hpws/onetime-expressions.php
    可以看到计数仅有10次。

    .. sourcecode:: html

        <style>
        p {
         background-color: expression( setCntr(), setOnetimeBgcolor(this) ); //函数内设置元素的背景颜色，包含表达式
        }
        </style>

2）Event Handlers

    避免在不相关的事件发生时也对表达式进行计算，也还是要把设置元素的表达式移到js代码中，对应到相关事件，比如说页面的resize事件，使得动态的计算元素属性值。
    Event Handler：http://stevesouders.com/hpws/event-handler.php

上述的链接都在IE中才能看到计数，因为IE不支持min-width,而用表达式计算，这可以在第一段css代码中可以看出来。