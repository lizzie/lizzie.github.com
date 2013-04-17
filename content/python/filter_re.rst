filter include re
====================

:date: 2008-06-19 05:06:23
:tags: GAE, Python

GAE中自定义filter的方法

1) 在工程main.py中，加入模板并register library

.. sourcecode:: python

    import logging, os
    #import sys

    # Google App Engine imports.
    from google.appengine.ext.webapp import util
    from google.appengine.ext.webapp import template  #导入

    # 自定义的过滤器，路径名要写正确了
    template.register_template_library('myblog/templatetags/my_filter')


    # Remove the standard version of Django.
    #for k in [k for k in sys.modules if k.startswith('django')]:
    #  del sys.modules[k]

    # Force sys.path to have our own directory first, in case we want to import
    # from it.
    #sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

    from django.conf import settings
    settings._target = None

    # Must set this env var *before* importing any part of Django
    os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

    import django.core.handlers.wsgi
    import django.core.signals
    import django.db
    import django.dispatch.dispatcher

    def log_exception(*args, **kwds):
     logging.exception('Exception in request:')

    # Log errors.
    django.dispatch.dispatcher.connect(
       log_exception, django.core.signals.got_request_exception)

    # Unregister the rollback event handler.
    django.dispatch.dispatcher.disconnect(
        django.db._rollback_on_exception,
        django.core.signals.got_request_exception)

    def main():
      # Create a Django application for WSGI.
      application = django.core.handlers.wsgi.WSGIHandler()

      # Run the WSGI CGI handler with that application.
      util.run_wsgi_app(application)

    if __name__ == '__main__':
      main()

加入到main.py中，主要是加载my_filter，生成字节码

2) 在my_filter.py中，同样导入django的模板并注册库，也可以用google.appengine.ext.webapp.template，效果一样。

.. sourcecode:: python

    #coding:utf-8
    from django import template
    #from google.appengine.ext import webapp

    register = template.Library()
    #register = webapp.template.create_template_register()

    import re
    from pygments import highlight
    from pygments.lexers import PythonLexer, HtmlDjangoLexer, JavascriptDjangoLexer
    from pygments.lexers import TextLexer
    from pygments.formatters import HtmlFormatter

    def get_url_not_endwithslash(url):
        return url[:-1]
    #...

3) 主要是一定要在main.py中注册模板库


奇怪的现象是：自定义的filter中，有几个是以前django独立工程中已有的，这几个在我放到gae上也是可以用的，但后来新加了几个filter后，一直报无法找到filter，但html代码中去掉，仅仅用旧的过滤器又正确了。奇怪也～

include的用法

    django的模板中的include，直接在页面中加入{% include "some.html" %}就可以套用了，这样可以使得各个页面重复代码大大减少。

正则式
又碰到正则式的麻烦问题了。

.. sourcecode:: python

    def post_body_style(body):
        """ 解析自定义样式
        """
        stylept = re.compile(r'(?P<st>[ABCIRGBHJKST])｛｛｛(?P<co>(?!｝｝｝)(?:.|\n)*?)｝｝｝')
        body_list = stylept.findall(body)
        for (st, co) in body_list:
            if st == 'A':   # 链接
                tmp = '<a href=%s>%s</a>' % (co, co)
            elif st == 'B':  # 加粗
                tmp = '<b>%s</b>' % co
            elif st == 'C': # Code using pygment
                tmp = highlight(co, PythonLexer(), HtmlFormatter())
            elif st == 'I': # Image??? add img link? img size??
                tmp = '<div class="postimg"><img border="0" src="/site_media/img/%s" alt="%s" title="%s"/></div>' % (co, co, co)
            elif st == 'R': # red-like
                tmp = '<span class="postred">%s</span>' % co
            elif st == 'G': # green-like
                tmp = '<span class="postgreen">%s</span>' % co
            elif st == 'B': # blue-like
                tmp = '<span class="postblue">%s</span>' % co
            elif st == 'H': # HTML
                tmp = highlight(co, HtmlDjangoLexer(), HtmlFormatter())
            elif st == 'J': # javascript
                tmp = highlight(co, JavascriptDjangoLexer(), HtmlFormatter())
            elif st == 'K':
                pass
            elif st == 'S':
                pass
            elif st == 'T': # text
                tmp = highlight(co, TextLexer(), HtmlFormatter())
            else:
                continue
            body = body.replace('%s｛｛｛%s｝｝｝' % (st, co), tmp)
        return body

这里面的正则式有个.*和.*?的区别，有个介绍类似的文章 http://www.codepub.com/info/2007/02/info-11598-6.html
另外一点，没实现的是，如何嵌套使用｛｝？

还存在问题是：

- 评论那边的为什么不能用 truncate words
- JS问题多多