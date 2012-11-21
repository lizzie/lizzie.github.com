Live and Bind
===================

:date: 2009-12-21 11:12:44
:tags: Javascript

live函数
-----------------

jQuery中有一个新的事件处理函数, 叫做live(). 用法和bind()类似, 用于绑定元素的事件.

.. sourcecode:: js

    $(".myDiv").live("click", function(){
        alert("clicked!");
    });


live()函数将事件绑定到元素上, 他和bind()的不同在于: bind()的动态绑定的对象仅为现存的元素, 而live()可以动态绑定现在以及将来的元素, 也就是说, $(".myDiv").live("click", function(){})后, 如果当前dom中生成一个新的节点myDiv, 不需要使用bind()来再次绑定事件, 就可以让myDiv响应click事件.


livequery
---------------------

在jQuery 1.3之前, 也有个类似功能的jQuery插件, 叫做livequery, 她和live()函数不同的实现机制.
live(): 利用了事件的冒泡机制, 直接把事件绑定在了document上，然后通过 event.target找出事件的来源.
jquery.livequery: 每20毫秒做一次检查, 如有新生成则重新绑定一次事件.

使用live的利弊:
好处:元素更新时不用反复去定义事件.
坏处: 把事件绑定在document上会在页面上每一个元素都呼叫一次, 如使用不当会严重影响性能.而且不支持blur, focus, mouseenter, mouseleave, change, submit.


Reference
---------------------

* livequery: http://plugins.jquery.com/project/livequery
* jquery-live介绍: http://www.51jquery.com/2009-10/jquery-live/
* live和bind区别: http://www.jimzhan.com/blog/archives/2372
