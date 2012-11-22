Cookie
================

:date: 2008-11-27 11:11:59
:tags: Python

之前整理过, 但不怎么明白, 现在再理下~
要实现抓取需要登录的页面, 主要是设置Cookies, 主要过程如下:

1) 了解HTTP协议和cookies相关, 主要是在RFC2965 http://www.faqs.org/rfcs/rfc2965.html 中描述.

    cookies在HTTP消息头部有固定格式, 很多属性是预先定义好的,,,只要遵循这个标准就可.

2) python相关库有: urllib, urllib2, httplib, httplib2, cookielib, ClientCookie, 这些都是python标准库, 其中, 有两个有用的文章

    * Handling Cookies in Python : http://www.voidspace.org.uk/python/articles/cookielib.shtml 讲述一个处理cookies的例子:

    .. sourcecode:: python

        #!/usr/bin/python
        #coding:utf-8
        """
        来自: http://www.voidspace.org.uk/python/articles/cookielib.shtml 上的例子
        """
        import os.path
        import urllib2
        # 要保存的cookies所在文件名
        COOKIEFILE = 'cookies.lwp'
        cj = None
        ClientCookie = None
        cookielib = None
        try:
            # 看cookielib是否可用
            import cookielib
        except ImportError:
            try:
                # cookielib不可用的话, 尝试ClentCookie
                import ClientCookie
            except ImportError:
                # 如果ClientCookie也不可用
                urllopen = urllib2.urlopen
                Request = urllib2.Request
            else:
                # ClientCookie导入,
                urlopen = ClientCookie.urlopen
                Request = ClientCookie.Request
                cj = ClientCookie.LWPCookieJar()
        else:
            urlopen = urllib2.urlopen
            Request = urllib2.Request
            cj = cookielib.LWPCookieJar()
        if cj is not None:
            # 也就是上述成功导入ClientCookie或cookielib
            if os.path.isfile(COOKIEFILE):
                # 已经存在cookie文件了, 则load进来
                cj.load(COOKIEFILE)
            if cookielib is not None:
                # 如果使用cookielib, 需获得HTTPCookieProcessor, 并安装opener
                opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
                urllib2.install_opener(opener)
            else:
                # 如果使用ClientCookie, 同样
                opener = ClientCookie.build_opener(ClientCookie.HTTPCookieProcessor(cj))
                CLientCookie.install_opener(opener)
        theurl = 'http://www.google.com/history/'
        # 如果是POST类型请求, 应使用urllib.urlencod(somedict)
        txdata = None
        # 假装浏览器, a user agent
        txheaders = {'User-Agent':'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20061201 Firefox/2.0.0.6 (Ubuntu-feisty)'}
        try:
            # 创建一个请求对象
            req = Request(theurl, txdata, txheaders)
            # 打开
            handle = urlopen(req)
        except IOError, e:
            print 'Failed to open "%s".' % theurl
            if hasattr(e, 'code'):
                print 'failed with error code - %s.' % e.code
            elif hasattr(e, 'reason'):
                print "The error object has the following 'reason' attribute :"
                print e.reason
                print "This usually means the server doesn't exist,",
                print "is down, or we don't have an internet connection."
            sys.exit()
        else:
            print 'The Headers of the Page:'
            print handle.info()
            # handle.read() returns the page
            # handle.geturl() returns the true url of the page fetched
            # (in case urlopen has followed any redirects, which it sometimes does)
        print
        if cj is None:
            print "We don't have a cookie library available - sorry."
            print "I can't show you any cookies."
        else:
            print 'These are the cookies we have received so far :'
            for index, cookie in enumerate(cj):
                print index, '  :  ', cookie
            cj.save(COOKIEFILE)                     # 保存cookie

* Basic Authentication/Authentication with Python : http://www.voidspace.org.uk/python/articles/authentication.shtml讲述基本认证, 可以是如:

    .. sourcecode:: python

        import urllib2
        theurl = 'www.someserver.com/toplevelurl/somepage.htm'
        protocol = 'http://'
        username = 'johnny'
        password = 'XXXXXX'
        # a great password

        passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
        # this creates a password manager
        passman.add_password(None, theurl, username, password)
        # because we have put None at the start it will always
        # use this username/password combination for  urls
        # for which `theurl` is a super-url

        authhandler = urllib2.HTTPBasicAuthHandler(passman)
        # create the AuthHandler

        opener = urllib2.build_opener(authhandler)

        urllib2.install_opener(opener)
        # All calls to urllib2.urlopen will now use our handler
        # Make sure not to include the protocol in with the URL, or
        # HTTPPasswordMgrWithDefaultRealm will be very confused.
        # You must (of course) use it when fetching the page though.

        pagehandle = urllib2.urlopen(protocol + theurl)
        # authentication is now handled automatically for us

3) 实现抓取web history上的历史搜索关键词, 使用的是cookielib

    .. sourcecode:: python

        try:
            # 登录获取cookies
            cj = cookielib.CookieJar()
            opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
            urllib2.install_opener(opener)

            opener.addheaders = [('User-Agent','Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20061201 Firefox/2.0.0.6 (Ubuntu-feisty)')]
            url_login = 'https://www.google.com/accounts/ServiceLoginAuth?service=hist'
            body = (('Email','shengyan1985@gmail.com'), ('Passwd','...')) # 密码!
            reqlogin = opener.open(url_login,urllib.urlencode(body))  #这时，cookie已经进来了。

            print 'The Headers of the Login Page:'
            print reqlogin.info()
        except:
            sys.exit(-1)

但我认为直接使用Cookie.SimpleCookie直接加入header也可以.