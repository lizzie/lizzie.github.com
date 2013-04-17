About django manage.py
==============================

:date: 2009-09-03 12:09:31
:tags: Python


之前看到过自定义的django app 扩展定义manage命令, 一直好奇别人是怎么实现的. 今天看到dapian源代码中使用了, 原来实现是非常简单的.

方法如下:

1) 在myapp下新建management/commands目录, 各级目录里面放上__init__.py, 然后在commands下建以命令名字命名的py文件, 然后脚本里面定义一些类, 重载一些方法.

2) 具体来说, 比如:

    ::

        当前目录结构
        |-- myapp
        |     |-------management
        |     |         |------__init__.py
        |     |         |------commands
        |     |         |        |-----__init__.py
        |     |         |        |-----category.py # 扩展一个名为category的命令, 其他的也可以依次创建py脚本

3) category.py中的内容

首先需要继承BaseCommand类, 里面增加option_list, 即命令的选项, 重载handle, 如:

    .. sourcecode:: python

        from django.core.management.base import BaseCommand
        from optparse import make_option

        class Command(BaseCommand):
            option_list = BaseCommand.option_list + (
                make_option('--load', action='store_true', default=False,   # 创建一个选项, 类似于optparse中的设置, 包括各个变量含义也是类似的
                            help='load category to db'),
                make_option('--clear', action='store_true', default=False,
                            help='clear the category'),
            )
            help = "Load category from txt to db."

            requires_model_validation = True

            def handle(self, load=False, clear=False, *args, **options): # 重载方法, 里面的load, clear都是上面的选项定义中的名字.


                if load:
                    load_category() # 具体的处理程序.
                if clear:
                    clear_category()

4) 最后, 就可以在命令行中使用 ``python manage.py category --load`` 了... 那其实这个功能的提供可以在django/core/management/__init__.py中可以看到相关的代码.

非常方便~~~