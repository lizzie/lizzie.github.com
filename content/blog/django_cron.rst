Django Cron
===================

:date: 2009-05-21 04:05:05
:tags: Javascript, CSS

DjangoPlug
-------------------

Django Plugables: http://djangoplugables.com/
这上面有好多Django的第三方应用, 很多都在不断更新,,,


django-cron
---------------------

在Django Plugables找到了一个django中使用定时任务的功能. 叫做django-cron: http://djangoplugables.com/projects/django-cron/

* 缘由

    * 可以实现cron的功能, 但这可以直接嵌入到Django中.
    * 这样一来的话, 比如操作数据库, 可以直接使用Django的orm, 写个定时操作数据库的函数注册到cron中, 就可以实现定时执行了.
    * 这比另外写python脚本, 再加入到crontab中, 方便多了, 其实就是想法子偷懒哈.

* 使用介绍

    ReadMe中有相关介绍, 主要步骤:

    1. Put 'django_cron' into your python path ## 加入不加入无所谓, 但需保证里面的导入模块能够找到.

    2. Add 'django_cron' to INSTALLED_APPS in your settings.py file ## 将django_cron作为独立的app.

    3. Add the following code to the beginning of your urls.py file (just after the imports):
        import django_cron
        django_cron.autodiscover()

    4. Create a file called 'cron.py' inside each installed app that you want to add a recurring job to. The app must be installed via the INSTALLED_APPS in your settings.py or the autodiscover will not find it. ## 创建各个app的cron.py脚本, 也就是一些定时任务.

    这里, 在第三步中, 当打开首页时, 一直出现个错误;

        ::

            UnboundLocalError at /
            local variable 'cron' referenced before assignment

    也就是在django_cron.autodiscover()中的cronScheduler = cron抛出异常, 其相关源码

    .. sourcecode:: python

        from ebuy.django_cron.base import Job, cron

        def autodiscover():
            """
            Auto-discover INSTALLED_APPS cron.py modules and fail silently when
            not present. This forces an import on them to register any cron jobs they
            may want.
            """
            import imp
            from django.conf import settings
            ##from ebuy.django_cron.base import Job, cron

            cronScheduler = cron

            for app in settings.INSTALLED_APPS:
            #...

    cron是导入的一个模块, 被赋值于cronScheduler, 但测试了下, 如果不在autodiscover()中导入cron模块, 就会产生这个错误. 照理说, 在文件头部导入就可以了的. 奇怪也.


后台进程
-------------

* 运行自带服务器上, 查看了后台进程, 在原来python manage.py基础上, 又增加了一个对应子进程. 这可能就是用于跑cron任务的吧.
* 如果使用Apache以 mod_python 方式跑的话, 需要对http.conf设置 MaxRequestsPerChild 为 50, 100, 或者 200
* 之后在lighttpd以fastcgi方式测试, 也可以正常使用.


其他
---------------
* pstree: 以树形的方式列出进程.
* 异步任务: http://code.google.com/p/django-queue-service/, 这个还没开发好?
