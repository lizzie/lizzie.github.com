Prevent Default
===================

:date: 2009-07-09 12:07:18
:tags: Javascript

定义和用法
--------------

取消事件的默认动作。

语法
------------

event.preventDefault()

说明
-------------

该方法将通知 Web 浏览器不要执行与事件关联的默认动作（如果存在这样的动作）。
例如，如果 type 属性是 "submit"，在事件传播的任意阶段可以调用任意的事件句柄，通过调用该方法，
可以阻止提交表单。注意，如果 Event 对象的 cancelable 属性是 fasle，那么就没有默认动作，或者不能阻止默认动作。无论哪种情况，调用该方法都没有作用。

例子
------------

.. sourcecode:: js

    $("#phrase").attr({
        "autocomplete": "OFF"
    }).keyup(function(e) {
        if (e.keyCode == 13) {
            send();
            e.preventDefault();
        }
    });
