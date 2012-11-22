Httplib
===================

:date: 2009-02-12 13:02:35
:tags: Python


使用httplib时, 出现了如下错误:

::

    ...
      File "httplib.pyc", line 509, in read
      File "httplib.pyc", line 548, in _read_chunked
    ValueError: invalid literal for int() with base 16:

这和 http://bugs.python.org/issue3721 说的一样, 同样几年前就有讨论 http://bugs.python.org/issue900744.

主要是由于Python版本问题, 尝试使用 http://svn.python.org/view?rev=61034&view=rev