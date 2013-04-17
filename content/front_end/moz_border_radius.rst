moz-border-radius
===================

:date: 2008-12-04 11:12:54
:tags: CSS

看到一个CSS上的小东西, 做圆角可以直接在css中设置,如:

.. sourcecode:: css

    div.mm {
        -moz-border-radius-bottomleft:40px;
        -moz-border-radius-bottomright:40px;
        -moz-border-radius-topleft:40px;
        -moz-border-radius-topright:40px;
        border:2px solid #3366CC;
        padding:20px;
    }


也就是定义CSS中的-moz-border-radius属性, 更进一步可以参考 https://developer.mozilla.org/en/CSS/-moz-border-radius ,不过可惜,IE中不能看到.