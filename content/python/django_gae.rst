django on GAE
====================

:date: 2008-06-17 14:06:37
:tags: GAE, Python


1) 将Django项目拷贝到GAE sdk工程目录下，工程名字和应用名字一样，即是同一层目录
2) 修改app.yaml如下：

.. sourcecode:: yaml

    application: lizziesky
    version: 1
    runtime: python
    api_version: 1

    handlers:
    - url: /site_media #和之前一样，注意要把静态文件加入就好
    static_dir: media

    - url: /.*
    script: main.py

3) 修改main.py如下：

.. sourcecode:: python

    import logging, os
    #import sys

    # Google App Engine imports.
    from google.appengine.ext.webapp import util

    # Remove the standard version of Django. # 这里如果使用自己的django，需要删除原来的，添加自己的django路径
    #for k in [k for k in sys.modules if k.startswith('django')]:
    # del sys.modules[k]

    # Force sys.path to have our own directory first, in case we want to import
    # from it.
    #sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

    from django.conf import settings #这边未设置对，出现错误ROOT_URLCONF is not found.
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


4) 修改settings.py如下：

.. sourcecode:: python

    # Django settings for lizziesky project.
    import os

    DEBUG = True
    TEMPLATE_DEBUG = DEBUG

    ADMINS = (
    # ('Your Name', 'your_email@domain.com'),
    )

    MANAGERS = ADMINS

    #DATABASE_ENGINE = 'appengine' # 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'ado_mssql'. #这里是不需要设置的
    #DATABASE_NAME = 'lizzieskydb' # Or path to database file if using sqlite3.
    #DATABASE_USER = '' # Not used with sqlite3.
    #DATABASE_PASSWORD = '' # Not used with sqlite3.
    #DATABASE_HOST = '' # Set to empty string for localhost. Not used with sqlite3.
    #DATABASE_PORT = '' # Set to empty string for default. Not used with sqlite3.

    # Local time zone for this installation. Choices can be found here:
    # http://www.postgresql.org/docs/8.1/static/datetime-keywords.html
    #DATETIME-TIMEZONE-SET-TABLE
    # although not all variations may be possible on all operating systems.
    # If running in a Windows environment this must be set to the same as your
    # system time zone.
    TIME_ZONE = 'UTC'

    # Language code for this installation. All choices can be found here:
    # http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
    # http://blogs.law.harvard.edu/tech/stories/storyReader$15
    LANGUAGE_CODE = 'en-us'

    SITE_ID = 1

    # If you set this to False, Django will make some optimizations so as not
    # to load the internationalization machinery.
    USE_I18N = True

    # Absolute path to the directory that holds media.
    # Example: "/home/media/media.lawrence.com/"
    MEDIA_ROOT = ''

    # URL that handles the media served from MEDIA_ROOT.
    # Example: "http://media.lawrence.com"
    MEDIA_URL = ''

    # URL prefix for admin media -- CSS, JavaScript and images. Make sure to use a
    # trailing slash.
    # Examples: "http://foo.com/media/", "/media/".
    ADMIN_MEDIA_PREFIX = '/media/'

    # Make this unique, and don't share it with anybody.
    SECRET_KEY = 'o_@ehh+&p#-8fiil(_x6(5#6yuy%_j=sq14_zi8p*p0!+i(1'

    # List of callables that know how to import templates from various sources.
    TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.load_template_source',
    'django.template.loaders.app_directories.load_template_source',
    # 'django.template.loaders.eggs.load_template_source',
    )

    MIDDLEWARE_CLASSES = ( #去掉不支持的模块
    'django.middleware.common.CommonMiddleware',
    # 'django.contrib.sessions.middleware.SessionMiddleware',
    # 'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.middleware.doc.XViewMiddleware',
    )

    TEMPLATE_CONTEXT_PROCESSORS = (
    'django.core.context_processors.auth',
    'django.core.context_processors.debug',
    'django.core.context_processors.i18n',
    # 'django.core.context_processors.media', # 0.97 only.
    # 'django.core.context_processors.request',
    )

    ROOT_URLCONF = 'urls' #这里不是工程名字.urls

    ROOT_PATH = os.path.dirname(__file__)
    TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    os.path.join(ROOT_PATH, 'templates') #模板路径
    )

    INSTALLED_APPS = (
    # 'django.contrib.auth', #不支持admin
    'django.contrib.contenttypes',
    # 'django.contrib.sessions',
    'django.contrib.sites',
    # 'django.contrib.admin',
    'myblog',
    )

    STATIC_PATH = os.path.join(ROOT_PATH, 'media')


5) 把所有的urls.py、views.py、models.py中的，涉及到不和谐的地方，全部改掉！mmd，超级多！主要是import路径（是不要工程名字的）、model的一些方法，还有就是template的页面上修改。
6) 在本地OK后，上传后，还是很多问题。

另外要注意的地方和些废话：

    * Settings中ROOT_URLCONF
    * 不需要工程名字，直接urls
    * 中文问题
    * DATABASE_ENGINE不需要
    * 同时也发现GAE提供的admin非常好，调试错误还有自定义信息都能显示
    * feed不能用，是因为django该部分用到数据库的模块了
    * 总能找到替代方法，对于很多问题。
    * 本地SDK和实际的google环境不一样！
    * 还有so many的问题。所以看来有这么长改的时间，还不如直接从零开始。
    * 现在基本功能已经实现，接下来，重新开始！