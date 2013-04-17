RSS
================

:date: 2008-10-27 12:10:17
:tags: GAE, Python

Django中的RSS实现

文档参考：http://www.djangoproject.com/documentation/0.96/syndication_feeds/

首先使用现成的 django.contrib.syndication.views.feed，

.. sourcecode:: python

    (r'^feeds/(?P<url>.*)/$', 'django.contrib.syndication.views.feed', {'feed_dict': feeds}),

Django中有现成的方法提供RSS，即提供高层的框架，也提供低层框架。
具体可以参考djangoproject上的例子，在这列出几个注意点：

.. sourcecode:: python

    feeds = {
    'latest': LatestEntries,
    'categories': LatestEntriesByCategory,
    }

中的latest这个是对应于templates／feeds／中的模板前缀名，模板里面写的obj.xx是models中的相应字段xx

* RSS定义里面的item，直接使用items函数，这个里面可以去获取models中的表字段
* 获取link，首先去寻找每项的get_absolute_url，如果没有定义，则会去找item_link
* RSS 中每项都有title，description，link还有语言等，这些都有默认值，自己设置后，请求feedsurl之后，返回的是个像上述样子的 xml文档，也就是说，只要符合这个xml文档的书写规则，就可以自定义生成feed，而不必依赖于django的 django.contrib.syndication.views.feed
* 同样，RSS阅读器其实也是解析这个xml文档，但里面一个非常要考虑的东西是feed时间更新问题

GAE上的Feed
由于GAE上不能直接使用django中的feed，所以尝试自己实现提供Feed
提供Feed本质上只要response出来的东西符合上述xml文档格式就ok
所以可以尝试使用feedgenerator这个低层，或者直接套模板，也就是将xml当成模板做：

.. sourcecode:: xml

    <?xml version="1.0" encoding="utf-8"?>
    <rss version="2.0">

    <channel>
        <title>LizSky</title>
        <link>http:/lizziesky.appspot.com/</link>
        <description>lizzie's blog</description>
        <language>zh_CN</language>
        {% for i in entry %}
        <item>
            <title>{{ i.title }}</title>
            <link>http:/lizziesky.appspot.com/blog/post/{{ i.key.id }}/</link>
            {% load my_filter %}
            <description>{{ i.body|post_body_style }}</description>
        </item>
        {% endfor %}
    </channel>
    </rss>


然后在view中

.. sourcecode:: python

    def get_feeds(request):
        entry = Entry.all().order('-pub_date')[:10]
        return render_to_response("blog/feed.html", {"entry":entry})


把她当成普通模板做，呵呵，似乎一切ok，不过有个问题是模板中可以用自定义filter也可以。