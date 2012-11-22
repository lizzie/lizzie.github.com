Lighttpd
===================

:date: 2009-05-20 12:05:18
:tags: Linux


今天终于面对这个问题了:)

Lighttpd上以fastcgi方式部署Django工程.


超级有用的几个链接
-----------------------

* 官方文档: http://docs.djangoproject.com/en/dev/howto/deployment/fastcgi/
* http://www.javaeye.com/topic/381760

安装过程
-----------------------

1) 安装lighttpd, 下载, 编译, 安装. /usr/local/lighttpd/下
2) flup安装, flup支持fastcgi, scgi, ajp. 直接easy_install flup
3) lighttpd配置文件, 可从解压包中的doc/rc.lighttpd拷贝到/etc/lighttpd/lighttpd.conf, 做如下修改:

    ::

        server.modules              = (
                                       "mod_rewrite",
                                       "mod_access",
                                       "mod_fastcgi",
                                       "mod_simple_vhost",
                                       "mod_evhost",
                                       "mod_accesslog" )
        server.document-root        = "/svn/trunk/mysite"
        ## 主要添加如下的fastcgi配置
        fastcgi.server = (
            "/mysite.fcgi" => (
                "main" => (
                    "host" => "127.0.0.1",  ##　主机地址和端口需要和下面runfcgi指定的一致.
                    "port" => 3033,
                    "check-local" => "disable",
                )
            ),
        )
        alias.url += (
            "/site_media/" => "/svn/trunk/mysite/site_media/"
        )
        url.rewrite-once = (
            "^(/site_media.*)$" => "$1",
            "^/favicon\.ico$" => "/site_media/favicon.ico",
            "^(/.*)$" => "/mysite.fcgi$1",
        )  ## 这样子的url, 就把静态文件请求url直接交给lighttpd来处理, 而其他的剩余的交给manage.py来. 但也可以把所有的东西全部给manage. 这样这里的配置直接写成如下, 不需要alias_url:
        #url.rewrite-once = (
        #    "^(/.*)$" => "/mysite.fcgi$1",
        #)

4) 启动lighttpd, /usr/local/lighttpd/sbin$ sudo ./lighttpd -f /etc/lighttpd/lighttpd.conf & 作为后台进程.

ok


Django工程
-----------------------

1) 以fcgi方式执行: python manage.py runfcgi method=threaded host=127.0.0.1 port=3033 & 同样作为后台进程. 不加&也可.
2) 默认使用的是fastcgi, 也可以指定协议protocol=scgi, 或ajp.


如果
-----------------------

如果以scgi协议来的话,

1) python manage.py runfcgi protocol=scgi method=threaded host=127.0.0.1 port=3033 &
2) 修改lighttpd.conf文件, 如下:

    ::

        server.modules              = (
                                       "mod_rewrite",
                                       "mod_access",
                                       "mod_fastcgi",
                                       "mod_scgi",
                                       "mod_simple_vhost",
                                       "mod_evhost",
                                       "mod_accesslog" )
        scgi.server = (
            "/" => (
                "ServerIPAddress" => (
                    "host" => "127.0.0.1",
                    "port" => 3033,
                    "check-local" => "disable",
                )
            ),
        )
        #alias.url += (
        #    "/site_media/" => "/svn/trunk/mysite/site_media/"
        #)

    但这样之后, 一些静态文件找不到, 尝试加上alias.url,,rewrite, 但貌似都不可以.可能还是哪边写错了.


SCGI
-----------------------

lighttpd的scgi服务器配置,

::

    $HTTP["host"] == "127.0.0.1" {
    $HTTP["url"] =~ "^/site_media/" {
        alias.url = ("/site_media/" => "/svn/trunk/mysite/site_media/")
    }
    else $HTTP["url"] !~ "^/site_media/" {
        scgi.server = ("/" => (
                               ("host" => "127.0.0.1",
                                "port" => 3033,
                                "check-local" => "disable"
                               )
                              )
                      )
    }
    }


可以通过scgi方式进行, 但一个问题是, 访问任何一个路径, 到达scgi服务器之后全解析成根url, 即/, 这应该不是lighttpd配置的问题, 而是scgi服务器中url解析的问题.

通过修改wsgi中WSGIRequest的path和path_info---这似乎是django的一bug, 测试了下wsgi.py中self.path_info和self.path值, 和base.py中打印出callback,
callback_args, callback_kwargs = resolver.resolve(request.path_info)的值, path_info不正确,导致url解析总是/, 返回的callback总是index的一个函数. 所以解决办法就是修改wsgi.py如下:

.. sourcecode:: python

    class WSGIRequest(http.HttpRequest):
        def __init__(self, environ):
            script_name = base.get_script_name(environ)
            path_info = force_unicode(environ.get('PATH_INFO', u'/'))
            print script_name, path_info
            if not path_info or path_info == script_name:
                # Sometimes PATH_INFO exists, but is empty (e.g. accessing
                # the SCRIPT_NAME URL without a trailing slash). We really need to
                # operate as if they'd requested '/'. Not amazingly nice to force
                # the path like this, but should be harmless.
                #
                # (The comparison of path_info to script_name is to work around an
                # apparent bug in flup 1.0.1. Se Django ticket #8490).
                path_info = u'/'
            self.environ = environ
            #self.path_info = path_info
            #self.path = '%s%s' % (script_name, path_info)
            if script_name == path_info:
                self.path_info = path_info
            else:
                self.path_info = '%s%s' % (script_name, path_info)
            self.path = path_info
            print 'after', self.path_info, self.path
            self.META = environ
            self.META['PATH_INFO'] = path_info
            self.META['SCRIPT_NAME'] = script_name
            self.method = environ['REQUEST_METHOD'].upper()
            self._post_parse_error = False
    #...


测试之后, 可以正确找到其他url的对应的函数, 但又有一个问题就是本来在fastcgi下为了禁用自动添加'/'而在settings中添加的一个FORCE_SCRIPT_NAME = ''值, 在这里scgi下必须去掉, 否则仍然转到/.

这个问题非常奇怪, 为何在fcgi下可以, 而在scgi下的获得的path和path_info就不一致呢???