Admin/Debug
=================

:date: 2008-06-24 14:06:11
:tags: GAE, Python

1) 增加Admin功能

可以通过lizziesky.appspot.com/_admin/访问控制台，不过这个比较简单，没有GAE自带的功能多。具体做法是在工程文件夹下，增加下列代码到app.yaml中

.. sourcecode:: yaml

    - url: /_admin/.*
      script: $PYTHON_LIB/google/appengine/ext/admin
      login: admin

可以看到主要是增加路径，然后脚本是用了gae自带的admin

2) Debug默认为True，现在改为False。因为在原来的Django工程中，只需将settings.py中的DEBUG改为False就可以了。但在GAE中，光光这样，在输入不能解析的路径时，会产生WSGI异常，产生之处在工程文件的主入口文件，我这儿是main.py的util.run_wsgi_app(application)中的某处抛出异常。那么，就在这个地方加个try...except语句吧，最终处理如下：

.. sourcecode:: python

    #main.py
    #...

    from google.appengine.ext import webapp
    import wsgiref.handlers
    import os
    from google.appengine.ext.webapp import template

    class ErrorSth(webapp.RequestHandler):
        def get(self):
            try:
                template_path = os.path.join(os.path.dirname(__file__), 'templates/404.html')
                #self.response.out.write('ERROR Oops From Bad URL ')#%s' % self.get_url())
                self.response.out.write(template.render(template_path, {}))
            except Error:
                self.error(404)

    def main():
      # Create a Django application for WSGI.
      application = django.core.handlers.wsgi.WSGIHandler()
      try:
          # Run the WSGI CGI handler with that application.
          util.run_wsgi_app(application)
      except Exception, e:
          errorapp = webapp.WSGIApplication([(r'/.*', ErrorSth)], debug=False)
          wsgiref.handlers.CGIHandler().run(errorapp)

这个办法不好，但目前没想到其他的。