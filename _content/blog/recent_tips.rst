近期一些Tips
=======================

:date: 2010-09-03 13:09:32
:tags: CSS

* JS 访问被拒, 很有可能是跨域引起的.
* a的target值可取:

    * _blank 总在一个新窗口/新标签页中打开文档.
    * _self 默认值, 在当前这个页/框架上打开.
    * _parent 在父窗口/框架中打开.
    * _top 清除现有所有被包含的框架, 在整个窗口中打开.
    * framename 在名字为framename的框架中打开.

* position

    * position: relative, 是说相对于正常情况下该元素在文档流中的位置而言, 仍占据原来元素在文档流的位置. 设置left,top, right, bottom, 可是长度, 百分比, auto;
    * position: absolute, 是**完全**移出文档流, 不占据元素原来在文档流中的位置;
    * position: static, 默认值, 元素在预设的地方, 就是正常出现在文档流中的位置;

    父容器设置relative之后, 其内部元素随之relative, 如果再设置子元素absolute, 就可以定位到父元素的任意位置. http://www.w3.org/TR/CSS2/visuren.html#positioning-scheme

* 设置背景透明

    * background: rgba(122, 122, 122, .5);
    * 不支持rgba的IE使用

    .. sourcecode:: css

        filter: progid:DXImageTransform.Microsoft.gradient(startColorStr='#7f7A7A7A',EndColorStr='#7f7A7A7A');

    渐变使用的时候, 要注意被设置元素hasLayout, 加个zoom:1, 或者设置一下height就可以, 不然渐变会出不来, 估计渐变是需要计算高度才能渲染出来, 不然未知高度下也不好确定渐变幅度什么的.

