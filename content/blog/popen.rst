Popen
============

:date: 2008-12-20 14:12:17
:tags: Python


os.popen3()一般用来运行一些命令或程序

.. sourcecode:: python

    (stdin, stdout, stderr) = os.popen3(somecommand)

一般在程序中使用类似上述的代码, 调用某些命令, 然后可以得到输出, 包括错误信息.要比os.system, os.popen, os.popen2好.

一个好玩的地方是,,,本来以为os.popen3只能用在python普通脚本中, 今天想实现打开个页面时打开本地某个程序. 这个程序是普通窗口程序. 在网上找了些资料, 大概是通过js中ActiveXObject("WS.shell").Run(program)实现. 但因为这个只有在Windows的IE浏览器下才能运行, 而Firefox,找了半天都没找到替代.
所以试试os.popen3(), 果然可以调用本地程序,,,不过再想想, 这样似乎不太好.但又找不出其他方法了.