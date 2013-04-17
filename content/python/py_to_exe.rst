py2exe
===================

:date: 2009-02-16 08:02:16
:tags: Python

在使用py2exe打包时, 编译时出现了丢失模块的信息:

::

    The following modules appear to be missing
    ['email.Generator', 'email.Iterators', 'email.Message', 'email.Utils', 'socks', 'stackless']

直接运行相应exe文档, 出现了如下错误:

::

    File httplib2\__init__.pyc", line 968
    File "email\__init__.pyc", line 79,
    in File "email\message.pyc", line 86,
    in File "email\message.pyc", line 786,
    in File "email\__init__.pyc", line 79,
    in ImportError: No module named iterators

前面的email的一些模块的缺失是因为Python新旧版本不一致, 大小写的区别,具体issue参考 http://bugs.python.org/issue2622 , 需要将源码中某些大写改成小写.

但其实在Python命令行中直接import email.iterators或import email.Iterators都是可以的.

修改之后还是出现了:

::

    The following modules appear to be missing
    ['email.Message', 'email.Utils', 'socks', 'stackless']

可能email的还有哪些地方没改过来, 以致py2exe导入了这个模块.

不过奇怪的是'socks'和'stackless', 前面的socks的确没有这个模块, 但stackless不可能没有的,,,,虽然运行exe文件没有问题, 所以暂时就不管了吧.

还有些解决的方法就是在py2exe的setup.py中设置一些选项. 具体可以见 `1 <http://groups.google.co.uk/group/python-cn/browse_thread/thread/97c6f30f9e9fd9e6/ee52763aff45eb1b>`_ 和 `2 <http://groups.google.co.uk/group/python-cn/msg/dd1c90e882339aab>`_