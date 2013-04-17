JS Select
===================

:date: 2009-06-05 09:06:05
:tags: Javascript

变态IE6下的jQuery select 无法设置selected属性。未指明的错误。

解决办法:

.. sourcecode:: js

    setTimeout(function() {
        $("select#selCourse option").attr("selected",true);
        // 或者直接赋给select某个值
        country.val(just);
    }, 5);


也就是过一段时间之后再去设置select值。
