Image Object in JS
=======================

:date: 2010-09-28 10:09:08
:tags: Javascript


DOM 中的 Image 对象, W3C 定义为:

..

    The Image object represents an embedded image.
    For each <img> tag in an HTML document, an Image object is created.
    Notice that images are not technically inserted into an HTML page, images are linked to HTML pages. The <img> tag creates a holding space for the referenced image.

暂且称 DOM 中的 img 标签元素 和 js 中的 Image 对象. 上面说, img 标签 代表了一个内嵌的图片, 当标签 img 插入到 document 中, 一个 Image 对象就创建了. img 标签在页面上创建一个占位符.

有个疑问, img 与 Image 之间的关系到底是什么? 找了好半天, 终于在某个网站上 [#f2]_ 的一小段话中找到:

..
    The Image Object is the JavaScript object for interfacing with IMG tags. The properties you see between <img> HTML markup map to similar property names that are a part of the DOM and become accessible to client-side scripting.


Image 对象是一个 img 标签的接口对象, img 标签的 src 可以是各种不同的图片类型, 统一通过 Image 封装起来, 其中的属性与 HTMLElement 大体一致, 详细见 [#f2]_ ;


因为浏览器加载图片是非阻塞的, 通常可以用 onload 或 complet 来判断图片是否加载完成.

Complete 定义:

..

    The complete property returns whether or not the browser is finished loading an image.
    If the image is finished loaded, the complete property returns true, otherwise it returns false.

onload 事件定义:

..

    The onload event occurs immediately after an image is loaded.

W3C 定义这两个很简单, complete 就是图片加载完了就为 true, 没加载完就是 false; onload 事件在图片加载完成后触发; 但现实总是复杂的!

如下的一段代码:

    .. sourcecode:: js

        var img = new Image();
        DOM.attr(img, 'src', 'xxxx');
        setTimeout(function(){
            Event.on(img, 'load', function(){
                console.log('image loaded!');
            });
        }, 1000);


在设置 src 之后并且这个图片很快加载完, 还没等到 onload 事件定义(这里是设置了一个延时, 也有可能图片在页面最上面, 脚本在最下面, 这个页面又很长, 又或者是图片直接取缓存), 就永远执行不到 load 事件;

一种解决办法是, 将 onload 定义到设置 src 之前;
但实际中, 不能总是把 load 放在前面的的, 于是乎, 就有 complete 来判断:

    .. sourcecode:: js

        function imgOnLoad(imgElem, callback) {
            if (imgElem && imgElem.complete && imgElem.width) {
                callback();
            } else {
                Event.on(img, 'load', callback);
            }
        }
        imgOnLoad(img, function(){
            console.log('image loaded!');
        });


双重判断, 确保都能执行到.

img.src 是可以动态修改的. 当 src 改变时, 每次修改都会触发 onload 事件(只要有定义到 onload 事件);
但是, 不同浏览器, 更改图片 src 之后, img.complete 的值奇怪的不同, 做个简单测试;

    .. sourcecode:: js

        var img = DOM.get('#img'),
            imgCopy;

        console.log('start');
        console.log([1, img.complete]);

        Event.on(img, 'load', function() {
            console.log([2, img.complete]);
            console.log('image loaded!');
        });
        S.later(function() {
             DOM.attr(img, 'src', 'http://img05.taobaocdn.com/imgextra/i5/T1DERIXmXsXXa26X.Z_031259.jpg');
             console.log('src changed!');
             console.log([3, img.complete]);
        }, 3000);

        /* 结果
        firefox 清缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,true  <------------
        2,true
        image loaded!
        firefox 来自缓存
        start
        1,true
        2,true
        image loaded!
        src changed!
        3,true
        2,true
        image loaded!

        chrome 清缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,true    <-------------
        2,true
        image loaded!
        chrome来自缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,true
        2,true
        image loaded!

        safari 清缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,false   <------------
        2,true
        image loaded!
        safari 来自缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,false
        2,true
        image loaded!

        opera 清缓存
        start
        1,false
        2,true
        image loaded!
        src changed!
        3,false  <------------
        2,true
        image loaded!
        opera 来自缓存
        start
        1,true
        2,true
        image loaded!
        src changed!
        3,true
        2,true
        image loaded!

        IE8 清缓存
        日志: start
        日志: 1,false
        日志: 2,false
        日志: image loaded!
        日志: src changed!
        日志: 3,true
        日志: 2,true
        日志: image loaded!

        IE8 来自缓存
        日志: start
        日志: 1,false
        日志: 2,false
        日志: image loaded!
        日志: 2,true
        日志: image loaded!
        日志: src changed!
        日志: 3,true

        */

不管是否来自缓存, 改变 src 之后, img.complete 仍然是 true, 这个貌似 opera 和 safari 才会重置为 false, 这才是想要的状态.
另外, IE下更为奇怪, load 完了竟然 img.complete 还是为 false.

所以, 判断两次还是有必要的.

PS: 对于 img 的宽高, 如果没有另外设置 image 的 height/width, 得到的是图片的真实宽高. 而如果设置了, 通过 image.height/clientHeight/offsetHeight 都不能获取图片的真实宽高.
如果想获取真实图片宽高, 通过另建一个 new Image().src = img.src 来获取.


.. rubric:: Footnotes

.. [#f1] http://www.w3schools.com/jsref/dom_obj_image.asp
.. [#f2] http://www.esqsoft.com/javascript-help/javascript-img-image-object.htm
.. [#f3] http://msdn.microsoft.com/en-us/library/cc197055(VS.85).aspx
.. [#f4] http://www.thefutureoftheweb.com/blog/image-onload-isnt-being-called
.. [#f5] http://bytes.com/topic/javascript/answers/626745-image-complete-property-prematurely-true
.. [#f6] http://www.w3schools.com/jsref/prop_img_complete.asp

