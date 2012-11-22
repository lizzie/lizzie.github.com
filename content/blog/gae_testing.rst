GAE Testing
====================

:date: 2008-06-12 10:06:07
:tags: Python, GAE

GAE环境下，有些模块不能用，做如下测试：

.. sourcecode:: python

    import os
    import pickle
    try:
        #pickle.dump(request, open('test.dump', 'w'))不能用w，即不支持创建新文件
        #if not os.system('date'):没有system和popen
        #    return HttpResponse("os.system return not 0!")
        #md5sum = os.popen('md5sum '+__file__).readlines()[0].split(' ')[0]
        cwd = os.getcwd()
        return HttpResponse("<p>cwd:%s</p>" % (cwd))#<p>md5:%s</p> md5sum,
    except Exception, e:
        return HttpResponse("Test Error: %s" % e)


结果 cwd:/base/data/home/apps/lizziesky/1.46

对于第三方库，可以直接把库源码拷至工程文件夹，包含__init__.py文件，只要保证能够找到库路径就可以了
