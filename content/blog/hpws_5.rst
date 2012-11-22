HPWS 5
===================

:date: 2009-03-19 13:03:13
:tags: Javascript, note


Rule 5: Put Stylesheets at the Top
Rule 6: Put Scripts at the Bottom
这两条比较简单,　就是将,　将样式放在页面的顶部,　而脚本放在页面的底部.

一些原因:

1) 页面各部分的下载顺序, 一般情况下是按照他们在文档中的出现顺序的.
2) 最好能让浏览器尽快的显示内容. This is especially important for pages with a lot of content and for users on slower Internet connections. When the browser loads the page progressively, the header, the navigation bar, the logo at the top, etc. all serve an visual feedback for the user who is waiting for the page.
3) Rule 5 has less to do with the actual time to load the page's components and more to do with how the browser reacts to the order of those components. The browser delays showing any visible components while it and the user wait for the stylesheet at the bottom.----"blank white screen."

例子:

* CSS at the Bottom: http://stevesouders.com/hpws/css-bottom.php
* CSS at the Top: http://stevesouders.com/hpws/css-top.php
* CSS at the Top Using @import: http://stevesouders.com/hpws/css-top-import.php 这种显示所有图片最快

.. sourcecode:: html

    <style>
    @import url("style.css");
    </style>

另外, Flash of Unstyled Content

例子:

* CSS Flash of Unstyled Content: http://stevesouders.com/hpws/css-fouc.php 看到了? 当页面下载完成后, 浏览器重新渲染页面.

解决这两个问题的rule就是: Put your stylesheets in the document HEAD using the LINK tag.

对于Scripts, 先看例子

* Scripts in the Middle: http://stevesouders.com/hpws/js-middle.php

    这导致两个问题1: Everything below the script won't render until the script is loaded;
    2:All components below the script don't start downloading until the script is done.

    可以并行的下载各个components, 这些components是具有不同的hostname,
    也就是说, browsers download two components in parallel per hostname.

* Scripts Block Downloads: http://stevesouders.com/hpws/js-blocking.php

    However, parallel downloading is actually disabled while a script is downloading--the browser won't start any other downloads, even on different hostnames.
    这是因为, the script may use document.write to alter the page content, so the browser waits to make sure the page is laid out appropriately. And the browser blocks parallel downloads then scripts are being loaded is to guarantee that the scripts are executed in the proper order.
    If multiple scripts were downloads in parallel, there's no guarantee the responses would arrive in the order specified. 就是说script的下载都是顺序执行的, 这才能满足之间的前后依赖关系.

    Scripts at the Top: http://stevesouders.com/hpws/js-top.php
    可以看到, 整个页面一直被阻断, 直到scripts下载完毕. 如果这个script下载的很慢, 那么页面就一直显示着空白,,,这是太糟糕了.

    Scripts at the Bottom: http://stevesouders.com/hpws/js-bottom.php
    这个明显快多了...

    Scripts Top vs Bottom: http://stevesouders.com/hpws/move-scripts.php
    scripts在顶部和底部的对比. 结果非常明显.

    In some situations, it's not easy to move scripts to the bottom,
    eg, the scripts uses docuemnt.write to insert part of the pages's content, it can't be moved lower in the page....
    the way is using deferred scripts. The DEFER attibute indicates that the script does not contain document.write, and is a clue to browsers that they can continue rendering.

    Deferred Scripts: http://stevesouders.com/hpws/js-defer.php
    使用就是类似如下的

    .. sourcecode:: html

        <script src="/bin/sleep.cgi?type=js&sleep=10&expires=-1&last=0" defer></script>

But,,,,The DEFER attribute for scripts doesn't solve the issues.
In Firefox, rendering and downloads are still blocked. In IE, the script is still downloaded, taking up one of the two download slots for that hostname.

虽然最后一种情况比较特殊外, 总得来说,,Move scripts to the bottom of the page