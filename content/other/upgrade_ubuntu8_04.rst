Upgrade to Ubuntu 8.04
=============================

:date: 2008-06-26 11:06:01
:tags: Linux

旧版本上的。。。

咔咔，昨儿个升级了一夜，到今天早上都还没完成，等了好长时间才OK。

重启之后，界面漂亮了，firfox为3.0了，这个lizziesky现在在ff下显示很好。字体变好看了。

换ubuntu源：刚开始换了8.04的源又出现讨厌的“有一些索引文件不能下载“这种错误，这个是因为源问题，所以找到一个中科大的源，正确并且非常快

::

    deb http://debian.ustc.edu.cn/ubuntu/ hardy main restricted universe multiverse
    deb http://debian.ustc.edu.cn/ubuntu/ hardy-backports restricted universe multiverse
    deb http://debian.ustc.edu.cn/ubuntu/ hardy-proposed main restricted universe multiverse
    deb http://debian.ustc.edu.cn/ubuntu/ hardy-security main restricted universe multiverse
    deb http://debian.ustc.edu.cn/ubuntu/ hardy-updates main restricted universe multiverse
    deb-src http://debian.ustc.edu.cn/ubuntu/ hardy main restricted universe multiverse
    deb-src http://debian.ustc.edu.cn/ubuntu/ hardy-backports main restricted universe multiverse
    deb-src http://debian.ustc.edu.cn/ubuntu/ hardy-proposed main restricted universe multiverse
    deb-src http://debian.ustc.edu.cn/ubuntu/ hardy-security main restricted universe multiverse
    deb-src http://debian.ustc.edu.cn/ubuntu/ hardy-updates main restricted universe multiverse

现在还在漫长的等待upgrade中。

另外还有其他的新问题等待我慢慢发现。。。。^o^

ok, 刚刚弄完新的系统，呵呵，又能看到久别的3D效果了，super cool！

之间差点忘了，之前因为重新编译过内核，进入这个2.6.24.4-custom看不到受限驱动程序，因为是没有安装的；后来重新进入2.6.24-16-generic，里面就可以看到正确的，打开nvidia驱动重启后就能进入。

3d效果太棒了！接着要仔细弄弄图片相关的实现。