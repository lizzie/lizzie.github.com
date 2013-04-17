PIL Error 1
===================

:date: 2009-04-19 14:04:39
:tags: Python

今天碰到一系列变态问题.
初始问题是由于在使用PIL包时, 出现如下:

::

    ImportError at ..
    The _imaging C module is not installed

也就是无法找到_imaging这个动态库, 一般在安装PIL时会生成在pil目录下生成一个_imaging.pyd文件(还有其他pyd文件), 找到相关资料http://effbot.org/zone/pil-imaging-not-installed.htm, 考虑Path是否没有包含于是就找不到这个文件, 但后来发现已经包含pil所在目录.

继续, 使用在python解释器下运行, 出现如下:

::

    >>> import _imaging
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    ImportError: DLL load failed: %1 is not a valid Win32 application.

看来是无法加载这个DLL, 是一个无效的win32应用程序. 原来操作系统是64位机, 在安装pil过程中(使用的是PIL-1.1.6.win32-py2.6.exe), 在选择python安装目录框时显示灰色不可用状态, 于是乎是否是注册表中没有注册python, 找到如下注册代码:

.. sourcecode:: python

    import sys

    from _winreg import *

    # tweak as necessary
    version = sys.version[:3]
    installpath = sys.prefix

    regpath = "SOFTWARE\\Python\\Pythoncore\\%s\\" % (version)
    installkey = "InstallPath"
    pythonkey = "PythonPath"
    pythonpath = "%s;%s\\Lib\\;%s\\DLLs\\" % (
        installpath, installpath, installpath
    )

    def RegisterPy():
        try:
            reg = OpenKey(HKEY_LOCAL_MACHINE, regpath)
        except EnvironmentError:
            try:
                reg = CreateKey(HKEY_LOCAL_MACHINE, regpath)
                SetValue(reg, installkey, REG_SZ, installpath)
                SetValue(reg, pythonkey, REG_SZ, pythonpath)
                CloseKey(reg)
            except:
                print "*** Unable to register!"
                return
            print "--- Python", version, "is now registered!"
            return
        if (QueryValue(reg, installkey) == installpath and
            QueryValue(reg, pythonkey) == pythonpath):
            CloseKey(reg)
            print "=== Python", version, "is already registered!"
            return
        CloseKey(reg)
        print "*** Unable to register!"
        print "*** You probably have another Python installation!"

    def UnRegisterPy():
        try:
            reg = OpenKey(HKEY_LOCAL_MACHINE, regpath)
        except EnvironmentError:
            print "*** Python not registered?!"
            return
        try:
            DeleteKey(reg, installkey)
            DeleteKey(reg, pythonkey)
            DeleteKey(HKEY_LOCAL_MACHINE, regpath)
        except:
            print "*** Unable to un-register!"
        else:
            print "--- Python", version, "is no longer registered!"
    if __name__ == "__main__":
        RegisterPy()

ps, 正常情况下, python在windows下的安装都是自动注册到注册表中的,,,但是奇怪为什么有时会在注册表中找不到.
运行注册程序之后, 在重新运行pil安装程序, 情况依旧, ps, 注册表修改后一般要重新机器生效.

还是ImportError: DLL load failed: %1 is not a valid Win32 application. 后来找到 http://www.opensubscriber.com/message/pyqt@riverbankcomputing.com/11127171.html 说:

::

    >
    > my windows is a Vista 64  running over a AMD Turion 64
    > my python 2.6  64AMD version
    >
    > *any ideia how to fix this error?*
    > *tnx for help me !!*

    I don't see how a 64 bit interpreter can be expected to handle a 32 bit
    .pyd extension.

也就是说64位的解释器无效执行32位的pyd程序. 晕~

那么,,,换成源码编译安装pil. 同样出现:

::

    python setup.py build_ext -i
    ...
    running build_ext
    building '_imaging' extension
    error: Unable to find vcvarsall.bat

系统没有安装任何c编译器, 根据 http://bugs.python.org/issue2698 上安装cygwin, 试试吧...

在编译安装时又出现垃圾错误:

::

    ...
    e to `_imp__PyArg_ParseTuple'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xcf5): undefined referenc
    e to `_imp___Py_NoneStruct'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xcfd): undefined referenc
    e to `_imp___Py_NoneStruct'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd31): undefined referenc
    e to `_imp__Py_FindMethod'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd3d): undefined referenc
    e to `_imp__PyErr_Clear'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd6d): undefined referenc
    e to `_imp__Py_BuildValue'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd7a): undefined referenc
    e to `_imp__PyExc_AttributeError'
    build\temp.win-amd64-2.6\Release\path.o:path.c:(.text+0xd85): undefined referenc
    e to `_imp__PyErr_SetString'
    collect2: ld returned 1 exit status
    error: command 'gcc' failed with exit status 1


http://mail.python.org/pipermail/python-win32/2003-September/001287.html

需要包含-L\libs\python26.LIB

PIL: http://effbot.org/zone/pil-index.htm

不过, 兜了半天, 最终是要PIL生成一些验证图片, 虽然PIL库强大, 但之前那些dll库原因,,饶了半天还没搞定, 考虑其他图形图像库, 在 http://wiki.woodpecker.org.cn/moin/ObpLovelyPython/LpyAttach2ResIdx 找到个captchaimage和PyCAPTCHA 0.4, 似乎这两个更小巧点,,,

