URL Fetch
================

:date: 2008-11-11 14:11:39
:tags: GAE, Python

URLFetch使用示例

一般使用就是直接使用urlfetch.fetch(url), 返回一个ResponseObject,其中有content, status_code等,基本使用请看对应文档 http://code.google.com/appengine/docs/urlfetch/
其中想要fetch需要登录的页面,似乎不是那么简单.依次尝试以下:

1) 使用curl

使用现成的curl模块, 参考 http://curl.haxx.se/docs/httpscripting.html还未尝试.

2) 添加cookie进行自动登录

网上一段示例代码片段

.. sourcecode:: python

    cj = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    exheaders = [("User-Agent","Mozilla/4.0 (compatible; MSIE 7.1; Windows NT 5.1; SV1)"),]
    opener.addheaders=exheaders
    url_login = 'http://xiaonei.com/Login.do'
    body = (('email','xxxxx@gmail.com'), ('password','*********')) #TODO:更改登录名和密码

    req1 = opener.open(url_login, urllib.urlencode(body))  #这时，cookie已经进来了。

可以看到,直接将用户名和密码放在请求头中了.

3) 另外一个设置cookie实现登录

.. sourcecode:: python

    #!/usr/bin/env python
    #coding=utf-8
    import urllib2,cookielib
    import urllib
    from BeautifulSoup import BeautifulSoup
    cookie=cookielib.CookieJar()
    opener=urllib2.build_opener(
    urllib2.HTTPCookieProcessor(cookie))
    urllib2.install_opener(opener)

    postdata=urllib.urlencode({'username':'python-
    cn','password':'aaaaaa'})
    login_response= urllib2.urlopen('http://www.meizu.com/bbs/
    login.asp' ,postdata)

    ww=open('f.html', 'w')
    url_us=r"http://www.meizu.com/bbs/infolist.asp?t=toplist&orders=7"
    page=urllib2.urlopen(url_us)
    soup=BeautifulSoup(page)
    ww.write(str(soup))
    ww.close()

还是将帐号密码放在代码里了....

以上都是直接增加cookies,,,而想要的认证方式,后来发现是例如这样的.

* google帐号授权 http://code.google.com/apis/accounts/docs/AuthSub.html
* http://code.google.com/apis/gdata/auth.html#AuthSub
* http://code.google.com/intl/zh-CN/appengine/articles/gdata.html
* http://code.google.com/appengine/docs/usinggdataservices.html
* http://code.google.com/apis/gdata/articles/python_client_lib.html
* http://code.google.com/apis/gdata/authsub.html
* http://code.google.com/apis/gdata/

,,,还没弄明白.待续...