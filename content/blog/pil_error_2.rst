PIL Error 2
===================

:date: 2009-04-20 12:04:42
:tags: Python

今天继续昨天的PIL错误问题.

    ::

        ImportError: DLL load failed: %1 is not a valid Win32 application. 这个错误始终没有解决.

依次尝试有, 由于exe找不到python26安装目录, 即使是注册表中有相关键值, 在pil安装时仍然找不到,

于是, 使用cygwin或mingw编译安装pil,

首先, 在cygwin下, 参考 `这里 <http://jetfar.com/cygwin-install-python-imaging-library/>`_, 使用rebase -b 0x1000000000 /bin/tk85.dll 这个tk84.dll一般在C:\Python26\DLLs下有; python setup.py install之后,可以完成安装, 但是缺少

    ::

        *** TKINTER support not available (Tcl/Tk 8.5 libraries needed)
        *** JPEG support not available
        *** ZLIB (PNG/ZIP) support not available
        *** FREETYPE2 support not available

这些支持, 需要自己编译安装 `以上包 <http://www.wiredfool.com/2005/10/29/how-to-build-the-python-imaging-library-for-windows/>`_ , 而且对于PIL的setup.py源文件也需做相应修改.

使用mingw, 方法是 ``D:\Imaging-1.1.6>python setup.py build -cmingw32`` , 但出现

    ::

        e to `_imp__PyExc_AttributeError'
        build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd85): undefined referenc
        e to `_imp__PyErr_SetString'
        collect2: ld returned 1 exit status
        error: command 'gcc' failed with exit status 1

`类似错误 <http://sebsauvage.net/python/mingw.html>`_,  也就是如何写python的c扩展, 使用pexports python26.dll > python26.def

    ::

        dlltool --dllname python26.dll --def python26.def --output-lib libpython26.a

再将libpython26.a拷贝到c:\python26\libs\ 不过安装官方python26之后libs下已经存在这个文件. 但在另外一台64位机上使用pexports都不能生成def文件, 所以直接将本机的libpython26.a拷贝至对方机子上, 使用python setup.py build -cmingw32 之后python setup.py install, ok, 正确安装pil到python26的site-packages下, 但是同样不支持JPEG, ZLIB. 而且在导入一些动态库时仍然是 ImportError: DLL load failed: %1 is not a valid Win32 application.错误.

看来编译安装实在是问题重重, 因为首先在windows下手工编译zlib或jpeg这也是比较麻烦的问题, 似乎不像linux下使用configure, make, make install 这么简单.

后来找到 `一篇文章 <http://vainchaos.blogspot.com/2009/01/pythonpil.html>`_, "我最先使用的是python.org的python,并且是从源码安装PIL,于是开始真是叫天天不应了。" 呵呵呵,真的是有同感. 后来还是转回到使用exe安装,,,不过把python26卸载, 使用activepython来安装, 因为activepython对windows支持比较好, 然后再进行pil的exe安装, 注册表中找到, 顺利安装完成.

再仔细看下, activepython和官方python在site-packages下，有些不同, 默认安装的包不同，activepython有很多关于win32的包, 这可能就是acitvepython更加适合在windows上运行的原因吧 .
再想想的话, 如果现在将activepython下的site-packages下的有关pil的模块全部拷贝出来, 再把activepython卸掉重装python26官方版, 再把pil模块拷贝进去, 不知道是否可以. 猜, 应该可以.

而对于那个DLL问题, 仍然不知道怎么解决.