Python Cron Jobs
===================

:date: 2009-10-20 04:10:07
:tags: Python


python中的计划任务
------------------------

除了依赖于linux的crontab外, 在python中, 有一些方法:

    1) `z3c.recipe.usercrontab <http://pypi.python.org/pypi/z3c.recipe.usercrontab>`_,  z3c.recipe.usercrontab interfaces with cron using crontab(1), and allows normal users to install their own cronjobs.
    2) `sched, python内置模块 <http://docs.python.org/library/sched.html>`_,  "sched不支持多线程, 多线程用threading.Timer"
    3) twisted框架中的多线程.
    4) 使用python 做个定时器，定时触发一个操作，该用哪个模块。可以用 ``threading.Timer(*args, **kwargs)``
    5) `复杂的 <http://www.webwareforpython.org/TaskKit/Docs/QuickStart.html>`_
    6) `简单的 <http://docs.python.org/lib/module-sched.html>`_
    7) `介于两者之间的 <http://code.google.com/p/scheduler-py/wiki/Examples>`_


twisted实现方式
------------------------

看了些文档, 利用最基本的一些接口实现了下, 但感觉还不是很明白内部如何.

    .. sourcecode:: python

        #  -*- coding: utf-8 -*-
        import sys, os
        from twisted.internet import reactor
        from twisted.internet import task

        reactor.suggestThreadPoolSize(20)  # 线程池大小

        def mainRun():
            reactor.callInThread(check_notify_dn_list)  # 具体的操作放在每个子线程中调用
            print "check dn notify."

            reactor.callInThread(check_signup)
            print "check signup."

            # ...
            print "done.\n"

        #seconds = 10  # 检测间隔
        if len(sys.argv) > 1:
            try:
                seconds = int(sys.argv[1])
            except:
                seconds = 10
        l = task.LoopingCall(mainRun)
        l.start(seconds)
        reactor.run()


其他
------------------------

1) datetime的combine方法使用。

    .. sourcecode:: python

        tomorrow_at_930 = datetime.datetime.combine(tomorrow, datetime.time(9, 30))

2) 普通应用中使用django的orm方法，只要配置settings相关变量就可以了

    .. sourcecode:: python

        from settings import DATABASE_ENGINE, DATABASE_HOST, DATABASE_NAME, DATABASE_USER, DATABASE_PASSWORD, DNST_CHOICES, PAY_EXPIRE, MSGTYPE_CHOICES, RCLOSE_DN_TIME, SM_CHOICES, OUT_CHOICES, SIGNUP_CONFIRM_TIMES, FIND_CONFIRM_TIMES

        from django.conf import settings
        settings.configure(DATABASE_ENGINE=DATABASE_ENGINE,
                          DATABASE_HOST=DATABASE_HOST,
                          DATABASE_NAME=DATABASE_NAME,
                          DATABASE_USER=DATABASE_USER,
                          DATABASE_PASSWORD=DATABASE_PASSWORD)

3) 关于twisted的介绍文章:

    - http://www.artima.com/weblogs/viewpost.jsp?thread=156396
    - http://www.artima.com/weblogs/viewpost.jsp?thread=230001
    - http://www.ibm.com/developerworks/cn/linux/theme/special/index.html#python

ps: 最近diigo书签都不能用了. 保存好的网页真是不方便!