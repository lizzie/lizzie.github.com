JS & CSS Notes
===================

:date: 2010-04-19 08:04:32
:tags: Javascript, CSS, note


近期笔记整理, 大多关于js, css... 有兴趣的, 可以深入下去


理解JavaScript面向对象的思路
------------------------------------------

http://www.cnblogs.com/winter-cn/archive/2009/05/16/1458390.html

js 中的类型布可扩展, 无法添加新的类型. js设计了6种数据类型: Boolean, Number, String, Null, Undefined, Object.

js允许对一个已经创建的对象添加/删除属性. 对一个不存在的属性赋值即向其添加属性, delete关键字被用于删除属性.

js引入原型(prototype), 对每个对象规定一个私有属性, 当读取一个对象的属性时, 如果对象本身没有这个属性, 会访问这个prototype. prototype所指向的对象仍然可以有prototype, 链式操作, 直到找到这个属性或者prototype为空, 所以常听到prototype链的说法. 防止prototype出现循环, js引擎会在任何对象的prototype属性被修改时检查.


__proto__

js规定一个内建对象作为所有对象的最终 prototype, 也就是说即使用{}创建的对象, 也会有prototype指向这个内建对象.
js中, 函数仅仅是一种特殊的对象, js设计了()运算符和function关键字让js的函数看起来更像是传统的语言, 只要实现了私有方法call的对象都被认为是函数对象,, 这与Function.prototype.call不是同一回事.

new会调用私有方法construct, 实现了construct的对象都可以被new接受, js并没有额外提供构造这种对象方法, 所以所有通过function关键字构造的函数对象被设计成实现了construct方法. 这也就是js的new很奇怪地针对函数的原因. 并非只有函数可以被new, js的宿主环境可能提供一些其他对象, 典型的例子是IE中的ActiveXObject.

所有函数的 construct方法都是类似的, 创建一个新对象, 将它的prototype设为函数对象的共有属性prototype, 以新对象作为this指针的值., 执行函数对象. 拥有共同的原型prototype, 被同一函数处理.

    .. sourcecode:: js

        Function.prototype.prop = 1;
        alert(Object.prop)
        alert(Function.prop)
        Object.prototype.prop = 1;
        alert(Object.prop)
        alert(Function.prop)
        Function.__proto__.prop = 1;
        alert(Object.prop)
        alert(Function.prop)
        function Class() {
        }

        Class.prototype = Class;
        Class.__proto__.prop = 1
        alert((new Class).prop);
        function Class() {
        }

        Class.prototype = Class.__proto__;
        Function.prototype.prop = 1;
        alert((new Class()).prop)
        function Class() {
        }

        Class.prototype.__proto__.prop = 1;
        Class.prototype = new Class;
        alert((new Class).prop);


如何减少浏览器repaint和reflow
------------------------------------------

* 原文链接: http://blog.csdn.net/baiduforum/archive/2010/03/25/5415527.aspx
* Understanding Internet Explorer Rendering Behaviour: http://blog.dynatrace.com/2009/12/12/understanding-internet-explorer-rendering-behaviour/
* Notes on HTML Reflow: http://www.mozilla.org/newlayout/doc/reflow.html
* Efficient JavaScript: http://dev.opera.com/articles/view/efficient-javascript/?page=3#reflow


when repaint/reflow
------------------------------------------

* dom元素的添加,修改(内容), 删除(reflow+repaint)
* 仅修改dom元素的字体颜色, 这个只有repaint, 不需要调整布局
* 应用新的样式或者修改任何影响元素外观的属性
* resize 浏览器窗口, 滚动页面
* 读取元素的Layout属性(offsetLeft, offsetTop, offsetHeight, offsetWidth, scrollTop/Left/Width/Height, clientTop/Left/Width/Height, getComputedStyle(), currentStyle(in IE)), 这点在测试中并没有体现出来.


