hmac和HttpResponse
==============================

:date: 2009-07-25 09:07:22
:tags: Javascript

1) hmac 使用的时候碰到一个错误

    .. sourcecode:: js

        try:
            hmacv = hmac.new(keyValue, args).hexdigest().lower()
        except Exception,e:
            print e
            hmacv = ''

输出异常: character mapping must return integer, None or unicode. 原来在linux下一直没有发现这个问题, 今天切换到windows, 居然出现, 导致签名无法生成.

后来找到issue http://bugs.python.org/issue5285 原来是在python2.6下不能对unicode字串处理. 而python2.5倒是可以. 既然这样, 索性把2.5下的hmac拷贝出来放在自己的库下使用, 一切ok...

2) HttpResponse

对于HttpResponse, 之前一向简单的使用 HttpResponse("something") 方式调用. 那如果碰到想让返回的内容指定编码, 或者说是http返回头中指定字符集. 可以指定content_type. 如:

        .. sourcecode:: js

            return HttpResponse(MakoTemplate(templatename="pay2.htm",
                 encode="gbk",
                 ruser=ruser,
                 pm=pm,
                 app_path=app_path,
                 ).decode("utf-8").encode("gbk"), content_type="text/html;charset=gbk")

这样返回的就是gbk编码的html文本.
之前一直以为得把整个模板保存成gbk,然后mako的输入输出编码集也指定gbk, html头部声明gbk, 可后来总还是出来的是乱码...想了头都大了. 原来只要这么简单.