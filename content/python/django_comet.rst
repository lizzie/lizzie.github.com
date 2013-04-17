django and comet
==============================

:date: 2009-07-14 12:07:26
:tags: Python, Javascript


一些介绍
------------------

原始需求, 想通过某个手段动态更新当前页面上的某些数据, 不通过刷新. 很容易想到的一种实现方式就是ajax不断请求服务器上数据, 若有更新则更改当前页面数据. 但这种方式比较笨. 于是乎, 想到之前听过comet, 想是否可以在这里实现服务器推送数据给客户端.

Orbited
-----------------

google上乱搜了一通django和comet,找到这个东西, 按其网站上说, 它提供了浏览器的即时通信, 支持多种协议, 如IRC, XMPP, STOMP(ActiveMQ, RabbitMQ). 那简单来说, 它提供了浏览器端的js/html socket, 用于与服务器交互. 而在后台也提供对应的服务.
整个结构可以如下图所示:

这是其中的一种实现方式(Orbited+MorbidQ+STOMP). 简单介绍下的话:

* 浏览器通过订阅(subscribe)相关url, 而orbited服务器会记录客户端连接情况, 如果有新数据到达时会推送给相应客户端.
* 而这些新的数据来自web应用框架, 其通过某中方式发送给orbited服务器.


具体使用
-----------------

那具体来说, 使用django+orbited+morbidQ, 大概介绍下的话:

* Orbited服务器起到的作用是 记录来自客户端到服务器的请求信息.但不是所有客户端的请求路径都保存,只保存订阅页面的路径开头的请求的那些客户端. Orbited记录这些信息之后,才能再收到到django框架发过来的更新数据之后发送给对应的客户端. 发送更新数据给客户端之后,页面上的js代码接收数据并显示出来. 
* 那orbited的数据来源是从哪里来的呢？ 当然是希望直接从web框架过来,但是django没有这方面的功能.至少我不知道.所以中间用了一个代理.也就是relay.py. 他也相当于一个服务器,具体实现成一个RPC,也就是远程过程调用服务, 这里的作用是接收django中发送过来的数据,进行编码后发送给orbited. 这就是web框架通过relay与orbited进行单向通信.
* 当然,这里利用的是orbited的MorbidQ,基于stomp协议, 还有基于其他协议的,比如xmpp等(ps, gmail是, 哲思也是用xmpp, 估计这个比较好.)


orbited
-----------------

依次安装, python2.5+, twisted, orbited, stompservice, simplejson, ok之后, 
orbited有个配置文件, 叫做orbited.cfg, 

.. sourcecode:: bash
    
    shengyan@shengyan-desktop:~$ cat /etc/orbited.cfg
    # Example Orbited Configuration file
    
    [global]
    reactor=select
    # reactor=kqueue
    # reactor=epoll
    #session.ping_interval = 40
    session.ping_interval = 300     # 服务器ping客户端时间间隔, 300秒
    session.ping_timeout = 30
    # once the sockets are open, orbited will drop its privileges to this user.
    user=orbited
    
    [listen]
    #http://:8000
    http://:9000           # 监听http协议的9000端口
    stomp://:61613         # 监听stomp协议的61613端口
    # uncomment to enable SSL on port 8043 using given .key and .crt files
    #https://:8043
    #
    #[ssl]
    #key=orbited.key
    #crt=orbited.crt
    
    [static]
    prdt=product.htm     # 相当于别名. 无关痛痒的个设置
    
    [access]
    #localhost:8000 -> irc.freenode.net:6667
    #* -> localhost:4747
    * -> localhost:61613    # 访问设置.
    
    [logging]
    debug=STDERR,debug.log
    info=STDERR,info.log
    access=STDERR,info.log
    warn=STDERR,error.log
    error=STDERR,error.log
    
    #Don't enable debug by default
    enabled.default=info,access,warn,error
    
    # Turn debug on for the "Proxy" logger
    [loggers]
    #Proxy=debug,info,access,warn,error

ok之后, 启动 $ orbited -c /etc/orbited.cfg #服务器启动之后看到的输出信息就是不同客户端链接和断开情况,


relay
-------------------

ralay是一个网上牛人写的RPCServer, 用户将django传送过来的数据编码, 后转发给orbited.

