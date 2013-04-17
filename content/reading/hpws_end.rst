HPWS END
===================

:date: 2009-04-12 14:04:14
:tags: Javascript, note


YSlow: http://developer.yahoo.com/yslow/

YSlow做了哪些工作进行测试? YSlow crawls the page's DOM to find all the components in the page. It uses XMLHttpResponse to find the response time and size of each component, as well as the HTTP response headers. This, along with other information gathered from parsing the page's HTML is used to score each rule. The overall YSlow grade is a weighted average of each rule's score. YSlow provides other tools as well, including a summary of the page's components and an analysis of all the JavaScript in the page using JSLint http://jslint.com

剩余的内容介绍了几个主要网站的YSlow评测结果, 并提出一些改进建议. 其中评测分数最高的是Google, page weight就十几k, Response time才1.7秒, HTTP requests为3, 主要还是本身页面上东西就不多. 所以...
其中看到一个特别的地方,

.. sourcecode:: html

    <script type="text/javascript" defer><!--
        function qs(el){...}
    //-->
    </script>

Using the DEFER attribute avoids possible rendering delays by telling the browser to continue rendering and execute the JavaScript later, the justification for using it with an inline script may be that parsing and excuting the JavaScript code could delay rendering the page. In this case, however, a problem is that after this SCRIPT block, ...

::

    some keywords
    Amazon: heavy page, Gzip the components, add a far future Expires.
    AOL: HTTP requests are made sequentially, so parallelization.
    CNN: heavies page, so many images
    eBay: IFrames(ecah IFrames is an additional HTTP request that typically is not cached. IFrames contains the Javascript code.)
    Google: preload,
    MSN: IFrames...rule 1, 3, 4, 9, 10, 13
    MySpace: rule 1, 3, 9, 10
    Wikipedia: reduce the HTTP requests. Expires header. Gzipped. PNG优化(PngOptimizer http://psydk.org/PngOptimizer.php)
    Yahoo: Minifying the HTML document
    YouTube: parallelization, dns lookups, Expires, Etags.

The End


晕也, 看完这书才发现网上已有中文版的网页加速的14条优化法则 http://java-guru.javaeye.com/blog/138659
另外, 原来这个就是CSS sprite http://www.xxcss.com/html/7/0/672/1.htm