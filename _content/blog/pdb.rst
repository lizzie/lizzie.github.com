PDB
===================

:date: 2010-05-20 01:05:50
:tags: Python


看到一篇Pdb的入门文章, 简单记录一下.

    * 原文: http://pythonconquerstheuniverse.wordpress.com/2009/09/10/debugging-in-python/
    * pdb文档: http://docs.python.org/library/pdb.html

pdb为python中的调试模块.

最简单的例子:

    .. sourcecode:: python

        import pdb  # pdb模块
        a = "aaa"
        pdb.set_trace()  # 设置跟踪点
        b = "bbb"
        c = "ccc"
        final = a + b + c
        print final

当运行该脚本之后, 进入pdb的调试界面. 主要是一些命令的使用:

    * n+Enter: 执行下一句;
    * 直接按Enter, 会重复执行上一命令;.
    * q: 退出调试;
    * p: 后面加变量, 可打印出变量值;
    * c: 退出调试但继续执行余下的程序, 或是有多个set_trace时, c会结束当前这个trace, 下一个trace时仍会进入调试;
    * l:　列出当前执行点前后的11行代码;
    * s: 进入子模块, step into;
    * r: 退出子模块;

就这些. 很简单吧..忘了还有一点.

    .. sourcecode:: python

        (Pdb)!b = "BBB" # 调试时改变某变量值.

