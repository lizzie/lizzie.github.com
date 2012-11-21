Web Notes
===================

:date: 2009-12-09 12:12:12
:tags: HTML, CSS

`ETag <http://koyoz.com/blog/?action=show&id=235>`_:

    HTTP协议规格说明定义ETag为“被请求变量的实体值”。 另一种说法是，ETag是一个可以与Web资源关联的记号（token）。典型的Web资源可以一个Web页，但也可能是JSON或XML文档。服务器单独负责判断记号是什么及其含义，并在HTTP响应头中将其传送到客户端。

聪明的服务器开发者会把ETags和GET请求的“If-None-Match”头一起使用，这样可利用客户端（例如浏览器）的缓存。因为服务器首先产生ETag，服务器可在稍后使用它来判断页面是否已经被修改。本质上，客户端通过将该记号传回服务器要求服务器验证其（客户端）缓存。

其过程如下:

    1. 客户端请求一个页面（A）。
    2. 服务器返回页面A，并在给A加上一个ETag。
    3. 客户端展现该页面，并将页面连同ETag一起缓存。
    4. 客户再次请求页面A，并将上次请求时服务器返回的ETag一起传递给服务器。
    5. 服务器检查该ETag，并判断出该页面自上次客户端请求之后还未被修改，直接返回响应304（未修改——Not Modified）和一个空的响应体。


`js引擎单线程及定时机制 <http://koyoz.com/blog/?action=show&id=250>`_

`css透明 <http://www.w3schools.com/Css/css_image_transparency.asp>`_
可以使用opacity（非IE），filter（IE）

.. sourcecode:: css

    /* for IE */
    filter:alpha(opacity=60);
    /* CSS3 standard */
    opacity:0.6;

.. sourcecode:: js

    onmouseover="this.style.opacity=1;this.filters.alpha.opacity=100"
    onmouseout="this.style.opacity=0.4;this.filters.alpha.opacity=40"

`文字阴影 <http://www.qianduan.net/css-shadow-xiangjie.html>`_

.. sourcecode:: css

    text-shadow:[颜色 x轴 y轴 模糊半径],[颜色 x轴 y轴 模糊半径]...
    text-shadow:black 2px 2px 2px;
    /* for IE */
    filter: Shadow(Color='black', Direction='135', Strength='2')


`css变量 <http://nathanborror.com/posts/2009/dec/1/less-more/>`_

.. sourcecode:: css

    .border-radius (@radius=4px) {
        -webkit-border-radius: @radius;
        -moz-border-radius: @radius;
        border-radius: @radius;
    }
    div { .border-radius(8px); }

