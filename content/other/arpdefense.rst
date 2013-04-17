ARPDefense
===================

:date: 2009-03-04 09:03:01
:tags: Other

局域网内ARP攻击, 导致无法上网个, 解决办法:

1) sudo arp -s 192.168.0.1 00:d0:f8:fb:8a:63 ## 静态绑定网关mac地址
2) sudo arp -a 查看显示

    ::

        ? (192.168.0.1) 位于 00:d0:f8:fb:8a:63 [ether] PERM 在 eth0

3) sudo vim /etc/ethers # 编辑加入

    ::

        192.168.0.1 00:d0:f8:fb:8a:63

4) sudo vim /etc/init.d/rc.local #加入arp -f, 以便启动执行

其他一些命令:

    ::

        arp -d #清除ARP缓存
