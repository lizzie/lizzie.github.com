Doctype
=======================

:date: 2010-08-13 08:08:14
:tags: HTML


之前讲过如何使用 `timeplot <http://www.simile-widgets.org/timeplot/docs/>`_  , 没想到时隔多日, 到线上之后出问题.

1) 问题: 区域背景不能透明, 导致显示在前面的数据遮盖了后面的数据.

    解决: 因为timeplot没有提供设置背景透明度的接口, 所以只能将fillcolor去掉, 只显示出线条颜色.

2) 问题: IE8下显示不出图形来, 但诡异的是IE6, IE7竟然可以显示.

    怀疑: 刚开始以为是不是js的问题, 或者是异步读取数据时错误, 导致没有读到数据, 但后来使用测试数据也是如此; 但诡异的是, 做的demo可以显示, 那就不应该是js的问题, 因为两者用的是同一个js文件. 后来看页面源代码. 哦!!! 才发现. demo当时简略, 没有写完整的html结构, 而线上页面结构完整.

    尝试: 于是乎, demo上加入 <!doctype html> 等, 之后, demo在IE8下也不能显示了. 而html标签没问题, 那就在于这个doctype标签了.


关于doctype, 是用来告诉浏览器, 当前文档使用哪个Html或者XHtml规范.
HTML 4.01/XHTML 有strict, transitional, frameset; 不同浏览器支持的模式也不一样.
详细的见 http://www.upsdell.com/BrowserNews/res_doctype.htm


IE系列 `有点特殊 <http://msdn.microsoft.com/en-us/library/cc288325%28VS.85%29.aspx>`_:

IE6默认使用 "Quirks mode" 而不是 "Standards mode" , 或者当页面使用的doctype, 她不认识的话也会使用 "Quirks mode" ;
IE7更加符合工业标准, 支持 quirks mode 和 standards mode, 但IE7 的 standards mode 替代 IE6的 standards mode ;
IE8, 为了保持 document compatibility , 提供使用meta 添加 X-UA-Compatible 来让以前网页使用低版本的IE来解析.
X-UA-Compatible的值有:

* Emulate IE8 mode : Standards mode directives are displayed in Internet Explorer 8 standards mode and quirks mode directives are displayed in IE5 mode.
* Emulate IE7 mode : Standards mode directives are displayed in Internet Explorer 7 standards mode and quirks mode directives are displayed in IE5 mode.
* IE5 mode : Internet Explorer 7's quirks mode
* IE7 mode renders content as if it were displayed by Internet Explorer 7's standards mode, whether or not the page contains a directive.
* IE8 mode provides the highest support available for industry standards,

如

    .. sourcecode:: html

        <meta http-equiv="X-UA-Compatible" content="IE=4">   <!-- IE5 mode -->
        <meta http-equiv="X-UA-Compatible" content="IE=7.5" > <!-- IE7 mode -->
        <meta http-equiv="X-UA-Compatible" content="IE=100" > <!-- IE8 mode -->
        <meta http-equiv="X-UA-Compatible" content="IE=a" >   <!-- IE5 mode -->

        <!-- This header mimics Internet Explorer 7 and uses
             <!DOCTYPE> to determine how to display the Web page -->
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" >

而在下面, 我又看到了最为关键的一段话

    When Internet Explorer 8 encounters a Web page that does not contain an X-UA-Compatible header, it uses the <!DOCTYPE>  directive to determine how to display the page. If the directive is missing or does not specify a standards-based document type, Internet Explorer 8 displays the page in IE5 mode (quirks mode).

    IE8下如果没有X-UA-Compatible, 会使用doctype, 如果没有指定doctype, 那么会使用 quirks mode.

    If the <!DOCTYPE> directive specifies a standards-based document type, Internet Explorer 8 displays the page in IE8 mode, except in the following cases:
    除以下情况外, IE8都会使用标准模式, 主要是关于兼容性视图的.

    * Compatibility View is enabled for the page.
    * The page is loaded in the Intranet zone and Internet Explorer 8 is configured to pages in the Intranet zone in Compatibility View.
    * Internet Explorer 8 is configured to display all Web sites in Compatibility View.
    * Internet Explorer 8 is configured to use the Compatibility View List, which specifies a set of Web sites that are always displayed in Compatibility View.
    * The Developer Tools are used to override the settings specified in the Web page.
    * The Web page encountered a page layout error and Internet Explorer 8 is configured to automatically recover from such errors by reopening the page in Compatibility View.

那既然这个timeplot产生的页面, IE7下ok, 那么就可以让IE8以IE7的模式显示.

解决:

    .. sourcecode:: html

        <meta http-equiv="X-UA-Compatible" content="IE=7.5" >

timeplot使用canvas生成图形, 但如果对于那些不支持canvas的浏览器来说, 会产生一大堆的自定义标签, 可能就是因为这些, 导致如果IE8下只是用标准模式就不能正常解析了.
