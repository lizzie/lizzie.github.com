Python Encoding
=================

:date: 2008-06-17 14:06:50
:tags: Python

str vs unicode

出现错误：

::

    UnicodeDecodeError: 'ascii' codec can't decode byte 0xe5 in position 0: ordinal not in range(128)
    ...

原因：

混淆了 python2 里边的 str 和 unicode 数据类型。。。

解决方法：

- 对需要 str->unicode 的代码，可以在前边写上

    .. sourcecode:: python

        import sys
        reload(sys)
        sys.setdefaultencoding('utf8')

    把 str 编码由 ascii 改为 utf8 (或 gb18030)

- python3 区分了 unicode str 和 byte arrary，并且默认编码不再是ascii
- unicode(description, "utf-8") or db.Text(post_body, encoding="utf-8") ...

参考链接：

- http://groups.google.com/group/python-cn/browse_thread/thread/f48ef745452740f6
- http://mail.python.org/pipermail/python-list/2005-May/321512.html