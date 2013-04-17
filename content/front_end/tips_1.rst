Tips1
============

:date: 2009-05-07 13:05:12
:tags: Other


今天还是照常记录一下,

1) 在 `Django自带文档 <http://docs.djangoproject.com/en/dev/topics/db/aggregation/>`_ 可以使用Max, Avg等来计算记录某字段的最大值, 平均值. 但用的时候, 出现了:

    .. sourcecode:: bash

        >>> from django.db.models import Avg
        Traceback (most recent call last):
          File "<console>", line 1, in <module>
        ImportError: cannot import name Avg
        >>> from django.db.models import Avg, Max, Min, Count
        >>> Book.objects.aggregate(Avg('price'), Max('price'), Min('price'))
        {'price__avg': 34.35, 'price__max': Decimal('81.20'), 'price__min': Decimal('12.99')}

    原来压根就没有这个Avg, Max函数. 包括aggregate也没有....
    本机上Django是1.0, 我想应该可以用的, 还是文档上错了??

    如果要实现获得平均值, 只能自己写sql语句了么? ps: SELECT AVG(price) FROM Book

    呵呵~ 找了下,,,原来是诺大的Aggregation标题下, 还有个"New in Django Development version." 于是乎,,,,,,,

2) jQuery中, clone(), insertBefore(), insertAfter()和html().

    这四个函数分别用于复制一个dom元素, 前插, 后插 和显示内部html代码. 当现在想调整table中的两行东西. 可以使用,

    .. sourcecode:: js

        // 这种就是普通替换两个的html代码.
        var t = uprow.html();
        uprow.html(row.html());
        row.html(t);
        //将当前行插入到上一行之前.
        row.insertBefore(uprow);

    虽然表面上这两者都可以交换两行的内容显示, 但区别是, 如果没个row代码中元素包含某些事件响应, 如果仅仅复制html代码的话, 结果出来的元素的响应事件不能发生, 也就是需要重新绑定; 而换成insertBefore, 因为每行的元素还是之前的元素, 只是换了个dom中的位置, 所以仍然可以响应事件.
    所以以后得多多注意这样的问题了....