.. sourcecode:: python

    #!/usr/bin/python
    # relay.py
    # http://cometdaily.com/2008/10/10/scalable-real-time-web-architecture-part-2-a-live-graph-with-orbited-morbidq-and-jsio/ & http://anirudhsanjeev.org/tutorialhow-to-django-comet-orbited-stomp-morbidq-jsio/
    
    from stompservice import StompClientFactory
    from twisted.internet import reactor
    from twisted.internet.task import LoopingCall
    from random import random
    from orbited import json
    from SimpleXMLRPCServer import *
    
    from threading import Thread
    import stompservice
    from settings import RPC_HOSTNAME as HOSTNAME, RPC_PORT as PORT, STOMP_PORT  # 主机名和端口号需要一致
    
    INTERVAL = 1000# in ms
    
    class DataProducer(StompClientFactory):
        def recv_connected(self, msg):
    
            print 'Connected; producing data'
            self.timer = LoopingCall(self.test_data)
            self.timer.start(INTERVAL/1000.0)       
    
        def send_data(self, channel, data):
            print "Transmitting: %s bytes" % len(data)
            #self.send(channel, data.encode("utf8"))
            self.send(channel, json.encode(data))
    
        def test_data(self):
            pass
    
    orbited_proxy = DataProducer()
    
    class RPCServer(Thread):
        def __init__(self, orbited):
            self.orbited = orbited
            Thread.__init__(self)
        def run(self):
            class RequestHandler(SimpleXMLRPCRequestHandler):
                rpc_paths = ('/RPC2',)
            #create a server
            server = SimpleXMLRPCServer((HOSTNAME,PORT),
                                        requestHandler = RequestHandler)
    
            server.register_introspection_functions()
            def transmit_orbited(channel, message):
                """
                @param channel: The stomp channel to send to
                @param message: The message that needs to be transmitted
                """
                self.orbited.send_data(channel, message)
                return ""
    
            server.register_function(transmit_orbited, 'transmit')
            server.serve_forever()
    
    if __name__ == "__main__":
            rpcthread = RPCServer(orbited_proxy)
            rpcthread.start()
    
            reactor.connectTCP(HOSTNAME, STOMP_PORT, orbited_proxy)
            reactor.run()
    
    
    #python relay.py 启动它.


django
----------------

django中的view中, 如果某用户提交了数据, 更新数据库,或者其他的, 都可触发更新, 将更新后的数据发送给relay. 
这里直接封装数据, 并使用xmlrpclib中的ServerProxy发送.

.. sourcecode:: python
    
    def _prdt(dnid='--',):
        """
        handle an XMLHttpRequest
        """
        import xmlrpclib
        proxy = xmlrpclib.ServerProxy("http://%s:%s" % (settings.RPC_HOSTNAME, settings.RPC_PORT))
        msg = {}
        msg['dnid'] = dnid
        #...
        proxy.transmit("/topic/prdt", msg)  # 这个路径和js中订阅的路径一致


js
-----------

页面中订阅及获取数据

.. sourcecode:: html
    
    <script src="/site_media/js/jquery-1.2.6.js" type="text/javascript"></script>
    <script src="/static/Orbited.js" type="text/javascript"></script>
    <script src="/static/protocols/stomp/stomp.js" type="text/javascript"></script>
    <script type="text/javascript">
        document.domain = document.domain;
        OrbitedHost = "localhost";  // 主机名
        Orbited.settings.port = 9000;  // Orbited端口
        Orbited.settings.hostname = OrbitedHost;
        TCPSocket = Orbited.TCPSocket;
        StompPort = 61613;    // STOMP端口, 这两个端口设置是和orbited配置中一致
    </script>



.. sourcecode: js
    
    //...
    //orbited
    stomp = new STOMPClient();  // 新建一个STOMP客户端. 
    stomp.onconnectedframe = function(){
        stomp.subscribe("/topic/prdt");  // 订阅目标源
    };
    stomp.onmessageframe = function(frame){  // 有新数据到达时的处理
        var result = eval('('+frame.body+')');
        var dnid = parseInt(result.dnid);
        var destid = parseInt($j("input[name='d']").val());
        if (!isNaN(dnid) && !isNaN(destid) && dnid == destid) {
            if (result.currenpric!= '--') {
                var mr = mcom(result.currenpric.toFixed(2));
                $j("i#curp1").html(mr);
            }
        }
    };
    stomp.connect(OrbitedHost, StompPort);  // 连接orbited服务器.


ok, 启动django服务器.
打开俩个相同页面的话, 在一个页面中更新数据, 另一个页面也会显示出来...


JSON数据读取
--------------------

js中读取JSON数据, 

.. sourcecode: js
        
    var resp = req.responseText;
    // 构造返回JSON对象的方法  
       var func = new Function("return " + resp);  
      // 得到JSON对象  
       var json = func( ); 
    
    // 或者可以直接用：
    var json = eval('(' + req.responseText+ ')');
    
最后
---------

前两天看到有人提到webqq, 好奇用了下, 的确做得很棒. 一句感叹,,,越来越多的这种类似的应用~~~


参考
---------------

* http://www.rkblog.rk.edu.pl/w/p/django-comet-and-irc-client/
* http://anirudhsanjeev.org/tutorialhow-to-django-comet-orbited-stomp-morbidq-jsio/ 简单入门教程
* http://www.rkblog.rk.edu.pl/w/p/django-and-comet/
* http://darkporter.com/?p=7#comment-5
* http://cometdaily.com/2008/10/10/scalable-real-time-web-architecture-part-2-a-live-graph-with-orbited-morbidq-and-jsio/ 实时图片
* http://orbited.org/
