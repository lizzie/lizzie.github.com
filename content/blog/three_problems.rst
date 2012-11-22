Three Problems
===================

:date: 2010-10-10 08:10:51
:tags: Javascript, CSS


window.length
-------------------------

window.length:

    - Returns the number of frames in the window.
    - 或是有 length 变量的全局定义;
    - https://developer.mozilla.org/en/DOM/window



渐变的一个例子
-------------------------

水平渐变，33%处为绿色，66%处为橙色：

    .. sourcecode:: css

        background-image:-webkit-gradient(linear,0% 0%,100% 0%,from(#2A8BBE),color-stop(0.33,#AAD010),color-stop(0.33,#FF7F00),to(#FE280E));

一直以为浏览器中的渐变只能两种颜色, 其他可以有很多~ 更多见 http://www.cnblogs.com/yuntian/archive/2010/10/08/1827993.html



IE下创建 Image 的宽高问题
-------------------------

在使用 document.createElement 或 new Image() 创建 img 时, IE6/7/8下会给 img 元素设置 width/height 属性, 如:

    .. sourcecode:: html

        <img src="http://img01.taobaocdn.com/imgextra/i1/T1s.pHXlFIXXbVn43V_021049.jpg" width=720 height=478 />

且之后如果再次更改 src , width/height 还是原来的值.

这似乎是一个bug, 创建一个img, 我并不想设置 width/height ! 替代方法是使用 ``S.DOM.create('<img src="http://img01.taobaocdn.com/imgextra/i1/T1s.pHXlFIXXbVn43V_021049.jpg" />');``
她实现时不用 document.createElement 而是创建一个父 div, 设置其 innerHTML 为目标字符串, 所以能避免自动设置 width/height;

这里, 比较奇怪的一个:

    .. sourcecode:: js

        var img = document.createElement('img'); // or new Image(); or S.DOM.create('&lt;img>');
        console.log([1, img.getAttribute('width'), img.width]);
        img.src = 'http://img01.taobaocdn.com/imgextra/i1/T1s.pHXlFIXXbVn43V_021049.jpg';
        console.log([2, img.getAttribute('width'), img.width]);
        document.body.appendChild(img);
        img.onload = function(){
            console.log([3, img.getAttribute('width'), img.width]);
        }


        // 日志: 1,,0,
        // 日志: 2,720,720,   <---- 图片还没有加载完, 但已经能获得图片宽高
        // 日志: 3,720,720,

width/height 获取并不是当图片加载完成之后设置, 而是一设置 src 后, 发出请求获取图片文件头后, 就能获取其宽高(jpg, png, gif文件头信息中都包含图像宽高信息).
从这点上, IE中, 不用等待图片加载完成就能获取其高宽, 这样有些情况下 onload 都不用写, 可惜~其他浏览器下不能这么做!


* http://stackoverflow.com/questions/226847/what-is-the-best-javascript-code-to-create-an-img-element
* http://dev.gameres.com/Program/Visual/Other/PNGFormat.htm
* http://www.onicos.com/staff/iz/formats/gif.html