一款强大的性能分析工具, dynaTrace http://www.dynatrace.com/en/,,, 可以看到页面的展示情况.
测试发现, 只要修改元素的cssText属性, 不论它值是什么, 都会导致浏览器reflow和repaint, 因此在某些时候选择特定的样式属性赋值会有更好的效果.
每一个渲染动作并不是立即执行, 而是维护一个渲染任务对象, 浏览器根据具体的需要分批集中执行其中的任务(定期调度). 脚本中的某些操作会导致浏览器立即执行渲染任务, 如读取元素的Layout属性.


优化注意
------------------------------------------

1) 避免在document上直接进行频繁的DOM操作, 如果确实需要, 可以采用off-document的方式进行:

    * 先将元素从document中删除, 完成修改后再把元素放回原来的位置.
    * 将元素的display设置为"none", 完成修改后再把display修改为原来的值
    * 如果需要创建多个dom节点, 可以使用documentFragment创建完后一次性的加入document, 如下例.

    .. sourcecode:: js

        function appendLast() {
            var frag = document.createDocumentFragment();
            for (var i = 5000; i--; ) {
                var n = document.createElement("div");
                n.innerHTML = "node" + i;
                frag.appendChild(n);
            }
            document.body.appendChild(frag);
        }


2) 集中修改样式

    * 尽可能少的修改元素style上的属性;
    * 尽量通过修改className来修改样式;
    * 通过cssText属性设置样式值.

3) 缓存Layout属性值

    * 多次访问则可以在一次访问时先存储到局部变量中, 之后读取这个局部变量值. 避免每次读取属性时造成浏览器的渲染.


4) 设置元素的position为absolute或fixed

    * 在元素的position为static和relative时, 元素处于Dom树中, 当对元素的某个操作需要重新渲染, 浏览器会渲染整个页面, 而将position设置为absolute和fixed可以使元素从Dom树结构中脱离出来独立的存在, 渲染时只需要渲染该元素以及位于该元素下方的元素...


最后介绍两个工具, 一个是css3 生成样式的网站, 另外一个随机生成文字.

CSS3 Generator
-----------------------

1. CSS3 Generator: http://css3generator.com/
2. CSS3 Gradient Generator: http://gradients.glrzad.com/
3. CSS3 Sandbox: http://westciv.com/tools/index.html
4. CSS Border Radius: http://border-radius.com/
5. Font-Face Kit Generator: http://www.fontsquirrel.com/fontface/generator
6. Border Image Generator: http://www.incaseofstairs.com/border-image-generator/} 话说border上的图片貌似怎么弄都不好看,,,这特性有必要么?
7. Cross Browser CSS3 Rule Generator: http://css3please.com/

PS下: 淘宝首页的工具条上的下拉菜单小按钮, 鼠标hover上去可以看到小按钮旋转的效果, 挺精致的. 它使用的是

    .. sourcecode:: css

        #site-nav .menu-hd b {
          position: absolute;
          right: 10px;
          top: 11px;
          width: 0;
          height: 0;
          border-width: 4px 4px;
          border-style: solid;
          border-color: #1f3d99 #f7f7f7 #f7f7f7 #f7f7f7;
          font-size: 0;
          line-height: 0;
          -webkit-transition: -webkit-transform .2s ease-in;
          -moz-transition: -webkit-transform .2s ease-in;
          -o-transition: -webkit-transform .2s ease-in;
          transition: -webkit-transform .2s ease-in;
        }

        #site-nav .hover .menu-hd b {
          border-color: #1f3d99 #fff #fff #fff;
          -moz-transform: rotate(180deg);
          -moz-transform-origin: 50% 30%;
          -webkit-transform: rotate(180deg);
          -webkit-transform-origin: 50% 30%;
          -o-transform: rotate(180deg);
          -o-transform-origin: 50% 30%;
          transform: rotate(180deg);
          transform-origin: 50% 30%;
          filter:progid:DXImageTransform.Microsoft.BasicImage(rotation = 2);
          top: 7 px\9;
        }


moretext
-----------------------

http://more.handlino.com/ 网页中随机生成一段中文文字,

    .. sourcecode:: html

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
        <script src="http://more.handlino.com/javascripts/moretext-1.0.js" type="text/javascript"></script>

        <span class="lipsum"></span>

