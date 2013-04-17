HPWS 7
===================

:date: 2009-03-23 14:03:14
:tags: Javascript, note

Rule 8: Make JavaScript and CSS External

Inline vs. External

Inlined JS and CSS: http://stevesouders.com/hpws/inlined.php
External JS and CSS: http://stevesouders.com/hpws/external.php
可以看到Inline更快点.

虽然inline的页面和external页面总得加起来的字节数是相同的, 但之前也说到过. 分成多个文件可以并行的下载. The inline example is faster than the external one is because the external example suffers from the overhead of multiple HTTP requests. But, the external example benefits from the stylesheet and scripts being downloaded in parallel.
另外一方面, 涉及到cache. JavaScript和CSS文件可能会被浏览器缓存, 那么这样对html页面来说就快多了. 而不是每次都要下次inline在html页面中的js和css了.

具体考虑还得结合以下几个实际因素:

* Page Views: 如果某个用户频繁访问, 那么, 浏览器很可能存在一些js和css文件,那么用External更有利, 反之, 用户的Page Views越少, 比如说一个月甚至更长时间才访问一次, 那么浏览器中估计全被冲掉了, 所以使用inline还是很好的.
* Empty Cache vs Primed Cache: 这里还是得考虑网站的类型, 和用户的访问习惯,,,

Knowing these statistics helps in estimating the potential benefit of using external files versus inlining. If the nature of your site results in higher primed cache rates for your users, the benefit of using external files is greater. If a primed cache is less likely, inlining becomes a better choice.

Component Reuse 重用

很显然的, external方式更利于重用. 而这里, 文件的分割, 合并程度也比较重要. 如,到底是将所有页面的js放在一块,还是分开成各个部分, 分开了, 里面相同的部分是否提取出来放于独立的文件中. 放在一起好处是fewer files(请求少), 坏处是有些页面用不着这个文件中的所有东西, 这会增加数据下载字节数. 不放在一起好处就是重用程度高, 但the downside of this is that every page subjects the user to another set of external components and resulting HTTP requests that slow down response times.
统一考虑, 也就是The best answer is a compromise.


The Best of Both Worlds

Post-Onload Download: http://stevesouders.com/hpws/post-onload.php
像Home page, that are the first of many page views, we want to inline the js and css for the home page, but leverage external files for all secondary page views. This is accomplished by dynamically downloading the external components in the home page after it has completely loaded(via the onload event). 对应的js代码

.. sourcecode:: html

    <script>
    function doOnload() {
        // Do the downloading awhile AFTER the onload.
        setTimeout("downloadComponents()", 1000);
    }

    window.onload = doOnload;

    // Download external components dynamically using JavaScript.
    function downloadComponents() {
        downloadCSS("http://stevesouders.com/hpws/testsm.css?t=1237818511");
        downloadJS("http://stevesouders.com/hpws/testsma.js?t=1237818511");
        downloadJS("http://stevesouders.com/hpws/testsmb.js?t=1237818511");
        downloadJS("http://stevesouders.com/hpws/testsmc.js?t=1237818511");
    }

    // Download a stylesheet dynamically.
    function downloadCSS(url) {
        var elem = document.createElement("link");
        elem.rel = "stylesheet";
        elem.type = "text/css";
        elem.href = url;
        document.body.appendChild(elem);
    }

    // Download a script dynamically.
    function downloadJS(url) {
        var elem = document.createElement("script");
        elem.src = url;
        document.body.appendChild(elem);
    }
    </script>


可以看到, 在页面load之后的1秒开始下载其他东西, 想想也是的, 用户在自己home页面浏览的同时去下载这些js和css, 那么进入相关的页面就快多了

Dynamic Inlining
The home page server can make a decision about inlining based on the absence or presence of the cookie. 为什么和cookie扯上关系呢? If the cookie is absent, the js or css is inlined. If cookie is present, it's likely the external component is in the browser's cache and external files are used. 也还是说, 如果cookie存在, 就有可能浏览器中已经包含相关静态文件, 如果不存在,那么可以用inline方式会更快.

Dynamic Inline: http://stevesouders.com/hpws/dynamic-inlining.php

// 原文是php实现, 大概思想是
判断cookie是否存在, 是:
    包含css/js文件
不是:
    直接写入css/js内容, 同时在onload事件中加入下载静态文件的处理.


这个不错,,,根据cookie来选择, 不过这是基于存在cookies代表cache中已有相关文件的假设了.

总结一下的话, 涉及到重用性, 速度, cookie, Page Views, Cache这么多.