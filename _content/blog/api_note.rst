API Notes
===================

:date: 2009-12-26 14:12:10
:tags: Python, GAE, note


Gravatar Api
-------------------------

* 它提供的是让用户在留言时显示自己的头像图片服务.
* 小巧, 不罗嗦.
* 简单介绍: 某用户在博客上留言, 留下email, 根据这个email, 计算对应的md5, 构成url请求该用户的avatar图片. 如果这个用户是gravatar注册用户, 并且对应这个email有设置图片的话, 就会返回这幅图片给博客程序. 如果不是有效用户, 则会转到博客程序默认使用的avatar路径. 对于博客应用来说, 只需要按照一定格式构成url即可, 而对于某个用户来说, 只需要注册gravatar帐号并上传图片即可.
* Gravatar: http://www.gravatar.com
* Gravatar API: http://en.gravatar.com/site/implement/
* Python实例: http://en.gravatar.com/site/implement/python

Bluga Api
-------------------------

* 提供将网页生成一缩略图的服务.
* 有所限制, 一个注册用户一个月只能提交请求100. (ps: 今天一天一下子用掉一半). 而且比较麻烦, 首先标准api下, 请求正文以xml格式, 请求分为提交任务请求, 获取结果请求, 查询状态等, 一般是需要请求两次才能获取到图片, 速度貌似有点慢, 因为第一次请求返回时有时间规定期间不能重提交任务, 所以只能等待之后再获取截图(估计是图片处理向来比较耗时的原因). 而简单api下, 提供url, size只有small, medium1, medium2, large, 不能指定截图位置, 还需计算url hash值, 包含key, 当前时间和待截图url. cache表明过期时间.
* Bluga: http://webthumb.bluga.net/
* Bluga API: http://webthumb.bluga.net/api
* Python实例: http://www.rossp.org/blog/2007/jun/13/using-webthumb-api-python/

Google Custom Seach Engine
------------------------------------

* 在http://www.google.com/cse/上创建一个就可以了, 然后虽然有提供js代码, 但生成出来的html代码可能和自己的很不协调, 所以可以直接将自定义搜索引擎上的form代码拷贝下来, 自己再定义样式, 其中的一些hidden值不能落掉.

GAE memcache
-------------------------

* GAE上使用memcache缓存: http://code.google.com/intl/zh-CN/appengine/docs/python/memcache/overview.html, 提供的接口也是很简单. 类似下面的代码就可以实现:

    .. sourcecode:: python

        def get_data():
          data = memcache.get("key") # 获得key对应的值
          if data is not None:
            return data
          else:
            data = self.query_for_data()
            memcache.add("key", data, 60) # 增加key, 对应的值为data, 过期时间为60秒.
            return data

* 还可以设置多值key-value
* 里面有个问题: 那就是如何清空缓存? 貌似后台没有...


sphinx
-------------------------

* 新版的sphinx支持自定义页面样式, 只需在conf.py中设置html_theme_path为寻找主题路径, 设置html_theme为主题名称. 每个主题下都有theme.conf指定页面整体布局是哪种, css文件是哪个, pygments的风格是哪种, 或者在这个文件中直接设置css_t文件中的变量值. 这个相当于一个css文件的模板,只是这个文件需要变量解析成最终的css文件.
* 关于主题设置可以详见: http://sphinx.pocoo.org/theming.html