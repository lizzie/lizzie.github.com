XServer
===================

:date: 2009-04-14 14:04:50
:tags: Tools

想要在网页中, 点击某个按钮/链接, 运行本地某条命令, 这可以直接在views中函数, 使用popen3或者是subprocess调用具体命令, 在使用django自带服务器时没有出现什么问题, 但后来部署到apache上, 就出现了一个

::

    ['No protocol specified\n', 'clustalx: cannot connect to X server :0.0\n']

这样的错误,,,网上找了很多, 还是没有找到解决问题, 后来终于看到一个说su 切换到root之后运行某些程序会出现x server问题.

但奇怪的是, 直接运行命令clustalx, 这是一个桌面程序, 在本地运行没有任何问题, 放在django中也正常出来. 但放到apache上就有上面的错误...后来不知道怎么就想到是不是apache不能去运行clusterx, 或者是apache进行以daemon这个用户运行, daemon不能打开x server,,,所以索性在apache配置文件中改他的用户和组为本地用户帐号, 这样设置之后, 我晕, 还真可以正常运行cluster... 那这样一来, 就估计就是这个用户问题了...虽然这样做, 使得apache的进程具有本地用户的权限, 但如果只作为单机应用的话,,应该没多大问题.


不管怎样, 先这样用吧.