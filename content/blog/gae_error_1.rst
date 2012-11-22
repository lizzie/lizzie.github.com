GAE Error II
====================

:date: 2008-06-12 09:06:55
:tags: Python, GAE

上传时的400错误

::

    Error 400: --- begin server output ---
    Creating a composite index failed:
    An index may not be comprised of a single repeated property.
    Your query probably doesn't need this index.
    Try without it!

解决办法

直接把index.yaml中自动产生的models信息删除，才能上传正确。

另外发现，上传时，有些时候明明做修改了的文件不能上传。只能再次修改，所以奇怪他是按照什么来判断文件是否要上传。

以下这个错误经常在新建entry提交后出现。新的entry是已经到后台数据库中，只是转到页面后出现如下错误：

::

    Error at /blog/post/401/
    Request Method: 	GET
    Request URL: 	http://lizziesky.appspot.com/blog/post/401/
    Exception Type: 	Error
    Exception Value:
    Exception Location: 	/base/python_lib/versions/1/google/appengine/api/datastore.py in _ToDatastoreError, line 1603
    Traceback (innermost last)
    Switch to copy-and-paste view

    * /base/python_lib/versions/1/django/core/handlers/base.py in get_response
        70. # Apply view middleware
        71. for middleware_method in self._view_middleware:
        72. response = middleware_method(request, callback, callback_args, callback_kwargs)
        73. if response:
        74. return response
        75.
        76. try:
        77. response = callback(request, *callback_args, **callback_kwargs) ...
        78. except Exception, e:
        79. # If the view raised an exception, run it through exception
        80. # middleware, and if the exception middleware returns a
        81. # response, use that. Otherwise, reraise the exception.
        82. for middleware_method in self._exception_middleware:
        83. response = middleware_method(request, e)

这个估计是服务器处理后台数据时的不稳定。