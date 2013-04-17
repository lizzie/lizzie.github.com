Notes from greader II
========================

:date: 2009-08-29 13:08:21
:tags: note


使用Apache做负载均衡
------------------------

`原文1 <http://tech.idv2.com/2009/07/22/loadbalancer-with-apache/>`_

还可以使用Apache做负载均衡. 主要过程:

1) 需要模块, mod_proxy提供代理服务器功能, mod_proxy_balancer提供负载均衡功能, mod_proxy_http让代理服务器能支持HTTP协议.

    ..

        LoadModule proxy_module modules/mod_proxy.so
        LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
        LoadModule proxy_http_module modules/mod_proxy_http.so

2) 主要配置

    ..

        ProxyRequests Off
        <Proxy balancer://mycluster>
            BalancerMember http://node-a.myserver.com:8080
            BalancerMember http://node-b.myserver.com:8080
        </Proxy>
        ProxyPass / balancer://mycluster

        # 警告：以下这段配置仅用于调试，绝不要添加到生产环境中！！！
        <Location /balancer-manager>
            SetHandler balancer-manager
            Order Deny,Allow
            Deny from all
            Allow from localhost
        </Location>


GDocBackup
------------------------

`原文2 <http://www.weborn.org/gdocbackup-990/>`_

一个工具软件, windows下, 用于将google doc上的文档同步备份到本机.还没具体试过, 但我觉得如果有安装gears的话, 这个也就没有必要了. 不过不知道它的速度如何, 如果快的话, 考虑换下. 因为gears有时总是出错, 而且速度慢, 内存狂飙上去, 出现多次ff无响应.


萨式自制风味烧鸡
------------------------

`原文3 <http://blog.sina.com.cn/s/blog_476745f60100egoq.html>`_

貌似很美味的一个做法, 哪天回家做给爸妈尝尝....
暂时先记到这儿, 貌似还有好多没看~~~