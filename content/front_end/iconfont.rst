IconFont
==============================

:date: 2013-03-22 16:59:59
:tags: note

昨天看到 `AliceUI <http://aliceui.org>`_ 上提供了一套图标集 Rei, 起初我以为就是一个 CSS Sprites, 查看了下源代码, 发现原来是一套字体, 有专门的名称 -- Icon Font.
这样, 只需自己制定一套字体, 页面载入这套字体, 直接输入对应的字符就能显示对应的图标. 因为是矢量的, 所以可以任意缩放, 着色也行, 非常方便. 具体在页面中如何使用, 可以查看这个 `简单的介绍 <http://css-tricks.com/html-for-icon-font-usage/>`_ .

不过我想学的是, 如何去做一套这样的字体? 因为小时候一直蛮喜欢各种西文字体的, 想着若以后能发明一套字体该多好, 有时, 也会在纸上涂鸦, 或者打开个 AI, 胡乱画一通, 可最终生成的只是一个图片, 没法和字体挂钩.

现在看到了 icon font, 又继续有了我去学做字体的动力, 于是乎, 找到这篇 `基础教程 <http://www.webdesignerdepot.com/2012/01/how-to-make-your-own-icon-webfont/>`_ .

教程非常简单, 一步步也很详细:

- 使用的是 Inkscape 的 SVG Font Editor, 来编辑最基本的图像, 最终生成的是一份标准的 SVG 文档;
- 在使用 `SVG转Font <http://www.freefontconverter.com/>`_ 工具来生成 .ttf;


这就搞定啦!

秀下我画了两个小时的一个"设计"的字符 -- S.


.. raw:: html

    <iframe src="/test/iconfont.html" width="300px" height="728px"></iframe>

貌似还是很难看...只能继续努力提高自身的设计美感啦~

PS: 找到一个网站 `fontello.com <http://fontello.com/>`_ 上有好多图标字体, 以后可以不用拼这种类似的图标啦;