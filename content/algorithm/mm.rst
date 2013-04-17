一些问题
===================

:date: 2009-09-09 09:09:26
:tags: Tools, Python

mysql crashed error
------------------------------
mysql数据库中在插入一条记录时，出现 Table 'xxx' is marked as crashed and should be repaired 的错误, 解决是使用myisamchk修复某个表. 如:

    .. sourcecode:: bash

        myisamchk -c -r /var/lib/mysql/somedb/sometable.MYI

可能原因:

    ::

        错误产生原因，有网友说是频繁查询和更新xxx表造成的索引错误，因为我的页面没有静态生成，而是动态页面，因此比较同意这种说法。
        还有说法为是MYSQL数据库因为某种原因而受到了损坏，如：数据库服务器突发性的断电、在提在数据库表提供服务时对表的原文件进行某种操作都有可能导致
        MYSQL数据库表被损坏而无法读取数据。总之就是因为某些不可测的问题造成表的损坏。


发送邮件
------------------

一封邮件可以显示发件人的昵称, 比如说在gmail中, 邮件显示了发送者的邮箱, 还有她的昵称(如果发送者没有昵称的话, 就直接去邮箱@前面的帐号) 那么, 如何设置这个"昵称"? 方法如下:

    .. sourcecode:: python

        # -*- coding: utf-8 -*-
        from email.Header import Header
        sender_name = u"liz"
        from_email = "your@you.com"

        sender_name = Header(sender_name.encode("UTF-8"), "UTF-8").encode()
        from_email = '"' + sender_name + '"' + " <" + from_email + ">"

        #...
        mm = EmailMessage(subject=subject, body=msg, from_email=from_email, to=[email])
        # 也就是将from_email作为参数传过去就可以了, 对于发信人也可以这样子做.

    这些都是在 `标准RFC 2047 <http://www.faqs.org/rfcs/rfc2047.html>`_


PS
--------

总是记不住mysql中的用户创建和授权.....特此特此特此记下:

    ::

        use mysql;
        grant all privileges on *.* to liz@localhost identified by 'password'; # 授予liz所有数据库,表的所有操作权限, 并且需要password验证, 且locahost登录.
        flush privileges; # 刷新

        show grants for shengyan@localhost; # 显示
        update user set password=password('asdzxc321456') where user='liz'; # 更改密码
        delete from user where user="xxx" and host="localhost";


gcc/++
-------------

某管理员安装linux某版本竟然没安装gcc, g++, 没有编译器差不多什么都不能安装了. rpm的依赖关系比较头疼. 那就用yum吧...于是乎:

    .. sourcecode:: bash

        yum install gcc gcc-c++

搞定!