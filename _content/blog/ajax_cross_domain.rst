Ajax Cross Domain
======================================

:date: 2009-12-30 11:12:55
:tags: Javascript


问题
------------------------------

昨天想通过FriendFeed API读取条目到自己的博客中，自然而然想到以前常用的ajax或者get请求。但问题来了，上传之后，总是没有结果显示。不断调试，发现ajax回调之后的readyState为4（表示请求完成，这个没有问题），而奇怪的是status总为0. 正常情况下是http的响应代码，如200，302，404等。而从未有过0的情况。以前用相同的ajax请求也都没有出现这个～ 尝试过浏览器直接访问url，这可以正常访问。

解决
------------------------------

google了很多，找到如下一些：

* http://www.henjiandan.net/yansen/?p=1801 列举了几个出现status为0的情况, 1)本地响应，2)错误路径，3)form表单action为空，4)跟Mysql的默认配置有关。
* http://markos.gaivo.net/blog/?p=109 而这篇博文也关于xhr和status返回0的问题，但同样是在表单提交时误将提交按钮类型写成image。在下面的评论中也有人提到ajax请求本地路径也会导致status为0，"""the status code = 0 is due you are trying to make an ajax request in your local drive files (ie: file:///C:/MyTests/etc) """. 另外一点就是，在表单提交时，若不想使用form的默认提交，则一定要在onsubmit处理函数中return false。

找了一圈，都不是我想要的。于是翻开jquery文档再仔细看。在getJSON中有一段

    在 jQuery 1.2 中，您可以通过使用JSONP 形式的回调函数来加载其他网域的JSON数据，如 "myurl?callback=?"。jQuery 将自动替换 ? 为正确的函数名，以执行回调函数。


"其他网域"? jsonp? callback? .... 原来又是跨域请求导致的! 因为请求的url并不是本域内的url, 而是其他网站中提供的接口, 这一下, 我又想起前前阵子用kissy editor时, 上传图片到另一个域名下, 返回图片url和描述的json格式数据, 但接收时总是报些奇怪的错误, 后来找了很久才知道是跨域引起的, 当时没有找到解决办法.

那现在, 可以使用JSONP形式, 如:

.. sourcecode:: js

    $j.ajax({
        url: "http://friendfeed-api.com/v2/feed/lizziesky/friends?num=6",
        dataType: "jsonp",
        success: function(data){
            $j.each(data.entries, function(i, entry){
                c.append("<li><a href='"+entry.url+"'>"+entry.date+"</a> "+entry.body+"</li>");
            });
        }
    });


这段代码指定数据类型为jsonp, 而在jquery处理时, 会在url中加个callback=?参数, 问号由真正的回调函数jsonp123代替, 这个回调函数jsonp123的名称(数字是递增生成的)和代码都是动态生成。 后台接收这个callback参数后，记下这个jsonp123名称和数据构成js代码jsonp123(data)返回, 且响应头内容是script类型，即直接当作js脚本执行。

整个过程了解之后，就很容易知道jquery提供的所有ajax请求函数（get，getJSON，getScript等等）是如何实现类似的跨域请求，因为他们都是根据最原始的ajax实现的， 第一，url增加callback，第二，后台返回内容的类型为text/script，并且包含正确的函数调用。


举例
------------------------------

这边举个请求flickr图片的例子. flickrAPI文档非常全, http://www.flickr.com/services/api/, 但刚开始看, 完全不知道从何开始.

如果是些公共信息的api(http://www.flickr.com/services/feeds/), 那就直接给出网址, 如 http://api.flickr.com/services/feeds/photos_public.gne?tags=cat&tagmode=any&format=json&jsoncallback=?, 这是查找所有标签为cat的公共图片, 返回格式为json,并定义jsoncallback, 如:

.. sourcecode:: js

    $j.getJSON("http://api.flickr.com/services/feeds/photos_public.gne?tags=cat&tagmode=any&format=json&jsoncallback=?",
        function(data){
            // do something
        });



如果是关于特定用户的东西,

* api请求的格式有REST(最简单的), XML-RPC, SOAP等. 这里拿REST举例, 她的最基本url为 http://api.flickr.com/services/rest/
* 在 http://www.flickr.com/services/api/ 右侧查找你想要的服务, 比如flickr.favorites.getPublicList, 因为是公共的信息不需要验证. 构成method=flickr.favorites.getPublicList
* 如果这个服务需要api_key和user_id, 则需要先申请一个key, 然后加api_key=yourapikey&user_id=youruserid到url中
* 返回格式也有很多种, xml格式居多. 这里还是那json举例. format=json
* 其他参数如, page, per_page, 分别设置页数和每页条目数. per_page=7
* 如果服务需要验证, 区分read, write, delete不同类型权限, 则还要麻烦些. 需要按照 http://www.flickr.com/services/api/auth.howto.web.html 上进行设置.
* 之后, 进行ajax请求,

.. sourcecode:: js

    $j.getJSON("http://api.flickr.com/services/rest/?method=flickr.favorites.getPublicList&api_key=8cbcdeb01bee05294deea64ebabb7244&user_id=26211501%40N07&format=json&per_page=7&jsoncallback=?",
        function(data){
            if (data.stat == "ok"){
            // do something
            }
        });
    // 这里有一点, 如果使用$.ajax, 然后设置dataType为jsonp后,
    //默认的url回调参数为callback, 而flickr后台接收的是
    //jsoncallback(且这个回调函数的名字默认值为"jsonFlickrApi"), 这样不一致了.
    // 但可在js文件中, 可以自行定义jsonFlickrApi().

* 返回的数据, 根据 http://www.flickr.com/services/api/misc.urls.html 组织成图片/网页url.

另外也有人拿豆瓣api做的跨域请求例子: http://www.cnblogs.com/fire-phoenix/archive/2009/11/13/1614143.html
里面也提到了 script 标签对 javascript 文档的动态解析（也可以用eval函数）。


资料
----------------------

* json/jsonp和跨域英文介绍: http://www.ibm.com/developerworks/library/wa-aj-jsonp1/
* 关于jsonp的使用和跨域中文介绍: http://kingapex.javaeye.com/blog/404300
* JSON类型返回介绍: http://simonwillison.net/2009/Feb/6/json/
* JSONRequest: http://www.json.org/JSONRequest.html