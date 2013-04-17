Tips2
============

:date: 2009-05-06 11:05:13
:tags: Other

1) 随机产生长度为n的字符串

    .. sourcecode:: python

        print ''.join(random.sample([chr(i) for i in range(65, 90)+range(97, 122)], n))

2) `source命令 <http://blog.csdn.net/coofive/archive/2006/04/21/671835.aspx>`_, 用于重新执行刚修改的初始化文件, 使之立即生效, 而不必注销并重新登录. source filename 或 . filename 为某个脚本文件, 可设置相关环境.

    ::

        source a.sh 同直接执行 ./a.sh 有什么不同呢,
        比如你在一个脚本里export $KKK=111, 如果你用./a.sh执行该脚本, 执行完毕后,
        你运行 echo $KKK, 发现没有值, 如果你用source来执行, 然后再echo, 就会发现KKK=111.
        因为调用./a.sh来执行shell是在一个子shell里运行的,
        所以执行后, 结构并没有反应到父shell里,
        但是 source不同它就是在本shell中执行的, 所以可以看到结果

3) su 和 su - 同样是切换用户, 但不同的是, 前者保留当前用户的相关环境, 后者完全切换到目标用户, 包括环境.

4) 今天碰到一个奇怪问题, RH AS3中, 某一软件运行的好好的, 突然隔了一段时间无法运行, 怪也. 后来终于找到...原来这个软件需要后台的一个license进程支持, 以提供相应的用户许可服务. 那么问题就在这个license manager进程了, 叫做lmgrd, 它以一个普通帐号accelycs开机自动启动, 然后运行目标软件即可. 但现在RH AS3上不知为何, 一重新启动后整个环境全部默认为原始的, 就连history条目都为空, 这样一来, 以accelycs运行的lmgrd中使用的环境变量也不正确, 只能在新的环境中重新启动这个lmgrd进程.

    ::

        source som.sh # accelycs用户下的某个脚本, 包括很多相关命令是安装在该用户目录下.
        su # 切换到root, 包含accelycs相关变量
        lmup # 即可.
        后台是以root身份运行lmgrd, 因为以accelycs身份运行的话,
        操作/usr/下的某个文件没有权限, 只好以root.

5) 今天又有机会玩了下mac os, 本想尝试一下ichat上gtalk, 看到ichat支持jabber, 输入自己帐号后仍然无法连接...回来不甘心, 找到 `详细的方法 <http://www.allwiki.com/wiki/%E5%A6%82%E4%BD%95%E4%B8%BA_GoogleTalk_%E9%85%8D%E7%BD%AEiChat>`_ (大写)原来是服务器talk.google.com和端口5223没有设置对....so,,,下次有机会再去试试:)

6) 农学院的两排梧桐树, 刚长出来的新叶子, 一片绿绿的, 很漂亮.